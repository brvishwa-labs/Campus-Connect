import sys, os
sys.path.insert(0, os.path.abspath('.'))
from app.core.database import SessionLocal
from app.models.user import User, UserRole
from app.models.leave import RestrictedHoliday, FacultyLeaveRequest, LeaveStatus
from app.api.leave import create_restricted_holiday, get_restricted_holidays, create_leave_request
from app.schemas.leave import RestrictedHolidayCreate, FacultyLeaveRequestCreate, FacultyDutyArrangementCreate
import datetime
from fastapi import HTTPException

db = SessionLocal()
try:
    # 1. Find an HR user (authority with title 'HR')
    from app.models.authority import Authority
    hr_user = db.query(User).join(Authority, User.id == Authority.user_id).filter(User.role == UserRole.AUTHORITY, Authority.title.ilike('%hr%')).first()
    # 2. Find a faculty user with actual faculty profile
    from app.models.faculty import Faculty
    faculty_profile = db.query(Faculty).first()
    faculty_user = db.query(User).filter(User.id == faculty_profile.user_id).first()
    
    # 2.5 Find a valid substitute faculty (different from the applicant)
    substitute_faculty = db.query(Faculty).filter(Faculty.id != faculty_profile.id).first()
    substitute_id = substitute_faculty.id if substitute_faculty else faculty_profile.id
    
    if not hr_user or not faculty_user:
        print("Required test users not found in DB.")
        sys.exit(1)
        
    print(f"Testing with HR user: {hr_user.email}, Faculty user: {faculty_user.email}")
    
    # Clean up existing test holidays
    db.query(RestrictedHoliday).filter(RestrictedHoliday.name.ilike('test holiday%')).delete()
    db.commit()
    
    # 3. Create a restricted holiday as HR
    holiday_date = datetime.date.today() + datetime.timedelta(days=10)
    holiday_in = RestrictedHolidayCreate(
        name="Test Holiday 1",
        date=holiday_date,
        academic_year="2023-2024",
        description="Test description"
    )
    
    try:
        new_holiday = create_restricted_holiday(holiday_in=holiday_in, db=db, current_user=hr_user)
        print("Successfully created restricted holiday:", new_holiday.name)
    except Exception as e:
        print("Failed to create holiday as HR:", e)
        
    # 4. Try to create restricted holiday as Faculty (should fail with 403)
    try:
        create_restricted_holiday(holiday_in=holiday_in, db=db, current_user=faculty_user)
        print("ERROR: Faculty was allowed to create restricted holiday!")
    except HTTPException as e:
        print("Success: Faculty was blocked from creating restricted holiday (status_code:", e.status_code, ")")
        
    # 5. List restricted holidays
    holidays = get_restricted_holidays(academic_year="2023-2024", db=db, current_user=faculty_user)
    print("Found restricted holidays for 2023-2024:", len(holidays))
    
    # 6. Try to apply for Restricted Leave on a non-restricted date (should fail with 400)
    arr = [FacultyDutyArrangementCreate(substitute_faculty_id=substitute_id, subject="Math", class_section="A", section_id=1, period="1")]
    leave_in = FacultyLeaveRequestCreate(
        leave_type="Restricted Leave",
        from_date=datetime.date.today(),
        to_date=datetime.date.today(),
        reason="Testing",
        arrangements=arr
    )
    
    try:
        create_leave_request(request=leave_in, db=db, current_user=faculty_user)
        print("ERROR: Faculty was allowed to apply for Restricted Leave on non-holiday date!")
    except HTTPException as e:
        print("Success: Restricted Leave on non-holiday date blocked (detail:", e.detail, ")")
        
    # 7. Apply for Restricted Leave on a holiday date (should succeed)
    leave_in_success = FacultyLeaveRequestCreate(
        leave_type="Restricted Leave",
        from_date=holiday_date,
        to_date=holiday_date,
        reason="Testing success",
        arrangements=arr
    )
    
    try:
        # Note: If the faculty profile for this user doesn't exist, this might fail, so we fetch their actual profile details.
        # But this tests the date validation which happens first.
        create_leave_request(request=leave_in_success, db=db, current_user=faculty_user)
        print("Success: Restricted Leave on holiday date succeeded (or reached HOD flow)!")
    except HTTPException as e:
        print("Request failed, but check detail:", e.detail)
        # If it failed due to already utilized, or other profile errors, that's fine.
        
except Exception as e:
    print("General test error:", e)
finally:
    db.close()
