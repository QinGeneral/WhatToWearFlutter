import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const _wardrobeKey = 'whattowear_wardrobe';
  static const _preferencesKey = 'whattowear_preferences';
  static const _profileKey = 'whattowear_profile';
  static const _recommendationsKey = 'whattowear_recommendations';
  static const _currentRecommendationKey = 'whattowear_current_recommendation';
  static const _historyKey = 'whattowear_recommendation_history';
  static const _dailyUsageKey = 'whattowear_daily_usage';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ═══════ Wardrobe ═══════
  List<WardrobeItem> getWardrobe() {
    final data = _prefs.getString(_wardrobeKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((e) => WardrobeItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> setWardrobe(List<WardrobeItem> items) async {
    // Strip images for storage
    final lean = items
        .map((item) => item.copyWith(images: [], optimizedImage: null).toJson())
        .toList();
    await _prefs.setString(_wardrobeKey, jsonEncode(lean));
  }

  // ═══════ Profile ═══════
  UserProfile? getProfile() {
    final data = _prefs.getString(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> setProfile(UserProfile profile) async {
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  // ═══════ Preferences ═══════
  UserPreference? getPreferences() {
    final data = _prefs.getString(_preferencesKey);
    if (data == null) return null;
    return UserPreference.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> setPreferences(UserPreference preferences) async {
    await _prefs.setString(_preferencesKey, jsonEncode(preferences.toJson()));
  }

  // ═══════ Recommendations (Favorites) ═══════
  List<Recommendation> getRecommendations() {
    final data = _prefs.getString(_recommendationsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> setRecommendations(List<Recommendation> recommendations) async {
    await _prefs.setString(
      _recommendationsKey,
      jsonEncode(recommendations.map((r) => r.toJson()).toList()),
    );
  }

  // ═══════ Current Recommendation ═══════
  Map<String, dynamic>? getCurrentRecommendation() {
    final data = _prefs.getString(_currentRecommendationKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> setCurrentRecommendation(
    Recommendation? current,
    List<Recommendation> alternatives,
  ) async {
    if (current == null) {
      await _prefs.remove(_currentRecommendationKey);
      return;
    }
    await _prefs.setString(
      _currentRecommendationKey,
      jsonEncode({
        'current': current.toJson(),
        'alternatives': alternatives.map((r) => r.toJson()).toList(),
      }),
    );
  }

  // ═══════ History ═══════
  List<Recommendation> getRecommendationHistory() {
    final data = _prefs.getString(_historyKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list
        .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> setRecommendationHistory(List<Recommendation> history) async {
    await _prefs.setString(
      _historyKey,
      jsonEncode(history.map((r) => r.toJson()).toList()),
    );
  }

  // ═══════ Daily Usage Limits ═══════
  int getDailyUsageCount(String featureKey) {
    final today = DateTime.now().toIso8601String().split('T').first;
    final key = '${_dailyUsageKey}_${featureKey}_$today';
    return _prefs.getInt(key) ?? 0;
  }

  Future<void> incrementDailyUsageCount(String featureKey) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final key = '${_dailyUsageKey}_${featureKey}_$today';
    final count = getDailyUsageCount(featureKey);
    await _prefs.setInt(key, count + 1);
  }

  // ═══════ Clear ═══════
  Future<void> clearAll() async {
    await _prefs.remove(_wardrobeKey);
    await _prefs.remove(_preferencesKey);
    await _prefs.remove(_profileKey);
    await _prefs.remove(_recommendationsKey);
    await _prefs.remove(_currentRecommendationKey);
    await _prefs.remove(_historyKey);
  }
}
