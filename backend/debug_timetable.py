from app.core.database import SessionLocal
from app.models.academic import CourseAssignment, Enrollment, Section
from app.models.lms import TimetableSlot

db = SessionLocal()

print("All sections:")
for sec in db.query(Section).all():
    print(f"Section {sec.id}: {sec.name}")

print("All CourseAssignments:")
cas = db.query(CourseAssignment).all()
print(f"Total CourseAssignments: {len(cas)}")
for ca in cas:
    print(f"CA {ca.id}: Section {ca.section_id}, Course {ca.course_id}")
    
slots = db.query(TimetableSlot).all()
print(f"Total TimetableSlots: {len(slots)}")
for slot in slots:
    print(f"Slot {slot.id}: CA {slot.course_assignment_id}")

