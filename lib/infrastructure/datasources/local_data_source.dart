import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for app storage using SharedPreferences
class LocalDataSource {
  static const _wardrobeKey = 'whattowear_wardrobe';
  static const _recommendationsKey = 'whattowear_recommendations';
  static const _currentRecommendationKey = 'whattowear_current_recommendation';
  static const _historyKey = 'whattowear_recommendation_history';
  static const _dailyUsageKey = 'whattowear_daily_usage';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ═══════ Wardrobe ═══════
  List<Map<String, dynamic>> getWardrobe() {
    final data = _prefs.getString(_wardrobeKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> setWardrobe(List<Map<String, dynamic>> items) async {
    await _prefs.setString(_wardrobeKey, jsonEncode(items));
  }

  // ═══════ Recommendations (Favorites) ═══════
  List<Map<String, dynamic>> getRecommendations() {
    final data = _prefs.getString(_recommendationsKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> setRecommendations(List<Map<String, dynamic>> recommendations) async {
    await _prefs.setString(_recommendationsKey, jsonEncode(recommendations));
  }

  // ═══════ Current Recommendation ═══════
  Map<String, dynamic>? getCurrentRecommendation() {
    final data = _prefs.getString(_currentRecommendationKey);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> setCurrentRecommendation(
    Map<String, dynamic>? current,
    List<Map<String, dynamic>> alternatives,
  ) async {
    if (current == null) {
      await _prefs.remove(_currentRecommendationKey);
      return;
    }
    await _prefs.setString(
      _currentRecommendationKey,
      jsonEncode({
        'current': current,
        'alternatives': alternatives,
      }),
    );
  }

  // ═══════ History ═══════
  List<Map<String, dynamic>> getRecommendationHistory() {
    final data = _prefs.getString(_historyKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> setRecommendationHistory(List<Map<String, dynamic>> history) async {
    await _prefs.setString(_historyKey, jsonEncode(history));
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
    await _prefs.remove(_recommendationsKey);
    await _prefs.remove(_currentRecommendationKey);
    await _prefs.remove(_historyKey);
  }
}
