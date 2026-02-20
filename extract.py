import os
import re

def find_chinese_strings():
    dart_files = []
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                dart_files.append(os.path.join(root, file))

    chinese_pattern = re.compile(r'[\u4e00-\u9fa5]')
    
    # Matches single or double quoted strings
    # We'll use a simple regex for finding strings first, then check if they contain Chinese.
    string_pattern = re.compile(r"(?:'([^'\\]*(?:\\.[^'\\]*)*)')|(?:\"([^\"\\]*(?:\\.[^\"\\]*)*)\")")

    results = {}
    
    for file_path in dart_files:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Remove single line comments
            content = re.sub(r'//.*', '', content)
            # Remove multi-line comments
            content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
            
            strings = string_pattern.findall(content)
            
            file_chinese_strings = []
            for s1, s2 in strings:
                s = s1 if s1 else s2
                if chinese_pattern.search(s):
                    file_chinese_strings.append(s)
            
            if file_chinese_strings:
                results[file_path] = list(set(file_chinese_strings))
                
    for path, strings in results.items():
        print(f"--- {path} ---")
        for s in strings:
            print(f"  {s}")

if __name__ == '__main__':
    find_chinese_strings()
