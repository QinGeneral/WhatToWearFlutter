// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WardrobeItemEntityImpl _$$WardrobeItemEntityImplFromJson(
  Map<String, dynamic> json,
) => _$WardrobeItemEntityImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  category: $enumDecode(_$ClothingCategoryEntityEnumMap, json['category']),
  subCategory: json['subCategory'] as String?,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  optimizedImage: json['optimizedImage'] as String?,
  color: (json['color'] as List<dynamic>).map((e) => e as String).toList(),
  colorPalette: (json['colorPalette'] as List<dynamic>?)
      ?.map((e) => Map<String, String>.from(e as Map))
      .toList(),
  style: (json['style'] as List<dynamic>)
      .map((e) => $enumDecode(_$StyleEntityEnumMap, e))
      .toList(),
  season: $enumDecode(_$SeasonEntityEnumMap, json['season']),
  brand: json['brand'] as String?,
  purchaseDate: json['purchaseDate'] as String?,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  material: json['material'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$WardrobeItemEntityImplToJson(
  _$WardrobeItemEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': _$ClothingCategoryEntityEnumMap[instance.category]!,
  'subCategory': instance.subCategory,
  'images': instance.images,
  'optimizedImage': instance.optimizedImage,
  'color': instance.color,
  'colorPalette': instance.colorPalette,
  'style': instance.style.map((e) => _$StyleEntityEnumMap[e]!).toList(),
  'season': _$SeasonEntityEnumMap[instance.season]!,
  'brand': instance.brand,
  'purchaseDate': instance.purchaseDate,
  'tags': instance.tags,
  'material': instance.material,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

const _$ClothingCategoryEntityEnumMap = {
  ClothingCategoryEntity.top: 'top',
  ClothingCategoryEntity.bottom: 'bottom',
  ClothingCategoryEntity.shoes: 'shoes',
  ClothingCategoryEntity.accessory: 'accessory',
  ClothingCategoryEntity.outerwear: 'outerwear',
};

const _$StyleEntityEnumMap = {
  StyleEntity.casual: 'casual',
  StyleEntity.formal: 'formal',
  StyleEntity.sport: 'sport',
  StyleEntity.retro: 'retro',
  StyleEntity.trendy: 'trendy',
  StyleEntity.minimalist: 'minimalist',
};

const _$SeasonEntityEnumMap = {
  SeasonEntity.spring: 'spring',
  SeasonEntity.summer: 'summer',
  SeasonEntity.autumn: 'autumn',
  SeasonEntity.winter: 'winter',
  SeasonEntity.all: 'all',
};
