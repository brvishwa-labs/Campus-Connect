"""
Migration: Create the `lab_marks` table.

Stores lab practical mark components per student per course assignment:
  - record_marks  (/30)
  - ia1_marks     (/15)
  - ia2_marks     (/15)
  - viva_marks    (/5)

Computed at API level (not stored):
  - avg_ia        = (ia1 + ia2) / 2  -> /15
  - att_pct       = from attendance table
  - att_marks     = /10 (based on att_pct thresholds)
  - total         = record + avg_ia + viva + att_marks  -> /60

Run once:
    python migrate_lab_marks.py
"""

import os
from sqlalchemy import create_engine, text

DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:admin@10.1.10.24:5432/campus_connect"
)

engine = create_engine(DATABASE_URL)


def migrate():
    with engine.connect() as conn:
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS lab_marks (
                id                   SERIAL PRIMARY KEY,
                course_assignment_id INTEGER NOT NULL
                                     REFERENCES course_assignments(id) ON DELETE CASCADE,
                student_id           INTEGER NOT NULL
                                     REFERENCES students(id) ON DELETE CASCADE,
                record_marks         NUMERIC(5, 2),
                ia1_marks            NUMERIC(5, 2),
                ia2_marks            NUMERIC(5, 2),
                viva_marks           NUMERIC(5, 2),
                is_published         BOOLEAN NOT NULL DEFAULT FALSE,
                graded_by_id         INTEGER REFERENCES faculty(id) ON DELETE SET NULL,
                created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                updated_at           TIMESTAMPTZ,
                CONSTRAINT uq_lab_mark_assignment_student
                    UNIQUE (course_assignment_id, student_id)
            );
        """))
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS ix_lab_marks_course_assignment_id
                ON lab_marks (course_assignment_id);
        """))
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS ix_lab_marks_student_id
                ON lab_marks (student_id);
        """))
        conn.commit()
        print("OK: lab_marks table created (or already exists).")


if __name__ == "__main__":
    migrate()
