import 'package:dartz/dartz.dart';
import 'package:what_to_wear_flutter/domain/entities/entities.dart';
import 'package:what_to_wear_flutter/domain/failures/failures.dart';
import 'package:what_to_wear_flutter/domain/repositories/wardrobe_repository.dart';
import 'package:what_to_wear_flutter/infrastructure/datasources/local_data_source.dart';
import 'package:what_to_wear_flutter/infrastructure/datasources/image_data_source.dart';
import 'package:what_to_wear_flutter/infrastructure/mappers/wardrobe_mapper.dart';

/// Implementation of WardrobeRepository using Either pattern
class WardrobeRepositoryImpl implements WardrobeRepository {
  final LocalDataSource _localDataSource;
  final ImageDataSource _imageDataSource;

  WardrobeRepositoryImpl(this._localDataSource, this._imageDataSource);

  @override
  Future<Either<AppFailure, List<WardrobeItemEntity>>> getItems() async {
    try {
      final data = _localDataSource.getWardrobe();
      final items = data.map(WardrobeMapper.fromJson).toList();
      return Right(items);
    } catch (e) {
      return Left(AppFailure.storage(
        message: 'Failed to load wardrobe items',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<AppFailure, WardrobeItemEntity>> getItemById(String id) async {
    try {
      final data = _localDataSource.getWardrobe();
      final item = data.firstWhere(
        (i) => i['id'] == id,
        orElse: () => throw Exception('Item not found'),
      );
      return Right(WardrobeMapper.fromJson(item));
    } catch (e) {
      return Left(AppFailure.storage(
        message: 'Failed to get item: $id',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<AppFailure, WardrobeItemEntity>> addItem(
    WardrobeItemEntity item,
  ) async {
    try {
      final data = _localDataSource.getWardrobe();
      data.add(WardrobeMapper.toJson(item));
      await _localDataSource.setWardrobe(data);

      // Save images
      if (item.images.isNotEmpty) {
        await _imageDataSource.saveImage(item.id, item.images.first);
      }
      if (item.optimizedImage != null) {
        await _imageDataSource.saveOptimizedImage(
          item.id,
          item.optimizedImage!,
        );
      }

      return Right(item);
    } catch (e) {
      return Left(AppFailure.storage(
        message: 'Failed to add item',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<AppFailure, WardrobeItemEntity>> updateItem(
    WardrobeItemEntity item,
  ) async {
    try {
      final data = _localDataSource.getWardrobe();
      final index = data.indexWhere((i) => i['id'] == item.id);
      if (index == -1) {
        return const Left(AppFailure.storage(message: 'Item not found'));
      }
      data[index] = WardrobeMapper.toJson(item);
      await _localDataSource.setWardrobe(data);
      return Right(item);
    } catch (e) {
      return Left(AppFailure.storage(
        message: 'Failed to update item',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteItem(String id) async {
    try {
      final data = _localDataSource.getWardrobe();
      data.removeWhere((i) => i['id'] == id);
      await _localDataSource.setWardrobe(data);
      await _imageDataSource.deleteImages(id);
      return const Right(null);
    } catch (e) {
      return Left(AppFailure.storage(
        message: 'Failed to delete item',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<AppFailure, List<WardrobeItemEntity>>> getItemsByCategory(
    ClothingCategoryEntity category,
  ) async {
    final result = await getItems();
    return result.map(
      (items) => items.where((i) => i.category == category).toList(),
    );
  }
}
