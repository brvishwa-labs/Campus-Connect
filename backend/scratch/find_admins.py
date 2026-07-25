import psycopg2

url = "postgresql://postgres:admin@localhost:5432/campus_connect"

try:
    conn = psycopg2.connect(url)
    cur = conn.cursor()
    
    cur.execute("SELECT id, email, role, is_active FROM users WHERE email LIKE '%admin%'")
    users = cur.fetchall()
    print("Users with 'admin' in email:")
    for u in users:
        print(f"ID: {u[0]}, Email: {u[1]}, Role: {u[2]}, Active: {u[3]}")
        
    cur.execute("SELECT DISTINCT role FROM users")
    roles = cur.fetchall()
    print("\nDistinct roles in users table:")
    for r in roles:
        print(r[0])
        
    cur.close()
    conn.close()
except Exception as e:
    print("Error:", e)
