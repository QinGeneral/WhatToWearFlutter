import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

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
    // Parse category with fallback
    final categoryStr = json['category'] as String? ?? 'top';
    final category = ClothingCategory.values.firstWhere(
      (c) => c.name == categoryStr,
      orElse: () => ClothingCategory.top,
    );

    // Parse season with fallback
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

/// Service for analyzing clothing images using Gemini AI.
class ImageAnalysisService {
  static const _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Analyzes a clothing image and returns structured data.
  ///
  /// [base64Image] should be the raw base64-encoded image data (no data URI prefix).
  static Future<ImageAnalysisResult> analyzeClothingImage(
    String base64Image,
  ) async {
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

      const prompt = '''
Analyze this clothing image and provide the following details.
Return ONLY a JSON object with these fields:
{
    "name": "Short descriptive name in Chinese (e.g. 白色亚麻衬衫)",
    "brand": "Brand name if visible/detectable, otherwise empty string (e.g. Nike, Uniqlo)",
    "category": "One of ['top', 'bottom', 'shoes', 'accessory', 'outerwear']",
    "color": "The dominant color definition in Chinese (e.g. 黑色, 白色, 蓝色)",
    "colorHex": "The dominant color hex code (e.g. #FFFFFF)",
    "season": "One of ['spring', 'summer', 'autumn', 'winter', 'all']",
    "material": "Likely material in Chinese (e.g. 棉, 麻, 羊毛, 丝绸, 牛仔, 皮革, 聚酯纤维)"
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

      debugPrint('[ImageAnalysis] Response: $text');

      final decoded = jsonDecode(text);
      final Map<String, dynamic> jsonResult;
      if (decoded is List && decoded.isNotEmpty) {
        jsonResult = decoded.first as Map<String, dynamic>;
      } else {
        jsonResult = decoded as Map<String, dynamic>;
      }
      return ImageAnalysisResult.fromJson(jsonResult);
    } catch (e) {
      debugPrint('[ImageAnalysis] Error: $e');
      rethrow;
    }
  }

  /// Optimizes a clothing image using Gemini AI image generation.
  ///
  /// Uses the Gemini REST API directly (not the SDK) because the
  /// `google_generative_ai` v0.4.7 SDK doesn't support parsing image
  /// (`inlineData`) responses or setting `responseModalities`.
  ///
  /// If [color] is provided, AI will suggest a complementary background color.
  /// Returns the optimized image as a raw base64 string (no data URI prefix).
  static Future<String> optimizeImage(
    String base64Image, {
    String? color,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY 未配置。请通过 --dart-define=GEMINI_API_KEY=your_key 传入。',
      );
    }

    try {
      // Step 1: Get ideal background color suggestion using SDK (text-only)
      String backgroundPrompt = 'clean, neutral background';

      if (color != null && color.isNotEmpty) {
        try {
          final textModel = GenerativeModel(
            model: 'gemini-2.0-flash',
            apiKey: _apiKey,
          );

          final backgroundQuery =
              '''
You are a professional product photographer.
For a clothing item with the color "$color", suggest ONE specific background color that would make it look premium.
Examples:
- Input: "White" -> Output: "soft heather grey"
- Input: "Black" -> Output: "warm cream"
- Input: "Navy Blue" -> Output: "clean white"

Return ONLY the color name description. No explanations.
''';

          final colorResult = await textModel.generateContent([
            Content.text(backgroundQuery),
          ]);
          final suggestedColor = colorResult.text?.trim();

          if (suggestedColor != null && suggestedColor.isNotEmpty) {
            debugPrint(
              '[ImageOptimize] AI suggested background for $color: $suggestedColor',
            );
            backgroundPrompt = '$suggestedColor background';
          }
        } catch (e) {
          debugPrint('[ImageOptimize] Failed to get background suggestion: $e');
        }
      }

      // Step 2: Generate the optimized image using raw HTTP
      // (SDK v0.4.7 can't parse inlineData image responses)
      final prompt =
          '''Re-generate this clothing image as a high-quality, professional flat-lay product photography.

CRITICAL REQUIREMENTS:
1. The clothing item in the output MUST be identical to the input image in terms of design, pattern, logo, text, color, texture, and material.
2. Do not change the shape or style of the clothing.
3. The goal is only to improve the presentation: remove wrinkles, improve lighting, and make it look neatly laid out (flat-lay).
4. Place the item on a professional $backgroundPrompt.
5. Do NOT crop the item; ensure the entire item is visible.
''';

      const imageGenModel = 'gemini-3-pro-image-preview';
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1alpha/models/$imageGenModel:generateContent?key=$_apiKey',
      );

      final requestBody = jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'inlineData': {'mimeType': 'image/jpeg', 'data': base64Image},
              },
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.3,
          'imageConfig': {'aspectRatio': '1:1', 'imageSize': '1K'},
        },
      });

      debugPrint('[ImageOptimize] Sending request to Gemini image gen API...');

      final httpResponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (httpResponse.statusCode != 200) {
        debugPrint(
          '[ImageOptimize] API error ${httpResponse.statusCode}: ${httpResponse.body}',
        );
        throw Exception(
          'Gemini API 返回错误 (${httpResponse.statusCode}): ${httpResponse.reasonPhrase}',
        );
      }

      final responseJson =
          jsonDecode(httpResponse.body) as Map<String, dynamic>;

      // Parse the response to extract inline image data
      final candidates = responseJson['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('Gemini 未返回任何候选结果');
      }

      final parts =
          (candidates[0]['content'] as Map<String, dynamic>)['parts']
              as List<dynamic>;

      for (final part in parts) {
        final partMap = part as Map<String, dynamic>;
        if (partMap.containsKey('inlineData')) {
          final inlineData = partMap['inlineData'] as Map<String, dynamic>;
          final imageBase64 = inlineData['data'] as String?;
          if (imageBase64 != null && imageBase64.isNotEmpty) {
            debugPrint(
              '[ImageOptimize] Successfully generated optimized image (${imageBase64.length} chars)',
            );
            return imageBase64;
          }
        }
      }

      throw Exception('Gemini 未能生成优化后的图片');
    } catch (e) {
      debugPrint('[ImageOptimize] Error: $e');
      rethrow;
    }
  }
}
