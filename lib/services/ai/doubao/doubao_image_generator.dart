import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_image_generator.dart';

/// 豆包 Seedream 4.5 实现的图片生成服务（衣物优化图 + 穿搭效果图）。
///
/// 使用火山引擎 Ark Images Generations API + doubao-seedream-4-5-251128 模型。
class DoubaoImageGenerator implements AIImageGenerator {
  final String _apiKey;

  /// Seedream 4.5 文生图模型。
  static const String _model = 'doubao-seedream-4-5-251128';

  /// Ark Images Generations 端点。
  static const String _baseUrl =
      'https://ark.cn-beijing.volces.com/api/v3/images/generations';

  DoubaoImageGenerator({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('ARK_API_KEY', defaultValue: '');

  // ── optimizeClothingImage ─────────────────────────────────────────

  @override
  Future<String> optimizeClothingImage(
    String base64Image, {
    String? color,
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'ARK_API_KEY 未配置。请通过 --dart-define=ARK_API_KEY=your_key 传入。',
      );
    }

    try {
      final colorHint = color != null ? '，主色调为$color' : '';
      final prompt =
          '专业服装产品摄影，一件衣物平铺在干净纯色背景上$colorHint，'
          '去除褶皱，整理衣物轮廓，高质量产品照，柔和专业灯光，'
          '极简风格，高清，8K，摄影棚效果';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'prompt': prompt,
          'response_format': 'url',
          'size': '2K',
          'seed': -1,
          'watermark': false,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[DoubaoImageGenerator] Image API error ${response.statusCode}: ${response.body}',
        );
        throw Exception(
          'Doubao Image API error (${response.statusCode}): ${response.reasonPhrase}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = _extractImageUrl(json);

      // 下载图片并转为 base64
      final imageBase64 = await _downloadImageAsBase64(imageUrl);

      debugPrint(
        '[DoubaoImageGenerator] Successfully optimized image (${imageBase64.length} chars)',
      );

      return imageBase64;
    } catch (e) {
      debugPrint('[DoubaoImageGenerator] optimizeClothingImage error: $e');
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
        'ARK_API_KEY 未配置。请通过 --dart-define=ARK_API_KEY=your_key 传入。',
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
          '高保真全身时尚照片，塑料模特身上穿着以下衣物：$itemsDescription。'
          '衣物颜色、材质、花纹和设计细节必须严格匹配描述。'
          '自然的面料垂坠和逼真的穿着效果。'
          '无头或抽象塑料模特，不是真人。'
          '极简摄影棚，柔和专业灯光，高度细致。';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'prompt': promptText,
          'response_format': 'url',
          'size': '2K',
          'seed': -1,
          'watermark': false,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(
          '[DoubaoImageGenerator] Image Gen API error ${response.statusCode}: ${response.body}',
        );
        throw Exception(
          'Doubao Image Gen API error (${response.statusCode}): ${response.reasonPhrase}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = _extractImageUrl(json);

      // Return as data URI
      final imageBase64 = await _downloadImageAsBase64(imageUrl);
      return 'data:image/png;base64,$imageBase64';
    } catch (e) {
      debugPrint('[DoubaoImageGenerator] generateOutfitImage error: $e');
      rethrow;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────

  /// 从 Ark Images Generations API 响应中提取图片 URL。
  ///
  /// 响应格式:
  /// ```json
  /// { "data": [ { "url": "https://..." } ] }
  /// ```
  String _extractImageUrl(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception('Doubao API 响应中没有 data 字段: $json');
    }

    final firstItem = data[0] as Map<String, dynamic>;
    final url = firstItem['url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('Doubao API 响应中没有图片 URL: $json');
    }

    return url;
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
