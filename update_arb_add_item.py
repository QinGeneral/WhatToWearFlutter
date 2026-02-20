import json

zh_additions_add_item = {
  "uploadClothingPhoto": "请上传衣物照片",
  "enterMaterialInfo": "请输入材质信息",
  "completeInfo": "请完善信息",
  "saveFailedCause": "保存失败：可能是因为图片过大或存储空间不足",
  "aiOptimizationSuccess": "图片优化成功！",
  "aiOptimizationFailed": "优化失败",
  "aiRecognitionFailed": "AI 识别失败",
  "basicInfo": "基础信息",
  "itemName": "衣物名称",
  "egWhiteLinenShirt": "例如：白色亚麻衬衫",
  "details": "详细细节",
  "egHundredPercentCotton": "例如：100% 纯棉",
  "egUniqlo": "例如：优衣库",
  "saveChanges": "保存修改",
  "aiOptimizing": "AI 优化中...",
  "aiRecognizing": "AI 识别中...",
  "clickToUploadPhoto": "点击上传照片"
}

en_additions_add_item = {
  "uploadClothingPhoto": "Please upload a clothing photo",
  "enterMaterialInfo": "Please enter material info",
  "completeInfo": "Please complete the information",
  "saveFailedCause": "Save failed: Image may be too large or not enough storage space",
  "aiOptimizationSuccess": "Image optimization successful!",
  "aiOptimizationFailed": "Optimization failed",
  "aiRecognitionFailed": "AI recognition failed",
  "basicInfo": "Basic Information",
  "itemName": "Item Name",
  "egWhiteLinenShirt": "e.g., White Linen Shirt",
  "details": "Details",
  "egHundredPercentCotton": "e.g., 100% Cotton",
  "egUniqlo": "e.g., Uniqlo",
  "saveChanges": "Save Changes",
  "aiOptimizing": "AI optimizing...",
  "aiRecognizing": "AI recognizing...",
  "clickToUploadPhoto": "Tap to upload photo"
}

def update_arb(file_path, additions):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in additions.items():
        data[k] = v
        
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

if __name__ == '__main__':
    update_arb('lib/l10n/app_zh.arb', zh_additions_add_item)
    update_arb('lib/l10n/app_en.arb', en_additions_add_item)
    print("Add item ARB files updated.")
