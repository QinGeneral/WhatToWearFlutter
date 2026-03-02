import json

zh_additions = {
  "recommendationNotFound": "推荐未找到",
  "outfitItems": "穿搭单品",
  "favorite": "收藏",
  "tagSummer": "夏季",
  "tagWarm": "保暖",
  "weatherLabel": "天气",
  "shareBtn": "分享",
  "generationFailed": "生成失败:",
  "generateTryOnImage": "生成试穿图"
}

en_additions = {
  "recommendationNotFound": "Recommendation not found",
  "outfitItems": "Outfit Items",
  "favorite": "Favorite",
  "tagSummer": "Summer",
  "tagWarm": "Warm",
  "weatherLabel": "Weather",
  "shareBtn": "Share",
  "generationFailed": "Generation failed:",
  "generateTryOnImage": "Generate Try-On"
}

def update_arb(file_path, additions):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in additions.items():
        data[k] = v
        
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

if __name__ == '__main__':
    update_arb('lib/l10n/app_zh.arb', zh_additions)
    update_arb('lib/l10n/app_en.arb', en_additions)
    print("OutfitDetailPage ARB files updated.")
