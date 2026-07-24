import psycopg2
import io
import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import engine, Base
import app.models  # Register all models

print("Step 1: Dropping and creating all tables via SQLAlchemy...")
with engine.connect() as conn:
    from sqlalchemy import text
    conn.execute(text("DROP SCHEMA public CASCADE; CREATE SCHEMA public;"))
    conn.commit()

Base.metadata.create_all(bind=engine)
print("SQLAlchemy create_all complete!")

from app.core.config import get_settings
db_url = get_settings().DATABASE_URL.replace("+pg8000", "").replace("+psycopg2", "")
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql://", 1)

conn = psycopg2.connect(db_url)
cursor = conn.cursor()

# Disable triggers / foreign key constraints during bulk COPY load
cursor.execute("SET session_replication_role = 'replica';")
conn.commit()

with open('dump.sql', 'r', encoding='utf-8') as f:
    lines = f.readlines()

in_copy = False
copy_cmd = ''
copy_lines = []
copy_ok = 0
copy_fail = 0

for line in lines:
    s = line.rstrip('\r\n')
    if not in_copy:
        if s.startswith('COPY ') or s.startswith('copy '):
            in_copy = True
            copy_cmd = s
            copy_lines = []
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

# Re-enable triggers / foreign key constraints
cursor.execute("SET session_replication_role = 'origin';")
conn.commit()

print(f"\nCOPY Summary: {copy_ok} succeeded, {copy_fail} failed.")

print("\nVerifying table counts:")
for t in ['users', 'students', 'faculty', 'departments', 'courses', 'sections', 'gate_passes', 'announcements', 'attendance']:
    try:
        cursor.execute(f"SELECT count(*) FROM \"{t}\";")
        print(f" - {t}: {cursor.fetchone()[0]} rows")
    except Exception as e:
        conn.rollback()
        print(f" - {t}: error ({e})")

cursor.close()
conn.close()
