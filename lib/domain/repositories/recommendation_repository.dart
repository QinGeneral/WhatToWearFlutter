import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../failures/failures.dart';

// ═══════ Recommendation Repository Interface ═══════
abstract class RecommendationRepository {
  /// Get current recommendation
  Future<Either<AppFailure, RecommendationEntity?>> getCurrentRecommendation();

  /// Save current recommendation
  Future<Either<AppFailure, void>> saveCurrentRecommendation(
    RecommendationEntity? current,
    List<RecommendationEntity> alternatives,
  );

  /// Get favorite recommendations
  Future<Either<AppFailure, List<RecommendationEntity>>> getFavorites();

  /// Toggle favorite status
  Future<Either<AppFailure, RecommendationEntity>> toggleFavorite(
    String recommendationId,
  );

  /// Get recommendation history
  Future<Either<AppFailure, List<RecommendationEntity>>> getHistory();

  /// Add to history
  Future<Either<AppFailure, void>> addToHistory(RecommendationEntity recommendation);

  /// Clear history
  Future<Either<AppFailure, void>> clearHistory();
}
