// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherInfoEntityImpl _$$WeatherInfoEntityImplFromJson(
  Map<String, dynamic> json,
) => _$WeatherInfoEntityImpl(
  temperature: (json['temperature'] as num).toInt(),
  condition: json['condition'] as String,
  humidity: (json['humidity'] as num).toInt(),
  icon: json['icon'] as String?,
  uvIndex: json['uvIndex'] as String?,
  comfortLevel: json['comfortLevel'] as String?,
  location: json['location'] as String?,
);

Map<String, dynamic> _$$WeatherInfoEntityImplToJson(
  _$WeatherInfoEntityImpl instance,
) => <String, dynamic>{
  'temperature': instance.temperature,
  'condition': instance.condition,
  'humidity': instance.humidity,
  'icon': instance.icon,
  'uvIndex': instance.uvIndex,
  'comfortLevel': instance.comfortLevel,
  'location': instance.location,
};
