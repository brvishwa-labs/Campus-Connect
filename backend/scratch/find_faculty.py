import psycopg2

url = "postgresql://postgres:admin@localhost:5432/campus_connect"

try:
    conn = psycopg2.connect(url)
    cur = conn.cursor()
    
    cur.execute("SELECT id, email, role, is_active, hashed_password FROM users WHERE email LIKE '%testfaculty%' OR email LIKE '%faculty%'")
    users = cur.fetchall()
    print(f"Found {len(users)} faculty matching users in campus_connect DB:")
    for u in users:
        print(f"ID: {u[0]}, Email: {u[1]}, Role: {u[2]}, Active: {u[3]}")
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
