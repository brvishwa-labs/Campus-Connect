import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.models.student import Student
from app.models.department import Department
from app.models.user import User

DATABASE_URL = "postgresql://postgres:admin@localhost:5432/campus_connect"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

# Find CSE department
dept = db.query(Department).filter(Department.code == "CSE").first()
if not dept:
    print("CSE department not found.")
else:
    # Query students in 3rd year CSE
    # incomplete profile: date_of_birth is null or gender is null
    students = db.query(Student).join(User).filter(
        Student.department_id == dept.id,
        Student.current_year == 3,
        User.role == "student",
        (Student.date_of_birth == None) | (Student.gender == None) | (Student.gender == "")
    ).all()

    print(f"Total students found: {len(students)}")
    for s in students:
        print(f"Reg No: {s.register_number}, Name: {s.first_name} {s.last_name}, Email: {s.college_email}")

db.close()
