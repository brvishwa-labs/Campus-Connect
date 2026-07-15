# Late Entry Notification Feature - Testing Guide

## 🎯 Quick Test Guide

### Prerequisites
- ✅ Backend server running on port 8000
- ✅ Frontend server running on port 5173
- ✅ Database migration completed
- ✅ User accounts: Student and Faculty (mentor assigned)

---

## 📱 Test Scenarios

### Scenario 1: Student Submits Before 8:45 AM ✅

**Steps:**
1. Login as a student
2. Navigate to: **"Late Entry Notification"** (in sidebar menu)
3. Verify usage counter shows: Used: 0, Remaining: 5
4. Fill the form:
   - Date: Today (auto-filled)
   - Expected Arrival Time: 09:30 AM
   - Reason: "Medical appointment"
5. Click **"Submit Notification"**

**Expected Result:**
- ✅ Success message appears
- ✅ Usage counter updates: Used: 1, Remaining: 4
- ✅ Notification appears in history table
- ✅ Mentor receives announcement

---

### Scenario 2: Student Tries to Submit After 8:45 AM ❌

**Steps:**
1. Wait until after 8:45 AM (or change system time for testing)
2. Login as a student
3. Navigate to: **"Late Entry Notification"**
4. Try to submit a notification for today

**Expected Result:**
- ❌ Error message: "Cannot submit for today after 8:45 AM. College has already started. Please submit before 8:45 AM."
- ✅ Form is NOT submitted
- ✅ Usage counter unchanged

---

### Scenario 3: Student Reaches Monthly Limit 🚫

**Steps:**
1. Submit 5 late entry notifications in the same month
2. Try to submit the 6th notification

**Expected Result:**
- ❌ Error message about monthly limit reached
- ✅ Submit button disabled or error shown
- ✅ Usage counter shows: Used: 5, Remaining: 0

---

### Scenario 4: Mentor Views Notifications 👁️

**Steps:**
1. Login as a **faculty member** (mentor)
2. Navigate to: **"Late Entry Notifications"** (in sidebar menu)
3. Verify dashboard shows:
   - Total count
   - Today's count
   - Pending count

**Expected Result:**
- ✅ Only see notifications from YOUR mentees (not all students)
- ✅ Can filter by All/Today/Pending
- ✅ Can search by name, register number, or reason
- ✅ Mobile and desktop views work properly

---

### Scenario 5: Mentor Marks as Viewed ✓

**Steps:**
1. Login as faculty (mentor)
2. Navigate to: **"Late Entry Notifications"**
3. Find a notification that hasn't been viewed
4. Click **"Mark as Viewed"** button

**Expected Result:**
- ✅ Button changes to "Viewed by Mentor" badge
- ✅ Timestamp recorded in database
- ✅ Student can see "Viewed by Mentor" status
- ✅ Page refreshes with updated status

---

### Scenario 6: Unauthorized Mentor Access ❌

**Steps:**
1. Login as a faculty member
2. Try to mark a notification as viewed for a student who is NOT your mentee

**Expected Result:**
- ❌ Error: "You can only mark notifications for your mentees"
- ✅ 403 Forbidden response
- ✅ No changes made

---

### Scenario 7: Search and Filter 🔍

**Steps:**
1. Login as faculty
2. Navigate to: **"Late Entry Notifications"**
3. Test filters:
   - Click "Today" - should show only today's notifications
   - Click "Pending" - should show unacknowledged notifications
   - Click "All" - should show all notifications
4. Test search:
   - Enter student name
   - Enter register number
   - Enter part of reason

**Expected Result:**
- ✅ Filters work correctly
- ✅ Search filters in real-time
- ✅ Results update immediately
- ✅ Counter reflects filtered count

---

### Scenario 8: Mobile Responsiveness 📱

**Steps:**
1. Open DevTools (F12)
2. Toggle device toolbar (Ctrl+Shift+M)
3. Select mobile device (iPhone/Android)
4. Test both student and faculty views

**Expected Result:**
- ✅ Card-based layout on mobile
- ✅ Touch-friendly buttons
- ✅ Readable text sizes
- ✅ Proper spacing and padding
- ✅ No horizontal scrolling
- ✅ Bottom navigation visible

---

### Scenario 9: History Table Display 📊

**Steps:**
1. Login as student
2. Navigate to: **"Late Entry Notification"**
3. Scroll down to history table
4. Submit multiple notifications over time

**Expected Result:**
- ✅ All submissions listed in reverse chronological order
- ✅ Shows: Date, Time, Reason, Submitted On
- ✅ Security acknowledgment status visible
- ✅ Mentor viewed status visible
- ✅ Mobile card view / Desktop table view

---

## 🔍 Backend API Testing

### Using Browser DevTools (F12 → Network Tab)

#### Test 1: Get Usage
```
Request:
GET http://localhost:8000/api/late/notifications/usage
Headers: Authorization: Bearer {token}

Expected Response (200):
{
  "used": 2,
  "remaining": 3,
  "limit": 5,
  "month": "2026-07"
}
```

#### Test 2: Submit Notification
```
Request:
POST http://localhost:8000/api/late/notifications
Headers: Authorization: Bearer {token}
Body: {
  "date": "2026-07-02",
  "expected_arrival_time": "09:30:00",
  "reason": "Medical appointment"
}

Expected Response (200):
{notification object with all fields}
```

#### Test 3: Submit After 8:45 AM
```
Request:
POST http://localhost:8000/api/late/notifications
(Same as above, but after 8:45 AM)

Expected Response (400):
{
  "detail": "Cannot submit late entry notification after 8:45 AM for today..."
}
```

#### Test 4: Mark as Viewed (Faculty)
```
Request:
PATCH http://localhost:8000/api/late/notifications/{id}/mark-viewed
Headers: Authorization: Bearer {faculty_token}

Expected Response (200):
{notification object with viewed_by_mentor: true}
```

---

## ✅ Verification Checklist

### Student Portal:
- [ ] Can access Late Entry Notification page
- [ ] Usage counter displays correctly
- [ ] Can submit notification before 8:45 AM
- [ ] Cannot submit after 8:45 AM (error shown)
- [ ] Monthly limit enforced (max 5)
- [ ] History table shows all submissions
- [ ] Security acknowledgment status visible
- [ ] Mentor viewed status visible
- [ ] Mobile responsive design works
- [ ] Form validation works
- [ ] Success/error messages display properly

### Faculty Portal:
- [ ] Can access Late Entry Notifications page
- [ ] Dashboard stats display correctly
- [ ] Only see assigned mentees' notifications
- [ ] Filter buttons work (All/Today/Pending)
- [ ] Search functionality works
- [ ] Can mark notification as viewed
- [ ] Cannot mark other mentors' students
- [ ] Status indicators display correctly
- [ ] Mobile card view works
- [ ] Desktop table view works
- [ ] Loading states display properly

### Backend API:
- [ ] GET /api/late/notifications/usage returns correct data
- [ ] POST /api/late/notifications creates notification
- [ ] 8:45 AM validation blocks late submissions
- [ ] Monthly limit validation works
- [ ] GET /api/late/notifications filters by mentor
- [ ] PATCH /api/late/notifications/{id}/mark-viewed works
- [ ] Authorization checks prevent unauthorized access
- [ ] Mentor announcement created on submission
- [ ] Database columns exist and store data correctly
- [ ] Timestamps recorded properly

### Database:
- [ ] late_entry_notifications table exists
- [ ] viewed_by_mentor column exists (default: false)
- [ ] viewed_at column exists (nullable timestamp)
- [ ] All foreign keys working
- [ ] Data persists correctly
- [ ] Monthly counting logic accurate

---

## 🐛 Common Issues & Solutions

### Issue 1: "Please login again" error
**Solution:** Check localStorage for "token" key (not "access_token")

### Issue 2: Faculty sees all students' notifications
**Solution:** Verify mentor_id is properly set in database

### Issue 3: Usage counter shows 0/0
**Solution:** Check student is logged in and API returns correct data

### Issue 4: 8:45 AM validation not working
**Solution:** Check server time and timezone settings

### Issue 5: "Mark as Viewed" button not showing
**Solution:** Verify user role is "faculty" and viewed_by_mentor is false

### Issue 6: Mobile view broken
**Solution:** Check responsive classes (md: breakpoints)

---

## 🔧 Debug Commands

### Check Backend Logs:
```powershell
# View backend process output
# Terminal ID: 4
```

### Check Frontend Logs:
```powershell
# View frontend process output
# Terminal ID: 6
```

### Check Database:
```sql
-- View all notifications
SELECT * FROM late_entry_notifications ORDER BY created_at DESC;

-- Check if columns exist
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'late_entry_notifications';

-- Count monthly usage for a student
SELECT COUNT(*) 
FROM late_entry_notifications 
WHERE student_id = 779 
AND DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE);
```

---

## 📈 Performance Considerations

- Notifications are limited to 100 per query
- Search is client-side filtered (consider server-side for large datasets)
- Real-time updates require page refresh
- Mobile view optimized for touch interactions

---

## 🎉 Success Criteria

All features working when:
1. ✅ Students can submit before 8:45 AM
2. ✅ Students blocked after 8:45 AM
3. ✅ Monthly limit (5) enforced
4. ✅ Mentors see only their mentees
5. ✅ Mentors can mark as viewed
6. ✅ History displays correctly
7. ✅ Mobile responsive on all screens
8. ✅ Announcements sent to mentor
9. ✅ Security can acknowledge arrivals
10. ✅ All error messages clear and helpful

---

**Last Updated:** July 2, 2026
**Tested By:** Development Team
**Status:** Ready for Production Testing ✅
