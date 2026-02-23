import os
import re
import json

def replace_in_file(file_path):
    with open('lib/l10n/app_zh.arb', 'r', encoding='utf-8') as f:
        zh_dict = json.load(f)

    # Reverse dict: Chinese string -> key
    # Filter out @@locale
    zh_to_key = {v: k for k, v in zh_dict.items() if not k.startswith('@')}
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Simple text replacements
    # Need to be careful with quotes: "全部" or '全部'
    modified = False
    
    for zh, key in zh_to_key.items():
        if not zh: continue
        # Replacement string
        replacement = f"AppLocalizations.of(context)?.{key} ?? '{zh}'"
        
        # We need to find places where 'zh' or "zh" exists.
        # But wait, we can't just replace blindly inside larger strings, though it's unlikely for these specific terms.
        # Let's replace exact matches: 'zh' or "zh"
        pattern1 = f"'{zh}'"
        pattern2 = f'"{zh}"'
        
        if pattern1 in content:
            content = content.replace(pattern1, replacement)
            modified = True
            
        if pattern2 in content:
            content = content.replace(pattern2, replacement)
            modified = True
            
    if modified:
        # Check if import is present
        import_stmt = "import 'package:what_to_wear_flutter/l10n/app_localizations.dart';"
        if import_stmt not in content:
            # Add after the first import
            content = re.sub(r"(import .*?;)", f"\\1\n{import_stmt}", content, count=1)
            
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {file_path}")

if __name__ == '__main__':
    target_files = [
        'lib/pages/wardrobe_page.dart',
        'lib/pages/add_item_page.dart',
        'lib/pages/custom_outfit_page.dart'
    ]
    for tf in target_files:
        if os.path.exists(tf):
            replace_in_file(tf)
