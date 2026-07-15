# Faculty Leave Request - Improvements V2

## ✅ Changes Implemented

### 1. **Real Timetable Integration**
- Faculty's actual timetable is fetched for the selected leave dates
- Shows all classes they're scheduled to teach during leave period
- Automatically creates arrangement rows for each class
- Displays day, time, subject, and class/section

### 2. **Accurate Faculty List**
- Shows all other active faculty members (excludes requesting faculty)
- Displays faculty name, designation, and department
- No more dummy data like "Dr. Alan Turing"

### 3. **Class Advisor Responsibilities**
- Detects if faculty is a class advisor for any section
- Automatically adds class advisor duty to arrangements
- Requires assigning another faculty for class advisor role

### 4. **Auto-Population of Arrangements**
When faculty selects leave dates:
- System fetches their timetable for those specific days
- Creates one arrangement row per class period
- Pre-fills subject code, class/section, and period time
- Faculty only needs to select substitute faculty member

### 5. **Withdraw Feature Restored**
- Can now withdraw requests at any pending stage:
  - PENDING_SUBSTITUTE
  - PENDING_HOD
  - PENDING_DEAN
  - PENDING_OM
- Cannot withdraw approved/rejected requests
- Edit feature still limited to PENDING_SUBSTITUTE only

## 🔧 Technical Implementation

### Backend Endpoint
**New:** `GET /api/leave/leave-preparation-data`

**Parameters:**
- `from_date`: Start date of leave (YYYY-MM-DD)
- `to_date`: End date of leave (YYYY-MM-DD)

**Returns:**
```json
{
  "my_schedule": [
    {
      "slot_id": 1,
      "day": "mon",
      "start_time": "09:00",
      "end_time": "10:00",
      "room": "R101",
      "course_code": "CS401",
      "course_name": "Data Structures",
      "class_section": "CSE Year-4 A",
      "period_display": "09:00 - 10:00"
    }
  ],
  "available_faculty": [
    {
      "id": 2,
      "name": "Dr. John Smith",
      "designation": "Associate Professor",
      "department": "Computer Science"
    }
  ],
  "class_advisor_duties": [
    {
      "section_id": 5,
      "class_display": "CSE Year-4 A",
      "duty_type": "Class Advisor",
      "year": 4,
      "batch": "2021-2025"
    }
  ],
  "total_periods_to_cover": 8,
  "requires_class_advisor_substitute": true
}
```

### Database Tables Used
1. **timetable_slots** - Faculty's teaching schedule
2. **course_assignments** - Faculty-Course-Section mapping
3. **courses** - Course details
4. **sections** - Class sections
5. **faculty** - Faculty profiles

### Frontend Flow
1. User selects leave dates (from_date, to_date)
2. `useEffect` triggers on date change
3. Calls `/api/leave/leave-preparation-data` with dates
4. Receives schedule and faculty list
5. Auto-creates arrangement rows:
   - One row per timetable slot
   - One row per class advisor duty
6. Pre-fills subject, class, period
7. Faculty selects substitutes from dropdown
8. Submits request

## 📊 Example Scenario

**Faculty:** Dr. Alice (CSE Department)

**Leave Dates:** December 15-16, 2024 (Monday-Tuesday)

**Monday Schedule:**
- Period 1 (09:00-10:00): CS401 - Data Structures, CSE Year-4 A
- Period 3 (11:00-12:00): CS402 - Algorithms, CSE Year-4 B

**Tuesday Schedule:**
- Period 2 (10:00-11:00): CS401 - Data Structures, CSE Year-4 A

**Class Advisor:** CSE Year-4 A

**Auto-Generated Arrangements:**
1. MON • CS401 • CSE Year-4 A • 09:00-10:00 → [Select Substitute]
2. MON • CS402 • CSE Year-4 B • 11:00-12:00 → [Select Substitute]
3. TUE • CS401 • CSE Year-4 A • 10:00-11:00 → [Select Substitute]
4. ALL • Class Advisor • CSE Year-4 A • All Periods → [Select Substitute]

**Total: 4 arrangements required**

## 🎨 UI Improvements

### Before Date Selection
- Empty duty arrangement section
- Generic message: "Add arrangement rows"

### After Date Selection
- Blue info box showing schedule:
  ```
  📚 Your Classes During Leave Period (3 periods)
  MON - CS401 (Data Structures) • CSE Year-4 A • 09:00-10:00
  MON - CS402 (Algorithms) • CSE Year-4 B • 11:00-12:00
  TUE - CS401 (Data Structures) • CSE Year-4 A • 10:00-11:00
  Class Advisor - CSE Year-4 A • 2021-2025
  
  💡 Assign substitutes below - one row per class/duty
  ```

- Auto-populated arrangement rows
- Subject, class, period pre-filled
- Faculty dropdown shows real faculty with designations
- Day indicator on mobile view

### If No Classes Scheduled
- Green success box:
  ```
  ✓ No classes scheduled during this period
  You may still need to assign substitutes for administrative duties if required
  ```

## 🔐 Business Logic

### Substitute Selection Rules
1. Cannot select self as substitute (excluded from dropdown)
2. Must select substitute for EVERY period
3. Must select substitute for class advisor duty (if applicable)
4. All substitutes must accept before HOD review

### Edit/Withdraw Rules
- **Edit:** Only in PENDING_SUBSTITUTE status
- **Withdraw:** Any pending status (PENDING_SUBSTITUTE, PENDING_HOD, PENDING_DEAN, PENDING_OM)
- **No Edit/Withdraw:** APPROVED or REJECTED status

### Validation
- At least one arrangement required
- All arrangements must have substitute faculty selected
- Date range must be valid (to_date >= from_date)

## 📝 Files Modified

### Backend
- `backend/app/api/leave.py`
  - Added `/leave-preparation-data` endpoint
  - Updated `/requests/{id}/withdraw` to allow all pending statuses
  - Added imports for timetable models

### Frontend
- `frontend/src/features/faculty/LeaveApply.jsx`
  - Added `leaveData` state
  - Added `fetchLeaveData()` function
  - Added useEffect for date changes
  - Updated duty arrangement display
  - Enhanced faculty dropdown
  - Auto-population of arrangements

- `frontend/src/features/faculty/LeaveDetails.jsx`
  - Restored withdraw button for all pending statuses
  - Updated conditional display logic

## 🚀 Benefits

### For Faculty
✅ No manual entry of class details
✅ Accurate list of substitutes
✅ Can't forget to assign someone for a period
✅ Can withdraw at any pending stage
✅ Clear visibility of all responsibilities

### For System
✅ Data comes from actual timetable
✅ Ensures all periods are covered
✅ Tracks class advisor responsibilities
✅ Prevents invalid assignments

### For Substitutes
✅ See exact periods they need to cover
✅ Real class and subject information
✅ Clear time slots

## 🧪 Testing Checklist

- [ ] Select leave dates → Schedule appears
- [ ] All timetable periods shown correctly
- [ ] Class advisor duty added (if applicable)
- [ ] Faculty dropdown shows other faculty only
- [ ] Subject, class, period pre-filled
- [ ] Can select different substitutes
- [ ] Can add/remove arrangement rows manually
- [ ] Withdraw works for PENDING_HOD status
- [ ] Withdraw works for PENDING_DEAN status
- [ ] Withdraw works for PENDING_OM status
- [ ] Cannot withdraw APPROVED requests
- [ ] Edit only works for PENDING_SUBSTITUTE

## 🎯 Next Steps (Optional)

1. **Smart Substitute Suggestions**
   - Suggest faculty who teach same subject
   - Check substitute's availability from their timetable
   - Highlight potential conflicts

2. **Conflict Detection**
   - Warn if substitute already has class at that time
   - Show substitute's existing schedule

3. **Bulk Assignment**
   - Assign same substitute to all periods
   - Quick-fill for common scenarios

4. **Historical Data**
   - Show who substituted last time
   - "Use previous substitutes" button
