"""
Find CSE students with incomplete profiles, grouped by year (2nd, 3rd, 4th).
Incomplete = any of these key fields is NULL or empty:
  date_of_birth, gender, blood_group, father_name, mother_name,
  phone, address_line1, community, aadhar_number
"""

from sqlalchemy import create_engine, or_
from sqlalchemy.orm import sessionmaker
import sys, os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from app.models.student import Student
from app.models.department import Department
from app.models.user import User

DATABASE_URL = "postgresql://postgres:admin@localhost:5432/campus_connect"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

dept = db.query(Department).filter(Department.code == "CSE").first()
if not dept:
    print("CSE department not found.")
    db.close()
    exit()

# String fields that must be filled for a "complete" profile
STRING_FIELDS = [
    Student.gender,
    Student.blood_group,
    Student.father_name,
    Student.mother_name,
    Student.address_line1,
    Student.community,
    Student.aadhar_number,
]

for year in [2, 3, 4]:
    # Build condition: any required field is NULL or empty string
    conditions = []
    # Date field — only check NULL (can't compare to empty string)
    conditions.append(Student.date_of_birth == None)
    # String fields — check NULL or empty
    for field in STRING_FIELDS:
        conditions.append(field == None)
        conditions.append(field == "")

    students = (
        db.query(Student)
        .join(User)
        .filter(
            Student.department_id == dept.id,
            Student.current_year == year,
            Student.is_active == True,
            User.role == "student",
            or_(*conditions),
        )
        .order_by(Student.register_number)
        .all()
    )

    year_label = {2: "2nd", 3: "3rd", 4: "4th"}[year]
    print(f"\n{'='*80}")
    print(f"  CSE {year_label} Year — Incomplete Profiles  ({len(students)} students)")
    print(f"{'='*80}")
    print(f"{'No.':<5} {'Register Number':<20} {'Name':<30} {'Missing Fields'}")
    print(f"{'-'*5} {'-'*20} {'-'*30} {'-'*30}")

    for i, s in enumerate(students, 1):
        missing = []
        if not s.date_of_birth:
            missing.append("DOB")
        if not s.gender:
            missing.append("Gender")
        if not s.blood_group:
            missing.append("Blood Group")
        if not s.father_name:
            missing.append("Father Name")
        if not s.mother_name:
            missing.append("Mother Name")
        if not s.address_line1:
            missing.append("Address")
        if not s.community:
            missing.append("Community")
        if not s.aadhar_number:
            missing.append("Aadhar")

        name = f"{s.first_name} {s.last_name}".strip()
        print(f"{i:<5} {s.register_number:<20} {name:<30} {', '.join(missing)}")

    if not students:
        print("  ✅ All students have completed their profiles!")

print()
db.close()
