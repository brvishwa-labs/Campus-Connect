import psycopg2
import io
import os

conn = psycopg2.connect('postgresql://postgres:admin@localhost:5432/campus_connect')
cursor = conn.cursor()

print("Resetting public schema...")
cursor.execute('DROP SCHEMA public CASCADE; CREATE SCHEMA public;')
cursor.execute('SET search_path TO public, pg_catalog;')
conn.commit()

with open('dump.sql', 'r', encoding='utf-8') as f:
    text = f.read()

# Replace any set_config search_path line
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
    s = line.strip()
    if s.startswith('\\') and not in_copy and s != r'\.':
        continue
    if not in_copy:
        if s.startswith('COPY ') or s.startswith('copy '):
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
                        print(f"DDL ERR at line {i}: {e}\nStmt: {st[:80]!r}\n")
                stmt_lines = []
            in_copy = True
            copy_cmd = line
        else:
            stmt_lines.append(line)
            if s.endswith(';'):
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
                        if ddl_fail <= 5:
                            print(f"DDL ERR at line {i}: {e}\nStmt: {st[:80]!r}\n")
    else:
        if s == r'\.':
            in_copy = False
            try:
                cursor.copy_expert(copy_cmd, io.StringIO('\n'.join(copy_lines) + '\n'))
                conn.commit()
                copy_ok += 1
            except Exception as e:
                conn.rollback()
                copy_fail += 1
                print(f"COPY ERR for {copy_cmd[:40]}: {e}")
            copy_lines = []
        else:
            copy_lines.append(line)

print(f"\nResult: DDL OK: {ddl_ok}, DDL FAIL: {ddl_fail} | COPY OK: {copy_ok}, COPY FAIL: {copy_fail}")
cursor.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
print('Tables created:', cursor.fetchone()[0])

for t in ['users', 'students', 'faculty', 'departments', 'courses', 'sections']:
    try:
        cursor.execute(f"SELECT count(*) FROM \"{t}\";")
        print(f" - {t}: {cursor.fetchone()[0]}")
    except Exception as e:
        conn.rollback()
        print(f" - {t}: missing ({e})")

cursor.close()
conn.close()
