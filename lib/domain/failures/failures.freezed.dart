// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppFailure {
  String get message => throw _privateConstructorUsedError;
  dynamic get originalError => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppFailureCopyWith<AppFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppFailureCopyWith<$Res> {
  factory $AppFailureCopyWith(
    AppFailure value,
    $Res Function(AppFailure) then,
  ) = _$AppFailureCopyWithImpl<$Res, AppFailure>;
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class _$AppFailureCopyWithImpl<$Res, $Val extends AppFailure>
    implements $AppFailureCopyWith<$Res> {
  _$AppFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            originalError: freezed == originalError
                ? _value.originalError
                : originalError // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _$NetworkFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        originalError: freezed == originalError
            ? _value.originalError
            : originalError // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'AppFailure.network(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) {
    return network(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) {
    return network?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements AppFailure {
  const factory NetworkFailure({
    required final String message,
    final dynamic originalError,
  }) = _$NetworkFailureImpl;

  @override
  String get message;
  @override
  dynamic get originalError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$StorageFailureImplCopyWith(
    _$StorageFailureImpl value,
    $Res Function(_$StorageFailureImpl) then,
  ) = __$$StorageFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class __$$StorageFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$StorageFailureImpl>
    implements _$$StorageFailureImplCopyWith<$Res> {
  __$$StorageFailureImplCopyWithImpl(
    _$StorageFailureImpl _value,
    $Res Function(_$StorageFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _$StorageFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        originalError: freezed == originalError
            ? _value.originalError
            : originalError // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$StorageFailureImpl implements StorageFailure {
  const _$StorageFailureImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'AppFailure.storage(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      __$$StorageFailureImplCopyWithImpl<_$StorageFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) {
    return storage(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) {
    return storage?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageFailure implements AppFailure {
  const factory StorageFailure({
    required final String message,
    final dynamic originalError,
  }) = _$StorageFailureImpl;

  @override
  String get message;
  @override
  dynamic get originalError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FormatFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$FormatFailureImplCopyWith(
    _$FormatFailureImpl value,
    $Res Function(_$FormatFailureImpl) then,
  ) = __$$FormatFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class __$$FormatFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$FormatFailureImpl>
    implements _$$FormatFailureImplCopyWith<$Res> {
  __$$FormatFailureImplCopyWithImpl(
    _$FormatFailureImpl _value,
    $Res Function(_$FormatFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _$FormatFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        originalError: freezed == originalError
            ? _value.originalError
            : originalError // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$FormatFailureImpl implements FormatFailure {
  const _$FormatFailureImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'AppFailure.format(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormatFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormatFailureImplCopyWith<_$FormatFailureImpl> get copyWith =>
      __$$FormatFailureImplCopyWithImpl<_$FormatFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) {
    return format(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) {
    return format?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) {
    if (format != null) {
      return format(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return format(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return format?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (format != null) {
      return format(this);
    }
    return orElse();
  }
}

abstract class FormatFailure implements AppFailure {
  const factory FormatFailure({
    required final String message,
    final dynamic originalError,
  }) = _$FormatFailureImpl;

  @override
  String get message;
  @override
  dynamic get originalError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormatFailureImplCopyWith<_$FormatFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LimitExceededFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$LimitExceededFailureImplCopyWith(
    _$LimitExceededFailureImpl value,
    $Res Function(_$LimitExceededFailureImpl) then,
  ) = __$$LimitExceededFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class __$$LimitExceededFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$LimitExceededFailureImpl>
    implements _$$LimitExceededFailureImplCopyWith<$Res> {
  __$$LimitExceededFailureImplCopyWithImpl(
    _$LimitExceededFailureImpl _value,
    $Res Function(_$LimitExceededFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _$LimitExceededFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        originalError: freezed == originalError
            ? _value.originalError
            : originalError // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$LimitExceededFailureImpl implements LimitExceededFailure {
  const _$LimitExceededFailureImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'AppFailure.limitExceeded(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LimitExceededFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LimitExceededFailureImplCopyWith<_$LimitExceededFailureImpl>
  get copyWith =>
      __$$LimitExceededFailureImplCopyWithImpl<_$LimitExceededFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) {
    return limitExceeded(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) {
    return limitExceeded?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) {
    if (limitExceeded != null) {
      return limitExceeded(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return limitExceeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return limitExceeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (limitExceeded != null) {
      return limitExceeded(this);
    }
    return orElse();
  }
}

abstract class LimitExceededFailure implements AppFailure {
  const factory LimitExceededFailure({
    required final String message,
    final dynamic originalError,
  }) = _$LimitExceededFailureImpl;

  @override
  String get message;
  @override
  dynamic get originalError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LimitExceededFailureImplCopyWith<_$LimitExceededFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AIFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$AIFailureImplCopyWith(
    _$AIFailureImpl value,
    $Res Function(_$AIFailureImpl) then,
  ) = __$$AIFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class __$$AIFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$AIFailureImpl>
    implements _$$AIFailureImplCopyWith<$Res> {
  __$$AIFailureImplCopyWithImpl(
    _$AIFailureImpl _value,
    $Res Function(_$AIFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _$AIFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        originalError: freezed == originalError
            ? _value.originalError
            : originalError // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$AIFailureImpl implements AIFailure {
  const _$AIFailureImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'AppFailure.ai(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIFailureImplCopyWith<_$AIFailureImpl> get copyWith =>
      __$$AIFailureImplCopyWithImpl<_$AIFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) {
    return ai(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) {
    return ai?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) {
    if (ai != null) {
      return ai(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return ai(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return ai?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (ai != null) {
      return ai(this);
    }
    return orElse();
  }
}

abstract class AIFailure implements AppFailure {
  const factory AIFailure({
    required final String message,
    final dynamic originalError,
  }) = _$AIFailureImpl;

  @override
  String get message;
  @override
  dynamic get originalError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIFailureImplCopyWith<_$AIFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res>
    implements $AppFailureCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(
    _$UnknownFailureImpl value,
    $Res Function(_$UnknownFailureImpl) then,
  ) = __$$UnknownFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, dynamic originalError});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$AppFailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
    _$UnknownFailureImpl _value,
    $Res Function(_$UnknownFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? originalError = freezed}) {
    return _then(
      _$UnknownFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        originalError: freezed == originalError
            ? _value.originalError
            : originalError // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'AppFailure.unknown(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, dynamic originalError) network,
    required TResult Function(String message, dynamic originalError) storage,
    required TResult Function(String message, dynamic originalError) format,
    required TResult Function(String message, dynamic originalError)
    limitExceeded,
    required TResult Function(String message, dynamic originalError) ai,
    required TResult Function(String message, dynamic originalError) unknown,
  }) {
    return unknown(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, dynamic originalError)? network,
    TResult? Function(String message, dynamic originalError)? storage,
    TResult? Function(String message, dynamic originalError)? format,
    TResult? Function(String message, dynamic originalError)? limitExceeded,
    TResult? Function(String message, dynamic originalError)? ai,
    TResult? Function(String message, dynamic originalError)? unknown,
  }) {
    return unknown?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, dynamic originalError)? network,
    TResult Function(String message, dynamic originalError)? storage,
    TResult Function(String message, dynamic originalError)? format,
    TResult Function(String message, dynamic originalError)? limitExceeded,
    TResult Function(String message, dynamic originalError)? ai,
    TResult Function(String message, dynamic originalError)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(FormatFailure value) format,
    required TResult Function(LimitExceededFailure value) limitExceeded,
    required TResult Function(AIFailure value) ai,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(FormatFailure value)? format,
    TResult? Function(LimitExceededFailure value)? limitExceeded,
    TResult? Function(AIFailure value)? ai,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(StorageFailure value)? storage,
    TResult Function(FormatFailure value)? format,
    TResult Function(LimitExceededFailure value)? limitExceeded,
    TResult Function(AIFailure value)? ai,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements AppFailure {
  const factory UnknownFailure({
    required final String message,
    final dynamic originalError,
  }) = _$UnknownFailureImpl;

  @override
  String get message;
  @override
  dynamic get originalError;

  /// Create a copy of AppFailure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
