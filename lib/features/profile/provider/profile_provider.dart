import 'package:flutter/material.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/features/profile/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;

  UserProfile? _profile;
  UserPreference _preferences = UserPreference.defaultPreference;
  bool _isLoading = false;

  ProfileProvider(this._repository);

  UserProfile? get profile => _profile;
  UserPreference get preferences => _preferences;
  bool get isLoading => _isLoading;
  ThemeMode get themeMode =>
      _preferences.theme == 'light' ? ThemeMode.light : ThemeMode.dark;
  Locale get locale => Locale(_preferences.language);

  bool hasCompletedOnboarding() {
    return _profile?.onboardingCompletedAt != null;
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = _repository.getProfile();
    _preferences =
        _repository.getPreferences() ?? UserPreference.defaultPreference;

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
    await _repository.saveProfile(_profile!);
    notifyListeners();
  }

  Future<void> updateIdentity(UserIdentity identity) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(identity: identity);
      await _repository.saveProfile(_profile!);
      notifyListeners();
    }
  }

  Future<void> updateNickname(String nickname) async {
    if (_profile != null) {
      _profile = _profile!.copyWith(nickname: nickname);
      await _repository.saveProfile(_profile!);
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = _preferences.theme == 'dark' ? 'light' : 'dark';
    _preferences = _preferences.copyWith(theme: newTheme);
    await _repository.savePreferences(_preferences);
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    _preferences = _preferences.copyWith(theme: theme);
    await _repository.savePreferences(_preferences);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _preferences = _preferences.copyWith(language: language);
    await _repository.savePreferences(_preferences);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    if (_profile != null) {
      _profile = UserProfile(
        id: _profile!.id,
        nickname: _profile!.nickname,
        createdAt: _profile!.createdAt,
        identity: _profile!.identity,
        onboardingCompletedAt: null,
      );
      await _repository.saveProfile(_profile!);
      notifyListeners();
    }
  }
}
