import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/models.dart';

/// User request data for AI outfit recommendation.
class UserRequest {
  final String date;
  final String location;
  final String activity;
  final String person;
  final String requirements;

  UserRequest({
    this.date = '',
    this.location = '',
    this.activity = '',
    this.person = '',
    this.requirements = '',
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'location': location,
    'activity': activity,
    'person': person,
    'requirements': requirements,
  };
}

/// Single outfit result from AI.
class OutfitResult {
  final String? topId;
  final String? bottomId;
  final String? shoesId;
  final String? outerwearId;
  final List<String>? accessoryIds;
  final String reasoning;
  final int matchPercentage;

  OutfitResult({
    this.topId,
    this.bottomId,
    this.shoesId,
    this.outerwearId,
    this.accessoryIds,
    required this.reasoning,
    required this.matchPercentage,
  });

  factory OutfitResult.fromJson(Map<String, dynamic> json) {
    return OutfitResult(
      topId: json['topId'] as String?,
      bottomId: json['bottomId'] as String?,
      shoesId: json['shoesId'] as String?,
      outerwearId: json['outerwearId'] as String?,
      accessoryIds: json['accessoryIds'] != null
          ? List<String>.from(json['accessoryIds'])
          : null,
      reasoning: json['reasoning'] as String? ?? '',
      matchPercentage: json['matchPercentage'] as int? ?? 80,
    );
  }
}

/// Result wrapper containing multiple outfit suggestions.
class AIRecommendationResult {
  final List<OutfitResult> outfits;

  AIRecommendationResult({required this.outfits});

  factory AIRecommendationResult.fromJson(Map<String, dynamic> json) {
    final outfitsList =
        (json['outfits'] as List?)
            ?.map((e) => OutfitResult.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return AIRecommendationResult(outfits: outfitsList);
  }
}

/// Service for generating AI-powered outfit recommendations using Gemini.
class AIRecommendationService {
  static const _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Generates outfit recommendations based on wardrobe, weather, and user request.
  static Future<AIRecommendationResult> getRecommendation({
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

      debugPrint('[AIRecommendation] Sending request to Gemini...');
      final content = Content.text(prompt);
      final response = await model.generateContent([content]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('Gemini 返回了空响应');
      }

      debugPrint('[AIRecommendation] Response: $text');

      final decoded = jsonDecode(text) as Map<String, dynamic>;
      return AIRecommendationResult.fromJson(decoded);
    } catch (e) {
      debugPrint('[AIRecommendation] Error: $e');
      rethrow;
    }
  }
}
