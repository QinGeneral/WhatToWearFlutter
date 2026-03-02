import 'package:flutter_test/flutter_test.dart';
import 'package:what_to_wear_flutter/models/models.dart';

void main() {
  group('UserPreference Serialization', () {
    test('toJson and fromJson should work correctly', () {
      final preference = UserPreference(
        id: 'user_1',
        style: [Style.casual, Style.formal],
        preferredColors: ['black', 'white'],
        dislikedColors: ['red'],
        size: {'top': 'L', 'bottom': 'M'},
        occasions: [Occasion.work, Occasion.casual],
        notifications: {'dailyRecommendation': true},
        theme: 'light',
        language: 'en',
      );

      final json = preference.toJson();
      final decodedPreference = UserPreference.fromJson(json);

      expect(decodedPreference.id, preference.id);
      expect(decodedPreference.style, preference.style);
      expect(decodedPreference.preferredColors, preference.preferredColors);
      expect(decodedPreference.dislikedColors, preference.dislikedColors);
      expect(decodedPreference.size, preference.size);
      expect(decodedPreference.occasions, preference.occasions);
      expect(decodedPreference.notifications, preference.notifications);
      expect(decodedPreference.theme, preference.theme);
      expect(decodedPreference.language, preference.language);
    });
  });

  group('UserProfile Serialization', () {
    test('toJson and fromJson should work correctly', () {
      final profile = UserProfile(
        id: 'profile_1',
        nickname: 'Test User',
        avatar: 'avatar.jpg',
        createdAt: '2023-10-01T12:00:00Z',
        identity: UserIdentity.student,
        onboardingCompletedAt: '2023-10-01T12:05:00Z',
      );

      final json = profile.toJson();
      final decodedProfile = UserProfile.fromJson(json);

      expect(decodedProfile.id, profile.id);
      expect(decodedProfile.nickname, profile.nickname);
      expect(decodedProfile.avatar, profile.avatar);
      expect(decodedProfile.createdAt, profile.createdAt);
      expect(decodedProfile.identity, profile.identity);
      expect(
        decodedProfile.onboardingCompletedAt,
        profile.onboardingCompletedAt,
      );
    });
  });

  group('WardrobeItem Serialization', () {
    test('toJson and fromJson should work correctly', () {
      final item = WardrobeItem(
        id: 'item_1',
        name: 'Cool T-Shirt',
        category: ClothingCategory.top,
        subCategory: 'T-Shirt',
        images: ['base64_string'],
        optimizedImage: 'optimized_url',
        color: ['White'],
        colorPalette: [
          {'hex': '#ffffff'},
        ],
        style: [Style.casual],
        season: Season.summer,
        brand: 'Nike',
        purchaseDate: '2023-01-01',
        tags: ['cotton', 'comfortable'],
        createdAt: '2023-01-01T12:00:00Z',
        updatedAt: '2023-01-01T12:00:00Z',
      );

      final json = item.toJson();
      final decodedItem = WardrobeItem.fromJson(json);

      expect(decodedItem.id, item.id);
      expect(decodedItem.name, item.name);
      expect(decodedItem.category, item.category);
      expect(decodedItem.subCategory, item.subCategory);
      expect(decodedItem.images, item.images);
      expect(decodedItem.optimizedImage, item.optimizedImage);
      expect(decodedItem.color, item.color);
      expect(decodedItem.colorPalette, item.colorPalette);
      expect(decodedItem.style, item.style);
      expect(decodedItem.season, item.season);
      expect(decodedItem.brand, item.brand);
      expect(decodedItem.purchaseDate, item.purchaseDate);
      expect(decodedItem.tags, item.tags);
      expect(decodedItem.createdAt, item.createdAt);
      expect(decodedItem.updatedAt, item.updatedAt);
    });
  });
}
