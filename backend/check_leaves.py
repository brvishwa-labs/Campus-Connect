import sqlite3
import datetime

conn = sqlite3.connect('d:/EduTrack/Campus-Connect/backend/campus_connect.db')
cursor = conn.cursor()
cursor.execute('SELECT name FROM sqlite_master WHERE type="table";')
print("Tables:", cursor.fetchall())

try:
    cursor.execute('SELECT id, from_date, to_date, status, faculty_id FROM faculty_leave_requests')
    print("Leaves:", cursor.fetchall())
except Exception as e:
    print("Error querying leaves:", e)
