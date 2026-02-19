import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/ai/ai_outfit_recommender.dart';
import '../services/ai/ai_service_provider.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class RecommendationProvider extends ChangeNotifier {
  final StorageService _storage;
  final AIServiceProvider _aiServices;
  final _uuid = const Uuid();
  final _random = Random();

  Recommendation? _currentRecommendation;
  List<Recommendation> _alternativeRecommendations = [];
  List<Recommendation> _favorites = [];
  List<Recommendation> _history = [];
  WeatherInfo? _weather;
  bool _isLoading = false;
  bool _isWeatherLoading = false;
  String? _error;

  RecommendationProvider(this._storage, this._aiServices);

  Recommendation? get currentRecommendation => _currentRecommendation;
  List<Recommendation> get alternativeRecommendations =>
      _alternativeRecommendations;
  List<Recommendation> get favorites => _favorites;
  List<Recommendation> get history => _history;
  WeatherInfo? get weather => _weather;
  bool get isLoading => _isLoading;
  bool get isWeatherLoading => _isWeatherLoading;
  String? get error => _error;

  Future<void> loadCurrentRecommendation() async {
    final data = _storage.getCurrentRecommendation();
    if (data != null) {
      _currentRecommendation = Recommendation.fromJson(
        data['current'] as Map<String, dynamic>,
      );
      _alternativeRecommendations = (data['alternatives'] as List)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList();

      // Sync favorite status
      final favIds = _favorites.map((f) => f.id).toSet();
      if (_currentRecommendation != null) {
        final isFav = favIds.contains(_currentRecommendation!.id);
        if (_currentRecommendation!.isFavorite != isFav) {
          _currentRecommendation = _currentRecommendation!.copyWith(
            isFavorite: isFav,
          );
        }
      }
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    _favorites = _storage.getRecommendations();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = _storage.getRecommendationHistory();

    // Sync favorite status
    final favIds = _favorites.map((f) => f.id).toSet();
    _history = _history.map((rec) {
      final isFav = favIds.contains(rec.id);
      return rec.isFavorite != isFav ? rec.copyWith(isFavorite: isFav) : rec;
    }).toList();

    notifyListeners();
  }

  Future<void> fetchWeather() async {
    _isWeatherLoading = true;
    notifyListeners();

    try {
      debugPrint('[RecommendationProvider] Starting weather fetch...');
      final position = await WeatherService.getCurrentLocation();
      debugPrint(
        '[RecommendationProvider] ✅ Got position: (${position.latitude}, ${position.longitude})',
      );
      _weather = await WeatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      debugPrint(
        '[RecommendationProvider] ✅ Weather fetched: ${_weather?.location}, ${_weather?.temperature}°C',
      );
    } catch (e, stackTrace) {
      debugPrint('[RecommendationProvider] ❌ Weather fetch error: $e');
      debugPrint('[RecommendationProvider] Stack trace: $stackTrace');
      // Fallback weather
      _weather = WeatherInfo(
        temperature: 22,
        condition: '晴朗',
        humidity: 55,
        icon: '☀️',
        uvIndex: '中',
        comfortLevel: '舒适',
        location: '定位失败',
      );
    }

    _isWeatherLoading = false;
    notifyListeners();
  }

  Future<void> generateRecommendation(
    List<WardrobeItem> wardrobeItems, {
    RecommendationContext? context,
  }) async {
    if (wardrobeItems.isEmpty) {
      _error = '衣橱为空，请先添加衣物';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weather =
          _weather ??
          WeatherInfo(
            temperature: 22,
            condition: '晴朗',
            humidity: 55,
            icon: '☀️',
            uvIndex: '中',
            comfortLevel: '舒适',
          );

      // Generate main recommendation
      final mainRec = _createOutfit(wardrobeItems, weather, context: context);

      // Generate 2-3 alternatives
      final alts = <Recommendation>[];
      for (int i = 0; i < 3; i++) {
        alts.add(_createOutfit(wardrobeItems, weather, context: context));
      }

      _currentRecommendation = mainRec;
      _alternativeRecommendations = alts;

      // Save to history
      _history = [mainRec, ..._history];

      await _storage.setCurrentRecommendation(mainRec, alts);
      await _storage.setRecommendationHistory(_history);
    } catch (e) {
      _error = '生成推荐失败：$e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Recommendation _createOutfit(
    List<WardrobeItem> items,
    WeatherInfo weather, {
    RecommendationContext? context,
  }) {
    // Filter items by season
    final currentSeason = _getCurrentSeason();
    final seasonItems = items
        .where(
          (item) => item.season == currentSeason || item.season == Season.all,
        )
        .toList();

    final availableItems = seasonItems.isNotEmpty ? seasonItems : items;

    // Pick items by category
    WardrobeItem? top = _pickRandom(
      availableItems.where((i) => i.category == ClothingCategory.top).toList(),
    );
    WardrobeItem? bottom = _pickRandom(
      availableItems
          .where((i) => i.category == ClothingCategory.bottom)
          .toList(),
    );
    WardrobeItem? shoes = _pickRandom(
      availableItems
          .where((i) => i.category == ClothingCategory.shoes)
          .toList(),
    );
    WardrobeItem? outerwear = weather.temperature < 20
        ? _pickRandom(
            availableItems
                .where((i) => i.category == ClothingCategory.outerwear)
                .toList(),
          )
        : null;

    final matchPct = 70 + _random.nextInt(26); // 70-95

    final reasonings = [
      '根据今日${weather.condition}天气(${weather.temperature}°C)，为你精选的搭配方案。',
      '考虑到当前${weather.comfortLevel ?? "适宜"}的气温，这套搭配既舒适又有型。',
      '基于你的衣橱单品和今天的天气状况，推荐这套百搭穿搭。',
    ];

    return Recommendation(
      id: _uuid.v4(),
      date: DateTime.now().toIso8601String(),
      weather: weather,
      occasion: Occasion.casual,
      items: RecommendationItems(
        top: top,
        bottom: bottom,
        shoes: shoes,
        outerwear: outerwear,
      ),
      isFavorite: false,
      matchPercentage: matchPct,
      reasoning: reasonings[_random.nextInt(reasonings.length)],
      context: context,
    );
  }

  WardrobeItem? _pickRandom(List<WardrobeItem> items) {
    if (items.isEmpty) return null;
    return items[_random.nextInt(items.length)];
  }

  Season _getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  Future<void> toggleFavorite(Recommendation recommendation) async {
    final isFav = !recommendation.isFavorite;
    final updated = recommendation.copyWith(isFavorite: isFav);

    // Update favorites list
    if (isFav) {
      _favorites = [updated, ..._favorites.where((f) => f.id != updated.id)];
    } else {
      _favorites = _favorites.where((f) => f.id != updated.id).toList();
    }

    // Update current recommendation if it matches
    if (_currentRecommendation?.id == updated.id) {
      _currentRecommendation = updated;
    }

    // Update in history
    _history = _history.map((rec) {
      return rec.id == updated.id ? updated : rec;
    }).toList();

    // Update alternatives
    _alternativeRecommendations = _alternativeRecommendations.map((rec) {
      return rec.id == updated.id ? updated : rec;
    }).toList();

    await _storage.setRecommendations(_favorites);
    await _storage.setRecommendationHistory(_history);
    if (_currentRecommendation != null) {
      await _storage.setCurrentRecommendation(
        _currentRecommendation!,
        _alternativeRecommendations,
      );
    }
    notifyListeners();
  }

  Future<void> deleteHistory(String id) async {
    _history = _history.where((rec) => rec.id != id).toList();
    await _storage.setRecommendationHistory(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    _currentRecommendation = null;
    _alternativeRecommendations = [];
    await _storage.setRecommendationHistory(_history);
    notifyListeners();
  }

  Future<void> deleteRecommendation(String id) async {
    _favorites = _favorites.where((rec) => rec.id != id).toList();
    await _storage.setRecommendations(_favorites);
    notifyListeners();
  }

  Recommendation? getRecommendationById(String id) {
    if (_currentRecommendation?.id == id) return _currentRecommendation;
    try {
      return _alternativeRecommendations.firstWhere((r) => r.id == id);
    } catch (_) {}
    try {
      return _history.firstWhere((r) => r.id == id);
    } catch (_) {}
    try {
      return _favorites.firstWhere((r) => r.id == id);
    } catch (_) {}
    return null;
  }

  /// Generates AI-powered outfit recommendation using Gemini.
  Future<void> generateAIRecommendation(
    UserRequest request,
    List<WardrobeItem> wardrobeItems,
  ) async {
    if (wardrobeItems.isEmpty) {
      _error = '衣橱为空，请先添加衣物';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Ensure weather is available
      if (_weather == null) {
        try {
          final position = await WeatherService.getCurrentLocation();
          _weather = await WeatherService.getWeather(
            position.latitude,
            position.longitude,
          );
        } catch (e) {
          debugPrint('[RecommendationProvider] Weather fetch error: $e');
          _isLoading = false;
          _error = '无法获取天气信息，请确保已授予定位权限并检查网络连接。';
          notifyListeners();
          return;
        }
      }

      // Call AI service via interface
      final result = await _aiServices.outfitRecommender.getRecommendation(
        request: request,
        wardrobe: wardrobeItems,
        weather: _weather!,
      );

      if (result.outfits.isEmpty) {
        throw Exception('AI 未能生成搭配方案');
      }

      // Map AI results to Recommendation objects
      final recommendations = result.outfits.asMap().entries.map((entry) {
        final index = entry.key;
        final outfit = entry.value;

        WardrobeItem? findItem(String? id) {
          if (id == null) return null;
          try {
            return wardrobeItems.firstWhere((i) => i.id == id);
          } catch (_) {
            return null;
          }
        }

        return Recommendation(
          id: '${DateTime.now().millisecondsSinceEpoch}$index',
          date: DateTime.now().toIso8601String(),
          weather: _weather!,
          occasion: _userRequestToOccasion(request.activity),
          items: RecommendationItems(
            top: findItem(outfit.topId),
            bottom: findItem(outfit.bottomId),
            shoes: findItem(outfit.shoesId),
            outerwear: findItem(outfit.outerwearId),
            accessories: outfit.accessoryIds
                ?.map((id) => findItem(id))
                .whereType<WardrobeItem>()
                .toList(),
          ),
          isFavorite: false,
          matchPercentage: outfit.matchPercentage,
          reasoning: outfit.reasoning,
          context: RecommendationContext(
            date: request.date,
            location: request.location,
            activity: request.activity,
            person: request.person,
            requirements: request.requirements,
          ),
        );
      }).toList();

      _currentRecommendation = recommendations[0];
      _alternativeRecommendations = recommendations.length > 1
          ? recommendations.sublist(1)
          : [];

      // Save to history
      _history = [recommendations[0], ..._history];

      await _storage.setCurrentRecommendation(
        _currentRecommendation!,
        _alternativeRecommendations,
      );
      await _storage.setRecommendationHistory(_history);
    } catch (e) {
      debugPrint('[RecommendationProvider] AI Recommendation error: $e');
      _error = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : '生成搭配方案失败，请稍后重试';
    }

    _isLoading = false;
    notifyListeners();
  }

  static Occasion _userRequestToOccasion(String activity) {
    if (activity.contains('上班') ||
        activity.contains('会议') ||
        activity.contains('工作') ||
        activity.contains('开会')) {
      return Occasion.work;
    }
    if (activity.contains('聚会') || activity.contains('派对')) {
      return Occasion.party;
    }
    if (activity.contains('约会')) {
      return Occasion.date;
    }
    if (activity.contains('运动') || activity.contains('健身')) {
      return Occasion.sport;
    }
    if (activity.contains('晚宴') || activity.contains('正式')) {
      return Occasion.formal;
    }
    if (activity.contains('旅行') || activity.contains('度假')) {
      return Occasion.travel;
    }
    if (activity.contains('通勤')) {
      return Occasion.commute;
    }
    return Occasion.casual;
  }

  Future<void> updateRecommendationImage(String id, String imageUrl) async {
    // Helper to update a list
    List<Recommendation> updateList(List<Recommendation> list) {
      return list.map((r) {
        return r.id == id ? r.copyWith(generatedImage: imageUrl) : r;
      }).toList();
    }

    // Update current if it matches
    if (_currentRecommendation?.id == id) {
      _currentRecommendation = _currentRecommendation!.copyWith(
        generatedImage: imageUrl,
      );
    }

    // Update alternatives
    _alternativeRecommendations = updateList(_alternativeRecommendations);

    // Update favorites
    _favorites = updateList(_favorites);

    // Update history
    _history = updateList(_history);

    notifyListeners();

    // Persist to storage
    if (_currentRecommendation != null) {
      await _storage.setCurrentRecommendation(
        _currentRecommendation!,
        _alternativeRecommendations,
      );
    }
    await _storage.setRecommendations(_favorites);
    await _storage.setRecommendationHistory(_history);
  }

  Future<void> generateTryOnImage(Recommendation recommendation) async {
    _isLoading = true;
    notifyListeners();

    try {
      final imageUrl = await _aiServices.imageGenerator.generateOutfitImage(
        recommendation,
      );
      await updateRecommendationImage(recommendation.id, imageUrl);
    } catch (e) {
      _error = '生成试穿图失败：$e';
      debugPrint('[RecommendationProvider] Generate Try-On error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
