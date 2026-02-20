import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_image_generator.dart';

/// 智谱 GLM 实现的图片生成服务（衣服优化图 + 穿衣效果图）。
///
/// - 衣物优化: 先用 GLM-4.6V 理解原图获取描述，再用 GLM-Image 生成 flat-lay 图。
/// - 穿搭效果图: 用 GLM-Image 基于衣物文字描述生成穿搭图。
class ZhipuImageGenerator implements AIImageGenerator {
  final String _apiKey;

  static const String _visionModel = 'glm-4.6v';
  static const String _imageModel = 'glm-image';
  static const String _textModel = 'glm-5';
  static const String _baseUrl = 'https://open.bigmodel.cn/api/paas/v4';

  ZhipuImageGenerator({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('ZHIPU_API_KEY', defaultValue: '');

  /// 通过 chat completions API 发送文字请求，返回文本内容。
  Future<String> _chatCompletion(
    String model,
    List<Map<String, dynamic>> messages, {
    double temperature = 0.7,
    int maxTokens = 2048,
  }) async {
    final requestBody = jsonEncode({
      'model': model,
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception('智谱 API 返回错误 (${response.statusCode}): ${response.body}');
    }

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = responseJson['choices'] as List<dynamic>?;

    if (choices == null || choices.isEmpty) {
      throw Exception('智谱 API 未返回任何结果');
    }

    final message = choices[0]['message'] as Map<String, dynamic>;
    return message['content'] as String? ?? '';
  }

  /// 调用 GLM-Image 生成图片，返回图片 URL。
  Future<String> _generateImage(
    String prompt, {
    String size = '1024x1024',
  }) async {
    final requestBody = jsonEncode({
      'model': _imageModel,
      'prompt': prompt,
      'size': size,
    });

    debugPrint('[ZhipuImageGenerator] Generating image with GLM-Image...');

    final response = await http.post(
      Uri.parse('$_baseUrl/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: requestBody,
    );

    if (response.statusCode != 200) {
      debugPrint(
        '[ZhipuImageGenerator] API error ${response.statusCode}: ${response.body}',
      );
      throw Exception(
        '智谱 GLM-Image API 返回错误 (${response.statusCode}): ${response.reasonPhrase}',
      );
    }

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final data = responseJson['data'] as List<dynamic>?;

    if (data == null || data.isEmpty) {
      throw Exception('GLM-Image 未返回任何图片');
    }

    final imageUrl = data[0]['url'] as String?;
    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception('GLM-Image 返回的图片 URL 为空');
    }

    return imageUrl;
  }

  /// 下载图片并转为 base64。
  Future<String> _downloadImageAsBase64(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('下载图片失败 (${response.statusCode})');
    }
    return base64Encode(response.bodyBytes);
  }

  @override
  Future<String> optimizeClothingImage(
    String base64Image, {
    String? color,
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'ZHIPU_API_KEY 未配置。请通过 --dart-define=ZHIPU_API_KEY=your_key 传入。',
      );
    }

    try {
      // Step 1: Use GLM-4.6V to understand the original image
      debugPrint(
        '[ZhipuImageGenerator] Step 1: Analyzing clothing with GLM-4.6V...',
      );

      const describePrompt = '''
请详细描述这件衣物的外观特征，包括：
1. 衣物类型（如T恤、衬衫、裤子等）
2. 颜色和图案
3. 材质特征
4. 设计细节（领口、袖型、纽扣、口袋等）
5. 品牌标志（如果可见）

请用英文描述，尽可能详细，以便用于重新生成该衣物的专业产品图。
''';

      final descriptionResponse = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _visionModel,
          'messages': [
            {
              'role': 'user',
              'content': [
                {'type': 'text', 'text': describePrompt},
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
              ],
            },
          ],
          'temperature': 0.3,
          'max_tokens': 1024,
        }),
      );

      if (descriptionResponse.statusCode != 200) {
        throw Exception('智谱视觉 API 返回错误 (${descriptionResponse.statusCode})');
      }

      final descJson =
          jsonDecode(descriptionResponse.body) as Map<String, dynamic>;
      final descChoices = descJson['choices'] as List<dynamic>?;
      final clothingDescription = descChoices != null && descChoices.isNotEmpty
          ? (descChoices[0]['message']['content'] as String? ?? '')
          : '';

      debugPrint(
        '[ZhipuImageGenerator] Clothing description: ${clothingDescription.substring(0, clothingDescription.length.clamp(0, 200))}...',
      );

      // Step 2: Get background color suggestion
      String backgroundPrompt = 'clean, neutral background';
      if (color != null && color.isNotEmpty) {
        try {
          final bgSuggestion = await _chatCompletion(
            _textModel,
            [
              {
                'role': 'user',
                'content':
                    'You are a professional product photographer.\n'
                    'For a clothing item with the color "$color", suggest ONE specific background color that would make it look premium.\n'
                    'Return ONLY the color name description in English. No explanations.',
              },
            ],
            temperature: 0.3,
            maxTokens: 64,
          );

          final suggested = bgSuggestion.trim();
          if (suggested.isNotEmpty) {
            debugPrint(
              '[ZhipuImageGenerator] AI suggested background: $suggested',
            );
            backgroundPrompt = '$suggested background';
          }
        } catch (e) {
          debugPrint(
            '[ZhipuImageGenerator] Failed to get background suggestion: $e',
          );
        }
      }

      // Step 3: Generate optimized flat-lay image with GLM-Image
      final generatePrompt =
          'Professional flat-lay product photography of: $clothingDescription. '
          'The clothing should be neatly laid out with no wrinkles, '
          'professional lighting, on a $backgroundPrompt. '
          'High-quality commercial product photo, 1k resolution.';

      final imageUrl = await _generateImage(generatePrompt);

      // Step 4: Download and convert to base64
      final imageBase64 = await _downloadImageAsBase64(imageUrl);

      debugPrint(
        '[ZhipuImageGenerator] Successfully generated optimized image (${imageBase64.length} chars)',
      );

      return imageBase64;
    } catch (e) {
      debugPrint('[ZhipuImageGenerator] optimizeClothingImage error: $e');
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
        'ZHIPU_API_KEY 未配置。请通过 --dart-define=ZHIPU_API_KEY=your_key 传入。',
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
          'Generate a high-fidelity, photorealistic full-body fashion photo of a plastic mannequin '
          'wearing EXACTLY the following clothing items: $itemsDescription. '
          'The clothing must strictly match the descriptions in color, texture, pattern, and design details. '
          'Ensure natural fabric draping and realistic fit on the mannequin. '
          'The subject must be a headless or abstract plastic mannequin, NOT a real human. '
          'Setting: Minimalist studio, soft professional lighting, highly detailed.';

      final imageUrl = await _generateImage(promptText);

      // Return as data URI
      final imageBase64 = await _downloadImageAsBase64(imageUrl);
      return 'data:image/png;base64,$imageBase64';
    } catch (e) {
      debugPrint('[ZhipuImageGenerator] generateOutfitImage error: $e');
      rethrow;
    }
  }
}
