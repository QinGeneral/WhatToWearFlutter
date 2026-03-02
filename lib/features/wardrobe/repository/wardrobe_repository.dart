import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class WardrobeRepository {
  Future<String> _getImageDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/wardrobe_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir.path;
  }

  Future<void> saveImage(String itemId, String base64Data) async {
    try {
      final dir = await _getImageDir();
      final file = File('$dir/$itemId.txt');
      await file.writeAsString(base64Data);
    } catch (e) {
      debugPrint('Failed to save image: $e');
    }
  }

  Future<void> saveOptimizedImage(String itemId, String base64Data) async {
    try {
      final dir = await _getImageDir();
      final file = File('$dir/${itemId}_opt.txt');
      await file.writeAsString(base64Data);
    } catch (e) {
      debugPrint('Failed to save optimized image: $e');
    }
  }

  Future<List<String>> loadImages(String itemId) async {
    try {
      final dir = await _getImageDir();
      final file = File('$dir/$itemId.txt');
      if (await file.exists()) {
        final data = await file.readAsString();
        return [data];
      }
    } catch (e) {
      debugPrint('Failed to load images: $e');
    }
    return [];
  }

  Future<String?> loadOptimizedImage(String itemId) async {
    try {
      final dir = await _getImageDir();
      final file = File('$dir/${itemId}_opt.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      debugPrint('Failed to load optimized image: $e');
    }
    return null;
  }

  Future<void> deleteImages(String itemId) async {
    try {
      final dir = await _getImageDir();
      final file = File('$dir/$itemId.txt');
      if (await file.exists()) await file.delete();
      final optFile = File('$dir/${itemId}_opt.txt');
      if (await optFile.exists()) await optFile.delete();
    } catch (e) {
      debugPrint('Failed to delete images: $e');
    }
  }
}
