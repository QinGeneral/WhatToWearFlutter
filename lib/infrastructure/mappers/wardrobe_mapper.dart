import 'package:what_to_wear_flutter/domain/entities/entities.dart';

/// Mapper for converting between old model and domain entity
class WardrobeMapper {
  // ═══════ Entity -> Old Model (for backward compatibility during transition) ═══════

  static ClothingCategoryEntity _categoryToEntity(String category) {
    return ClothingCategoryEntity.values.firstWhere(
      (e) => e.name == category,
      orElse: () => ClothingCategoryEntity.top,
    );
  }

  static String _categoryToString(ClothingCategoryEntity entity) {
    return entity.name;
  }

  static SeasonEntity _seasonToEntity(String season) {
    return SeasonEntity.values.firstWhere(
      (e) => e.name == season,
      orElse: () => SeasonEntity.all,
    );
  }

  static String _seasonToString(SeasonEntity entity) {
    return entity.name;
  }

  static StyleEntity _styleToEntity(String style) {
    return StyleEntity.values.firstWhere(
      (e) => e.name == style,
      orElse: () => StyleEntity.casual,
    );
  }

  static String _styleToString(StyleEntity entity) {
    return entity.name;
  }

  // ═══════ JSON -> Entity ═══════
  static WardrobeItemEntity fromJson(Map<String, dynamic> json) {
    return WardrobeItemEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      category: _categoryToEntity(json['category'] as String),
      subCategory: json['subCategory'] as String?,
      images: List<String>.from(json['images'] ?? []),
      optimizedImage: json['optimizedImage'] as String?,
      color: List<String>.from(json['color'] ?? []),
      colorPalette: json['colorPalette'] != null
          ? (json['colorPalette'] as List)
              .map((e) => Map<String, String>.from(e as Map))
              .toList()
          : null,
      style: (json['style'] as List?)
              ?.map((s) => _styleToEntity(s as String))
              .toList() ??
          [],
      season: _seasonToEntity(json['season'] as String),
      brand: json['brand'] as String?,
      purchaseDate: json['purchaseDate'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  // ═══════ Entity -> JSON ═══════
  static Map<String, dynamic> toJson(WardrobeItemEntity entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'category': _categoryToString(entity.category),
      'subCategory': entity.subCategory,
      'images': entity.images,
      'optimizedImage': entity.optimizedImage,
      'color': entity.color,
      'colorPalette': entity.colorPalette,
      'style': entity.style.map(_styleToString).toList(),
      'season': _seasonToString(entity.season),
      'brand': entity.brand,
      'purchaseDate': entity.purchaseDate,
      'tags': entity.tags,
      'createdAt': entity.createdAt,
      'updatedAt': entity.updatedAt,
    };
  }
}
