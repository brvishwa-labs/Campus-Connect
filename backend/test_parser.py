"""
test_parser.py

Tests the new dynamic row-by-row Tally file parser logic in fees.py.
"""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.api.fees import _parse_raw_rows
from fastapi import HTTPException
import datetime
from decimal import Decimal

def test_clean_file():
    print("Testing clean file...")
    rows = [
        ["Ledger Name", "Amount", "Date", "Voucher No"],
        ["John Doe", "15000", "2024-03-15", "VCH123"],
        ["Jane Smith", "10500.50", "15/03/2024", "VCH124"],
        ["", "", "", ""], # empty
        ["Grand Total", "25500.50", "", ""] # footer
    ]
    
    parsed = _parse_raw_rows(rows)
    assert len(parsed) == 2, f"Expected 2 rows, got {len(parsed)}"
    
    assert parsed[0]["ledger_name"] == "John Doe"
    assert parsed[0]["amount"] == Decimal("15000")
    assert parsed[0]["payment_date"] == datetime.date(2024, 3, 15)
    assert parsed[0]["voucher_no"] == "VCH123"
    
    assert parsed[1]["ledger_name"] == "Jane Smith"
    assert parsed[1]["amount"] == Decimal("10500.50")
    assert parsed[1]["payment_date"] == datetime.date(2024, 3, 15)
    assert parsed[1]["voucher_no"] == "VCH124"
    
    print("Clean file test passed!")

def test_messy_file():
    print("Testing messy Tally file...")
    rows = [
        ["Sri Venkateshwara College", "", "", ""],
        ["123 Main St, Tech City", "", "", ""],
        ["Phone: 123-456-7890", "", "", ""],
        [""],
        ["Group Summary", "", "", ""],
        ["1-Apr-2023 to 31-Mar-2024", "", "", ""],
        [""],
        ["Particulars", "Closing Balance", "", ""],
        ["", "Debit", "Credit", ""],
        ["Alice Student", "5000", "", ""],
        ["Bob Student", "", "1000", ""], # credit balance
        ["Charlie", "-", "", ""], # zero/dash
        ["David", "  2,500.00 ", "", ""],
        [""],
        ["Grand Total", "6500", "1000", ""]
    ]
    
    parsed = _parse_raw_rows(rows)
    assert len(parsed) == 3, f"Expected 3 rows, got {len(parsed)}"
    
    assert parsed[0]["ledger_name"] == "Alice Student"
    assert parsed[0]["amount"] == Decimal("5000")
    
    assert parsed[1]["ledger_name"] == "Bob Student"
    assert parsed[1]["amount"] == Decimal("1000")
    
    assert parsed[2]["ledger_name"] == "David"
    assert parsed[2]["amount"] == Decimal("2500.00")
    
    print("Messy file test passed!")

def test_no_header():
    print("Testing missing header...")
    rows = [
        ["Just", "Random", "Data"],
        ["Nothing", "Here", "Match"]
    ]
    try:
        _parse_raw_rows(rows)
        assert False, "Should have raised exception"
    except HTTPException as e:
        assert "Could not find a Particulars/Ledger Name" in e.detail
        print("Missing header test passed!")

if __name__ == "__main__":
    try:
        test_clean_file()
        test_messy_file()
        test_no_header()
        print("\nAll tests passed successfully! 🎉")
    except AssertionError as e:
        print(f"\n❌ Test failed: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
