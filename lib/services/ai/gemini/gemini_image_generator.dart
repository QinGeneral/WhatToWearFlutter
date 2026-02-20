import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_image_generator.dart';

/// Gemini 实现的图片生成服务（衣服优化图 + 穿衣效果图）。
class GeminiImageGenerator implements AIImageGenerator {
  final String _apiKey;

  /// Image generation model name (requires image generation capability).
  static const String _imageGenModel = 'gemini-3-pro-image-preview';

  GeminiImageGenerator({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  @override
  Future<String> optimizeClothingImage(
    String base64Image, {
    String? color,
    String language = 'zh',
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
              '[GeminiImageGenerator] AI suggested background for $color: $suggestedColor',
            );
            backgroundPrompt = '$suggestedColor background';
          }
        } catch (e) {
          debugPrint(
            '[GeminiImageGenerator] Failed to get background suggestion: $e',
          );
        }
      }

      // Step 2: Generate the optimized image using raw HTTP
      final prompt =
          '''Re-generate this clothing image as a high-quality, professional flat-lay product photography.

CRITICAL REQUIREMENTS:
1. The clothing item in the output MUST be identical to the input image in terms of design, pattern, logo, text, color, texture, and material.
2. Do not change the shape or style of the clothing.
3. The goal is only to improve the presentation: remove wrinkles, improve lighting, and make it look neatly laid out (flat-lay).
4. Place the item on a professional $backgroundPrompt.
5. Do NOT crop the item; ensure the entire item is visible.
''';

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1alpha/models/$_imageGenModel:generateContent?key=$_apiKey',
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

      debugPrint(
        '[GeminiImageGenerator] Sending optimize request to Gemini...',
      );

      final httpResponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (httpResponse.statusCode != 200) {
        debugPrint(
          '[GeminiImageGenerator] API error ${httpResponse.statusCode}: ${httpResponse.body}',
        );
        throw Exception(
          'Gemini API 返回错误 (${httpResponse.statusCode}): ${httpResponse.reasonPhrase}',
        );
      }

      final responseJson =
          jsonDecode(httpResponse.body) as Map<String, dynamic>;

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
              '[GeminiImageGenerator] Successfully generated optimized image (${imageBase64.length} chars)',
            );
            return imageBase64;
          }
        }
      }

      throw Exception('Gemini 未能生成优化后的图片');
    } catch (e) {
      debugPrint('[GeminiImageGenerator] optimizeClothingImage error: $e');
      rethrow;
    }
  }

  @override
  Future<String> generateOutfitImage(
    Recommendation recommendation, {
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY 未配置。请通过 --dart-define=GEMINI_API_KEY=your_key 传入。',
      );
    }

    try {
      final itemsDescription = [
        recommendation.items.outerwear?.name,
        recommendation.items.top?.name,
        recommendation.items.bottom?.name,
        recommendation.items.shoes?.name,
        ...(recommendation.items.accessories?.map((a) => a.name) ?? []),
      ].where((item) => item != null && item.isNotEmpty).join(', ');

      final promptText =
          '''
Generate a high-fidelity, photorealistic full-body fashion photo of a plastic mannequin wearing EXACTLY the following clothing items: $itemsDescription.

CRITICAL REQUIREMENTS:
1. The clothing in the generated image must strictly match the reference descriptions in color, texture, pattern, and design details.
2. Do not alter, simplify, or hallucinate new features on the clothing.
3. Ensure natural fabric draping and realistic fit on the mannequin.
4. The subject must be a headless or abstract plastic mannequin, NOT a real human.

Setting: Minimalist studio, soft professional lighting, 1k resolution, highly detailed.
''';

      // Prepare payload
      final parts = <Map<String, dynamic>>[];
      parts.add({'text': promptText});

      // Add reference images
      void addImageIfPresent(String? base64Image) {
        if (base64Image != null && base64Image.isNotEmpty) {
          final cleanBase64 = base64Image.contains(',')
              ? base64Image.split(',').last
              : base64Image;

          parts.add({
            'inlineData': {'mimeType': 'image/jpeg', 'data': cleanBase64},
          });
        }
      }

      addImageIfPresent(recommendation.items.top?.images.firstOrNull);
      addImageIfPresent(recommendation.items.bottom?.images.firstOrNull);
      addImageIfPresent(recommendation.items.outerwear?.images.firstOrNull);

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1alpha/models/$_imageGenModel:generateContent?key=$_apiKey',
      );

      final requestBody = jsonEncode({
        'contents': [
          {'role': 'user', 'parts': parts},
        ],
        'generationConfig': {
          'temperature': 0.4,
          'imageConfig': {'aspectRatio': '3:4', 'imageSize': '1K'},
        },
      });

      debugPrint('[GeminiImageGenerator] Sending outfit generation request...');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[GeminiImageGenerator] Error ${response.statusCode}: ${response.body}',
        );
        throw Exception('Gemini API Error: ${response.statusCode}');
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      if (responseJson['candidates'] != null) {
        final candidates = responseJson['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          for (final part in parts) {
            if (part.containsKey('inlineData')) {
              final data = part['inlineData']['data'];
              final mime = part['inlineData']['mimeType'] ?? 'image/jpeg';
              return 'data:$mime;base64,$data';
            }
          }
        }
      }

      throw Exception('No image data generated');
    } catch (e) {
      debugPrint('[GeminiImageGenerator] generateOutfitImage error: $e');
      rethrow;
    }
  }
}
