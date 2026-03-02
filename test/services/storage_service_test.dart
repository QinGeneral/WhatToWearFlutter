import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/services/storage_service.dart';

void main() {
  late StorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storageService = StorageService();
    await storageService.init();
  });

  group('StorageService Profile Operations', () {
    test('getProfile returns null when no data exists', () {
      expect(storageService.getProfile(), isNull);
    });

    test('setProfile and getProfile work correctly', () async {
      final profile = UserProfile(
        id: 'user_test',
        nickname: 'Alice',
        createdAt: '2023-10-01T12:00:00Z',
      );

      await storageService.setProfile(profile);
      final retrievedProfile = storageService.getProfile();

      expect(retrievedProfile, isNotNull);
      expect(retrievedProfile!.id, 'user_test');
      expect(retrievedProfile.nickname, 'Alice');
      expect(retrievedProfile.createdAt, '2023-10-01T12:00:00Z');
    });
  });

  group('StorageService Daily Usage Limit Operations', () {
    test('getDailyUsageCount returns 0 initially', () {
      expect(storageService.getDailyUsageCount('generate_image'), 0);
    });

    test('incrementDailyUsageCount increments correctly', () async {
      await storageService.incrementDailyUsageCount('generate_image');
      expect(storageService.getDailyUsageCount('generate_image'), 1);

      await storageService.incrementDailyUsageCount('generate_image');
      expect(storageService.getDailyUsageCount('generate_image'), 2);
    });
  });

  group('StorageService Clear Operations', () {
    test('clearAll removes profile data', () async {
      final profile = UserProfile(
        id: 'user_test',
        nickname: 'Alice',
        createdAt: '2023-10-01T12:00:00Z',
      );

      await storageService.setProfile(profile);
      expect(storageService.getProfile(), isNotNull);

      await storageService.clearAll();
      expect(storageService.getProfile(), isNull);
    });
  });
}
