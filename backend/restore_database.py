"""
Database Restore & Initialization Tool for Campus Connect ERP
Populates a connected PostgreSQL database (local or cloud) using dump.sql.
"""

import sys
import os
import io
import re

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.config import get_settings
import psycopg2

def fix_database_url(url: str) -> str:
    if not url:
        return ""
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql://", 1)
    return url.replace("+pg8000", "").replace("+psycopg2", "")

def restore_dump(dump_path: str = "dump.sql"):
    settings = get_settings()
    db_url = fix_database_url(settings.DATABASE_URL)
    
    if not os.path.exists(dump_path):
        if os.path.exists("new.sql"):
            dump_path = "new.sql"
        elif os.path.exists("backup_2026-07-21.sql"):
            dump_path = "backup_2026-07-21.sql"
        else:
            print(f"ERROR: SQL dump file '{dump_path}' not found.")
            return False

    print(f"\n=========================================")
    print(f"Campus Connect Database Restoration Tool")
    print(f"=========================================")
    target = db_url.split('@')[-1] if '@' in db_url else db_url
    print(f"Target Database: {target}")
    print(f"SQL Dump File  : {dump_path}")

    encoding = "utf-8"
    try:
        with open(dump_path, "r", encoding="utf-8") as f:
            f.read(1000)
    except UnicodeDecodeError:
        encoding = "utf-16"

    with open(dump_path, "r", encoding=encoding) as f:
        content = f.read()

    # Crucial fix for pg_dump: override search_path reset
    content = content.replace("SELECT pg_catalog.set_config('search_path', '', false);", "SET search_path TO public;")
    content = content.replace('SELECT pg_catalog.set_config("search_path", "", false);', "SET search_path TO public;")

    conn = psycopg2.connect(db_url)
    cursor = conn.cursor()

    print("Resetting 'public' schema (CASCADE)...")
    try:
        cursor.execute("DROP SCHEMA public CASCADE; CREATE SCHEMA public;")
        cursor.execute("SET search_path TO public;")
        conn.commit()
        print("Schema reset successful.")
    except Exception as e:
        conn.rollback()
        print(f"Schema reset warning: {e}")

    lines = content.splitlines()

    current_statement = []
    in_copy = False
    copy_cmd = ""
    copy_lines = []
    
    ddl_success = 0
    ddl_errors = 0
    copy_success = 0
    copy_errors = 0

    for line in lines:
        stripped = line.strip()
        
        if stripped.startswith("\\") and not in_copy and stripped != r"\.":
            continue

        if not in_copy:
            if stripped.startswith("COPY ") or stripped.startswith("copy "):
                if current_statement:
                    stmt = "\n".join(current_statement).strip()
                    if stmt:
                        try:
                            cursor.execute(stmt)
                            conn.commit()
                            ddl_success += 1
                        except Exception:
                            conn.rollback()
                            ddl_errors += 1
                    current_statement = []

                in_copy = True
                copy_cmd = line
                copy_lines = []
            else:
                current_statement.append(line)
                if stripped.endswith(";"):
                    stmt = "\n".join(current_statement).strip()
                    current_statement = []
                    if stmt and not stmt.startswith("--"):
                        try:
                            cursor.execute(stmt)
                            conn.commit()
                            ddl_success += 1
                        except Exception:
                            conn.rollback()
                            ddl_errors += 1
        else:
            if stripped == r"\.":
                in_copy = False
                try:
                    data_str = "\n".join(copy_lines) + ("\n" if copy_lines else "")
                    cursor.copy_expert(copy_cmd, io.StringIO(data_str))
                    conn.commit()
                    copy_success += 1
                except Exception as e:
                    conn.rollback()
                    copy_errors += 1
                    table_name = copy_cmd.split()[1] if len(copy_cmd.split()) > 1 else copy_cmd
                    print(f"Warning: COPY to table {table_name} failed: {e}")
                copy_lines = []
            else:
                copy_lines.append(line)

    if current_statement:
        stmt = "\n".join(current_statement).strip()
        if stmt:
            try:
                cursor.execute(stmt)
                conn.commit()
                ddl_success += 1
            except Exception:
                conn.rollback()
                ddl_errors += 1

    print(f"\nExecution Summary:")
    print(f" - DDL Statements Executed: {ddl_success} success, {ddl_errors} skipped/errors")
    print(f" - Data COPY Blocks Loaded : {copy_success} tables loaded, {copy_errors} failed")

    print("\n=========================================")
    print("VERIFYING RESTORED DATABASE CONTENT")
    print("=========================================")
    cursor.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
    total_tables = cursor.fetchone()[0]
    print(f"Total tables created in public schema: {total_tables}\n")

    tables_to_verify = [
        'users', 'students', 'faculty', 'departments', 
        'courses', 'sections', 'gate_passes', 'announcements',
        'attendance', 'authorities', 'course_assignments'
    ]
    
    for t in tables_to_verify:
        try:
            cursor.execute(f"SELECT COUNT(*) FROM \"{t}\";")
            count = cursor.fetchone()[0]
            print(f" [OK] Table '{t}': {count} records")
        except Exception:
            conn.rollback()
            print(f" [MISSING] Table '{t}'")

    cursor.close()
    conn.close()
    print("\n=========================================")
    print("DATABASE RESTORATION COMPLETE!")
    print("=========================================\n")
    return True

if __name__ == "__main__":
    restore_dump()
