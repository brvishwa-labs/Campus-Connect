import psycopg2
from app.core.security import verify_password

url = "postgresql://postgres:admin@localhost:5432/campus_connect"

try:
    conn = psycopg2.connect(url)
    cur = conn.cursor()
    
    cur.execute("SELECT id, email, hashed_password FROM users WHERE email = 'testfaculty7@college.edu'")
    row = cur.fetchone()
    if row:
        user_id, email, hpw = row
        print(f"User found: {email}, Hashed PW: {hpw}")
        
        passwords_to_test = [
            "faculty123", "password", "password123", "testfaculty7", 
            "welcome123", "admin123", "123456", "test1234", "svcet@123",
            "college123", "faculty", "test", "Password123", "Password@123", "12345678"
        ]
        
        matched = False
        for pw in passwords_to_test:
            if verify_password(pw, hpw):
                print(f"MATCH FOUND! Password for {email} is: '{pw}'")
                matched = True
                break
        if not matched:
            print(f"None of the common passwords matched for {email}.")
    else:
        print("User testfaculty7@college.edu not found.")
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
