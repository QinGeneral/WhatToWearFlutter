import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/services/ai/ai_outfit_recommender.dart';
import 'package:what_to_wear_flutter/domain/failures/failures.dart';
import 'package:what_to_wear_flutter/features/recommendation/repository/recommendation_repository.dart';
import 'package:what_to_wear_flutter/services/ai/ai_service_provider.dart';
import 'package:what_to_wear_flutter/services/analytics_service.dart';
import 'package:what_to_wear_flutter/services/weather_service.dart';

class RecommendationProvider extends ChangeNotifier {
  final RecommendationRepository _repository;
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

  static const int _maxHistoryCount = 100;

  RecommendationProvider(this._repository, this._aiServices);

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
    final data = _repository.getCurrentRecommendation();
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
    _favorites = _repository.getFavorites();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = _repository.getHistory();

    // Sync favorite status
    final favIds = _favorites.map((f) => f.id).toSet();
    _history = _history.map((rec) {
      final isFav = favIds.contains(rec.id);
      return rec.isFavorite != isFav ? rec.copyWith(isFavorite: isFav) : rec;
    }).toList();

    notifyListeners();
  }

  // ═══════ Public Methods ═══════

  Future<void> fetchWeather() async {
    _isWeatherLoading = true;
    notifyListeners();

    final result = await _fetchWeather();
    result.fold(
      (failure) {
        debugPrint(
          '[RecommendationProvider] ❌ Weather fetch error: ${failure.message}',
        );
        _weather = WeatherInfo(
          temperature: 22,
          condition: '晴朗',
          humidity: 55,
          icon: '☀️',
          uvIndex: '中',
          comfortLevel: '舒适',
          location: '定位失败',
        );
      },
      (weather) {
        debugPrint(
          '[RecommendationProvider] ✅ Weather fetched: ${weather.location}, ${weather.temperature}°C',
        );
        _weather = weather;
      },
    );

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

    AnalyticsService.onEvent('recommendation_generate', {
      'type': 'rule',
      'wardrobe_size': wardrobeItems.length.toString(),
    });
    final result = await _generateRuleOutfit(wardrobeItems, context);
    result.fold(
      (failure) {
        _error = failure.message;
        AnalyticsService.onEvent('recommendation_generate_fail', {'type': 'rule'});
      },
      (pair) {
        _currentRecommendation = pair.$1;
        _alternativeRecommendations = pair.$2;
        _history = [pair.$1, ..._history].take(_maxHistoryCount).toList();
        AnalyticsService.onEvent('recommendation_generate_success', {'type': 'rule'});
      },
    );

    _isLoading = false;
    notifyListeners();
  }

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

    if (_weather == null) {
      final weatherResult = await _fetchWeather();
      var earlyExit = false;
      weatherResult.fold(
        (failure) {
          _isLoading = false;
          _error = '无法获取天气信息，请确保已授予定位权限并检查网络连接。';
          notifyListeners();
          earlyExit = true;
        },
        (weather) => _weather = weather,
      );
      if (earlyExit) return;
    }

    AnalyticsService.onEvent('recommendation_generate', {
      'type': 'ai',
      'activity': request.activity,
      'wardrobe_size': wardrobeItems.length.toString(),
    });
    final result = await _fetchAIRecommendations(request, wardrobeItems);
    result.fold(
      (failure) {
        debugPrint(
          '[RecommendationProvider] AI Recommendation error: ${failure.message}',
        );
        _error = failure.message;
        AnalyticsService.onEvent('recommendation_generate_fail', {'type': 'ai'});
      },
      (recommendations) {
        _currentRecommendation = recommendations[0];
        _alternativeRecommendations =
            recommendations.length > 1 ? recommendations.sublist(1) : [];
        _history = [recommendations[0], ..._history].take(_maxHistoryCount).toList();
        AnalyticsService.onEvent('recommendation_generate_success', {'type': 'ai'});
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> generateTryOnImage(Recommendation recommendation) async {
    if (_repository.getDailyUsageCount('generate_outfit') >= 3) {
      _error = '今日生成穿搭次数已达上限 (3/3)';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    AnalyticsService.onEvent('try_on_start');
    final result = await _generateTryOn(recommendation);
    result.fold(
      (failure) {
        debugPrint(
          '[RecommendationProvider] Generate Try-On error: ${failure.message}',
        );
        _error = failure.message;
        AnalyticsService.onEvent('try_on_fail');
      },
      (_) {
        AnalyticsService.onEvent('try_on_success');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(Recommendation recommendation) async {
    final isFav = !recommendation.isFavorite;
    final updated = recommendation.copyWith(isFavorite: isFav);

    if (isFav) {
      _favorites = [updated, ..._favorites.where((f) => f.id != updated.id)];
    } else {
      _favorites = _favorites.where((f) => f.id != updated.id).toList();
    }

    if (_currentRecommendation?.id == updated.id) {
      _currentRecommendation = updated;
    }

    _history = _history.map((rec) {
      return rec.id == updated.id ? updated : rec;
    }).toList();

    _alternativeRecommendations = _alternativeRecommendations.map((rec) {
      return rec.id == updated.id ? updated : rec;
    }).toList();

    await _repository.saveFavorites(_favorites);
    await _repository.saveHistory(_history);
    if (_currentRecommendation != null) {
      await _repository.saveCurrentRecommendation(
        _currentRecommendation!,
        _alternativeRecommendations,
      );
    }
    AnalyticsService.onEvent(
      'favorite_toggle',
      {'is_favorite': isFav.toString()},
    );
    notifyListeners();
  }

  Future<void> deleteHistory(String id) async {
    _history = _history.where((rec) => rec.id != id).toList();
    await _repository.saveHistory(_history);
    AnalyticsService.onEvent('history_delete');
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    _currentRecommendation = null;
    _alternativeRecommendations = [];
    await _repository.saveHistory(_history);
    AnalyticsService.onEvent('history_clear');
    notifyListeners();
  }

  Future<void> deleteRecommendation(String id) async {
    _favorites = _favorites.where((rec) => rec.id != id).toList();
    await _repository.saveFavorites(_favorites);
    notifyListeners();
  }

  Recommendation? getRecommendationById(String id) {
    if (_currentRecommendation?.id == id) return _currentRecommendation;
    return _alternativeRecommendations.where((r) => r.id == id).firstOrNull ??
        _history.where((r) => r.id == id).firstOrNull ??
        _favorites.where((r) => r.id == id).firstOrNull;
  }

  Future<void> updateRecommendationImage(String id, String imageUrl) async {
    List<Recommendation> updateList(List<Recommendation> list) {
      return list.map((r) {
        return r.id == id ? r.copyWith(generatedImage: imageUrl) : r;
      }).toList();
    }

    if (_currentRecommendation?.id == id) {
      _currentRecommendation = _currentRecommendation!.copyWith(
        generatedImage: imageUrl,
      );
    }

    _alternativeRecommendations = updateList(_alternativeRecommendations);
    _favorites = updateList(_favorites);
    _history = updateList(_history);

    notifyListeners();

    if (_currentRecommendation != null) {
      await _repository.saveCurrentRecommendation(
        _currentRecommendation!,
        _alternativeRecommendations,
      );
    }
    await _repository.saveFavorites(_favorites);
    await _repository.saveHistory(_history);
  }

  // ═══════ Private Either Methods ═══════

  Future<Either<AppFailure, WeatherInfo>> _fetchWeather() async {
    try {
      debugPrint('[RecommendationProvider] Starting weather fetch...');
      final position = await WeatherService.getCurrentLocation();
      debugPrint(
        '[RecommendationProvider] ✅ Got position: (${position.latitude}, ${position.longitude})',
      );
      final weather = await WeatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      return Right(weather);
    } on AppFailure catch (f) {
      return Left(f);
    } catch (e, stackTrace) {
      debugPrint('[RecommendationProvider] Stack trace: $stackTrace');
      return Left(
        AppFailure.network(message: '无法获取天气信息：$e', originalError: e),
      );
    }
  }

  Future<Either<AppFailure, (Recommendation, List<Recommendation>)>>
  _generateRuleOutfit(
    List<WardrobeItem> wardrobeItems,
    RecommendationContext? context,
  ) async {
    try {
      final weather = _weather ??
          WeatherInfo(
            temperature: 22,
            condition: '晴朗',
            humidity: 55,
            icon: '☀️',
            uvIndex: '中',
            comfortLevel: '舒适',
          );
      final mainRec = _createOutfit(wardrobeItems, weather, context: context);
      final alts = [
        for (int i = 0; i < 3; i++)
          _createOutfit(wardrobeItems, weather, context: context),
      ];
      await _repository.saveCurrentRecommendation(mainRec, alts);
      await _repository.saveHistory([mainRec, ..._history].take(_maxHistoryCount).toList());
      return Right((mainRec, alts));
    } on AppFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(
        AppFailure.unknown(message: '生成推荐失败：$e', originalError: e),
      );
    }
  }

  Future<Either<AppFailure, List<Recommendation>>> _fetchAIRecommendations(
    UserRequest request,
    List<WardrobeItem> wardrobeItems,
  ) async {
    try {
      final prefs = _repository.getPreferences();
      final lang = prefs?.language ?? 'zh';

      final result = await _aiServices.outfitRecommender.getRecommendation(
        request: request,
        wardrobe: wardrobeItems,
        weather: _weather!,
        language: lang,
      );

      if (result.outfits.isEmpty) {
        return const Left(AppFailure.ai(message: 'AI 未能生成搭配方案'));
      }

      final recommendations = _mapAIResultToRecommendations(
        result,
        request,
        wardrobeItems,
      );
      await _repository.saveCurrentRecommendation(
        recommendations[0],
        recommendations.length > 1 ? recommendations.sublist(1) : [],
      );
      await _repository.saveHistory([recommendations[0], ..._history].take(_maxHistoryCount).toList());
      return Right(recommendations);
    } on AppFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(
        AppFailure.ai(
          message: e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : '生成搭配方案失败，请稍后重试',
          originalError: e,
        ),
      );
    }
  }

  Future<Either<AppFailure, Unit>> _generateTryOn(
    Recommendation recommendation,
  ) async {
    try {
      final prefs = _repository.getPreferences();
      final lang = prefs?.language ?? 'zh';

      final imageUrl = await _aiServices.imageGenerator.generateOutfitImage(
        recommendation,
        language: lang,
      );
      await updateRecommendationImage(recommendation.id, imageUrl);
      await _repository.incrementDailyUsageCount('generate_outfit');
      return const Right(unit);
    } on AppFailure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(
        AppFailure.ai(message: '生成试穿图失败：$e', originalError: e),
      );
    }
  }

  // ═══════ Helpers ═══════

  List<Recommendation> _mapAIResultToRecommendations(
    AIRecommendationResult result,
    UserRequest request,
    List<WardrobeItem> wardrobeItems,
  ) {
    WardrobeItem? findItem(String? id) {
      if (id == null) return null;
      return wardrobeItems.where((i) => i.id == id).firstOrNull;
    }

    return result.outfits.asMap().entries.map((entry) {
      final index = entry.key;
      final outfit = entry.value;
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
              ?.map(findItem)
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
  }

  Recommendation _createOutfit(
    List<WardrobeItem> items,
    WeatherInfo weather, {
    RecommendationContext? context,
  }) {
    final currentSeason = _getCurrentSeason();
    final seasonItems = items
        .where(
          (item) => item.season == currentSeason || item.season == Season.all,
        )
        .toList();

    final availableItems = seasonItems.isNotEmpty ? seasonItems : items;

    final top = _pickRandom(
      availableItems.where((i) => i.category == ClothingCategory.top).toList(),
    );
    final bottom = _pickRandom(
      availableItems
          .where((i) => i.category == ClothingCategory.bottom)
          .toList(),
    );
    final shoes = _pickRandom(
      availableItems
          .where((i) => i.category == ClothingCategory.shoes)
          .toList(),
    );
    final outerwear = weather.temperature < 20
        ? _pickRandom(
            availableItems
                .where((i) => i.category == ClothingCategory.outerwear)
                .toList(),
          )
        : null;

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
      matchPercentage: 70 + _random.nextInt(26),
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
    if (activity.contains('约会')) return Occasion.date;
    if (activity.contains('运动') || activity.contains('健身')) {
      return Occasion.sport;
    }
    if (activity.contains('晚宴') || activity.contains('正式')) {
      return Occasion.formal;
    }
    if (activity.contains('旅行') || activity.contains('度假')) {
      return Occasion.travel;
    }
    if (activity.contains('通勤')) return Occasion.commute;
    return Occasion.casual;
  }
}
