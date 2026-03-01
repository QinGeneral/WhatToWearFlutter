import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:what_to_wear_flutter/features/wardrobe/repository/wardrobe_repository.dart';
import 'package:what_to_wear_flutter/models/models.dart';
import 'package:what_to_wear_flutter/services/storage_service.dart';

class WardrobeProvider extends ChangeNotifier {
  final StorageService _storage;
  final WardrobeRepository _repository = WardrobeRepository();
  final _uuid = const Uuid();

  List<WardrobeItem> _items = [];
  ClothingCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;

  WardrobeProvider(this._storage);

  List<WardrobeItem> get items => _items;
  ClothingCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<WardrobeItem> get filteredItems {
    var filtered = _items;
    if (_selectedCategory != null) {
      filtered = filtered
          .where((item) => item.category == _selectedCategory)
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (item) =>
                item.name.toLowerCase().contains(q) ||
                item.brand?.toLowerCase().contains(q) == true ||
                item.tags.any((t) => t.toLowerCase().contains(q)),
          )
          .toList();
    }
    return filtered;
  }

  void setCategory(ClothingCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadWardrobe() async {
    _isLoading = true;
    notifyListeners();

    final newItems = _storage.getWardrobe();

    // Hydrate images from file system
    for (int i = 0; i < newItems.length; i++) {
      final item = newItems[i];
      final images = await _repository.loadImages(item.id);
      final optimized = await _repository.loadOptimizedImage(item.id);
      newItems[i] = item.copyWith(
        images: images.isNotEmpty ? images : item.images,
        optimizedImage: optimized,
      );
    }

    _items = newItems;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem({
    required String name,
    required ClothingCategory category,
    required List<String> images,
    String? optimizedImage,
    required List<String> color,
    required Season season,
    required List<String> tags,
    String? brand,
    List<Map<String, String>>? colorPalette,
  }) async {
    final now = DateTime.now().toIso8601String();
    final id = _uuid.v4();

    final item = WardrobeItem(
      id: id,
      name: name,
      category: category,
      images: images,
      optimizedImage: optimizedImage,
      color: color,
      colorPalette: colorPalette,
      style: [],
      season: season,
      brand: brand,
      tags: tags,
      createdAt: now,
      updatedAt: now,
    );

    // Save images to files
    if (images.isNotEmpty) {
      await _repository.saveImage(id, images.first);
    }
    if (optimizedImage != null) {
      await _repository.saveOptimizedImage(id, optimizedImage);
    }

    _items = [item, ..._items];
    await _storage.setWardrobe(_items);
    notifyListeners();
  }

  Future<void> updateItem(
    String id, {
    String? name,
    ClothingCategory? category,
    List<String>? images,
    String? optimizedImage,
    List<String>? color,
    Season? season,
    List<String>? tags,
    String? brand,
    List<Map<String, String>>? colorPalette,
  }) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final existing = _items[index];
    _items[index] = existing.copyWith(
      name: name,
      category: category,
      images: images,
      optimizedImage: optimizedImage,
      color: color,
      season: season,
      tags: tags,
      brand: brand,
      colorPalette: colorPalette,
      updatedAt: DateTime.now().toIso8601String(),
    );

    if (images != null && images.isNotEmpty) {
      await _repository.saveImage(id, images.first);
    }
    if (optimizedImage != null) {
      await _repository.saveOptimizedImage(id, optimizedImage);
    }

    await _storage.setWardrobe(_items);
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    _items = _items.where((item) => item.id != id).toList();
    await _repository.deleteImages(id);
    await _storage.setWardrobe(_items);
    notifyListeners();
  }
}
