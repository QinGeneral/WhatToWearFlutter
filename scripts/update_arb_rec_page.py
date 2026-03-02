import json

zh_additions_rec_page = {
  "forYouRecommendation": "为你推荐",
  "clickFabToGetRecommendation": "点击右下角按钮获取穿搭推荐",
  "uvIndexPrefix": "紫外线",
  "humidityPrefix": "湿度 ",
  "comfortLevelPrefix": "舒适度：",
  "matchSuffix": "% 匹配",
  "businessCasualBreathable": "商务休闲 • 透气棉质",
  "classicBusiness": "经典商务",
  "uvMedium": "中",
  "comfortNormal": "一般"
}

en_additions_rec_page = {
  "forYouRecommendation": "Recommended for You",
  "clickFabToGetRecommendation": "Tap the bottom right button to get an outfit recommendation",
  "uvIndexPrefix": "UV ",
  "humidityPrefix": "Humidity ",
  "comfortLevelPrefix": "Comfort: ",
  "matchSuffix": "% Match",
  "businessCasualBreathable": "Business Casual • Breathable",
  "classicBusiness": "Classic Business",
  "uvMedium": "Med",
  "comfortNormal": "Normal"
}

def update_arb(file_path, additions):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in additions.items():
        data[k] = v
        
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

if __name__ == '__main__':
    update_arb('lib/l10n/app_zh.arb', zh_additions_rec_page)
    update_arb('lib/l10n/app_en.arb', en_additions_rec_page)
    print("Rec page ARB files updated.")
