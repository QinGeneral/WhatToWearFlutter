import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../ai_image_analyzer.dart';

/// 智谱 GLM-4.6V 实现的衣物图片分析服务。
class ZhipuImageAnalyzer implements AIImageAnalyzer {
  final String _apiKey;

  /// 视觉理解模型。
  static const String _model = 'glm-4.6v';
  static const String _baseUrl = 'https://open.bigmodel.cn/api/paas/v4';

  ZhipuImageAnalyzer({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('ZHIPU_API_KEY', defaultValue: '');

  @override
  Future<ImageAnalysisResult> analyzeClothingImage(String base64Image) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'ZHIPU_API_KEY 未配置。请通过 --dart-define=ZHIPU_API_KEY=your_key 传入。',
      );
    }

    try {
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

      final requestBody = jsonEncode({
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
              },
            ],
          },
        ],
        'temperature': 0.3,
        'max_tokens': 1024,
      });

      debugPrint('[ZhipuImageAnalyzer] Sending request to GLM-4.6V...');

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: requestBody,
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[ZhipuImageAnalyzer] API error ${response.statusCode}: ${response.body}',
        );
        throw Exception(
          '智谱 API 返回错误 (${response.statusCode}): ${response.reasonPhrase}',
        );
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = responseJson['choices'] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        throw Exception('智谱 API 未返回任何结果');
      }

      final message = choices[0]['message'] as Map<String, dynamic>;
      var text = message['content'] as String? ?? '';

      debugPrint('[ZhipuImageAnalyzer] Response: $text');

      // Strip markdown code fence if present (```json ... ```)
      text = text.trim();
      if (text.startsWith('```')) {
        text = text.replaceFirst(RegExp(r'^```\w*\n?'), '');
        text = text.replaceFirst(RegExp(r'\n?```$'), '');
        text = text.trim();
      }

      final decoded = jsonDecode(text);
      final Map<String, dynamic> jsonResult;
      if (decoded is List && decoded.isNotEmpty) {
        jsonResult = decoded.first as Map<String, dynamic>;
      } else {
        jsonResult = decoded as Map<String, dynamic>;
      }
      return ImageAnalysisResult.fromJson(jsonResult);
    } catch (e) {
      debugPrint('[ZhipuImageAnalyzer] Error: $e');
      rethrow;
    }
  }
}
