# Audit Logs Setup Guide for Sathish Branch

## ⚠️ IMPORTANT: This branch contains ONLY the audit logs feature files

The Sathish branch has the audit logs implementation files, but you need to integrate them into your main application. Follow these steps:

## Prerequisites

1. **Working Campus Connect Application** - You need the complete application (main.py, App.jsx, etc.)
2. **PostgreSQL Database** - Running and accessible
3. **Python 3.8+** with dependencies installed
4. **Node.js 18+** for frontend

## Files Included in This Branch

### Backend Files
```
backend/app/api/audit_logs.py           - API endpoints
backend/app/core/postgres_listener.py   - Real-time listener
backend/app/middleware/audit_middleware.py - Request logging
backend/app/models/audit_log.py         - Database model
backend/migrate_audit_logs.py           - Migration script
backend/setup_triggers.py               - Database triggers
```

### Frontend Files
```
frontend/src/features/admin/AuditLogs.jsx - Admin UI
```

## Step-by-Step Integration

### Step 1: Database Setup

Run these commands in the backend folder:

```bash
cd backend
python migrate_audit_logs.py
python setup_triggers.py
```

Expected output:
```
✅ Successfully created 'audit_logs' table
✅ Created index: idx_audit_logs_timestamp
✅ Successfully created notify_audit_log_insert function and trigger
```

### Step 2: Update `backend/app/main.py`

Add these imports at the top:
```python
from app.middleware.audit_middleware import AuditLoggingMiddleware
import asyncio
from app.core.postgres_listener import start_postgres_listener
```

Add middleware (after CORS middleware):
```python
# Add Audit Logging Middleware
app.add_middleware(AuditLoggingMiddleware)
```

Add startup event (before routers):
```python
@app.on_event("startup")
async def startup_event():
    """Start the PostgreSQL LISTEN task for real-time audit log updates"""
    asyncio.create_task(start_postgres_listener())
```

Add router (with other routers):
```python
from app.api import audit_logs
app.include_router(audit_logs.router, prefix="/api/audit-logs", tags=["Audit Logs"])
```

**Complete example:**
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.middleware.audit_middleware import AuditLoggingMiddleware
import asyncio
from app.core.postgres_listener import start_postgres_listener

app = FastAPI(title="Campus Connect ERP API")

# CORS
app.add_middleware(CORSMiddleware, ...)

# Add Audit Middleware
app.add_middleware(AuditLoggingMiddleware)

# Startup
@app.on_event("startup")
async def startup_event():
    asyncio.create_task(start_postgres_listener())

# Routers
from app.api import audit_logs
app.include_router(audit_logs.router, prefix="/api/audit-logs", tags=["Audit Logs"])
# ... other routers
```

### Step 3: Update `backend/app/models/__init__.py`

Add import:
```python
from app.models.audit_log import AuditLog
```

Add to `__all__` list:
```python
__all__ = [
    # ... existing models ...
    "AuditLog",
]
```

### Step 4: Update `frontend/src/App.jsx`

Add import:
```javascript
import { AuditLogs } from './features/admin/AuditLogs';
```

Add route in admin section:
```jsx
<Route path="/admin/audit-logs" element={
  <ProtectedRoute allowedRole="admin">
    <AuditLogs />
  </ProtectedRoute>
} />
```

### Step 5: Update `frontend/src/layouts/DashboardLayout.jsx`

Import Shield icon:
```javascript
import { 
  // ... existing imports ...
  Shield
} from 'lucide-react';
```

Add to admin navigation:
```javascript
admin: [
  // ... existing items ...
  { name: 'Audit Logs', path: '/admin/audit-logs', icon: Shield },
],
```

### Step 6: Install Dependencies

**Backend:**
Check `requirements.txt` includes:
```
asyncpg>=0.29.0
```

If not, add it and run:
```bash
pip install -r requirements.txt
```

**Frontend:**
No new dependencies needed - uses existing libraries.

### Step 7: Start the Application

**Backend:**
```bash
cd backend
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Expected output:
```
Connecting to Postgres for LISTEN/NOTIFY...
Successfully connected and listening to 'audit_logs_channel'
INFO: Application startup complete.
```

**Frontend:**
```bash
cd frontend
npm run dev
```

### Step 8: Test

1. Login as **admin**
2. Navigate to **Audit Logs** in the sidebar
3. You should see:
   - ✅ "Live" indicator (green)
   - ✅ Real-time logs appearing
   - ✅ Filters working

4. Test by:
   - Navigating to different pages
   - Creating/editing records
   - Logs should appear instantly

## Troubleshooting

### Issue: "Cannot import module 'app.main'"
**Solution:** The Sathish branch doesn't have `main.py`. You need to integrate these files into your working application.

### Issue: WebSocket not connecting
**Solution:** 
1. Check PostgreSQL is running: `python setup_triggers.py`
2. Verify startup event is in main.py
3. Check browser console for errors

### Issue: No logs appearing
**Solution:**
1. Verify middleware is registered: Check `app.add_middleware(AuditLoggingMiddleware)`
2. Check table exists: `python migrate_audit_logs.py`
3. Look for errors in terminal

### Issue: "asyncpg not found"
**Solution:**
```bash
pip install asyncpg
```

### Issue: Frontend errors
**Solution:**
1. Check AuditLogs.jsx is in `frontend/src/features/admin/`
2. Verify route is added in App.jsx
3. Check navigation item in DashboardLayout.jsx

## How It Works

### Request Flow:
1. **User action** (any user: student, faculty, admin, etc.)
2. **Middleware captures** request details
3. **Saved to database** with user context
4. **PostgreSQL trigger** fires NOTIFY
5. **Listener receives** notification
6. **WebSocket broadcasts** to all admin dashboards
7. **Admin sees** log instantly

### What Gets Logged:
- ✅ Login/logout actions
- ✅ Create/update/delete operations
- ✅ All API calls
- ✅ User context (who, when, from where)
- ✅ Response times and status codes

### What's NOT Logged (to reduce noise):
- ❌ Health checks
- ❌ API documentation endpoints
- ❌ WebSocket connections
- ❌ Static file requests

## Security Notes

- **Only admin can view logs** - Enforced at API and WebSocket level
- **All users are logged** - Students, faculty, HOD, authorities, admin
- **Sensitive data** - Logs contain IPs, endpoints, user IDs
- **Access control** - WebSocket validates JWT token on connect

## Support

If you're still having issues:

1. Ensure you're on the **Sathish branch**: `git branch`
2. Check all files exist: `git ls-files | grep audit`
3. Verify PostgreSQL is running
4. Check backend terminal for errors
5. Check browser console for WebSocket errors

## Quick Checklist

- [ ] Database migrations run successfully
- [ ] Triggers setup completed
- [ ] `main.py` updated with imports, middleware, startup event, router
- [ ] `models/__init__.py` updated with AuditLog import
- [ ] `App.jsx` updated with route
- [ ] `DashboardLayout.jsx` updated with navigation item
- [ ] Backend server starts without errors
- [ ] Frontend server starts without errors
- [ ] Can login as admin
- [ ] Audit Logs page loads
- [ ] WebSocket shows "Live" status
- [ ] Logs appear when navigating pages

## Need the Complete Application?

The Sathish branch contains ONLY the audit logs feature. If you need the complete working application, you should:

1. **Option A:** Merge from `development` branch
   ```bash
   git checkout Sathish
   git merge development
   ```

2. **Option B:** Work on `development` branch
   ```bash
   git checkout development
   git pull origin development
   ```

The `development` branch has the complete application with audit logs already integrated and working.

---

**Last Updated:** 2026-07-02  
**Branch:** Sathish  
**Status:** Integration Required
