import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_outfit_recommender.dart';

/// 豆包 Doubao-Seed-2.0-lite 实现的穿搭推荐服务。
///
/// 使用火山引擎 Ark Responses API + doubao-seed-2-0-lite 模型。
class DoubaoOutfitRecommender implements AIOutfitRecommender {
  final String _apiKey;

  static const String _model = 'doubao-seed-2-0-lite-260215';
  static const String _baseUrl =
      'https://ark.cn-beijing.volces.com/api/v3/responses';

  DoubaoOutfitRecommender({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('ARK_API_KEY', defaultValue: '');

  @override
  Future<AIRecommendationResult> getRecommendation({
    required UserRequest request,
    required List<WardrobeItem> wardrobe,
    required WeatherInfo weather,
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'ARK_API_KEY 未配置。请通过 --dart-define=ARK_API_KEY=your_key 传入。',
      );
    }

    try {
      // Simplify wardrobe items to reduce token count
      final simplifiedWardrobe = wardrobe
          .map(
            (item) => {
              'id': item.id,
              'name': item.name,
              'category': item.category.name,
              'color': item.color,
              'season': item.season.name,
              'style': item.style.map((s) => s.name).toList(),
              'tags': item.tags,
            },
          )
          .toList();

      final langInstruction = language == 'en'
          ? 'The "reasoning" field MUST be in English. '
          : 'The "reasoning" field MUST be in Chinese. ';

      final prompt =
          '''
You are a professional fashion stylist. Based on the user's wardrobe, current weather, and specific occasion, recommend up to 3 outfit combinations.
$langInstruction

## Current Weather
- Temperature: ${weather.temperature}°C
- Condition: ${weather.condition}
- Humidity: ${weather.humidity}%
${weather.comfortLevel != null ? '- Comfort Level: ${weather.comfortLevel}' : ''}

## User's Wardrobe
${jsonEncode(simplifiedWardrobe)}

## User Request
- Date: ${request.date}
- Location: ${request.location}
- Activity: ${request.activity}
- Person: ${request.person}
- Requirements: ${request.requirements}

Return a JSON object with the following structure:
{
  "outfits": [
    {
      "topId": "wardrobe item id or null",
      "bottomId": "wardrobe item id or null",
      "shoesId": "wardrobe item id or null",
      "outerwearId": "wardrobe item id or null",
      "accessoryIds": ["id1", "id2"] or null,
      "reasoning": "explanation why this combination works",
      "matchPercentage": 85
    }
  ]
}

IMPORTANT:
- Only use item IDs from the provided wardrobe.
- Each outfit should be practical for the current weather.
- Return ONLY valid JSON, no markdown or extra text.
''';

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
              'role': 'system',
              'content': [
                {
                  'type': 'input_text',
                  'text':
                      'You are a professional fashion stylist. Always respond with valid JSON only.',
                },
              ],
            },
            {
              'role': 'user',
              'content': [
                {'type': 'input_text', 'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Doubao API error ${response.statusCode}: ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final content = _extractTextContent(json);

      final jsonStr = _extractJson(content);
      final result = jsonDecode(jsonStr) as Map<String, dynamic>;

      return AIRecommendationResult.fromJson(result);
    } catch (e) {
      debugPrint('[DoubaoOutfitRecommender] getRecommendation error: $e');
      rethrow;
    }
  }

  /// 从 Responses API 响应中提取文本内容。
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

    final jsonRegex = RegExp(r'\{[\s\S]*\}');
    final jsonMatch = jsonRegex.firstMatch(text);
    if (jsonMatch != null) return jsonMatch.group(0)!;

    return text.trim();
  }
}
