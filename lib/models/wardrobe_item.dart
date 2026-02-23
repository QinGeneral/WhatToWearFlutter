import 'package:what_to_wear_flutter/models/enums.dart';

// ═══════ Wardrobe Item ═══════
class WardrobeItem {
  final String id;
  final String name;
  final ClothingCategory category;
  final String? subCategory;
  final List<String> images; // base64
  final String? optimizedImage;
  final List<String> color;
  final List<Map<String, String>>? colorPalette;
  final List<Style> style;
  final Season season;
  final String? brand;
  final String? purchaseDate;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    this.subCategory,
    required this.images,
    this.optimizedImage,
    required this.color,
    this.colorPalette,
    required this.style,
    required this.season,
    this.brand,
    this.purchaseDate,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  WardrobeItem copyWith({
    String? id,
    String? name,
    ClothingCategory? category,
    String? subCategory,
    List<String>? images,
    String? optimizedImage,
    List<String>? color,
    List<Map<String, String>>? colorPalette,
    List<Style>? style,
    Season? season,
    String? brand,
    String? purchaseDate,
    List<String>? tags,
    String? createdAt,
    String? updatedAt,
  }) {
    return WardrobeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      images: images ?? this.images,
      optimizedImage: optimizedImage ?? this.optimizedImage,
      color: color ?? this.color,
      colorPalette: colorPalette ?? this.colorPalette,
      style: style ?? this.style,
      season: season ?? this.season,
      brand: brand ?? this.brand,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.name,
    'subCategory': subCategory,
    'images': images,
    'optimizedImage': optimizedImage,
    'color': color,
    'colorPalette': colorPalette,
    'style': style.map((s) => s.name).toList(),
    'season': season.name,
    'brand': brand,
    'purchaseDate': purchaseDate,
    'tags': tags,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory WardrobeItem.fromJson(Map<String, dynamic> json) => WardrobeItem(
    id: json['id'] as String,
    name: json['name'] as String,
    category: ClothingCategory.values.firstWhere(
      (c) => c.name == json['category'],
      orElse: () => ClothingCategory.top,
    ),
    subCategory: json['subCategory'] as String?,
    images: List<String>.from(json['images'] ?? []),
    optimizedImage: json['optimizedImage'] as String?,
    color: List<String>.from(json['color'] ?? []),
    colorPalette: json['colorPalette'] != null
        ? List<Map<String, String>>.from(
            (json['colorPalette'] as List).map(
              (e) => Map<String, String>.from(e as Map),
            ),
          )
        : null,
    style:
        (json['style'] as List?)
            ?.map(
              (s) => Style.values.firstWhere(
                (st) => st.name == s,
                orElse: () => Style.casual,
              ),
            )
            .toList() ??
        [],
    season: Season.values.firstWhere(
      (s) => s.name == json['season'],
      orElse: () => Season.all,
    ),
    brand: json['brand'] as String?,
    purchaseDate: json['purchaseDate'] as String?,
    tags: List<String>.from(json['tags'] ?? []),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}
