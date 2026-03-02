import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../failures/failures.dart';

// ═══════ Wardrobe Repository Interface ═══════
abstract class WardrobeRepository {
  /// Get all wardrobe items
  Future<Either<AppFailure, List<WardrobeItemEntity>>> getItems();

  /// Get a single wardrobe item by ID
  Future<Either<AppFailure, WardrobeItemEntity>> getItemById(String id);

  /// Add a new wardrobe item
  Future<Either<AppFailure, WardrobeItemEntity>> addItem(WardrobeItemEntity item);

  /// Update an existing wardrobe item
  Future<Either<AppFailure, WardrobeItemEntity>> updateItem(WardrobeItemEntity item);

  /// Delete a wardrobe item
  Future<Either<AppFailure, void>> deleteItem(String id);

  /// Get wardrobe items by category
  Future<Either<AppFailure, List<WardrobeItemEntity>>> getItemsByCategory(
    ClothingCategoryEntity category,
  );
}
