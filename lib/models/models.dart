import 'package:flutter/material.dart';

// Enums and Models for WhatToWear Flutter

// ═══════ Clothing Category ═══════
enum ClothingCategory {
  top,
  bottom,
  shoes,
  accessory,
  outerwear;

  String get label {
    switch (this) {
      case top:
        return '上衣';
      case bottom:
        return '裤子';
      case shoes:
        return '鞋履';
      case accessory:
        return '配饰';
      case outerwear:
        return '外套';
    }
  }
}

// ═══════ Season ═══════
enum Season {
  spring,
  summer,
  autumn,
  winter,
  all;

  String get label {
    switch (this) {
      case spring:
        return '春季';
      case summer:
        return '夏季';
      case autumn:
        return '秋季';
      case winter:
        return '冬季';
      case all:
        return '四季';
    }
  }
}

// ═══════ Style ═══════
enum Style {
  casual,
  formal,
  sport,
  retro,
  trendy,
  minimalist;

  String get label {
    switch (this) {
      case casual:
        return '休闲';
      case formal:
        return '商务';
      case sport:
        return '运动';
      case retro:
        return '复古';
      case trendy:
        return '潮流';
      case minimalist:
        return '极简';
    }
  }
}

// ═══════ Occasion ═══════
enum Occasion {
  commute,
  date,
  sport,
  party,
  travel,
  work,
  casual,
  formal;

  String get label {
    switch (this) {
      case commute:
        return '通勤';
      case date:
        return '约会';
      case sport:
        return '运动';
      case party:
        return '聚会';
      case travel:
        return '旅行';
      case work:
        return '通勤';
      case casual:
        return '日常休闲';
      case formal:
        return '正式场合';
    }
  }
}

// ═══════ User Identity ═══════
enum UserIdentity {
  student,
  it,
  business,
  freelancer,
  fashionista,
  artist,
  other;

  String get name {
    switch (this) {
      case student:
        return '校园学生';
      case it:
        return '互联网/IT';
      case business:
        return '商务人士';
      case freelancer:
        return '自由职业';
      case fashionista:
        return '时尚达人';
      case artist:
        return '艺术工作者';
      case other:
        return '其他';
    }
  }

  String get description {
    switch (this) {
      case student:
        return '轻松休闲';
      case it:
        return '极客风格';
      case business:
        return '正式干练';
      case freelancer:
        return '随性舒适';
      case fashionista:
        return '潮流前线';
      case artist:
        return '个性独特';
      case other:
        return '自定义';
    }
  }

  IconData get icon {
    switch (this) {
      case student:
        return Icons.school;
      case it:
        return Icons.code;
      case business:
        return Icons.business_center;
      case freelancer:
        return Icons.coffee;
      case fashionista:
        return Icons.checkroom;
      case artist:
        return Icons.palette;
      case other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case student:
        return const Color(0xFF3B82F6);
      case it:
        return const Color(0xFFA855F7);
      case business:
        return const Color(0xFF64748B);
      case freelancer:
        return const Color(0xFFF59E0B);
      case fashionista:
        return const Color(0xFFEC4899);
      case artist:
        return const Color(0xFF14B8A6);
      case other:
        return const Color(0xFF64748B);
    }
  }
}

// ═══════ Weather Info ═══════
class WeatherInfo {
  final int temperature;
  final String condition;
  final int humidity;
  final String? icon;
  final String? uvIndex;
  final String? comfortLevel;
  final String? location;

  WeatherInfo({
    required this.temperature,
    required this.condition,
    required this.humidity,
    this.icon,
    this.uvIndex,
    this.comfortLevel,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'condition': condition,
    'humidity': humidity,
    'icon': icon,
    'uvIndex': uvIndex,
    'comfortLevel': comfortLevel,
    'location': location,
  };

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => WeatherInfo(
    temperature: json['temperature'] as int,
    condition: json['condition'] as String,
    humidity: json['humidity'] as int,
    icon: json['icon'] as String?,
    uvIndex: json['uvIndex'] as String?,
    comfortLevel: json['comfortLevel'] as String?,
    location: json['location'] as String?,
  );
}

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

// ═══════ Recommendation ═══════
class RecommendationItems {
  final WardrobeItem? top;
  final WardrobeItem? bottom;
  final WardrobeItem? shoes;
  final List<WardrobeItem>? accessories;
  final WardrobeItem? outerwear;

  RecommendationItems({
    this.top,
    this.bottom,
    this.shoes,
    this.accessories,
    this.outerwear,
  });

  Map<String, dynamic> toJson() => {
    'top': top?.toJson(),
    'bottom': bottom?.toJson(),
    'shoes': shoes?.toJson(),
    'accessories': accessories?.map((a) => a.toJson()).toList(),
    'outerwear': outerwear?.toJson(),
  };

  factory RecommendationItems.fromJson(Map<String, dynamic> json) =>
      RecommendationItems(
        top: json['top'] != null
            ? WardrobeItem.fromJson(json['top'] as Map<String, dynamic>)
            : null,
        bottom: json['bottom'] != null
            ? WardrobeItem.fromJson(json['bottom'] as Map<String, dynamic>)
            : null,
        shoes: json['shoes'] != null
            ? WardrobeItem.fromJson(json['shoes'] as Map<String, dynamic>)
            : null,
        accessories: json['accessories'] != null
            ? (json['accessories'] as List)
                  .map((a) => WardrobeItem.fromJson(a as Map<String, dynamic>))
                  .toList()
            : null,
        outerwear: json['outerwear'] != null
            ? WardrobeItem.fromJson(json['outerwear'] as Map<String, dynamic>)
            : null,
      );

  List<WardrobeItem> get allItems {
    return [
      outerwear,
      top,
      bottom,
      shoes,
      ...(accessories ?? []),
    ].whereType<WardrobeItem>().toList();
  }
}

class RecommendationContext {
  final String date;
  final String location;
  final String activity;
  final String person;
  final String requirements;
  final List<String>? tags;
  final String? freeText;

  RecommendationContext({
    this.date = '',
    this.location = '',
    this.activity = '',
    this.person = '',
    this.requirements = '',
    this.tags,
    this.freeText,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'location': location,
    'activity': activity,
    'person': person,
    'requirements': requirements,
    'tags': tags,
    'freeText': freeText,
  };

  factory RecommendationContext.fromJson(Map<String, dynamic> json) =>
      RecommendationContext(
        date: json['date'] as String? ?? '',
        location: json['location'] as String? ?? '',
        activity: json['activity'] as String? ?? '',
        person: json['person'] as String? ?? '',
        requirements: json['requirements'] as String? ?? '',
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        freeText: json['freeText'] as String?,
      );
}

class Recommendation {
  final String id;
  final String date;
  final WeatherInfo weather;
  final Occasion? occasion;
  final RecommendationItems items;
  final bool isFavorite;
  final int? matchPercentage;
  final String? reasoning;
  final String? generatedImage;
  final RecommendationContext? context;

  Recommendation({
    required this.id,
    required this.date,
    required this.weather,
    this.occasion,
    required this.items,
    required this.isFavorite,
    this.matchPercentage,
    this.reasoning,
    this.generatedImage,
    this.context,
  });

  Recommendation copyWith({
    String? id,
    String? date,
    WeatherInfo? weather,
    Occasion? occasion,
    RecommendationItems? items,
    bool? isFavorite,
    int? matchPercentage,
    String? reasoning,
    String? generatedImage,
    RecommendationContext? context,
  }) {
    return Recommendation(
      id: id ?? this.id,
      date: date ?? this.date,
      weather: weather ?? this.weather,
      occasion: occasion ?? this.occasion,
      items: items ?? this.items,
      isFavorite: isFavorite ?? this.isFavorite,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      reasoning: reasoning ?? this.reasoning,
      generatedImage: generatedImage ?? this.generatedImage,
      context: context ?? this.context,
    );
  }

  String get title {
    if (items.outerwear != null) {
      return '${items.outerwear!.name} & ${items.bottom?.name ?? ''}';
    }
    return '${items.top?.name ?? ''} & ${items.bottom?.name ?? ''}';
  }

  String? get mainImage {
    return generatedImage ??
        items.outerwear?.optimizedImage ??
        items.outerwear?.images.firstOrNull ??
        items.top?.optimizedImage ??
        items.top?.images.firstOrNull;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'weather': weather.toJson(),
    'occasion': occasion?.name,
    'items': items.toJson(),
    'isFavorite': isFavorite,
    'matchPercentage': matchPercentage,
    'reasoning': reasoning,
    'generatedImage': generatedImage,
    'context': context?.toJson(),
  };

  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
    id: json['id'] as String,
    date: json['date'] as String,
    weather: WeatherInfo.fromJson(json['weather'] as Map<String, dynamic>),
    occasion: json['occasion'] != null
        ? Occasion.values.firstWhere(
            (o) => o.name == json['occasion'],
            orElse: () => Occasion.casual,
          )
        : null,
    items: RecommendationItems.fromJson(json['items'] as Map<String, dynamic>),
    isFavorite: json['isFavorite'] as bool? ?? false,
    matchPercentage: json['matchPercentage'] as int?,
    reasoning: json['reasoning'] as String?,
    generatedImage: json['generatedImage'] as String?,
    context: json['context'] != null
        ? RecommendationContext.fromJson(
            json['context'] as Map<String, dynamic>,
          )
        : null,
  );
}

// ═══════ User Preference ═══════
class UserPreference {
  final String id;
  final List<Style> style;
  final List<String> preferredColors;
  final List<String> dislikedColors;
  final Map<String, String> size;
  final List<Occasion> occasions;
  final Map<String, bool> notifications;
  final String theme;

  UserPreference({
    required this.id,
    required this.style,
    required this.preferredColors,
    required this.dislikedColors,
    required this.size,
    required this.occasions,
    required this.notifications,
    required this.theme,
  });

  UserPreference copyWith({String? theme}) {
    return UserPreference(
      id: id,
      style: style,
      preferredColors: preferredColors,
      dislikedColors: dislikedColors,
      size: size,
      occasions: occasions,
      notifications: notifications,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'style': style.map((s) => s.name).toList(),
    'preferredColors': preferredColors,
    'dislikedColors': dislikedColors,
    'size': size,
    'occasions': occasions.map((o) => o.name).toList(),
    'notifications': notifications,
    'theme': theme,
  };

  factory UserPreference.fromJson(Map<String, dynamic> json) => UserPreference(
    id: json['id'] as String,
    style:
        (json['style'] as List?)
            ?.map(
              (s) => Style.values.firstWhere(
                (st) => st.name == s,
                orElse: () => Style.casual,
              ),
            )
            .toList() ??
        [Style.casual],
    preferredColors: List<String>.from(json['preferredColors'] ?? []),
    dislikedColors: List<String>.from(json['dislikedColors'] ?? []),
    size: Map<String, String>.from(json['size'] ?? {}),
    occasions:
        (json['occasions'] as List?)
            ?.map(
              (o) => Occasion.values.firstWhere(
                (oc) => oc.name == o,
                orElse: () => Occasion.casual,
              ),
            )
            .toList() ??
        [],
    notifications: Map<String, bool>.from(json['notifications'] ?? {}),
    theme: json['theme'] as String? ?? 'dark',
  );

  static UserPreference get defaultPreference => UserPreference(
    id: 'default',
    style: [Style.casual],
    preferredColors: [],
    dislikedColors: [],
    size: {'top': 'M', 'bottom': 'M', 'shoes': '42'},
    occasions: [],
    notifications: {'dailyRecommendation': false, 'weatherAlert': false},
    theme: 'dark',
  );
}

// ═══════ User Profile ═══════
class UserProfile {
  final String id;
  final String? nickname;
  final String? avatar;
  final String createdAt;
  final UserIdentity? identity;
  final String? onboardingCompletedAt;

  UserProfile({
    required this.id,
    this.nickname,
    this.avatar,
    required this.createdAt,
    this.identity,
    this.onboardingCompletedAt,
  });

  UserProfile copyWith({
    String? nickname,
    UserIdentity? identity,
    String? onboardingCompletedAt,
  }) {
    return UserProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatar: avatar,
      createdAt: createdAt,
      identity: identity ?? this.identity,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nickname': nickname,
    'avatar': avatar,
    'createdAt': createdAt,
    'identity': identity?.name,
    'onboardingCompletedAt': onboardingCompletedAt,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    nickname: json['nickname'] as String?,
    avatar: json['avatar'] as String?,
    createdAt: json['createdAt'] as String,
    identity: json['identity'] != null
        ? UserIdentity.values.firstWhere(
            (i) => i.name == json['identity'],
            orElse: () => UserIdentity.other,
          )
        : null,
    onboardingCompletedAt: json['onboardingCompletedAt'] as String?,
  );
}
