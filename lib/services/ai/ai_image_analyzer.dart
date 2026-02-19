import '../../../models/models.dart';

// ═══════ Image Analysis Result ═══════

/// Result of AI clothing image analysis.
class ImageAnalysisResult {
  final String name;
  final String? brand;
  final ClothingCategory category;
  final String color;
  final String? colorHex;
  final Season season;
  final String material;

  ImageAnalysisResult({
    required this.name,
    this.brand,
    required this.category,
    required this.color,
    this.colorHex,
    required this.season,
    required this.material,
  });

  factory ImageAnalysisResult.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String? ?? 'top';
    final category = ClothingCategory.values.firstWhere(
      (c) => c.name == categoryStr,
      orElse: () => ClothingCategory.top,
    );

    final seasonStr = json['season'] as String? ?? 'all';
    final season = Season.values.firstWhere(
      (s) => s.name == seasonStr,
      orElse: () => Season.all,
    );

    return ImageAnalysisResult(
      name: json['name'] as String? ?? '未知衣物',
      brand: (json['brand'] as String?)?.isNotEmpty == true
          ? json['brand'] as String
          : null,
      category: category,
      color: json['color'] as String? ?? '黑色',
      colorHex: json['colorHex'] as String?,
      season: season,
      material: json['material'] as String? ?? '未知',
    );
  }
}

// ═══════ Abstract Interface ═══════

/// 衣物图片分析接口 — 通过 AI 识别图片中衣物的属性信息。
///
/// 不同 AI 提供商（Gemini、OpenAI 等）实现此接口即可替换底层模型。
abstract class AIImageAnalyzer {
  /// 分析衣物图片，返回结构化属性数据（名称、类别、颜色、季节等）。
  ///
  /// [base64Image] 应为原始 base64 编码的图片数据（不含 data URI 前缀）。
  Future<ImageAnalysisResult> analyzeClothingImage(String base64Image);
}
