import psycopg2
import io
import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.config import get_settings
db_url = get_settings().DATABASE_URL.replace("+pg8000", "").replace("+psycopg2", "")
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql://", 1)

conn = psycopg2.connect(db_url)
cursor = conn.cursor()

print("Resetting public schema...")
cursor.execute("DROP SCHEMA public CASCADE; CREATE SCHEMA public;")
cursor.execute("SET search_path TO public, pg_catalog;")
cursor.execute("SET session_replication_role = 'replica';")
conn.commit()

with open('dump.sql', 'r', encoding='utf-8') as f:
    text = f.read()

# Replace any set_config search_path line so search_path stays public
text = text.replace("SELECT pg_catalog.set_config('search_path', '', false);", "SET search_path TO public, pg_catalog;")

lines = text.splitlines()
stmt_lines = []
in_copy = False
copy_cmd = ''
copy_lines = []
copy_ok = 0
copy_fail = 0
ddl_ok = 0
ddl_fail = 0

for i, line in enumerate(lines):
    s = line.rstrip('\r\n')
    if s.strip().startswith('\\') and not in_copy and s.strip() != r'\.':
        continue
    if not in_copy:
        if s.strip().startswith('COPY ') or s.strip().startswith('copy '):
            if stmt_lines:
                st = '\n'.join(stmt_lines).strip()
                if st:
                    try:
                        cursor.execute(st)
                        conn.commit()
                        ddl_ok += 1
                    except Exception as e:
                        conn.rollback()
                        ddl_fail += 1
                stmt_lines = []
            in_copy = True
            copy_cmd = s
            copy_lines = []
        else:
            stmt_lines.append(line)
            if s.strip().endswith(';'):
                st = '\n'.join(stmt_lines).strip()
                stmt_lines = []
                if st and not st.startswith('--'):
                    try:
                        cursor.execute(st)
                        conn.commit()
                        ddl_ok += 1
                    except Exception as e:
                        conn.rollback()
                        ddl_fail += 1
    else:
        if s.strip() == r'\.':
            in_copy = False
            try:
                cleaned_data = '\n'.join(copy_lines) + ('\n' if copy_lines else '')
                cursor.copy_expert(copy_cmd, io.StringIO(cleaned_data))
                conn.commit()
                copy_ok += 1
            except Exception as e:
                conn.rollback()
                copy_fail += 1
                table_name = copy_cmd.split()[1] if len(copy_cmd.split()) > 1 else copy_cmd
                print(f"COPY Error on {table_name}: {e}")
            copy_lines = []
        else:
            copy_lines.append(s)

if stmt_lines:
    st = '\n'.join(stmt_lines).strip()
    if st:
        try:
            cursor.execute(st)
            conn.commit()
            ddl_ok += 1
        except Exception as e:
            conn.rollback()

cursor.execute("SET session_replication_role = 'origin';")
conn.commit()

print(f"\nResult: DDL OK: {ddl_ok}, DDL FAIL: {ddl_fail} | COPY OK: {copy_ok}, COPY FAIL: {copy_fail}")
cursor.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
print('Tables created:', cursor.fetchone()[0])

for t in ['users', 'students', 'faculty', 'departments', 'courses', 'sections', 'gate_passes', 'announcements', 'attendance']:
    try:
        cursor.execute(f"SELECT count(*) FROM \"{t}\";")
        print(f" - {t}: {cursor.fetchone()[0]}")
    except Exception as e:
        conn.rollback()
        print(f" - {t}: missing ({e})")

cursor.close()
conn.close()
