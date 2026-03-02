import json
import re

zh_additions = {
  "customOutfitTitle": "定制穿搭",
  "customOutfitSubtitle": "您的搭配需求？",
  "customOutfitDescription": "按指引填写日期、地点、活动和人物，获取精准方案",
  "customOutfitHint": "日期: [例如：本周末，下午]\n地点: [例如：户外，城市公园]\n活动: [例如：朋友的休闲生日聚会]\n人物: [例如：亲近的朋友]",
  "addCustomOptionPrefix": "添加\"",
  "addCustomOptionSuffix": "\"选项",
  "enterCustomContent": "请输入自定义内容",
  "customOption": "自定义",
  "generatingOutcome": "生成中...",
  "getOutfitPlan": "获取搭配方案",
  "generatingExclusiveOutfit": "正在为您定制专属穿搭...",
  "categoryDate": "日期",
  "categoryLocation": "地点",
  "categoryActivity": "活动",
  "categoryPerson": "人物",
  "optToday": "今天",
  "optTomorrow": "明天",
  "optDayAfter": "后天",
  "optWeekend": "周末",
  "optNextWeek": "下周",
  "optWorkday": "工作日",
  "optIndoor": "室内",
  "optOutdoor": "户外",
  "optMall": "商场",
  "optCafe": "咖啡厅",
  "optOffice": "办公室",
  "optPark": "公园",
  "optBirthday": "生日聚会",
  "optMeeting": "开会",
  "optDate": "约会",
  "optSports": "运动",
  "optCasual": "休闲",
  "optDinner": "正式晚宴",
  "optFriend": "朋友",
  "optColleague": "同事",
  "optFamily": "家人",
  "optPartner": "伴侣",
  "optClient": "客户"
}

en_additions = {
  "customOutfitTitle": "Custom Outfit",
  "customOutfitSubtitle": "Outfit Requirements?",
  "customOutfitDescription": "Fill in Date, Location, Activity, and Person to get a precise plan.",
  "customOutfitHint": "Date: [e.g. This weekend, afternoon]\nLocation: [e.g. Outdoors, city park]\nActivity: [e.g. Friend's casual birthday party]\nPerson: [e.g. Close friends]",
  "addCustomOptionPrefix": "Add \"",
  "addCustomOptionSuffix": "\" option",
  "enterCustomContent": "Please enter custom content",
  "customOption": "Custom",
  "generatingOutcome": "Generating...",
  "getOutfitPlan": "Get Outfit Plan",
  "generatingExclusiveOutfit": "Tailoring your exclusive outfit...",
  "categoryDate": "Date",
  "categoryLocation": "Location",
  "categoryActivity": "Activity",
  "categoryPerson": "Person",
  "optToday": "Today",
  "optTomorrow": "Tomorrow",
  "optDayAfter": "Day After",
  "optWeekend": "Weekend",
  "optNextWeek": "Next Week",
  "optWorkday": "Workday",
  "optIndoor": "Indoor",
  "optOutdoor": "Outdoor",
  "optMall": "Mall",
  "optCafe": "Cafe",
  "optOffice": "Office",
  "optPark": "Park",
  "optBirthday": "Birthday",
  "optMeeting": "Meeting",
  "optDate": "Date",
  "optSports": "Sports",
  "optCasual": "Casual",
  "optDinner": "Formal Dinner",
  "optFriend": "Friend",
  "optColleague": "Colleague",
  "optFamily": "Family",
  "optPartner": "Partner",
  "optClient": "Client"
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
    print("CustomOutfitPage ARB files updated.")
