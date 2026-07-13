"""
Campus Connect ERP — Holiday Utility

Shared helpers to check whether a date is a holiday.
Rules:
  1. Every Sunday is always a holiday (computed, not stored in DB).
  2. Admin-marked dates in the `holidays` table are holidays.
"""

from datetime import date as date_type
from sqlalchemy.orm import Session
from app.models.attendance import Holiday


def is_holiday(check_date: date_type, db: Session) -> bool:
    """
    Return True if the given date is a holiday.
    A date is a holiday if it's a Sunday (weekday == 6)
    or if it has a record in the `holidays` table.
    """
    # Sunday check (weekday: Mon=0 … Sun=6)
    if check_date.weekday() == 6:
        return True

    # DB check
    return db.query(Holiday).filter(Holiday.date == check_date).first() is not None


def get_holiday_name(check_date: date_type, db: Session) -> str | None:
    """
    Return the name of the holiday for the given date, or None if not a holiday.
    Sundays return 'Sunday' unless there is also an explicit DB entry.
    """
    record = db.query(Holiday).filter(Holiday.date == check_date).first()
    if record:
        return record.name
    if check_date.weekday() == 6:
        return "Sunday"
    return None


def get_academic_year_bounds(year_str: str | None = None) -> tuple[date_type, date_type]:
    """
    Return (start_date, end_date) for an academic year string like '2025-2026'.
    If year_str is None, infer the current academic year
    (June 1 → May 31 of the following year).
    """
    import datetime
    today = datetime.date.today()

    if year_str:
        try:
            parts = year_str.split("-")
            start_year = int(parts[0])
            end_year = int(parts[1])
            return (
                date_type(start_year, 6, 1),
                date_type(end_year, 5, 31),
            )
        except Exception:
            pass

    # Infer: academic year starts in June
    if today.month >= 6:
        start_year = today.year
    else:
        start_year = today.year - 1

    return (
        date_type(start_year, 6, 1),
        date_type(start_year + 1, 5, 31),
    )
