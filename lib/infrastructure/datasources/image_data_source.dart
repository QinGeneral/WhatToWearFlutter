import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Data source for handling wardrobe item images
class ImageDataSource {
  Future<String> _getImageDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/wardrobe_images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir.path;
  }

  Future<void> saveImage(String itemId, String base64Data) async {
    final dir = await _getImageDir();
    final file = File('$dir/$itemId.txt');
    await file.writeAsString(base64Data);
  }

  Future<void> saveOptimizedImage(String itemId, String base64Data) async {
    final dir = await _getImageDir();
    final file = File('$dir/${itemId}_opt.txt');
    await file.writeAsString(base64Data);
  }

  Future<List<String>> loadImages(String itemId) async {
    final dir = await _getImageDir();
    final file = File('$dir/$itemId.txt');
    if (await file.exists()) {
      final data = await file.readAsString();
      return [data];
    }
    return [];
  }

  Future<String?> loadOptimizedImage(String itemId) async {
    final dir = await _getImageDir();
    final file = File('$dir/${itemId}_opt.txt');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  Future<void> deleteImages(String itemId) async {
    final dir = await _getImageDir();
    final file = File('$dir/$itemId.txt');
    if (await file.exists()) await file.delete();
    final optFile = File('$dir/${itemId}_opt.txt');
    if (await optFile.exists()) await optFile.delete();
  }
}
