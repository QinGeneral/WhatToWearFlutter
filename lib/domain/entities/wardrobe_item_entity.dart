import 'package:freezed_annotation/freezed_annotation.dart';

part 'wardrobe_item_entity.freezed.dart';
part 'wardrobe_item_entity.g.dart';

// ═══════ Wardrobe Item Entity ═══════
@freezed
class WardrobeItemEntity with _$WardrobeItemEntity {
  const factory WardrobeItemEntity({
    required String id,
    required String name,
    required ClothingCategoryEntity category,
    String? subCategory,
    required List<String> images,
    String? optimizedImage,
    required List<String> color,
    List<Map<String, String>>? colorPalette,
    required List<StyleEntity> style,
    required SeasonEntity season,
    String? brand,
    String? purchaseDate,
    required List<String> tags,
    required String createdAt,
    String? updatedAt,
  }) = _WardrobeItemEntity;

  factory WardrobeItemEntity.fromJson(Map<String, dynamic> json) =>
      _$WardrobeItemEntityFromJson(json);
}

// ═══════ Clothing Category ═══════
enum ClothingCategoryEntity {
  top,
  bottom,
  shoes,
  accessory,
  outerwear,
}

// ═══════ Season ═══════
enum SeasonEntity {
  spring,
  summer,
  autumn,
  winter,
  all,
}

// ═══════ Style ═══════
enum StyleEntity {
  casual,
  formal,
  sport,
  retro,
  trendy,
  minimalist,
}
