import '../../models/models.dart';

// ═══════ Request / Result Data Classes ═══════

/// User request data for AI outfit recommendation.
class UserRequest {
  final String date;
  final String location;
  final String activity;
  final String person;
  final String requirements;

  UserRequest({
    this.date = '',
    this.location = '',
    this.activity = '',
    this.person = '',
    this.requirements = '',
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'location': location,
    'activity': activity,
    'person': person,
    'requirements': requirements,
  };
}

/// Single outfit result from AI.
class OutfitResult {
  final String? topId;
  final String? bottomId;
  final String? shoesId;
  final String? outerwearId;
  final List<String>? accessoryIds;
  final String reasoning;
  final int matchPercentage;

  OutfitResult({
    this.topId,
    this.bottomId,
    this.shoesId,
    this.outerwearId,
    this.accessoryIds,
    required this.reasoning,
    required this.matchPercentage,
  });

  factory OutfitResult.fromJson(Map<String, dynamic> json) {
    return OutfitResult(
      topId: json['topId'] as String?,
      bottomId: json['bottomId'] as String?,
      shoesId: json['shoesId'] as String?,
      outerwearId: json['outerwearId'] as String?,
      accessoryIds: json['accessoryIds'] != null
          ? List<String>.from(json['accessoryIds'])
          : null,
      reasoning: json['reasoning'] as String? ?? '',
      matchPercentage: json['matchPercentage'] as int? ?? 80,
    );
  }
}

/// Result wrapper containing multiple outfit suggestions.
class AIRecommendationResult {
  final List<OutfitResult> outfits;

  AIRecommendationResult({required this.outfits});

  factory AIRecommendationResult.fromJson(Map<String, dynamic> json) {
    final outfitsList =
        (json['outfits'] as List?)
            ?.map((e) => OutfitResult.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return AIRecommendationResult(outfits: outfitsList);
  }
}

// ═══════ Abstract Interface ═══════

/// 穿搭推荐接口 — AI 根据用户衣橱、当前天气和穿着场景需求推荐搭配方案。
///
/// 不同 AI 提供商实现此接口即可替换底层模型。
abstract class AIOutfitRecommender {
  /// 根据用户请求、衣橱数据和天气信息生成穿搭推荐。
  ///
  /// 返回 [AIRecommendationResult]，包含最多 3 套搭配方案。
  Future<AIRecommendationResult> getRecommendation({
    required UserRequest request,
    required List<WardrobeItem> wardrobe,
    required WeatherInfo weather,
    String language = 'zh',
  });
}
