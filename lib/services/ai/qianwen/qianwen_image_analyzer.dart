import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../ai_image_analyzer.dart';

/// 千问 Qwen3.5 实现的衣物图片分析服务。
///
/// 使用 OpenAI 兼容的 Chat Completions 端点 + qwen3.5-plus 视觉理解模型。
class QianwenImageAnalyzer implements AIImageAnalyzer {
  final String _apiKey;

  /// 视觉理解模型。
  static const String _model = 'qwen3.5-plus';
  static const String _baseUrl =
      'https://dashscope.aliyuncs.com/compatible-mode/v1';

  QianwenImageAnalyzer({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('DASHSCOPE_API_KEY', defaultValue: '');

  @override
  Future<ImageAnalysisResult> analyzeClothingImage(
    String base64Image, {
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'DASHSCOPE_API_KEY 未配置。请通过 --dart-define=DASHSCOPE_API_KEY=your_key 传入。',
      );
    }

    final langInstruction = language == 'en'
        ? '\\nPlease return the JSON values (name, color, material) in English.'
        : '';

    final prompt =
        '''
请分析这张衣物图片，以 JSON 格式返回以下信息：
{
  "name": "衣物名称（简短描述，如'白色圆领T恤'）",
  "brand": "品牌（如无法识别则为 null）",
  "category": "分类（top/bottom/shoes/accessory/outerwear 之一）",
  "color": "主要颜色（中文）",
  "colorHex": "主要颜色的十六进制值（如 #FFFFFF）",
  "season": "适合季节（spring/summer/autumn/winter/all 之一）",
  "material": "材质（如: 纯棉、涤纶、羊毛等）"
}
只返回 JSON，不要包含其他文字说明。$langInstruction
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
                {'type': 'text', 'text': prompt},
              ],
            },
          ],
          'temperature': 0.1,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Qianwen Vision API error ${response.statusCode}: ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final content = json['choices'][0]['message']['content'] as String;

      // 提取 JSON（可能包裹在 ```json ... ``` 中）
      final jsonStr = _extractJson(content);
      final result = jsonDecode(jsonStr) as Map<String, dynamic>;

      return ImageAnalysisResult.fromJson(result);
    } catch (e) {
      debugPrint('[QianwenImageAnalyzer] analyzeClothingImage error: $e');
      rethrow;
    }
  }

  /// 从可能包含 markdown 代码块的文本中提取 JSON 字符串。
  String _extractJson(String text) {
    final codeBlockRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final match = codeBlockRegex.firstMatch(text);
    if (match != null) return match.group(1)!.trim();

    // 尝试直接查找 JSON 对象
    final jsonRegex = RegExp(r'\{[\s\S]*\}');
    final jsonMatch = jsonRegex.firstMatch(text);
    if (jsonMatch != null) return jsonMatch.group(0)!;

    return text.trim();
  }
}
