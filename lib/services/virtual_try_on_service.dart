import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class VirtualTryOnService {
  static const _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  // Use the image generation model
  static const String _modelName = 'gemini-3-pro-image-preview';

  VirtualTryOnService() {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set');
    }
  }

  Future<String> generateTryOnImage(Recommendation recommendation) async {
    try {
      final itemsDescription = [
        recommendation.items.outerwear?.name,
        recommendation.items.top?.name,
        recommendation.items.bottom?.name,
        recommendation.items.shoes?.name,
        ...(recommendation.items.accessories?.map((a) => a.name) ?? []),
      ].where((item) => item != null && item.isNotEmpty).join(', ');

      final promptText =
          '''
Generate a high-fidelity, photorealistic full-body fashion photo of a plastic mannequin wearing EXACTLY the following clothing items: $itemsDescription.

CRITICAL REQUIREMENTS:
1. The clothing in the generated image must strictly match the reference descriptions in color, texture, pattern, and design details.
2. Do not alter, simplify, or hallucinate new features on the clothing.
3. Ensure natural fabric draping and realistic fit on the mannequin.
4. The subject must be a headless or abstract plastic mannequin, NOT a real human.

Setting: Minimalist studio, soft professional lighting, 1k resolution, highly detailed.
''';

      // Prepare payload
      final parts = <Map<String, dynamic>>[];

      // Add text prompt
      parts.add({'text': promptText});

      // Add reference images
      void addImageIfPresent(String? base64Image) {
        if (base64Image != null && base64Image.isNotEmpty) {
          final cleanBase64 = base64Image.contains(',')
              ? base64Image.split(',').last
              : base64Image;

          parts.add({
            'inlineData': {'mimeType': 'image/jpeg', 'data': cleanBase64},
          });
        }
      }

      addImageIfPresent(recommendation.items.top?.images.firstOrNull);
      addImageIfPresent(recommendation.items.bottom?.images.firstOrNull);
      addImageIfPresent(recommendation.items.outerwear?.images.firstOrNull);

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1alpha/models/$_modelName:generateContent?key=$_apiKey',
      );

      final requestBody = jsonEncode({
        'contents': [
          {'role': 'user', 'parts': parts},
        ],
        'generationConfig': {
          'temperature': 0.4,
          'imageConfig': {'aspectRatio': '3:4', 'imageSize': '1K'},
        },
      });

      print('[VirtualTryOn] Sending request to Gemini $_modelName...');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode != 200) {
        print('[VirtualTryOn] Error ${response.statusCode}: ${response.body}');
        // Fallback for demo? Or throw
        throw Exception('Gemini API Error: ${response.statusCode}');
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // Attempt to extract image
      if (responseJson['candidates'] != null) {
        final candidates = responseJson['candidates'] as List;
        if (candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          for (final part in parts) {
            if (part.containsKey('inlineData')) {
              final data = part['inlineData']['data'];
              final mime = part['inlineData']['mimeType'] ?? 'image/jpeg';
              return 'data:$mime;base64,$data';
            }
          }
        }
      }

      throw Exception('No image data generated');
    } catch (e) {
      print('Virtual Try-On Generation Failed: $e');
      rethrow;
    }
  }
}
