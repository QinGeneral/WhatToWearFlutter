import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  final StorageService _storage;

  UserProfile? _profile;
  UserPreference _preferences = UserPreference.defaultPreference;
  bool _isLoading = false;

  ProfileProvider(this._storage);

  UserProfile? get profile => _profile;
  UserPreference get preferences => _preferences;
  bool get isLoading => _isLoading;
  ThemeMode get themeMode =>
      _preferences.theme == 'light' ? ThemeMode.light : ThemeMode.dark;

  bool hasCompletedOnboarding() {
    return _profile?.onboardingCompletedAt != null;
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = _storage.getProfile();
    _preferences =
        _storage.getPreferences() ?? UserPreference.defaultPreference;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding(String name, UserIdentity identity) async {
    final now = DateTime.now().toIso8601String();
    _profile = UserProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      nickname: name,
      createdAt: now,
      identity: identity,
      onboardingCompletedAt: now,
    );
    await _storage.setProfile(_profile!);
    notifyListeners();
  }

  Future<void> updateIdentity(UserIdentity identity) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(identity: identity);
      await _storage.setProfile(_profile!);
      notifyListeners();
    }
  }

  Future<void> updateNickname(String nickname) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(nickname: nickname);
      await _storage.setProfile(_profile!);
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = _preferences.theme == 'dark' ? 'light' : 'dark';
    _preferences = _preferences.copyWith(theme: newTheme);
    await _storage.setPreferences(_preferences);
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    _preferences = _preferences.copyWith(theme: theme);
    await _storage.setPreferences(_preferences);
    notifyListeners();
  }
}
