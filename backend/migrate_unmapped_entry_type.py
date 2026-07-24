"""
migrate_unmapped_entry_type.py — Add 'entry_type' column to 'unmapped_ledger_entries' table

Run this ONCE:
    cd backend
    python migrate_unmapped_entry_type.py
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.core.database import engine
from sqlalchemy import text


def run():
    print("=" * 60)
    print("Campus Connect — Unmapped Ledger Entry Type Migration")
    print("=" * 60)

    with engine.connect() as conn:
        try:
            conn.execute(text(
                "ALTER TABLE unmapped_ledger_entries "
                "ADD COLUMN IF NOT EXISTS entry_type VARCHAR(50) DEFAULT 'payment' NOT NULL"
            ))
            conn.execute(text("COMMIT"))
            print("  [SUCCESS] Added 'entry_type' column to 'unmapped_ledger_entries'.")
        except Exception as e:
            print(f"  [ERROR] {e}")

    print("=" * 60)


if __name__ == "__main__":
    try:
        run()
    except Exception as exc:
        print(f"\nERROR: {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
