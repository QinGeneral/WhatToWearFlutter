import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../models/models.dart';
import '../ai_outfit_recommender.dart';

/// Gemini 实现的穿搭推荐服务。
class GeminiOutfitRecommender implements AIOutfitRecommender {
  final String _apiKey;

  GeminiOutfitRecommender({String? apiKey})
    : _apiKey =
          apiKey ??
          const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  @override
  Future<AIRecommendationResult> getRecommendation({
    required UserRequest request,
    required List<WardrobeItem> wardrobe,
    required WeatherInfo weather,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY 未配置。请通过 --dart-define=GEMINI_API_KEY=your_key 传入。',
      );
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

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
4. Provide a reasoning for each recommendation in Chinese.
5. Assign a match percentage (0-100) based on how well it fits the occasion and weather.

**Output Format:**
Return a JSON object with a single field "outfits" which is an array of objects.
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

      debugPrint('[GeminiOutfitRecommender] Sending request to Gemini...');
      final content = Content.text(prompt);
      final response = await model.generateContent([content]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('Gemini 返回了空响应');
      }

      debugPrint('[GeminiOutfitRecommender] Response: $text');

      final decoded = jsonDecode(text) as Map<String, dynamic>;
      return AIRecommendationResult.fromJson(decoded);
    } catch (e) {
      debugPrint('[GeminiOutfitRecommender] Error: $e');
      rethrow;
    }
  }
}
