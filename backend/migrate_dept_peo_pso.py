"""
migrate_dept_peo_pso.py
-----------------------
Adds the following to an EXISTING database:
  1. `peos` and `psos` TEXT columns to the `departments` table.
  2. The `program_outcomes` table (institution-wide POs, single row).

Safe to run multiple times — checks for existing columns/tables first.

Usage:
    cd backend
    python migrate_dept_peo_pso.py
"""

import os
import sys

# Ensure we can import app modules
sys.path.insert(0, os.path.dirname(__file__))

from app.core.database import engine
from sqlalchemy import text, inspect

def column_exists(inspector, table_name, column_name):
    columns = [c["name"] for c in inspector.get_columns(table_name)]
    return column_name in columns

def table_exists(inspector, table_name):
    return table_name in inspector.get_table_names()

def run_migration():
    inspector = inspect(engine)

    with engine.begin() as conn:
        # ── 1. Add `peos` column to departments ──────────────────────────────
        if not column_exists(inspector, "departments", "peos"):
            print("[+] Adding column `peos` to `departments`...")
            conn.execute(text("ALTER TABLE departments ADD COLUMN peos TEXT"))
        else:
            print("[=] Column `peos` already exists in `departments` — skipping.")

        # ── 2. Add `psos` column to departments ──────────────────────────────
        if not column_exists(inspector, "departments", "psos"):
            print("[+] Adding column `psos` to `departments`...")
            conn.execute(text("ALTER TABLE departments ADD COLUMN psos TEXT"))
        else:
            print("[=] Column `psos` already exists in `departments` — skipping.")

        # ── 3. Widen `vision` and `mission` to TEXT if they're VARCHAR(500) ──
        # NOTE: SQLite does not enforce column types strictly; for PostgreSQL
        # we alter the type. Skip if already TEXT.
        try:
            dialect = engine.dialect.name
            if dialect == "postgresql":
                for col in ("vision", "mission"):
                    print(f"[+] Altering `{col}` to TEXT in PostgreSQL...")
                    conn.execute(text(
                        f"ALTER TABLE departments ALTER COLUMN {col} TYPE TEXT"
                    ))
        except Exception as e:
            print(f"[!] Could not alter vision/mission types: {e}")

        # ── 4. Create `program_outcomes` table ───────────────────────────────
        if not table_exists(inspector, "program_outcomes"):
            print("[+] Creating table `program_outcomes`...")
            conn.execute(text("""
                CREATE TABLE program_outcomes (
                    id INTEGER PRIMARY KEY,
                    outcomes TEXT,
                    updated_by_id INTEGER REFERENCES users(id),
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """))
        else:
            print("[=] Table `program_outcomes` already exists — skipping.")

    print("\n[OK] Migration complete.")

if __name__ == "__main__":
    run_migration()
