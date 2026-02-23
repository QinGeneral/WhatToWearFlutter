import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/services/storage_service.dart';

class RecommendationRepository {
  final StorageService _storage;

  RecommendationRepository(this._storage);

  Map<String, dynamic>? getCurrentRecommendation() {
    return _storage.getCurrentRecommendation();
  }

  Future<void> saveCurrentRecommendation(
    Recommendation current,
    List<Recommendation> alternatives,
  ) async {
    await _storage.setCurrentRecommendation(current, alternatives);
  }

  List<Recommendation> getFavorites() {
    return _storage.getRecommendations();
  }

  Future<void> saveFavorites(List<Recommendation> favorites) async {
    await _storage.setRecommendations(favorites);
  }

  List<Recommendation> getHistory() {
    return _storage.getRecommendationHistory();
  }

  Future<void> saveHistory(List<Recommendation> history) async {
    await _storage.setRecommendationHistory(history);
  }

  int getDailyUsageCount(String feature) {
    return _storage.getDailyUsageCount(feature);
  }

  Future<void> incrementDailyUsageCount(String feature) async {
    await _storage.incrementDailyUsageCount(feature);
  }

  UserPreference? getPreferences() {
    return _storage.getPreferences();
  }
}
