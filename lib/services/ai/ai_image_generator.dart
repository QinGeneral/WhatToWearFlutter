import '../../models/models.dart';

/// 图片生成接口 — 生成衣服优化图和穿搭效果图。
///
/// 合并了衣物图片优化（flat-lay 产品图）和穿衣效果图（虚拟试穿）两个能力。
/// 不同 AI 提供商实现此接口即可替换底层模型。
abstract class AIImageGenerator {
  /// 优化衣物图片：去皱、专业背景、平铺产品摄影效果。
  ///
  /// [base64Image] 原始图片 base64 数据。
  /// [color] 可选，衣物主色调，用于智能推荐互补背景色。
  /// 返回优化后图片的原始 base64 字符串（不含 data URI 前缀）。
  Future<String> optimizeClothingImage(String base64Image, {String? color});

  /// 根据推荐搭配生成穿衣效果图（虚拟试穿）。
  ///
  /// [recommendation] 包含搭配单品信息的推荐对象。
  /// 返回生成的穿衣图 data URI 或 base64 字符串。
  Future<String> generateOutfitImage(Recommendation recommendation);
}
