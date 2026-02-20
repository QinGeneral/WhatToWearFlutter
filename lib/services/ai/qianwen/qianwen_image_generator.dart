import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_image_generator.dart';

/// 千问实现的图片生成服务（衣服优化图 + 穿搭效果图）。
///
/// - 衣物优化: 使用 qwen-image-edit-max 图像编辑模型（传入原图 + 编辑指令）
/// - 穿搭效果图: 使用 qwen-image-max 文生图模型
class QianwenImageGenerator implements AIImageGenerator {
  final String _apiKey;

  /// 图像编辑模型（衣物优化）。
  static const String _editModel = 'qwen-image-edit-max';

  /// 文生图模型（穿搭效果图）。
  static const String _genModel = 'qwen-image-max';

  /// DashScope 多模态生成端点。
  static const String _baseUrl =
      'https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation';

  QianwenImageGenerator({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('DASHSCOPE_API_KEY', defaultValue: '');

  // ── optimizeClothingImage ─────────────────────────────────────────

  @override
  Future<String> optimizeClothingImage(
    String base64Image, {
    String? color,
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'DASHSCOPE_API_KEY 未配置。请通过 --dart-define=DASHSCOPE_API_KEY=your_key 传入。',
      );
    }

    try {
      final colorHint = color != null ? '，主色调为$color' : '';
      final prompt =
          '将这张衣物照片优化为专业的平铺产品摄影效果：'
          '去除褶皱、整理衣物轮廓、使用干净纯色背景$colorHint。'
          '保持衣物本身的颜色、款式和细节不变。';

      // 使用 qwen-image-edit-max 编辑原图
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _editModel,
          'input': {
            'messages': [
              {
                'role': 'user',
                'content': [
                  {'image': 'data:image/jpeg;base64,$base64Image'},
                  {'text': prompt},
                ],
              },
            ],
          },
          'parameters': {
            'n': 1,
            'negative_prompt': '模糊, 变形, 低质量, 水印',
            'prompt_extend': true,
            'watermark': false,
            'size': '1024*1024',
          },
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[QianwenImageGenerator] Image Edit API error ${response.statusCode}: ${response.body}',
        );
        throw Exception(
          'Qianwen Image Edit API error (${response.statusCode}): ${response.reasonPhrase}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = _extractImageUrl(json);

      // 下载图片并转为 base64
      final imageBase64 = await _downloadImageAsBase64(imageUrl);

      debugPrint(
        '[QianwenImageGenerator] Successfully optimized image (${imageBase64.length} chars)',
      );

      return imageBase64;
    } catch (e) {
      debugPrint('[QianwenImageGenerator] optimizeClothingImage error: $e');
      rethrow;
    }
  }

  // ── generateOutfitImage ───────────────────────────────────────────

  @override
  Future<String> generateOutfitImage(
    Recommendation recommendation, {
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'DASHSCOPE_API_KEY 未配置。请通过 --dart-define=DASHSCOPE_API_KEY=your_key 传入。',
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

      // 使用 qwen-image-max 文生图
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _genModel,
          'input': {
            'messages': [
              {
                'role': 'user',
                'content': [
                  {'text': promptText},
                ],
              },
            ],
          },
          'parameters': {
            'n': 1,
            'negative_prompt': '变形, 多余手指, 低质量, 模糊',
            'size': '768*1024',
          },
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[QianwenImageGenerator] Image Gen API error ${response.statusCode}: ${response.body}',
        );
        throw Exception(
          'Qianwen Image Gen API error (${response.statusCode}): ${response.reasonPhrase}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = _extractImageUrl(json);

      // Return as data URI
      final imageBase64 = await _downloadImageAsBase64(imageUrl);
      return 'data:image/png;base64,$imageBase64';
    } catch (e) {
      debugPrint('[QianwenImageGenerator] generateOutfitImage error: $e');
      rethrow;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  /// 从 DashScope 多模态生成响应中提取图片 URL。
  ///
  /// DashScope 响应格式:
  /// ```json
  /// { "output": { "choices": [ { "message": { "content": [ { "image": "url" } ] } } ] } }
  /// ```
  String _extractImageUrl(Map<String, dynamic> json) {
    final output = json['output'] as Map<String, dynamic>?;
    if (output == null) {
      throw Exception('Qianwen API 响应中没有 output 字段: $json');
    }

    final choices = output['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('Qianwen API 响应中没有 choices: $json');
    }

    final message = choices[0]['message'] as Map<String, dynamic>;
    final content = message['content'] as List<dynamic>;

    for (final item in content) {
      if (item is Map<String, dynamic> && item.containsKey('image')) {
        return item['image'] as String;
      }
    }

    throw Exception('Qianwen API 响应中没有找到图片 URL: $json');
  }

  /// 下载图片并返回 base64 编码字符串。
  Future<String> _downloadImageAsBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('下载图片失败: ${response.statusCode}');
    }
    return base64Encode(response.bodyBytes);
  }
}
