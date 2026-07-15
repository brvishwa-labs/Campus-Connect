"""Check all 4 conditions for cseanbus substitute display bug."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from app.core.database import SessionLocal
from app.models.user import User
from app.models.faculty import Faculty
from app.models.leave import FacultyLeaveRequest, FacultyDutyArrangement, LeaveStatus, ArrangementStatus
from app.models.academic import CourseAssignment, Course, Section
from datetime import date

db = SessionLocal()
today = date(2026, 7, 16)

# Step 0: Find cseanbus
user = db.query(User).filter(User.email.ilike("%cseanbus%")).first()
if not user:
    print("ERROR: No user matching 'cseanbus' found")
    users = db.query(User).filter(User.email.ilike("%csea%")).all()
    print(f"Similar users: {[(u.id, u.email, u.role) for u in users]}")
    db.close()
    sys.exit()

print(f"USER:    id={user.id}, email={user.email}, role={user.role}")

faculty = db.query(Faculty).filter(Faculty.user_id == user.id).first()
if not faculty:
    print("ERROR: No Faculty row for this user")
    db.close()
    sys.exit()

print(f"FACULTY: id={faculty.id}, user_id={faculty.user_id}, name={faculty.first_name} {faculty.last_name}")
print()

# ─── CHECK: All arrangements where cseanbus IS the substitute ───
print("=" * 80)
print("ALL FacultyDutyArrangement WHERE cseanbus IS SUBSTITUTE")
print("=" * 80)

arrangements = db.query(FacultyDutyArrangement).filter(
    FacultyDutyArrangement.substitute_faculty_id == faculty.id
).all()

if not arrangements:
    print("  *** NO ARRANGEMENTS FOUND AT ALL ***")
else:
    for arr in arrangements:
        lr = arr.leave_request
        original_fac = db.query(Faculty).filter(Faculty.id == lr.faculty_id).first()
        orig_name = f"{original_fac.first_name} {original_fac.last_name}" if original_fac else "UNKNOWN"

        in_range = lr.from_date <= today <= lr.to_date

        print(f"\n  --- Arrangement #{arr.id} ---")
        print(f"  leave_request_id     = {arr.leave_request_id}")
        print(f"  original_faculty     = id={lr.faculty_id} ({orig_name})")
        print(f"  substitute_faculty   = id={arr.substitute_faculty_id}")
        print(f"  subject              = \"{arr.subject}\"")
        print(f"  class_section        = \"{arr.class_section}\"")
        print(f"  period               = \"{arr.period}\"")
        print(f"  day                  = \"{arr.day}\"")
        print(f"  compensation_date    = {arr.compensation_date}")
        print(f"  compensation_period  = \"{arr.compensation_period}\"")
        print(f"  arrangement.status   = \"{arr.status}\"  (raw type: {type(arr.status).__name__})")
        print(f"  leave_request.status = \"{lr.status}\"  (raw type: {type(lr.status).__name__})")
        print(f"  leave from_date      = {lr.from_date}")
        print(f"  leave to_date        = {lr.to_date}")
        print(f"  TODAY ({today}) in range? => {in_range}")

        # CHECK 1: Leave approved + date in range
        if lr.status == LeaveStatus.APPROVED and in_range:
            print(f"  CHECK 1 PASS: Leave is APPROVED and today is in range")
        else:
            print(f"  CHECK 1 FAIL: status={lr.status}, in_range={in_range}")

        # CHECK 2: substitute_faculty_id matches Faculty.id (not User.id)
        if arr.substitute_faculty_id == faculty.id:
            print(f"  CHECK 2 PASS: substitute_faculty_id={arr.substitute_faculty_id} == faculty.id={faculty.id}")
        else:
            print(f"  CHECK 2 FAIL: substitute_faculty_id={arr.substitute_faculty_id} != faculty.id={faculty.id}")

        # CHECK 3: Arrangement status is ACCEPTED
        if arr.status == ArrangementStatus.ACCEPTED:
            print(f"  CHECK 3 PASS: arrangement status is ACCEPTED")
        else:
            print(f"  CHECK 3 FAIL: arrangement status is \"{arr.status}\" (expected ACCEPTED)")

        # CHECK 4: subject matches Course.code or Course.short_name
        matching = db.query(CourseAssignment).join(Course).filter(
            CourseAssignment.faculty_id == lr.faculty_id,
            CourseAssignment.is_active == True,
            (Course.code == arr.subject) | (Course.short_name == arr.subject)
        ).all()

        if matching:
            for ma in matching:
                sec = db.query(Section).filter(Section.id == ma.section_id).first()
                sec_label = f"{sec.year}Y {sec.name}" if sec else "N/A"
                print(f"  CHECK 4 PASS: Matched CourseAssignment id={ma.id}, code=\"{ma.course.code}\", section={sec_label}")
        else:
            print(f"  CHECK 4 FAIL: No match for subject=\"{arr.subject}\"")
            orig_asgns = db.query(CourseAssignment).join(Course).filter(
                CourseAssignment.faculty_id == lr.faculty_id,
                CourseAssignment.is_active == True
            ).all()
            print(f"    Original faculty's active assignments:")
            for oa in orig_asgns:
                print(f"      id={oa.id} code=\"{oa.course.code}\" short=\"{oa.course.short_name}\" name=\"{oa.course.name}\"")

print()
print("=" * 80)
print("CSEANBUS OWN ACTIVE COURSE ASSIGNMENTS")
print("=" * 80)
own = db.query(CourseAssignment).join(Course).filter(
    CourseAssignment.faculty_id == faculty.id,
    CourseAssignment.is_active == True
).all()
for a in own:
    sec = db.query(Section).filter(Section.id == a.section_id).first()
    sec_label = f"{sec.year}Y {sec.name}" if sec else "N/A"
    print(f"  id={a.id} code=\"{a.course.code}\" name=\"{a.course.name}\" section_id={a.section_id} ({sec_label})")

db.close()
print("\nDone.")
