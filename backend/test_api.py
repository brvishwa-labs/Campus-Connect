import requests

BASE = "http://localhost:8000"

# Step 1: Login
print("=== STEP 1: Login ===")
login_resp = requests.post(f"{BASE}/api/auth/login", data={"username": "admin@svcet.edu", "password": "admin123"})
print(f"Login status: {login_resp.status_code}")
print(f"Login body: {login_resp.json()}")

token = login_resp.json()["access_token"]
headers = {"Authorization": f"Bearer {token}"}

# Step 2: Test /api/auth/me
print("\n=== STEP 2: GET /api/auth/me ===")
me_resp = requests.get(f"{BASE}/api/auth/me", headers=headers)
print(f"Status: {me_resp.status_code}")
print(f"Body: {me_resp.json()}")

# Step 3: Test GET /api/departments
print("\n=== STEP 3: GET /api/departments ===")
dept_resp = requests.get(f"{BASE}/api/departments", headers=headers)
print(f"Status: {dept_resp.status_code}")
print(f"Body: {dept_resp.json()}")

# Step 4: Test POST /api/departments
print("\n=== STEP 4: POST /api/departments ===")
dept_data = {"name": "Mechanical Engineering", "code": "ME", "description": "Department of Mechanical Engineering"}
post_resp = requests.post(f"{BASE}/api/departments", json=dept_data, headers=headers)
print(f"Status: {post_resp.status_code}")
print(f"Body: {post_resp.json()}")
