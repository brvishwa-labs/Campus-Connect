"""
migrate_fees.py — Create Fees Module tables

Run this script ONCE (or repeatedly — it is safe to re-run due to checkfirst=True):

    cd backend
    python migrate_fees.py

Tables created (if they don't already exist):
    fee_structures
    student_fee_assignments
    payments
    tally_ledger_mappings
    unmapped_ledger_entries

Follows the same pattern as all other migrate_*.py scripts in this project.
No existing tables are altered.
"""

import sys
import os

# Make sure the app package is importable from this script's directory
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.core.database import engine, Base

# Import ALL existing models so Base.metadata has them (prevents FK resolution errors)
import app.models  # noqa: F401 — imports everything via __init__.py

# Now import the new fee models specifically
from app.models.fees import (
    FeeStructure,
    StudentFeeAssignment,
    Payment,
    TallyLedgerMapping,
    UnmappedLedgerEntry,
)

FEE_TABLES = [
    FeeStructure.__table__,
    StudentFeeAssignment.__table__,
    Payment.__table__,
    TallyLedgerMapping.__table__,
    UnmappedLedgerEntry.__table__,
]


def run():
    print("=" * 60)
    print("Campus Connect — Fees Module Migration")
    print("=" * 60)

    for table in FEE_TABLES:
        from sqlalchemy import inspect
        inspector = inspect(engine)
        if table.name in inspector.get_table_names():
            print(f"  [SKIP]   Table '{table.name}' already exists.")
        else:
            table.create(engine, checkfirst=True)
            print(f"  [CREATE] Table '{table.name}' created successfully.")

    print("\nMigration complete. Fees module tables are ready.")
    print("=" * 60)


if __name__ == "__main__":
    try:
        run()
    except Exception as exc:
        print(f"\nERROR: Migration failed — {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
