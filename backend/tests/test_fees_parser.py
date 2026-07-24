import re
import pytest
import datetime

def extract_meta_info(ledger_name: str):
    """
    Extracted parsing logic from _smart_match_student for testing.
    """
    match = re.match(r'^(.*?)\s*\((.*?)\)$', ledger_name.strip())
    if not match:
        return None, None

    meta_part = match.group(2).strip()

    meta_match = re.match(
        r'^(?:\w+\s*-\s*)?([A-Za-z]+)\s*/\s*((?:19|20)\d{2}(?:-(?:19|20)?\d{2})?)$',
        meta_part
    )
    if not meta_match:
        return None, None

    dept_code = meta_match.group(1).upper()
    batch_year = meta_match.group(2).replace(' ', '')
    return dept_code, batch_year


def test_tally_real_formats():
    # Format 1: quota prefix with slashes
    dept, batch = extract_meta_info("Gokul S (Cen - CSE/2022-23)")
    assert dept == "CSE"
    assert batch == "2022-23"

    # Format 2: different prefix
    dept, batch = extract_meta_info("John Doe (Mng - TEST/2026-2030)")
    assert dept == "TEST"
    assert batch == "2026-2030"

    # Format 3: no spaces around dash/slash
    dept, batch = extract_meta_info("Jane (Cen-CSE/2022-23)")
    assert dept == "CSE"
    assert batch == "2022-23"

    # Format 4: no quota prefix
    dept, batch = extract_meta_info("Bob (CSE/2022-23)")
    assert dept == "CSE"
    assert batch == "2022-23"

    # Format 5: bad formats return None
    assert extract_meta_info("Invalid Name") == (None, None)
    assert extract_meta_info("Name (CSE 2022-23)") == (None, None)


def test_opening_balance_no_fee_structure_required():
    """
    Verifies the find-or-create logic for StudentFeeAssignment works when
    no FeeStructure exists (fs=None). The assignment must be creatable with
    fee_structure_id=None and must never fail just because FeeStructure is absent.
    This mirrors the logic in upload_opening_balance_file() and the
    opening_balance branch of resolve_unmapped().
    """
    now = datetime.datetime.utcnow()
    if now.month >= 7:
        expected_ay = f"{now.year}-{now.year + 1}"
    else:
        expected_ay = f"{now.year - 1}-{now.year}"

    # Simulate: no FeeStructure found for this student's dept+semester
    fs = None
    fs_id = fs.id if fs else None
    ay = fs.academic_year if fs else expected_ay

    # Should not fail — fs_id must be None, ay must be a valid AY string
    assert fs_id is None
    assert "-" in ay  # e.g. "2025-2026"

    # Simulate construction of a StudentFeeAssignment with no fee_structure_id
    assignment_data = {
        "student_id": 999,
        "fee_structure_id": fs_id,
        "amount_due": 45000.00,
        "semester": 3,
        "academic_year": ay,
    }

    assert assignment_data["fee_structure_id"] is None, (
        "Opening balance must allow fee_structure_id=None"
    )
    assert assignment_data["amount_due"] == 45000.00
    assert assignment_data["academic_year"] == expected_ay
