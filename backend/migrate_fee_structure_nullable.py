"""
migrate_fee_structure_nullable.py — Make student_fee_assignments.fee_structure_id nullable.

Run ONCE:
    cd backend
    python migrate_fee_structure_nullable.py

This allows Opening Balance imports to create StudentFeeAssignment rows
even when no FeeStructure has been defined for the student's dept/semester.
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.core.database import engine
from sqlalchemy import text


def run():
    print("=" * 60)
    print("Campus Connect — Make fee_structure_id Nullable Migration")
    print("=" * 60)

    with engine.connect() as conn:
        # Check current nullable status
        result = conn.execute(text("""
            SELECT column_name, is_nullable
            FROM information_schema.columns
            WHERE table_name = 'student_fee_assignments'
              AND column_name = 'fee_structure_id'
        """))
        row = result.fetchone()
        if not row:
            print("  [ERROR] Table 'student_fee_assignments' or column 'fee_structure_id' not found.")
            sys.exit(1)

        if row[1] == 'YES':
            print("  [SKIP]  fee_structure_id is already nullable. Nothing to do.")
        else:
            conn.execute(text("""
                ALTER TABLE student_fee_assignments
                ALTER COLUMN fee_structure_id DROP NOT NULL
            """))
            conn.commit()
            print("  [ALTER] fee_structure_id is now nullable on student_fee_assignments.")

    print("\nMigration complete.")
    print("=" * 60)


if __name__ == "__main__":
    try:
        run()
    except Exception as exc:
        print(f"\nERROR: Migration failed — {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
