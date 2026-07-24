import re
import sys

file_path = r'c:\Users\Jeeva\My projects\Campus Connect\backend\app\api\notifications.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r'apply_view_filter\(([^,]+),\s*[^,]+,\s*"[^"]+",\s*views_dict\)', r'\1', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

