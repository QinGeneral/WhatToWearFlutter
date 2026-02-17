import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/models.dart';

class WeatherService {
  static Future<Position> getCurrentLocation() async {
    debugPrint('[Location] Checking location service status...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('[Location] ❌ Location services are disabled');
      throw Exception('Location services are disabled.');
    }
    debugPrint('[Location] ✅ Location services enabled');

    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint('[Location] Current permission: $permission');
    if (permission == LocationPermission.denied) {
      debugPrint('[Location] Requesting permission...');
      permission = await Geolocator.requestPermission();
      debugPrint('[Location] Permission after request: $permission');
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('[Location] ❌ Permission permanently denied');
      throw Exception('Location permissions are permanently denied');
    }

    // Try last known position first (returns instantly if available)
    debugPrint('[Location] Trying last known position...');
    final lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      debugPrint(
        '[Location] ✅ Last known: (${lastPosition.latitude}, ${lastPosition.longitude})',
      );
      return lastPosition;
    }
    debugPrint('[Location] No last known position, getting current...');

    // Fall back to getting current position with longer timeout
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 30),
      ),
    );
    debugPrint(
      '[Location] ✅ Current position: (${position.latitude}, ${position.longitude})',
    );
    return position;
  }

  static Future<WeatherInfo> getWeather(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,weather_code',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather data');
    }

    final data = jsonDecode(response.body);
    final current = data['current'];

    final weatherCode = current['weather_code'] as int;
    final mapped = _mapWeatherCode(weatherCode);
    final temp = (current['temperature_2m'] as num).round();
    final humidity = (current['relative_humidity_2m'] as num).round();

    // Reverse geocode for location name (using native geocoding)
    String? locationName;
    try {
      debugPrint(
        '[Geocode] Using native geocoding for ($latitude, $longitude)...',
      );
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        debugPrint(
          '[Geocode] Placemark: city=${place.locality}, subAdmin=${place.subAdministrativeArea}, admin=${place.administrativeArea}, country=${place.country}',
        );
        locationName =
            place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            place.country;
        debugPrint('[Geocode] ✅ Native resolved: $locationName');
      }
    } catch (e) {
      debugPrint('[Geocode] Native geocoding failed: $e, trying nominatim...');
    }

    // Fallback: nominatim HTTP reverse geocoding
    if (locationName == null || locationName.isEmpty) {
      try {
        final geoUrl = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse'
          '?format=json&lat=$latitude&lon=$longitude&zoom=10&accept-language=zh',
        );
        final geoResponse = await http.get(
          geoUrl,
          headers: {'User-Agent': 'WhatToWearFlutter/1.0'},
        );
        if (geoResponse.statusCode == 200) {
          final geoData = jsonDecode(geoResponse.body);
          final address = geoData['address'];
          locationName =
              address?['city'] ??
              address?['town'] ??
              address?['suburb'] ??
              address?['district'] ??
              address?['village'] ??
              address?['county'] ??
              address?['state'] ??
              address?['country'] ??
              geoData['display_name']?.toString().split(',').first;
          debugPrint('[Geocode] ✅ Nominatim resolved: $locationName');
        }
      } catch (e) {
        debugPrint('[Geocode] Nominatim also failed: $e');
      }
    }

    locationName ??=
        '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
    debugPrint('[Weather] Final location name: $locationName');

    return WeatherInfo(
      temperature: temp,
      condition: mapped['condition']!,
      humidity: humidity,
      icon: mapped['icon'],
      uvIndex: '中',
      comfortLevel: _calculateComfortLevel(
        temp.toDouble(),
        humidity.toDouble(),
      ),
      location: locationName,
    );
  }

  static Map<String, String> _mapWeatherCode(int code) {
    if (code == 0) return {'condition': '晴朗', 'icon': '☀️'};
    if (code >= 1 && code <= 3) return {'condition': '多云', 'icon': '⛅'};
    if (code >= 45 && code <= 48) return {'condition': '雾', 'icon': '🌫️'};
    if (code >= 51 && code <= 67) return {'condition': '雨', 'icon': '🌧️'};
    if (code >= 71 && code <= 77) return {'condition': '雪', 'icon': '❄️'};
    if (code >= 80 && code <= 82) return {'condition': '阵雨', 'icon': '🌦️'};
    if (code >= 95 && code <= 99) return {'condition': '雷雨', 'icon': '⛈️'};
    return {'condition': '未知', 'icon': '❓'};
  }

  static String _calculateComfortLevel(double temp, double humidity) {
    if (temp >= 28) return '炎热';
    if (temp <= 10) return '寒冷';
    if (temp >= 18 && temp < 28 && humidity < 70) return '舒适';
    return '一般';
  }
}
