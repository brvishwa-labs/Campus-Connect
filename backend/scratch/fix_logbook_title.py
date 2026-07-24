import re

file_path = r"c:\Users\Jeeva\My projects\Campus Connect\frontend\src\features\faculty\lms\LMSLogbookReport.jsx"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Pattern matching {course.code} ... {course.name}
old_pattern = r'<p style=\{\{ fontFamily: \'Times New Roman, serif\', fontSize: \'14pt\', fontWeight: \'bold\', color: \'#334155\', margin: \'0 0 12px 0\' \}\}>\{course\.code\}[^<]*\{course\.name\}</p>'

new_replacement = r'<p style={{ fontFamily: \'Times New Roman, serif\', fontSize: \'14pt\', fontWeight: \'bold\', color: \'#334155\', margin: \'0 0 12px 0\' }}>{course.code ? `${course.code} - ${course.name}` : course.name}</p>'

new_content, count = re.subn(old_pattern, new_replacement, content)

print(f"Replaced {count} occurrences")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(new_content)
