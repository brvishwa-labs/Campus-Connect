with open('backend/app/api/dashboard.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('@router.get(') and 'dean/stats' in line:
        start_idx = i
        break

if start_idx == -1:
    print('Could not find dean stats')
    exit(1)

end_idx = len(lines)
for i in range(start_idx + 1, len(lines)):
    if lines[i].startswith('@router.get(') or lines[i].startswith('@router.post('):
        end_idx = i
        break

dean_func_lines = lines[start_idx:end_idx]
om_func_str = ''.join(dean_func_lines)
om_func_str = om_func_str.replace('dean/stats', 'om/analytics')
om_func_str = om_func_str.replace('def get_dean_dashboard_stats', 'def get_om_analytics')
om_func_str = om_func_str.replace('authority.title != "Dean"', 'False')
om_func_str = om_func_str.replace('Access denied: Dean role required', 'Access denied')

with open('backend/app/api/dashboard.py', 'a', encoding='utf-8') as f:
    f.write('\n\n' + om_func_str)
print('Appended OM analytics endpoint.')
