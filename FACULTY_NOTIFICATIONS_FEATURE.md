# Faculty Dashboard - Mentor Notification Feature

## ✅ Feature Implemented

Added real-time notification cards on the Faculty Dashboard specifically for **MENTORS** to display pending requests from their **MENTEES** with visual badge counters.

## 🎯 What Was Added

### 1. Mentor Notification Cards with Badge Counters
Three notification cards showing mentor-specific requests:
- **Student Leave Requests** (Blue) - Shows mentee leave requests pending mentor approval
- **Gate Pass Requests** (Green) - Shows mentee gate pass requests pending mentor approval  
- **Late Entry Notifications** (Amber) - Shows unacknowledged late entries from mentees

### 2. Visual Features
- **Red Badge Counter**: Shows number of unseen/pending requests from mentees
- **Animated Ping Effect**: Red badge has a pulsing animation to draw attention
- **Hover Effects**: Cards lift and show chevron on hover
- **Click Navigation**: Clicking any card navigates to the respective page
- **Clear Labeling**: Section titled "Mentee Requests (Requires Your Approval)"

### 3. Real-Time Updates
- Counts refresh every 30 seconds automatically
- Fresh data on page load
- Independent of course filter selection
- Error handling: Shows 0 if API fails

## 📁 Files Modified

### Frontend
**File**: `frontend/src/features/dashboards/FacultyDashboardNew.jsx`

**Changes**:
1. Updated notification fetching logic to specifically filter for mentor requests:
   - Leave requests: `status === 'pending_mentor'`
   - Gate pass requests: `status === 'pending_mentor'`
   - Late entries: `mentor_acknowledged === false`

2. Updated UI labels:
   - Section header: "Mentee Requests (Requires Your Approval)"
   - Card title: "Student Leave Requests" (clarifies these are from students)

3. Updated navigation:
   - Leave requests → `/faculty/mentorship` (mentor dashboard)
   - Gate pass requests → `/faculty/gatepass`
   - Late entries → `/faculty/late-entry`

4. Added error handling to set counts to 0 on API failure

## 🔄 How It Works

### Student Leave Requests (Mentor Approval)
- **Endpoint**: `/api/leave/requests`
- **Filter**: `status === 'pending_mentor'`
- **Navigates to**: `/faculty/mentorship`
- **Shows**: Only leave requests from mentees awaiting mentor approval

### Gate Pass Requests (Mentor Approval)
- **Endpoint**: `/api/gatepass/mentor`
- **Filter**: `status === 'pending_mentor'`
- **Navigates to**: `/faculty/gatepass`
- **Shows**: Only gate pass requests from mentees awaiting mentor approval

### Late Entry Notifications (Mentor Acknowledgment)
- **Endpoint**: `/api/late-entry/my-mentees`
- **Filter**: `mentor_acknowledged === false`
- **Navigates to**: `/faculty/late-entry`
- **Shows**: Only late entries from mentees that mentor hasn't acknowledged

## 🎨 UI/UX Features

### Section Header
```
🔔 Mentee Requests (Requires Your Approval)
```
- Clear indication these are mentor-specific notifications
- Emphasizes action required from mentor

### Badge Display
- Shows count only when > 0
- Red background with white text (#EF4444)
- Pulsing animation with `animate-ping`
- Size: 24px circle with centered number
- Hidden when count = 0

### Card Design
- White background with subtle shadow
- Colored icon circle (48px)
- Title and "Click to view" subtitle
- Right-pointing chevron that slides right on hover
- Card lifts 2px on hover with increased shadow
- Smooth transitions (300ms)

### Responsive Design
- **Mobile**: 1 column layout
- **Tablet/Desktop** (md+): 3 column layout
- Proper spacing: 16px gap on desktop, 12px on mobile
- Touch-friendly click targets

## 🚀 Benefits for Mentors

1. **Immediate Visibility**: Mentors see all pending mentee requests at a glance
2. **Priority Awareness**: Red badge count shows exactly how many items need attention
3. **One-Click Access**: Direct navigation to the specific approval page
4. **Real-Time Updates**: Auto-refresh every 30 seconds ensures current information
5. **No Manual Checking**: No need to navigate to each section to check for requests
6. **Clear Responsibility**: "Requires Your Approval" label makes role clear

## 📊 Display Logic

### Badge Shows When:
- **Leave Requests**: 1+ mentee leave requests with status `pending_mentor`
- **Gate Pass**: 1+ mentee gate pass requests with status `pending_mentor`
- **Late Entries**: 1+ mentee late entries where `mentor_acknowledged = false`

### Badge Hidden When:
- Count = 0 (no pending items from mentees)
- API error (defaults to 0)

## 🔔 Example Scenarios

**Scenario 1**: Mentor logs in, sees:
- Student Leave Requests: **2** (red badge) - 2 mentees requested leave
- Gate Pass Requests: **1** (red badge) - 1 mentee needs gate pass
- Late Entry: **0** (no badge) - No late entries to acknowledge

**Action**: Mentor clicks "Student Leave Requests" → Navigates to mentorship page to approve/reject

**Scenario 2**: After approving all requests:
- All badges disappear (counts = 0)
- Clean dashboard indicates no pending mentor actions

**Scenario 3**: New late entry arrives while mentor is logged in:
- After 30 seconds (auto-refresh), Late Entry badge shows **1**
- Mentor notices pulsing red badge
- Clicks to acknowledge late entry

## 🔄 Request Workflow

### Student Leave Request Flow:
1. Student submits leave request
2. Status = `pending_mentor`
3. **Mentor sees notification badge**
4. Mentor clicks → Reviews → Approves/Rejects
5. If approved → Status changes to `pending_hod`
6. Badge count decreases by 1

### Gate Pass Request Flow:
1. Student requests gate pass
2. Status = `pending_mentor`
3. **Mentor sees notification badge**
4. Mentor clicks → Reviews → Approves/Rejects  
5. If approved → Status changes (next approval level)
6. Badge count decreases by 1

### Late Entry Flow:
1. Student marked late by security
2. `mentor_acknowledged = false`
3. **Mentor sees notification badge**
4. Mentor clicks → Views → Acknowledges
5. `mentor_acknowledged = true`
6. Badge count decreases by 1

## ✨ Technical Details

### API Endpoints Used
```javascript
// Leave requests (mentees only)
GET /api/leave/requests
Filter: status === 'pending_mentor'

// Gate pass requests (mentees only)
GET /api/gatepass/mentor
Filter: status === 'pending_mentor'

// Late entries (mentees only)
GET /api/late-entry/my-mentees
Filter: mentor_acknowledged === false
```

### State Management
```javascript
const [pendingLeaveRequests, setPendingLeaveRequests] = useState(0);
const [pendingGatePassRequests, setPendingGatePassRequests] = useState(0);
const [pendingLateEntries, setPendingLateEntries] = useState(0);
```

### Auto-Refresh
```javascript
useEffect(() => {
  fetchNotificationCounts();
  const interval = setInterval(fetchNotificationCounts, 30000);
  return () => clearInterval(interval);
}, []);
```

## 🧪 Testing Checklist

- [x] Cards display correctly for mentors
- [x] Badge shows correct count of mentee requests
- [x] Badge hidden when count = 0
- [x] Clicking card navigates to correct page
- [x] Section header shows "Mentee Requests"
- [x] Only mentee requests counted (not all faculty requests)
- [x] Hover effects work properly
- [x] Auto-refresh works (30s interval)
- [x] Error handling sets counts to 0
- [x] Responsive on mobile and desktop
- [x] No console errors
- [x] Pulsing animation works

## 🎓 User Roles

### Who Sees These Notifications?
- **Faculty members who are assigned as mentors**
- Shows requests ONLY from their assigned mentees
- Does not show requests from other students

### Who Doesn't See These?
- Faculty without mentor assignments (will see 0 counts)
- HOD (has separate dashboard)
- Students
- Admin

## 📝 Important Notes

- **Mentor-Specific**: Only shows requests from assigned mentees
- **First Approval Level**: Mentor approval is the first step in workflow
- **No Backend Changes**: Uses existing API endpoints
- **Performance**: Optimized with 30s refresh interval (not polling every second)
- **Error Handling**: Gracefully handles API failures by showing 0
- **Accessibility**: Proper color contrast and click targets
- **Mobile-Friendly**: Responsive design works on all devices

## 🔮 Future Enhancements (Optional)

1. **Sound Notification**: Play sound when new request arrives
2. **Browser Push**: Browser notifications even when tab is inactive
3. **Email Alerts**: Send email for urgent requests
4. **Request Preview**: Hover tooltip showing request details
5. **Bulk Actions**: Approve/reject multiple requests at once
6. **Priority Badges**: Different colors for urgent vs normal
7. **History**: Show recently resolved requests
8. **Analytics**: Track average response time

## 📸 Visual Reference

```
┌───────────────────────────────────────────────────────┐
│  🔔 Mentee Requests (Requires Your Approval)         │
├───────────────────────────────────────────────────────┤
│                                                       │
│  ┌─────────────────────────────────────┐            │
│  │  📅  Student Leave Requests   🔴 2  │  →         │
│  │      Click to view                   │            │
│  └─────────────────────────────────────┘            │
│                                                       │
│  ┌─────────────────────────────────────┐            │
│  │  📍  Gate Pass Requests       🔴 1  │  →         │
│  │      Click to view                   │            │
│  └─────────────────────────────────────┘            │
│                                                       │
│  ┌─────────────────────────────────────┐            │
│  │  ⏰  Late Entry Notifications        │  →         │
│  │      Click to view                   │            │
│  └─────────────────────────────────────┘            │
│                                                       │
└───────────────────────────────────────────────────────┘
```

Red badges (🔴) pulse with animation when count > 0!


## 🎯 What Was Added

### 1. Notification Cards with Badge Counters
Three notification cards showing:
- **Leave Requests** (Blue) - Shows pending leave requests
- **Gate Pass Requests** (Green) - Shows pending gate pass requests  
- **Late Entry Notifications** (Amber) - Shows unacknowledged late entries

### 2. Visual Features
- **Red Badge Counter**: Shows number of unseen/pending requests
- **Animated Ping Effect**: Red badge has a pulsing animation to draw attention
- **Hover Effects**: Cards lift and show chevron on hover
- **Click Navigation**: Clicking any card navigates to the respective page

### 3. Real-Time Updates
- Counts refresh every 30 seconds automatically
- Fresh data on page load
- Independent of course filter selection

## 📁 Files Modified

### Frontend
**File**: `frontend/src/features/dashboards/FacultyDashboardNew.jsx`

**Changes**:
1. Added `MapPin` icon import for Gate Pass
2. Added `useNavigate` hook from react-router-dom
3. Created new `NotificationCard` component with:
   - Badge counter display
   - Animated ping effect
   - Click navigation
   - Hover animations

4. Added state variables:
   ```javascript
   const [pendingLeaveRequests, setPendingLeaveRequests] = useState(0);
   const [pendingGatePassRequests, setPendingGatePassRequests] = useState(0);
   const [pendingLateEntries, setPendingLateEntries] = useState(0);
   ```

5. Added `useEffect` hook to fetch notification counts:
   - Fetches leave requests with status `pending_faculty` or `pending_mentor`
   - Fetches gate pass requests with status `pending_mentor`
   - Fetches late entries where `mentor_acknowledged = false`
   - Auto-refreshes every 30 seconds

6. Added notification cards section in UI after Quick Stats

## 🔄 How It Works

### Leave Requests
- Endpoint: `/api/leave/requests`
- Filters: `status === 'pending_faculty' || status === 'pending_mentor'`
- Navigates to: `/faculty/leave`

### Gate Pass Requests
- Endpoint: `/api/gatepass/mentor`
- Filters: `status === 'pending_mentor'`
- Navigates to: `/faculty/gatepass`

### Late Entry Notifications
- Endpoint: `/api/late-entry/my-mentees`
- Filters: `mentor_acknowledged === false`
- Navigates to: `/faculty/late-entry`

## 🎨 UI/UX Features

### Badge Display
- Shows count only when > 0
- Red background with white text
- Pulsing animation to draw attention
- Size: 24px circle with centered number

### Card Design
- White background with shadow
- Icon in colored circle (12x12)
- Title and subtitle text
- Right-pointing chevron that slides on hover
- Card lifts 2px on hover

### Responsive
- 1 column on mobile
- 3 columns on desktop (md breakpoint)
- Proper spacing and padding

## 🚀 Benefits for Faculty

1. **No Manual Navigation**: Faculty can see all pending requests at a glance
2. **Visual Indicators**: Red badge makes urgent items obvious
3. **Quick Access**: One click to navigate to the specific request page
4. **Real-Time**: Auto-refresh ensures counts are always current
5. **Priority Awareness**: Faculty immediately know what needs attention

## 📊 Display Logic

### Badge Shows Number When:
- Leave Requests: 1+ pending requests = Shows count
- Gate Pass: 1+ pending requests = Shows count
- Late Entries: 1+ unacknowledged entries = Shows count

### Badge Hidden When:
- Count = 0 (no pending items)

## 🔔 Example Scenarios

**Scenario 1**: Faculty logs in, sees:
- Leave Requests: **3** (red badge)
- Gate Pass: **0** (no badge)
- Late Entry: **5** (red badge)

Result: Faculty knows to check leave requests and late entries first

**Scenario 2**: After reviewing requests:
- All badges disappear as items are processed
- Faculty sees clean dashboard = no pending actions

## ✨ Future Enhancements (Optional)

1. Add sound notification when new request arrives
2. Browser push notifications
3. Email alerts for high-priority requests
4. Breakdown by student/section in tooltip
5. Mark as seen/unseen functionality
6. Priority sorting (urgent vs normal)

## 🧪 Testing Checklist

- [x] Cards display correctly on dashboard
- [x] Badge shows correct count
- [x] Badge hidden when count = 0
- [x] Clicking card navigates to correct page
- [x] Hover effects work properly
- [x] Auto-refresh works (30s interval)
- [x] Responsive on mobile and desktop
- [x] No console errors
- [x] Pulsing animation works

## 📝 Notes

- Feature uses existing API endpoints
- No backend changes required
- Works with current authentication
- Compatible with class advisor role
- Performance optimized with 30s refresh interval
