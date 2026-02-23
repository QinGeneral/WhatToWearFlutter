import os
import re
import json

def generate_string_dict():
    dart_files = []
    target_dirs = ['lib/pages', 'lib/widgets']
    for d in target_dirs:
      if not os.path.exists(d): continue
      for root, dirs, files in os.walk(d):
          for file in files:
              if file.endswith('.dart'):
                  dart_files.append(os.path.join(root, file))

    chinese_pattern = re.compile(r'[\u4e00-\u9fa5]')
    string_pattern = re.compile(r"(?:'([^'\\]*(?:\\.[^'\\]*)*)')|(?:\"([^\"\\]*(?:\\.[^\"\\]*)*)\")")

    unique_strings = set()
    
    for file_path in dart_files:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            content = re.sub(r'//.*', '', content)
            content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
            
            strings = string_pattern.findall(content)
            for s1, s2 in strings:
                s = s1 if s1 else s2
                if chinese_pattern.search(s):
                    # Filter out dynamic/complex strings
                    if '$' in s or 'assets/' in s or '\\n' in s or '\\' in s:
                        continue
                    unique_strings.add(s)
            
    # Output to a json file
    result = {s: {"key": "", "en": ""} for s in unique_strings}
    with open('chinese_strings_static.json', 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
        
if __name__ == '__main__':
    generate_string_dict()
