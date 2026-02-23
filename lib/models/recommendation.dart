import 'package:what_to_wear_flutter/models/enums.dart';
import 'package:what_to_wear_flutter/models/wardrobe_item.dart';
import 'package:what_to_wear_flutter/models/weather_info.dart';

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
