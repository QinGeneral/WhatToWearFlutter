import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

// ═══════ App Failure (Base) ═══════
@freezed
class AppFailure with _$AppFailure {
  const factory AppFailure.network({
    required String message,
    dynamic originalError,
  }) = NetworkFailure;

  const factory AppFailure.storage({
    required String message,
    dynamic originalError,
  }) = StorageFailure;

  const factory AppFailure.format({
    required String message,
    dynamic originalError,
  }) = FormatFailure;

  const factory AppFailure.limitExceeded({
    required String message,
    dynamic originalError,
  }) = LimitExceededFailure;

  const factory AppFailure.ai({
    required String message,
    dynamic originalError,
  }) = AIFailure;

  const factory AppFailure.unknown({
    required String message,
    dynamic originalError,
  }) = UnknownFailure;
}
