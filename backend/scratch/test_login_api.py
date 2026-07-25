import urllib.request
import urllib.parse
import json

url = "http://localhost:8000/api/auth/login"
data = urllib.parse.urlencode({
    'username': 'admin@svcet.edu',
    'password': 'admin123'
}).encode('utf-8')

req = urllib.request.Request(
    url, 
    data=data, 
    headers={'Content-Type': 'application/x-www-form-urlencoded'}
)

print("Attempting to login at:", url)
try:
    with urllib.request.urlopen(req) as response:
        res_data = response.read().decode('utf-8')
        json_res = json.loads(res_data)
        print("SUCCESS! Response:")
        print(json.dumps(json_res, indent=2))
except Exception as e:
    print("FAILED to login:", e)
    if hasattr(e, 'read'):
        print("Error response:", e.read().decode('utf-8'))
