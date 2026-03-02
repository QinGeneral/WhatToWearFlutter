import json

zh_additions = {
  "occasionType": "场合类型",
  "dailyLiteral": "日常",
  "topDefault": "上装",
  "bottomDefault": "下装"
}

en_additions = {
  "occasionType": "Occasion Type",
  "dailyLiteral": "Daily",
  "topDefault": "Top",
  "bottomDefault": "Bottom"
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
    print("ShareDialog ARB files updated.")
