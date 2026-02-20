import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../models/models.dart';
import '../ai_outfit_recommender.dart';

/// 智谱 GLM-5 实现的穿搭推荐服务。
class ZhipuOutfitRecommender implements AIOutfitRecommender {
  final String _apiKey;

  static const String _model = 'glm-5';
  static const String _baseUrl = 'https://open.bigmodel.cn/api/paas/v4';

  ZhipuOutfitRecommender({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('ZHIPU_API_KEY', defaultValue: '');

  @override
  Future<AIRecommendationResult> getRecommendation({
    required UserRequest request,
    required List<WardrobeItem> wardrobe,
    required WeatherInfo weather,
    String language = 'zh',
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'ZHIPU_API_KEY 未配置。请通过 --dart-define=ZHIPU_API_KEY=your_key 传入。',
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

      final langInstruction = language == 'en' ? 'in English' : 'in Chinese';

      final prompt =
          '''
You are a professional fashion stylist. Based on the user's wardrobe, current weather, and specific occasion, recommend up to 3 outfit combinations.

**User Request:**
- Date/Time: ${request.date}
- Location: ${request.location}
- Activity: ${request.activity}
- People involved: ${request.person}
${request.requirements.isNotEmpty ? '- Additional Requirements: ${request.requirements}' : ''}

**Weather:**
- Temperature: ${weather.temperature}°C
- Condition: ${weather.condition}
- Humidity: ${weather.humidity}%

**User Wardrobe:**
${jsonEncode(simplifiedWardrobe)}

**Requirements:**
1. Recommend exactly 3 outfits (if possible) ranked by suitability.
2. Use ONLY items from the provided wardrobe. Use the exact 'id' for each item.
3. Each outfit MUST have at least a top and a bottom (or a dress/suit if applicable), and shoes. Outerwear and accessories are optional but recommended if the weather requires it.
4. Provide a reasoning for each recommendation $langInstruction.
5. Assign a match percentage (0-100) based on how well it fits the occasion and weather.

**Output Format:**
Return ONLY a JSON object (no markdown, no explanations) with a single field "outfits" which is an array of objects.
Example:
{
    "outfits": [
        {
            "topId": "id_1",
            "bottomId": "id_2",
            "shoesId": "id_3",
            "outerwearId": "id_4",
            "accessoryIds": ["id_5"],
            "reasoning": "This outfit is perfect for...",
            "matchPercentage": 95
        }
    ]
}
''';

      debugPrint('[ZhipuOutfitRecommender] Sending request to GLM-5...');

      final requestBody = jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 4096,
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
        debugPrint(
          '[ZhipuOutfitRecommender] API error ${response.statusCode}: ${response.body}',
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

      debugPrint('[ZhipuOutfitRecommender] Response: $text');

      // Strip markdown code fence if present (```json ... ```)
      text = text.trim();
      if (text.startsWith('```')) {
        text = text.replaceFirst(RegExp(r'^```\w*\n?'), '');
        text = text.replaceFirst(RegExp(r'\n?```$'), '');
        text = text.trim();
      }

      final decoded = jsonDecode(text) as Map<String, dynamic>;
      return AIRecommendationResult.fromJson(decoded);
    } catch (e) {
      debugPrint('[ZhipuOutfitRecommender] Error: $e');
      rethrow;
    }
  }
}
