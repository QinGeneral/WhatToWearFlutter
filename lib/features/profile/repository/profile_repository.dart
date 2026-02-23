import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/services/storage_service.dart';

class ProfileRepository {
  final StorageService _storage;

  ProfileRepository(this._storage);

  UserProfile? getProfile() {
    return _storage.getProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _storage.setProfile(profile);
  }

  UserPreference? getPreferences() {
    return _storage.getPreferences();
  }

  Future<void> savePreferences(UserPreference preferences) async {
    await _storage.setPreferences(preferences);
  }
}
