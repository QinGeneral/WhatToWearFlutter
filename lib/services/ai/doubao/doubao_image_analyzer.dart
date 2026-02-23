import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../ai_image_analyzer.dart';

/// 豆包 Doubao-Seed-2.0-lite 实现的衣物图片分析服务。
///
/// 使用火山引擎 Ark Responses API + doubao-seed-2-0-lite 多模态模型。
class DoubaoImageAnalyzer implements AIImageAnalyzer {
  final String _apiKey;

  /// 多模态视觉理解模型。
  static const String _model = 'doubao-seed-2-0-lite-260215';
  static const String _baseUrl =
      'https://ark.cn-beijing.volces.com/api/v3/responses';

  DoubaoImageAnalyzer({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('ARK_API_KEY', defaultValue: '');

  @override
  Future<ImageAnalysisResult> analyzeClothingImage(
    String base64Image, {
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'ARK_API_KEY 未配置。请通过 --dart-define=ARK_API_KEY=your_key 传入。',
      );
    }

    final langInstruction = language == 'en'
        ? '\nPlease return the JSON values (name, color, material) in English.'
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
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'input': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'input_image',
                  'image_url': 'data:image/jpeg;base64,$base64Image',
                },
                {'type': 'input_text', 'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Doubao Vision API error ${response.statusCode}: ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final content = _extractTextContent(json);

      // 提取 JSON（可能包裹在 ```json ... ``` 中）
      final jsonStr = _extractJson(content);
      final result = jsonDecode(jsonStr) as Map<String, dynamic>;

      return ImageAnalysisResult.fromJson(result);
    } catch (e) {
      debugPrint('[DoubaoImageAnalyzer] analyzeClothingImage error: $e');
      rethrow;
    }
  }

  /// 从 Responses API 响应中提取文本内容。
  ///
  /// Responses API 响应格式:
  /// ```json
  /// { "output": [ { "type": "message", "content": [ { "type": "output_text", "text": "..." } ] } ] }
  /// ```
  String _extractTextContent(Map<String, dynamic> json) {
    final output = json['output'] as List<dynamic>?;
    if (output == null || output.isEmpty) {
      throw Exception('Doubao API 响应中没有 output 字段: $json');
    }

    for (final item in output) {
      if (item is Map<String, dynamic> && item['type'] == 'message') {
        final content = item['content'] as List<dynamic>?;
        if (content != null) {
          for (final block in content) {
            if (block is Map<String, dynamic> &&
                block['type'] == 'output_text') {
              return block['text'] as String;
            }
          }
        }
      }
    }

    throw Exception('Doubao API 响应中没有找到文本内容: $json');
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
