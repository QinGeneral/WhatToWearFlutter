import json

# Adding weather translation keys to ARB files
zh_additions = {
  "weatherClear": "晴朗",
  "weatherPartlyCloudy": "少云",
  "weatherCloudy": "多云",
  "weatherOvercast": "阴天",
  "weatherFog": "雾",
  "weatherFreezingFog": "冻雾",
  "weatherLightDrizzle": "小毛毛雨",
  "weatherDrizzle": "毛毛雨",
  "weatherHeavyDrizzle": "密集毛毛雨",
  "weatherLightFreezingDrizzle": "轻冻雨",
  "weatherFreezingDrizzle": "冻雨",
  "weatherSlightRain": "小雨",
  "weatherModerateRain": "中雨",
  "weatherHeavyRain": "大雨",
  "weatherLightFreezingRain": "轻冻雨",
  "weatherHeavyFreezingRain": "强冻雨",
  "weatherSlightSnow": "小雪",
  "weatherModerateSnow": "中雪",
  "weatherHeavySnow": "大雪",
  "weatherSnowGrains": "雪粒",
  "weatherSlightRainShowers": "小阵雨",
  "weatherModerateRainShowers": "阵雨",
  "weatherViolentRainShowers": "强阵雨",
  "weatherSlightSnowShowers": "小阵雪",
  "weatherHeavySnowShowers": "强阵雪",
  "weatherThunderstorm": "雷暴",
  "weatherThunderstormHail": "雷暴伴冰雹",
  "weatherHeavyThunderstormHail": "强雷暴伴冰雹",
  "weatherUnknown": "未知",
  "comfortHot": "炎热",
  "comfortCold": "寒冷",
  "comfortComfortable": "舒适"
}

en_additions = {
  "weatherClear": "Clear",
  "weatherPartlyCloudy": "Partly Cloudy",
  "weatherCloudy": "Cloudy",
  "weatherOvercast": "Overcast",
  "weatherFog": "Fog",
  "weatherFreezingFog": "Freezing Fog",
  "weatherLightDrizzle": "Light Drizzle",
  "weatherDrizzle": "Drizzle",
  "weatherHeavyDrizzle": "Heavy Drizzle",
  "weatherLightFreezingDrizzle": "Light Freezing Drizzle",
  "weatherFreezingDrizzle": "Freezing Drizzle",
  "weatherSlightRain": "Slight Rain",
  "weatherModerateRain": "Moderate Rain",
  "weatherHeavyRain": "Heavy Rain",
  "weatherLightFreezingRain": "Light Freezing Rain",
  "weatherHeavyFreezingRain": "Heavy Freezing Rain",
  "weatherSlightSnow": "Slight Snow",
  "weatherModerateSnow": "Moderate Snow",
  "weatherHeavySnow": "Heavy Snow",
  "weatherSnowGrains": "Snow Grains",
  "weatherSlightRainShowers": "Slight Rain Showers",
  "weatherModerateRainShowers": "Moderate Rain Showers",
  "weatherViolentRainShowers": "Violent Rain Showers",
  "weatherSlightSnowShowers": "Slight Snow Showers",
  "weatherHeavySnowShowers": "Heavy Snow Showers",
  "weatherThunderstorm": "Thunderstorm",
  "weatherThunderstormHail": "Thunderstorm with Hail",
  "weatherHeavyThunderstormHail": "Heavy Thunderstorm with Hail",
  "weatherUnknown": "Unknown",
  "comfortHot": "Hot",
  "comfortCold": "Cold",
  "comfortComfortable": "Comfortable"
}

def update_arb(file_path, additions):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in additions.items():
        if k not in data:
            data[k] = v
        
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

if __name__ == '__main__':
    update_arb('lib/l10n/app_zh.arb', zh_additions)
    update_arb('lib/l10n/app_en.arb', en_additions)
    print("Weather ARB files updated.")
