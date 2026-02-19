import 'ai_image_analyzer.dart';
import 'ai_image_generator.dart';
import 'ai_outfit_recommender.dart';

/// 聚合所有 AI 服务能力的提供者。
///
/// 通过 Provider 注入到 widget tree 中，调用方无需关心底层使用的 AI 模型。
/// 切换 AI 提供商时只需在创建处替换具体实现。
class AIServiceProvider {
  final AIImageAnalyzer imageAnalyzer;
  final AIImageGenerator imageGenerator;
  final AIOutfitRecommender outfitRecommender;

  const AIServiceProvider({
    required this.imageAnalyzer,
    required this.imageGenerator,
    required this.outfitRecommender,
  });
}
