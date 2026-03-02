import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_info_entity.freezed.dart';
part 'weather_info_entity.g.dart';

// ═══════ Weather Info Entity ═══════
@freezed
class WeatherInfoEntity with _$WeatherInfoEntity {
  const factory WeatherInfoEntity({
    required int temperature,
    required String condition,
    required int humidity,
    String? icon,
    String? uvIndex,
    String? comfortLevel,
    String? location,
  }) = _WeatherInfoEntity;

  factory WeatherInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoEntityFromJson(json);
}
