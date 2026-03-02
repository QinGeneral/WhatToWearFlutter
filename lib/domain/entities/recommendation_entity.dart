import 'package:freezed_annotation/freezed_annotation.dart';
import 'weather_info_entity.dart';
import 'wardrobe_item_entity.dart';

part 'recommendation_entity.freezed.dart';
part 'recommendation_entity.g.dart';

// ═══════ Recommendation Items Entity ═══════
@freezed
class RecommendationItemsEntity with _$RecommendationItemsEntity {
  const factory RecommendationItemsEntity({
    WardrobeItemEntity? top,
    WardrobeItemEntity? bottom,
    WardrobeItemEntity? shoes,
    List<WardrobeItemEntity>? accessories,
    WardrobeItemEntity? outerwear,
  }) = _RecommendationItemsEntity;

  factory RecommendationItemsEntity.fromJson(Map<String, dynamic> json) =>
      _$RecommendationItemsEntityFromJson(json);
}

// ═══════ Recommendation Context Entity ═══════
@freezed
class RecommendationContextEntity with _$RecommendationContextEntity {
  const factory RecommendationContextEntity({
    @Default('') String date,
    @Default('') String location,
    @Default('') String activity,
    @Default('') String person,
    @Default('') String requirements,
    List<String>? tags,
    String? freeText,
  }) = _RecommendationContextEntity;

  factory RecommendationContextEntity.fromJson(Map<String, dynamic> json) =>
      _$RecommendationContextEntityFromJson(json);
}

// ═══════ Recommendation Entity ═══════
@freezed
class RecommendationEntity with _$RecommendationEntity {
  const factory RecommendationEntity({
    required String id,
    required String date,
    required WeatherInfoEntity weather,
    OccasionEntity? occasion,
    required RecommendationItemsEntity items,
    @Default(false) bool isFavorite,
    int? matchPercentage,
    String? reasoning,
    String? generatedImage,
    RecommendationContextEntity? context,
  }) = _RecommendationEntity;

  factory RecommendationEntity.fromJson(Map<String, dynamic> json) =>
      _$RecommendationEntityFromJson(json);
}

// ═══════ Occasion Entity ═══════
enum OccasionEntity {
  commute,
  date,
  sport,
  party,
  travel,
  work,
  casual,
  formal,
}
