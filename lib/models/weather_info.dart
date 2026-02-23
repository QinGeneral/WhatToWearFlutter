// ═══════ Weather Info ═══════
class WeatherInfo {
  final int temperature;
  final String condition;
  final int humidity;
  final String? icon;
  final String? uvIndex;
  final String? comfortLevel;
  final String? location;

  WeatherInfo({
    required this.temperature,
    required this.condition,
    required this.humidity,
    this.icon,
    this.uvIndex,
    this.comfortLevel,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'condition': condition,
    'humidity': humidity,
    'icon': icon,
    'uvIndex': uvIndex,
    'comfortLevel': comfortLevel,
    'location': location,
  };

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => WeatherInfo(
    temperature: json['temperature'] as int,
    condition: json['condition'] as String,
    humidity: json['humidity'] as int,
    icon: json['icon'] as String?,
    uvIndex: json['uvIndex'] as String?,
    comfortLevel: json['comfortLevel'] as String?,
    location: json['location'] as String?,
  );
}
