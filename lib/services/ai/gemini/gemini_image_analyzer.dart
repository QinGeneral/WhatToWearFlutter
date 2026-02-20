import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../ai_image_analyzer.dart';

/// Gemini 实现的衣物图片分析服务。
class GeminiImageAnalyzer implements AIImageAnalyzer {
  final String _apiKey;

  GeminiImageAnalyzer({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  @override
  Future<ImageAnalysisResult> analyzeClothingImage(
    String base64Image, {
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY 未配置。请通过 --dart-define=GEMINI_API_KEY=your_key 传入。',
      );
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final imageBytes = base64Decode(base64Image);

      final langInstruction = language == 'en' ? 'in English' : 'in Chinese';

      final prompt =
          '''
Analyze this clothing image and provide the following details.
Return ONLY a JSON object with these fields:
{
    "name": "Short descriptive name $langInstruction (e.g. 白色亚麻衬衫 or White linen shirt)",
    "brand": "Brand name if visible/detectable, otherwise empty string (e.g. Nike, Uniqlo)",
    "category": "One of ['top', 'bottom', 'shoes', 'accessory', 'outerwear']",
    "color": "The dominant color definition $langInstruction (e.g. 黑色, 白色, 蓝色 or Black, White, Blue)",
    "colorHex": "The dominant color hex code (e.g. #FFFFFF)",
    "season": "One of ['spring', 'summer', 'autumn', 'winter', 'all']",
    "material": "Likely material $langInstruction (e.g. 棉, 麻, 羊毛, 聚酯纤维 or Cotton, Linen, Wool)"
}

Strictly follow the allowed values for 'category' and 'season'.
''';

      final content = Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', Uint8List.fromList(imageBytes)),
      ]);

      final response = await model.generateContent([content]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('Gemini 返回了空响应');
      }

      debugPrint('[GeminiImageAnalyzer] Response: $text');

      final decoded = jsonDecode(text);
      final Map<String, dynamic> jsonResult;
      if (decoded is List && decoded.isNotEmpty) {
        jsonResult = decoded.first as Map<String, dynamic>;
      } else {
        jsonResult = decoded as Map<String, dynamic>;
      }
      return ImageAnalysisResult.fromJson(jsonResult);
    } catch (e) {
      debugPrint('[GeminiImageAnalyzer] Error: $e');
      rethrow;
    }
  }
}
