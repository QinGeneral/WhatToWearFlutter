import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_outfit_recommender.dart';

/// 千问 Qwen3.5 实现的穿搭推荐服务。
class QianwenOutfitRecommender implements AIOutfitRecommender {
  final String _apiKey;

  static const String _model = 'qwen3.5-plus';
  static const String _baseUrl =
      'https://dashscope.aliyuncs.com/compatible-mode/v1';

  QianwenOutfitRecommender({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('DASHSCOPE_API_KEY', defaultValue: '');

  @override
  Future<AIRecommendationResult> getRecommendation({
    required UserRequest request,
    required List<WardrobeItem> wardrobe,
    required WeatherInfo weather,
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'DASHSCOPE_API_KEY 未配置。请通过 --dart-define=DASHSCOPE_API_KEY=your_key 传入。',
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
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a professional fashion stylist. Always respond with valid JSON only.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Qianwen API error ${response.statusCode}: ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final content = json['choices'][0]['message']['content'] as String;

      final jsonStr = _extractJson(content);
      final result = jsonDecode(jsonStr) as Map<String, dynamic>;

      return AIRecommendationResult.fromJson(result);
    } catch (e) {
      debugPrint('[QianwenOutfitRecommender] getRecommendation error: $e');
      rethrow;
    }
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
