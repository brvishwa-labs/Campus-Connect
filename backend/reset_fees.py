import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.core.database import engine
from sqlalchemy import text

def run():
    print("=" * 60)
    print("Campus Connect — Resetting Fees Data")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("Deleting payments...")
        conn.execute(text("DELETE FROM payments"))
        
        print("Deleting student_fee_assignments...")
        conn.execute(text("DELETE FROM student_fee_assignments"))
        
        print("Deleting unmapped_ledger_entries...")
        conn.execute(text("DELETE FROM unmapped_ledger_entries"))
        
        print("Deleting tally_ledger_mappings...")
        conn.execute(text("DELETE FROM tally_ledger_mappings"))
        
        conn.execute(text("COMMIT"))
        
    print("Done resetting fees data.")
    
if __name__ == "__main__":
    try:
        run()
    except Exception as exc:
        print(f"\nERROR: {exc}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
