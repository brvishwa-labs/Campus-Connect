# Faculty Leave Request - Substitute Approval Workflow

## Overview
This document describes the implementation of the two-step faculty leave submission process where substitute faculty must approve duty arrangements before the leave request is forwarded to authorities.

## Workflow Changes

### Previous Flow
1. Faculty submits leave request with arrangements
2. Request goes directly to HOD for approval
3. Substitute faculty have no formal approval step

### New Flow
1. Faculty submits leave request with **mandatory** substitute arrangements
2. Request status: `PENDING_SUBSTITUTE`
3. Each substitute faculty must **accept or reject** their assignment
4. **Only when ALL substitutes accept**, request moves to `PENDING_HOD`
5. If ANY substitute rejects, the entire request is rejected
6. After substitute approvals complete, normal approval chain continues (HOD → Dean → Principal)

## Backend Changes

### 1. Leave Request Creation (`POST /api/leave/request`)
**File:** `backend/app/api/leave.py`

**Changes:**
- Now **requires** at least one substitute arrangement
- Always creates request with `PENDING_SUBSTITUTE` status
- All arrangements start with `PENDING` status

```python
# Validation added
if not request.arrangements or len(request.arrangements) == 0:
    raise HTTPException(status_code=400, detail="At least one substitute arrangement must be provided")

# Always PENDING_SUBSTITUTE initially
status=LeaveStatus.PENDING_SUBSTITUTE
```

### 2. Leave Request Update (`PUT /api/leave/requests/{request_id}`)
**File:** `backend/app/api/leave.py`

**Changes:**
- Can only edit requests in `PENDING_SUBSTITUTE` status
- After substitutes start accepting, request becomes locked
- Requires at least one substitute arrangement

```python
# Only allow edits if still in PENDING_SUBSTITUTE state
if leave_req.status != LeaveStatus.PENDING_SUBSTITUTE:
    raise HTTPException(status_code=400, detail="Cannot modify request after substitute approval has started")
```

### 3. Substitute Approval (`PUT /api/leave/substitute-requests/{arr_id}`)
**File:** `backend/app/api/leave.py`

**Changes:**
- Enhanced validation to prevent double-processing
- Clear status messages for different scenarios
- Automatic rejection if any substitute declines
- Automatic forwarding to HOD only when ALL accept

```python
# If any arrangement is rejected, reject the entire leave request
any_rejected = any(a.status == ArrangementStatus.REJECTED for a in req.arrangements)

if any_rejected:
    req.status = LeaveStatus.REJECTED
    req.rejection_reason = "One or more substitute faculty rejected the duty arrangement."
    return {"message": "Arrangement rejected. Leave request has been rejected."}

# Only move to PENDING_HOD if ALL arrangements are accepted
all_accepted = all(a.status == ArrangementStatus.ACCEPTED for a in req.arrangements)

if all_accepted and req.status == LeaveStatus.PENDING_SUBSTITUTE:
    req.status = LeaveStatus.PENDING_HOD
    return {"message": "All substitutes have accepted. Leave request forwarded to HOD for approval."}
```

### 4. Withdraw Request (`PUT /api/leave/requests/{request_id}/withdraw`)
**File:** `backend/app/api/leave.py`

**Changes:**
- Can only withdraw if in `PENDING_SUBSTITUTE` status
- Cannot withdraw after substitutes approve

```python
if req.status != LeaveStatus.PENDING_SUBSTITUTE:
    raise HTTPException(status_code=400, detail="Cannot withdraw request after substitute approvals are complete")
```

## Frontend Changes

### 1. Leave Application Form (`LeaveApply.jsx`)
**File:** `frontend/src/features/faculty/LeaveApply.jsx`

**Changes:**
- Added validation requiring at least one substitute
- Added warning banner about substitute approval requirement
- Enhanced submission tips with critical notice
- Better error messaging

**Key Additions:**
```jsx
// Validation in handleSubmit
const validArrangements = arrangements.filter(a => a.substitute_faculty_id !== '');
if (validArrangements.length === 0) {
  setError('At least one substitute faculty arrangement is required. Your leave request will only be forwarded to HOD after all substitutes accept.');
  return;
}

// Warning banner in duty arrangement section
<div className="bg-amber-50 border border-amber-200 rounded-lg p-3">
  <p className="font-bold">Required: Substitute Faculty Approval</p>
  <p>Your leave request will remain pending until ALL substitute faculty accept...</p>
</div>
```

### 2. Leave Request List (`LeaveRequests.jsx`)
**File:** `frontend/src/features/faculty/LeaveRequests.jsx`

**Changes:**
- Enhanced status badges to show different pending states
- Added specific badge for `AWAITING SUBSTITUTES`

```jsx
case 'pending_substitute':
  return <span className="bg-amber-100 text-amber-700">AWAITING SUBSTITUTES</span>;
case 'pending_hod':
  return <span className="bg-yellow-100 text-yellow-700">PENDING HOD</span>;
```

### 3. Leave Request Details (`LeaveDetails.jsx`)
**File:** `frontend/src/features/faculty/LeaveDetails.jsx`

**Changes:**
- Only show edit/withdraw buttons when in `PENDING_SUBSTITUTE` status
- Added alert banner showing substitute approval status
- Show lock icon when request is no longer editable
- Enhanced arrangement cards with better status display

**Key Additions:**
```jsx
// Alert for pending substitutes
{request.status === 'pending_substitute' && (
  <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
    <p>Your leave request will be forwarded to HOD only after ALL substitute faculty accept...</p>
    <p>{pendingCount} substitute(s) still need to respond.</p>
  </div>
)}

// Edit restriction notice
{['pending_hod', 'pending_dean', 'pending_om'].includes(request.status) && (
  <div className="text-xs text-gray-500 italic">
    <Lock className="w-3.5 h-3.5 inline" />
    Request locked for editing after substitute approvals
  </div>
)}
```

### 4. Substitute Approvals (`SubstituteApprovals.jsx`)
**File:** `frontend/src/features/faculty/SubstituteApprovals.jsx`

**Changes:**
- Added informational banner explaining importance of approval
- Enhanced feedback with server response messages
- Better success/error handling

**Key Additions:**
```jsx
// Info banner
<div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
  <p className="font-bold">Your Approval is Required</p>
  <p>Faculty leave requests will only be forwarded to HOD after all substitutes accept...</p>
</div>

// Enhanced action handler
const message = res.data?.message || 'Status updated successfully';
alert(message);
```

## Status Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ Faculty Creates Leave Request with Substitute Arrangements │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │ PENDING_SUBSTITUTE   │◄──── Request Created
              └──────────┬───────────┘
                         │
         ┌───────────────┴────────────────┐
         │                                │
         ▼                                ▼
  ┌─────────────┐                ┌──────────────┐
  │ Substitute  │                │  Substitute  │
  │ ACCEPTS     │                │  REJECTS     │
  └──────┬──────┘                └──────┬───────┘
         │                              │
         │  All                         │
         │  Accept?                     │
         ▼                              ▼
    ┌─────────┐                  ┌──────────┐
    │   YES   │                  │ REJECTED │
    └────┬────┘                  └──────────┘
         │
         ▼
  ┌──────────────┐
  │ PENDING_HOD  │◄──── Forwarded to Authorities
  └──────┬───────┘
         │
         ▼
  ┌───────────────┐
  │ PENDING_DEAN  │
  └──────┬────────┘
         │
         ▼
  ┌──────────────┐
  │ PENDING_OM   │
  └──────┬───────┘
         │
         ▼
    ┌──────────┐
    │ APPROVED │
    └──────────┘
```

## Key Business Rules

1. **Mandatory Arrangements**: Faculty cannot submit a leave request without at least one substitute arrangement
2. **All Must Accept**: ALL substitute faculty must accept for the request to proceed
3. **Any Rejection = Total Rejection**: If even one substitute rejects, the entire leave request is rejected
4. **Locked After Approval**: Once substitutes start accepting, the request cannot be edited or withdrawn
5. **Only Editable When Pending**: Faculty can only modify/withdraw while in `PENDING_SUBSTITUTE` status

## User Experience Improvements

1. **Clear Expectations**: Faculty are informed upfront that substitute approval is required
2. **Transparent Status**: Status badges clearly show where request is in the approval chain
3. **Actionable Feedback**: Substitutes receive clear information about their role and impact
4. **Progress Visibility**: Faculty can see which substitutes have responded and which are pending
5. **Locked State Clarity**: Clear messaging when request is no longer editable

## Testing Scenarios

### Happy Path
1. Faculty creates leave with 2 substitute arrangements
2. First substitute accepts → Request stays in PENDING_SUBSTITUTE
3. Second substitute accepts → Request moves to PENDING_HOD
4. HOD approves → Request moves to PENDING_DEAN
5. Dean approves → Request moves to PENDING_OM
6. Principal approves → Request becomes APPROVED

### Rejection Path
1. Faculty creates leave with 2 substitute arrangements
2. First substitute accepts → Request stays in PENDING_SUBSTITUTE
3. Second substitute rejects → Request immediately becomes REJECTED
4. Faculty receives notification that arrangement was rejected

### Edit Restriction
1. Faculty creates leave with 1 substitute arrangement
2. Faculty tries to edit while in PENDING_SUBSTITUTE → Allowed
3. Substitute accepts → Request moves to PENDING_HOD
4. Faculty tries to edit → Blocked with error message

## Database Schema (No Changes Required)

The existing schema already supports this workflow:

```sql
-- FacultyLeaveRequest has status field
status ENUM('pending_substitute', 'pending_hod', 'pending_dean', 'pending_om', 'approved', 'rejected')

-- FacultyDutyArrangement has status field
status ENUM('pending', 'accepted', 'rejected')
```

## API Endpoints Summary

| Endpoint | Method | Changes |
|----------|--------|---------|
| `/api/leave/request` | POST | Now requires arrangements, always creates PENDING_SUBSTITUTE |
| `/api/leave/requests/{id}` | PUT | Only allows edit if PENDING_SUBSTITUTE |
| `/api/leave/requests/{id}/withdraw` | PUT | Only allows withdraw if PENDING_SUBSTITUTE |
| `/api/leave/substitute-requests/{arr_id}` | PUT | Enhanced logic for all-accept/any-reject |
| `/api/leave/substitute-requests` | GET | No changes |
| `/api/leave/my-requests` | GET | No changes |

## Migration Notes

- **No database migration required** - existing schema supports this workflow
- **No data migration required** - existing requests can continue with current status
- **Backward compatible** - old requests without substitute approval remain valid

## Future Enhancements

1. **Email Notifications**: Send emails to substitute faculty when assigned
2. **Reminder System**: Remind pending substitutes after 24 hours
3. **Bulk Approval**: Allow substitutes to accept multiple arrangements at once
4. **Alternative Suggestions**: Let substitutes suggest alternative faculty
5. **Auto-Assignment**: Suggest compatible substitute faculty based on timetable
