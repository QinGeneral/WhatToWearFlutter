sealed class AppFailure {
  final String message;
  final dynamic originalError;

  const AppFailure(this.message, [this.originalError]);

  @override
  String toString() =>
      'AppFailure: $message ${originalError != null ? "($originalError)" : ""}';
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, [super.originalError]);
}

class StorageFailure extends AppFailure {
  const StorageFailure(super.message, [super.originalError]);
}

class FormatFailure extends AppFailure {
  const FormatFailure(super.message, [super.originalError]);
}

class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure(super.message, [super.originalError]);
}

class LimitExceededFailure extends AppFailure {
  const LimitExceededFailure(super.message, [super.originalError]);
}
