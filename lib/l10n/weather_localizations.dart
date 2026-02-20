import 'app_localizations.dart';

extension WeatherLocalizations on AppLocalizations {
  String translateWeatherCondition(String condition) {
    switch (condition) {
      case '晴朗':
        return weatherClear;
      case '少云':
        return weatherPartlyCloudy;
      case '多云':
        return weatherCloudy;
      case '阴天':
        return weatherOvercast;
      case '雾':
        return weatherFog;
      case '冻雾':
        return weatherFreezingFog;
      case '小毛毛雨':
        return weatherLightDrizzle;
      case '毛毛雨':
        return weatherDrizzle;
      case '密集毛毛雨':
        return weatherHeavyDrizzle;
      case '轻冻雨':
        return weatherLightFreezingRain; // Fallback to rain since names overlap in some maps
      case '冻雨':
        return weatherFreezingDrizzle;
      case '小雨':
        return weatherSlightRain;
      case '中雨':
        return weatherModerateRain;
      case '大雨':
        return weatherHeavyRain;
      case '强冻雨':
        return weatherHeavyFreezingRain;
      case '小雪':
        return weatherSlightSnow;
      case '中雪':
        return weatherModerateSnow;
      case '大雪':
        return weatherHeavySnow;
      case '雪粒':
        return weatherSnowGrains;
      case '小阵雨':
        return weatherSlightRainShowers;
      case '阵雨':
        return weatherModerateRainShowers;
      case '强阵雨':
        return weatherViolentRainShowers;
      case '小阵雪':
        return weatherSlightSnowShowers;
      case '强阵雪':
        return weatherHeavySnowShowers;
      case '雷暴':
        return weatherThunderstorm;
      case '雷暴伴冰雹':
        return weatherThunderstormHail;
      case '强雷暴伴冰雹':
        return weatherHeavyThunderstormHail;
      case '未知':
        return weatherUnknown;
      default:
        return condition;
    }
  }

  String translateComfortLevel(String comfort) {
    switch (comfort) {
      case '炎热':
        return comfortHot;
      case '寒冷':
        return comfortCold;
      case '舒适':
        return comfortComfortable;
      case '一般':
        return comfortNormal;
      default:
        return comfort;
    }
  }
}
