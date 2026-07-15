# Faculty Leave Request - User Guide

## 🎯 Quick Start

### For Requesting Faculty

#### Before You Start
- ✅ Check your leave balance
- ✅ Identify faculty who can substitute for your classes
- ✅ Inform potential substitutes before submitting request
- ✅ Have all class details ready (subject, section, period)

#### Submitting a Request

**Step 1: Fill Basic Details**
1. Navigate to Faculty → Leave Requests
2. Click "New Request"
3. Select leave type
4. Choose dates
5. Enter reason

**Step 2: Assign Substitutes** ⚠️ REQUIRED
1. For each class, click "+ Add Row"
2. Select substitute faculty from dropdown
3. Enter subject code (e.g., CS-401)
4. Enter class/section (e.g., B.Tech 4A)
5. Enter period (e.g., II or 10:30)
6. At least 1 arrangement required

**Step 3: Submit**
- Click "Submit Request"
- Your request status will be `AWAITING SUBSTITUTES`
- **You cannot edit after any substitute accepts**

#### Tracking Your Request

**Status Meanings:**

| Status | What it Means | What Happens Next |
|--------|---------------|-------------------|
| 🟡 **AWAITING SUBSTITUTES** | Waiting for all substitutes to accept | Monitor which substitutes have responded |
| 🟡 **PENDING HOD** | All substitutes accepted, with HOD | HOD will review and approve/reject |
| 🟡 **PENDING DEAN** | HOD approved, with Dean | Dean will review |
| 🟡 **PENDING PRINCIPAL** | Dean approved, with Principal | Final approval stage |
| 🟢 **APPROVED** | Request approved | Leave balance deducted |
| 🔴 **REJECTED** | Request rejected | Check rejection reason |

**Actions You Can Take:**

| Action | When Available | Notes |
|--------|----------------|-------|
| ✏️ **Modify** | Only in `AWAITING SUBSTITUTES` | Before any substitute accepts |
| ❌ **Withdraw** | Only in `AWAITING SUBSTITUTES` | Before any substitute accepts |
| 👁️ **View Details** | Anytime | See status and progress |

---

### For Substitute Faculty

#### When You Receive a Request

**You'll see:**
- Requesting faculty name
- Leave dates and duration
- Subject and class you need to cover
- Period/time slot

**Your Options:**

1. **✅ Accept**
   - Commits you to covering the class
   - Request proceeds if all substitutes accept
   - You'll see "ACCEPTED" badge

2. **❌ Decline**
   - Rejects the entire leave request immediately
   - Requesting faculty must find alternative
   - Use if you have conflicts or cannot cover

**Important:**
- ⚠️ **Think carefully before declining** - it rejects the entire request
- 💬 Consider discussing with requesting faculty first
- ⏰ Respond promptly to avoid delays
- 🔒 Decision is final once submitted

#### How to Respond

1. Navigate to Faculty → Leave Requests → "Substitute Approvals"
2. Review each request and arrangement
3. Click **Accept** or **Decline** for each arrangement
4. Confirmation message will show the impact

**Messages You'll See:**

| Message | Meaning |
|---------|---------|
| "Status updated. Waiting for other substitute approvals" | Others still need to respond |
| "All substitutes have accepted. Forwarded to HOD" | Request proceeding to authorities |
| "Arrangement rejected. Leave request has been rejected" | Your decline rejected the request |

---

### For HOD/Dean/Principal

#### What You'll See

**Only requests with confirmed substitute coverage reach you:**
- All substitute faculty have already accepted
- Class coverage is guaranteed
- You can focus on approving the leave itself

#### Your Review Process

1. Check leave type and duration
2. Verify reason is appropriate
3. Review leave balance impact
4. Approve or reject with reason

**Decision Impact:**
- ✅ **Approve**: Moves to next authority (or final approval)
- ❌ **Reject**: Request rejected, faculty notified

---

## 📋 Common Scenarios

### Scenario 1: All Substitutes Accept (Happy Path)

```
You submit with 2 substitutes
    ↓
Dr. Smith accepts (1/2) → Still waiting
    ↓
Dr. Johnson accepts (2/2) → All accepted!
    ↓
Request forwarded to HOD
    ↓
HOD approves → Forwarded to Dean
    ↓
Dean approves → Forwarded to Principal
    ↓
Principal approves → APPROVED ✅
```

### Scenario 2: One Substitute Declines

```
You submit with 2 substitutes
    ↓
Dr. Smith accepts (1/2)
    ↓
Dr. Johnson declines → Request REJECTED ❌
    ↓
You receive notification
    ↓
Find alternative and submit new request
```

### Scenario 3: Need to Make Changes

```
You submit request → Status: AWAITING SUBSTITUTES
    ↓
Realize you made an error
    ↓
Click "Modify" → Make changes → Save
    ↓
Substitutes get updated request
```

---

## ⚠️ Important Rules

### The All-or-Nothing Rule
- **ALL** substitutes must accept for request to proceed
- If **ANY** substitute rejects → entire request rejected
- No partial approvals

### The Lock Rule
- Can only edit/withdraw in `AWAITING SUBSTITUTES` status
- Once substitutes start accepting → locked 🔒
- Cannot undo after first acceptance

### The Mandatory Arrangement Rule
- Must assign at least 1 substitute
- Cannot submit without arrangements
- Ensures class coverage

---

## 💡 Best Practices

### For Requesting Faculty

**Before Submitting:**
1. ✅ Contact potential substitutes first
2. ✅ Ensure they're available for those periods
3. ✅ Get verbal agreement before assigning
4. ✅ Double-check all details

**After Submitting:**
1. 👀 Monitor substitute responses
2. 💬 Follow up with pending substitutes
3. 📅 Plan ahead for rejected requests
4. 🔄 Be prepared with backup substitutes

**Tips:**
- Submit at least 3-5 days in advance
- Avoid last-minute requests
- Choose substitutes teaching similar subjects
- Keep substitute list handy

### For Substitute Faculty

**When Reviewing:**
1. ✅ Check your schedule for conflicts
2. ✅ Verify you're qualified for the subject
3. ✅ Consider workload impact
4. ✅ Discuss concerns with requesting faculty

**Tips:**
- Respond within 24 hours
- Decline early if you can't cover
- Accept if you've already agreed verbally
- Keep requesting faculty informed

---

## 🆘 Troubleshooting

### "Cannot submit without arrangements"
**Problem:** No substitute arrangements provided  
**Solution:** Add at least one substitute arrangement before submitting

### "Cannot modify request after substitute approval"
**Problem:** Trying to edit after substitutes accepted  
**Solution:** Request is locked. Contact HOD if urgent changes needed

### "This arrangement has already been processed"
**Problem:** Trying to accept/reject twice  
**Solution:** You've already responded. Check current status

### Request shows REJECTED
**Problem:** One substitute declined  
**Solution:** Contact them to understand why. Submit new request with different substitute

---

## 📊 Status Tracking Guide

### Understanding Your Request Status

**Visual Indicators:**

```
🟡 Yellow = Pending/Waiting
🟢 Green = Approved/Accepted
🔴 Red = Rejected/Declined
🔒 Lock = Cannot edit
⚠️ Warning = Action needed
```

**Tracking Progress:**

1. **My Requests Page**
   - See all your requests
   - Filter by status
   - Quick status badges

2. **Request Details Page**
   - Timeline showing progress
   - Individual arrangement status
   - Edit/withdraw buttons (if available)

3. **Substitute Approvals Page**
   - Requests where you're assigned as substitute
   - Accept/decline buttons
   - Impact of your decision

---

## 🎓 Example Walkthrough

### Complete Request Example

**Faculty:** Dr. Alice (Computer Science)  
**Leave Type:** Casual Leave  
**Dates:** Dec 15-16, 2024 (2 days)  
**Reason:** Personal work

**Classes to Cover:**

| Day | Period | Subject | Class | Substitute |
|-----|--------|---------|-------|------------|
| Dec 15 | II | CS-401 | 4A | Dr. Bob |
| Dec 16 | III | CS-402 | 4B | Dr. Carol |

**Submission Process:**

1. **Day 1 (Dec 10):** Dr. Alice submits request
   - Status: `AWAITING SUBSTITUTES`
   - Dr. Bob receives notification
   - Dr. Carol receives notification

2. **Day 1 (Afternoon):** Dr. Bob accepts
   - Status: Still `AWAITING SUBSTITUTES`
   - Waiting for Dr. Carol

3. **Day 2 (Dec 11):** Dr. Carol accepts
   - Status: `PENDING HOD`
   - HOD receives notification
   - Dr. Alice receives "All accepted" notification

4. **Day 2 (Afternoon):** HOD approves
   - Status: `PENDING DEAN`

5. **Day 3 (Dec 12):** Dean approves
   - Status: `PENDING PRINCIPAL`

6. **Day 3 (Afternoon):** Principal approves
   - Status: `APPROVED` ✅
   - Leave balance deducted
   - All parties notified

---

## 📞 Need Help?

**Contact:**
- HOD Office: For policy questions
- IT Support: For technical issues
- Faculty Affairs: For leave balance queries

**Resources:**
- Leave Policy Document
- Academic Calendar
- Faculty Handbook

---

## ✨ Remember

> **The substitute approval system ensures that:**
> - Classes are never left unattended
> - Coverage is confirmed before approval
> - All parties are informed and agree
> - Quality of education is maintained

**Plan ahead, communicate clearly, and respond promptly for smooth processing!**
