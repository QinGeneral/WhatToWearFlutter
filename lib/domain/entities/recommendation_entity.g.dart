// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationItemsEntityImpl _$$RecommendationItemsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationItemsEntityImpl(
  top: json['top'] == null
      ? null
      : WardrobeItemEntity.fromJson(json['top'] as Map<String, dynamic>),
  bottom: json['bottom'] == null
      ? null
      : WardrobeItemEntity.fromJson(json['bottom'] as Map<String, dynamic>),
  shoes: json['shoes'] == null
      ? null
      : WardrobeItemEntity.fromJson(json['shoes'] as Map<String, dynamic>),
  accessories: (json['accessories'] as List<dynamic>?)
      ?.map((e) => WardrobeItemEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  outerwear: json['outerwear'] == null
      ? null
      : WardrobeItemEntity.fromJson(json['outerwear'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RecommendationItemsEntityImplToJson(
  _$RecommendationItemsEntityImpl instance,
) => <String, dynamic>{
  'top': instance.top,
  'bottom': instance.bottom,
  'shoes': instance.shoes,
  'accessories': instance.accessories,
  'outerwear': instance.outerwear,
};

_$RecommendationContextEntityImpl _$$RecommendationContextEntityImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationContextEntityImpl(
  date: json['date'] as String? ?? '',
  location: json['location'] as String? ?? '',
  activity: json['activity'] as String? ?? '',
  person: json['person'] as String? ?? '',
  requirements: json['requirements'] as String? ?? '',
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  freeText: json['freeText'] as String?,
);

Map<String, dynamic> _$$RecommendationContextEntityImplToJson(
  _$RecommendationContextEntityImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'location': instance.location,
  'activity': instance.activity,
  'person': instance.person,
  'requirements': instance.requirements,
  'tags': instance.tags,
  'freeText': instance.freeText,
};

_$RecommendationEntityImpl _$$RecommendationEntityImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationEntityImpl(
  id: json['id'] as String,
  date: json['date'] as String,
  weather: WeatherInfoEntity.fromJson(json['weather'] as Map<String, dynamic>),
  occasion: $enumDecodeNullable(_$OccasionEntityEnumMap, json['occasion']),
  items: RecommendationItemsEntity.fromJson(
    json['items'] as Map<String, dynamic>,
  ),
  isFavorite: json['isFavorite'] as bool? ?? false,
  matchPercentage: (json['matchPercentage'] as num?)?.toInt(),
  reasoning: json['reasoning'] as String?,
  generatedImage: json['generatedImage'] as String?,
  context: json['context'] == null
      ? null
      : RecommendationContextEntity.fromJson(
          json['context'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$RecommendationEntityImplToJson(
  _$RecommendationEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'weather': instance.weather,
  'occasion': _$OccasionEntityEnumMap[instance.occasion],
  'items': instance.items,
  'isFavorite': instance.isFavorite,
  'matchPercentage': instance.matchPercentage,
  'reasoning': instance.reasoning,
  'generatedImage': instance.generatedImage,
  'context': instance.context,
};

const _$OccasionEntityEnumMap = {
  OccasionEntity.commute: 'commute',
  OccasionEntity.date: 'date',
  OccasionEntity.sport: 'sport',
  OccasionEntity.party: 'party',
  OccasionEntity.travel: 'travel',
  OccasionEntity.work: 'work',
  OccasionEntity.casual: 'casual',
  OccasionEntity.formal: 'formal',
};
