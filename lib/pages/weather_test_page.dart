import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';

/// All distinct weather states from WeatherService._mapWeatherCode
const _allWeatherStates = <Map<String, String>>[
  {'condition': '晴朗', 'icon': 'assets/weather/晴朗.svg'},
  {'condition': '少云', 'icon': 'assets/weather/少云.svg'},
  {'condition': '多云', 'icon': 'assets/weather/多云.svg'},
  {'condition': '阴天', 'icon': 'assets/weather/阴天.svg'},
  {'condition': '雾', 'icon': 'assets/weather/雾.svg'},
  {'condition': '冻雾', 'icon': 'assets/weather/冻雾.svg'},
  {'condition': '毛毛雨', 'icon': 'assets/weather/毛毛雨.svg'},
  {'condition': '冻雨', 'icon': 'assets/weather/冻雨.svg'},
  {'condition': '小雨', 'icon': 'assets/weather/小雨.svg'},
  {'condition': '中雨', 'icon': 'assets/weather/中雨.svg'},
  {'condition': '大雨', 'icon': 'assets/weather/大雨.svg'},
  {'condition': '小雪', 'icon': 'assets/weather/小雪.svg'},
  {'condition': '中雪', 'icon': 'assets/weather/中雪.svg'},
  {'condition': '大雪', 'icon': 'assets/weather/大雪.svg'},
  {'condition': '雪粒', 'icon': 'assets/weather/雪粒.svg'},
  {'condition': '阵雨', 'icon': 'assets/weather/阵雨.svg'},
  {'condition': '阵雪', 'icon': 'assets/weather/阵雪.svg'},
  {'condition': '雷暴', 'icon': 'assets/weather/雷暴.svg'},
  {'condition': '雷暴伴冰雹', 'icon': 'assets/weather/雷暴伴冰雹.svg'},
];

class WeatherTestPage extends StatelessWidget {
  const WeatherTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '天气组件测试',
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_allWeatherStates.length} 种',
                style: context.textTheme.bodyMedium?.copyWith(color: context.textTertiary),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        itemCount: _allWeatherStates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final state = _allWeatherStates[index];
          final weather = WeatherInfo(
            temperature: _temperatureForCondition(state['condition']!),
            condition: state['condition']!,
            humidity: _humidityForCondition(state['condition']!),
            icon: state['icon'],
            uvIndex: '中',
            comfortLevel: '舒适',
            location: '测试城市',
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  '#${index + 1}  ${state['condition']}',
                  style: context.textTheme.labelSmall?.copyWith(color: context.textTertiary, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
              ),
              _WeatherCardPreview(weather: weather),
            ],
          );
        },
      ),
    );
  }

  /// Generate a plausible temperature for each condition for demo
  static int _temperatureForCondition(String condition) {
    switch (condition) {
      case '晴朗':
        return 28;
      case '少云':
        return 25;
      case '多云':
        return 22;
      case '阴天':
        return 18;
      case '雾':
        return 12;
      case '冻雾':
        return -2;
      case '毛毛雨':
        return 16;
      case '冻雨':
        return -1;
      case '小雨':
        return 15;
      case '中雨':
        return 14;
      case '大雨':
        return 13;
      case '小雪':
        return 0;
      case '中雪':
        return -3;
      case '大雪':
        return -5;
      case '雪粒':
        return -4;
      case '阵雨':
        return 20;
      case '阵雪':
        return -2;
      case '雷暴':
        return 26;
      case '雷暴伴冰雹':
        return 24;
      default:
        return 20;
    }
  }

  static int _humidityForCondition(String condition) {
    if (condition.contains('雨') || condition.contains('毛毛')) return 85;
    if (condition.contains('雪') || condition.contains('冻')) return 75;
    if (condition.contains('雾')) return 95;
    if (condition.contains('雷')) return 80;
    if (condition == '晴朗') return 40;
    return 60;
  }
}

/// A replica of the recommendation page's _WeatherCard for testing
class _WeatherCardPreview extends StatelessWidget {
  final WeatherInfo weather;

  const _WeatherCardPreview({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${weather.temperature}°C',
                      style: context.textTheme.displayLarge?.copyWith(color: context.textPrimary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    if (weather.icon != null && weather.icon!.endsWith('.svg'))
                      SvgPicture.asset(weather.icon!, width: 32, height: 32)
                    else
                      Text(
                        weather.icon ?? '☀️',
                        style: context.textTheme.displayMedium,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      weather.condition,
                      style: context.textTheme.titleMedium?.copyWith(color: context.textPrimary, fontWeight: FontWeight.w500),
                    ),
                    if (weather.location != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '📍 ${weather.location}',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '紫外线${weather.uvIndex ?? "中"}',
                      style: context.textTheme.bodySmall?.copyWith(color: context.textTertiary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '湿度 ${weather.humidity}%',
                      style: context.textTheme.bodySmall?.copyWith(color: context.textTertiary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '舒适度：${weather.comfortLevel ?? "一般"}',
                      style: context.textTheme.bodySmall?.copyWith(color: context.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.weatherSunnyStart,
                  AppColors.weatherSunnyEnd,
                ],
              ),
            ),
            child: Center(
              child: weather.icon != null && weather.icon!.endsWith('.svg')
                  ? SvgPicture.asset(weather.icon!, width: 48, height: 48)
                  : Text(
                      weather.icon ?? '☀️',
                      style: const TextStyle(fontSize: 40),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
