// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_info_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeatherInfoEntity _$WeatherInfoEntityFromJson(Map<String, dynamic> json) {
  return _WeatherInfoEntity.fromJson(json);
}

/// @nodoc
mixin _$WeatherInfoEntity {
  int get temperature => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  int get humidity => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get uvIndex => throw _privateConstructorUsedError;
  String? get comfortLevel => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this WeatherInfoEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherInfoEntityCopyWith<WeatherInfoEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherInfoEntityCopyWith<$Res> {
  factory $WeatherInfoEntityCopyWith(
    WeatherInfoEntity value,
    $Res Function(WeatherInfoEntity) then,
  ) = _$WeatherInfoEntityCopyWithImpl<$Res, WeatherInfoEntity>;
  @useResult
  $Res call({
    int temperature,
    String condition,
    int humidity,
    String? icon,
    String? uvIndex,
    String? comfortLevel,
    String? location,
  });
}

/// @nodoc
class _$WeatherInfoEntityCopyWithImpl<$Res, $Val extends WeatherInfoEntity>
    implements $WeatherInfoEntityCopyWith<$Res> {
  _$WeatherInfoEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? condition = null,
    Object? humidity = null,
    Object? icon = freezed,
    Object? uvIndex = freezed,
    Object? comfortLevel = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _value.copyWith(
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as int,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            humidity: null == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as int,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            uvIndex: freezed == uvIndex
                ? _value.uvIndex
                : uvIndex // ignore: cast_nullable_to_non_nullable
                      as String?,
            comfortLevel: freezed == comfortLevel
                ? _value.comfortLevel
                : comfortLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherInfoEntityImplCopyWith<$Res>
    implements $WeatherInfoEntityCopyWith<$Res> {
  factory _$$WeatherInfoEntityImplCopyWith(
    _$WeatherInfoEntityImpl value,
    $Res Function(_$WeatherInfoEntityImpl) then,
  ) = __$$WeatherInfoEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int temperature,
    String condition,
    int humidity,
    String? icon,
    String? uvIndex,
    String? comfortLevel,
    String? location,
  });
}

/// @nodoc
class __$$WeatherInfoEntityImplCopyWithImpl<$Res>
    extends _$WeatherInfoEntityCopyWithImpl<$Res, _$WeatherInfoEntityImpl>
    implements _$$WeatherInfoEntityImplCopyWith<$Res> {
  __$$WeatherInfoEntityImplCopyWithImpl(
    _$WeatherInfoEntityImpl _value,
    $Res Function(_$WeatherInfoEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? condition = null,
    Object? humidity = null,
    Object? icon = freezed,
    Object? uvIndex = freezed,
    Object? comfortLevel = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _$WeatherInfoEntityImpl(
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as int,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        humidity: null == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as int,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        uvIndex: freezed == uvIndex
            ? _value.uvIndex
            : uvIndex // ignore: cast_nullable_to_non_nullable
                  as String?,
        comfortLevel: freezed == comfortLevel
            ? _value.comfortLevel
            : comfortLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherInfoEntityImpl implements _WeatherInfoEntity {
  const _$WeatherInfoEntityImpl({
    required this.temperature,
    required this.condition,
    required this.humidity,
    this.icon,
    this.uvIndex,
    this.comfortLevel,
    this.location,
  });

  factory _$WeatherInfoEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherInfoEntityImplFromJson(json);

  @override
  final int temperature;
  @override
  final String condition;
  @override
  final int humidity;
  @override
  final String? icon;
  @override
  final String? uvIndex;
  @override
  final String? comfortLevel;
  @override
  final String? location;

  @override
  String toString() {
    return 'WeatherInfoEntity(temperature: $temperature, condition: $condition, humidity: $humidity, icon: $icon, uvIndex: $uvIndex, comfortLevel: $comfortLevel, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherInfoEntityImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex) &&
            (identical(other.comfortLevel, comfortLevel) ||
                other.comfortLevel == comfortLevel) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    temperature,
    condition,
    humidity,
    icon,
    uvIndex,
    comfortLevel,
    location,
  );

  /// Create a copy of WeatherInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherInfoEntityImplCopyWith<_$WeatherInfoEntityImpl> get copyWith =>
      __$$WeatherInfoEntityImplCopyWithImpl<_$WeatherInfoEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherInfoEntityImplToJson(this);
  }
}

abstract class _WeatherInfoEntity implements WeatherInfoEntity {
  const factory _WeatherInfoEntity({
    required final int temperature,
    required final String condition,
    required final int humidity,
    final String? icon,
    final String? uvIndex,
    final String? comfortLevel,
    final String? location,
  }) = _$WeatherInfoEntityImpl;

  factory _WeatherInfoEntity.fromJson(Map<String, dynamic> json) =
      _$WeatherInfoEntityImpl.fromJson;

  @override
  int get temperature;
  @override
  String get condition;
  @override
  int get humidity;
  @override
  String? get icon;
  @override
  String? get uvIndex;
  @override
  String? get comfortLevel;
  @override
  String? get location;

  /// Create a copy of WeatherInfoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherInfoEntityImplCopyWith<_$WeatherInfoEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
