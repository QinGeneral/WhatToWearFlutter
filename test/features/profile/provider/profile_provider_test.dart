import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:what_to_wear_flutter/features/profile/provider/profile_provider.dart';
import 'package:what_to_wear_flutter/features/profile/repository/profile_repository.dart';
import 'package:what_to_wear_flutter/models/models.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeUserProfile extends Fake implements UserProfile {}

class FakeUserPreference extends Fake implements UserPreference {}

void main() {
  late ProfileProvider provider;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeUserProfile());
    registerFallbackValue(FakeUserPreference());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    provider = ProfileProvider(mockRepository);
  });

  group('ProfileProvider Logic Tests', () {
    test('initial state is correct', () {
      expect(provider.isLoading, false);
      expect(provider.profile, isNull);
      expect(provider.preferences, isNotNull); // Should be default preference
    });

    test('loadProfile loads data from repository correctly', () async {
      final mockProfile = UserProfile(
        id: '1',
        nickname: 'Alice',
        createdAt: 'date',
      );
      final mockPreference = UserPreference.defaultPreference.copyWith(
        theme: 'light',
      );

      when(() => mockRepository.getProfile()).thenReturn(mockProfile);
      when(() => mockRepository.getPreferences()).thenReturn(mockPreference);

      await provider.loadProfile();

      expect(provider.profile, equals(mockProfile));
      expect(provider.preferences, equals(mockPreference));
      expect(provider.themeMode, equals(ThemeMode.light));
      verify(() => mockRepository.getProfile()).called(1);
      verify(() => mockRepository.getPreferences()).called(1);
    });

    test('completeOnboarding creates profile and saves', () async {
      when(() => mockRepository.saveProfile(any())).thenAnswer((_) async {});

      await provider.completeOnboarding('Bob', UserIdentity.it);

      expect(provider.profile, isNotNull);
      expect(provider.profile!.nickname, equals('Bob'));
      expect(provider.profile!.identity, equals(UserIdentity.it));
      expect(provider.hasCompletedOnboarding(), isTrue);
      verify(() => mockRepository.saveProfile(any())).called(1);
    });

    test('toggleTheme switches between light and dark and saves', () async {
      when(
        () => mockRepository.savePreferences(any()),
      ).thenAnswer((_) async {});

      // Initial theme is dark by default
      await provider.toggleTheme();

      expect(provider.preferences.theme, 'light');
      expect(provider.themeMode, ThemeMode.light);
      verify(() => mockRepository.savePreferences(any())).called(1);

      await provider.toggleTheme();

      expect(provider.preferences.theme, 'dark');
      expect(provider.themeMode, ThemeMode.dark);
      verify(() => mockRepository.savePreferences(any())).called(1);
    });
  });
}
