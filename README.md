# 🎓 Campus Connect ERP

> A full-featured **Education Resource Planning (ERP)** system built for colleges and universities. Campus Connect provides role-based portals for Admins, HODs, Faculty, Students, and Higher Authorities — covering everything from LMS course management and attendance to leave workflows, discipline tracking, and real-time analytics.

---

## 📋 Table of Contents

- [Tech Stack](#tech-stack)
- [Project Architecture](#project-architecture)
- [Portal Overview](#portal-overview)
- [Key Features by Portal](#key-features-by-portal)
- [API Reference](#api-reference)
- [Developer Setup](#developer-setup)
- [Default Login Credentials](#default-login-credentials)
- [Deployment](#deployment)
- [Development Phases](#development-phases)

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | React 19, Vite 8, TailwindCSS v4 |
| **UI Components** | MUI (Material UI v9), Lucide React Icons |
| **Charts & Analytics** | Recharts |
| **Drag & Drop** | @hello-pangea/dnd |
| **PDF Export** | jsPDF, jsPDF-AutoTable |
| **Excel Export** | xlsx |
| **HTTP Client** | Axios |
| **Routing** | React Router DOM v7 |
| **Backend** | FastAPI (Python 3.11+) |
| **ORM** | SQLAlchemy 2.x |
| **Database** | PostgreSQL 14+ |
| **Auth** | JWT (python-jose + passlib/bcrypt) |
| **Report Gen** | ReportLab (PDF), openpyxl (Excel) |
| **Migrations** | Alembic |
| **Deployment (Backend)** | Railway (via nixpacks.toml / Procfile) |
| **Deployment (Frontend)** | Vercel (via vercel.json) |

---

## 🏗 Project Architecture

```
Campus-Connect/
├── backend/                        # FastAPI Python backend
│   ├── app/
│   │   ├── api/                    # Route handlers (23 modules)
│   │   │   ├── auth.py             # JWT login/logout/token refresh
│   │   │   ├── admin.py            # Admin CRUD operations
│   │   │   ├── faculty.py          # Faculty portal APIs (largest module)
│   │   │   ├── hod.py              # HOD management APIs
│   │   │   ├── student_portal.py   # Student-facing APIs
│   │   │   ├── dashboard.py        # Cross-role dashboard analytics
│   │   │   ├── leave.py            # Multi-step leave workflow
│   │   │   ├── class_advisor.py    # Class advisor operations
│   │   │   ├── announcements.py    # Announcements system
│   │   │   ├── discipline.py       # Discipline & incident tracking
│   │   │   ├── late.py             # Late-entry tracker
│   │   │   ├── gatepass.py         # Student gate-pass system
│   │   │   ├── faculty_gatepass.py # Faculty gate-pass system
│   │   │   ├── notifications.py    # Notification center
│   │   │   ├── messaging.py        # Internal messaging
│   │   │   ├── retest.py           # Retest marks management
│   │   │   ├── courses.py          # Course catalog
│   │   │   ├── course_plan.py      # Syllabus / course plan
│   │   │   ├── departments.py      # Department management
│   │   │   ├── students.py         # Student management
│   │   │   ├── alumni.py           # Alumni management
│   │   │   └── authorities.py      # Higher authority accounts
│   │   ├── core/
│   │   │   ├── config.py           # App settings (env vars)
│   │   │   ├── database.py         # SQLAlchemy session factory
│   │   │   ├── security.py         # Password hashing, JWT utilities
│   │   │   └── tasks.py            # Background tasks (faculty attendance job)
│   │   ├── models/                 # SQLAlchemy ORM models (19 files)
│   │   ├── schemas/                # Pydantic request/response schemas
│   │   └── middleware/             # Custom FastAPI middleware
│   ├── requirements.txt
│   ├── init_db.py                  # Creates tables + seeds default admin
│   └── .env                        # Local environment variables
│
├── frontend/                       # React + Vite frontend
│   ├── src/
│   │   ├── features/               # Feature-based modules (12 portals)
│   │   │   ├── admin/              # Admin portal (10 pages)
│   │   │   ├── hod/                # HOD portal (22 pages)
│   │   │   ├── faculty/            # Faculty portal (12+ pages)
│   │   │   │   ├── lms/            # LMS course manager (10 components)
│   │   │   │   └── classadvisor/   # Class advisor module
│   │   │   ├── student/            # Student portal (12 pages)
│   │   │   ├── authority/          # Higher authority portal
│   │   │   ├── dean/               # Dean portal
│   │   │   ├── auth/               # Login / authentication pages
│   │   │   ├── dashboards/         # Role-based dashboard landing pages
│   │   │   ├── leave/              # Leave management UI
│   │   │   ├── gatepass/           # Gate pass UI
│   │   │   ├── latetracker/        # Late entry tracker UI
│   │   │   └── profile/            # User profile management
│   │   ├── components/             # Shared/reusable components
│   │   ├── context/                # React Context (AuthContext)
│   │   ├── hooks/                  # Custom React hooks
│   │   ├── layouts/                # Dashboard layout + Sidebar
│   │   └── App.jsx                 # Root router with protected routes
│   ├── package.json
│   └── vite.config.js
│
└── README.md
```

---

## 🎭 Portal Overview

Campus Connect has **6 distinct role-based portals**, each with dedicated features and access controls:

| Portal | Role(s) | Purpose |
|---|---|---|
| **Admin** | `admin` | System-wide management: users, departments, courses, bulk imports |
| **HOD** | `hod` | Department head: faculty assignment, timetables, leave approvals |
| **Faculty** | `faculty` | Teaching: LMS, attendance, gradebook, mentorship, leave |
| **Student** | `student` | Learning: courses, assignments, attendance view, leave application |
| **Authority** | `dean`, `principal`, `vice_principal`, `om` | Institution-wide monitoring and analytics |
| **Dean** | `dean` | Specialized dean-level communications and approvals |

---

## 🔑 Key Features by Portal

### 🔵 Admin Portal
- **Dashboard** — Institution-wide stats (students, faculty, departments, courses, HODs, active users)
- **Department Management** — Full CRUD, activate/deactivate departments
- **Faculty Management** — Add, edit, delete, bulk CSV import, activate/deactivate
- **Student Management** — Add, edit, delete, bulk CSV import with register number and section assignment
- **Batch Promotion** — Promote students semester-wise or promote an entire batch with academic year update
- **Course Management** — Create and maintain the central course catalog; HODs can only assign faculty to admin-created courses
- **HOD Management** — Assign/change/remove HOD per department
- **High Authority Management** — Create/manage accounts for Dean, Principal, Vice Principal, OM
- **Announcement Management** — Institution-wide notices targeting any role group
- **Audit Logs** — View, search, and filter all system actions with timestamp, user, role, action, and status
- **Role & Access Management** — Assign, modify, disable roles; reset credentials
- **Discipline Management** — View/edit all discipline and late-entry records; only admin can modify submitted records
- **Holiday Calendar** — Manage the academic holiday schedule
- **Alumni Management** — Track and manage alumni profiles

### 🟢 HOD Portal
- **Dashboard** — Department KPIs: faculty count, student count, active courses, attendance overview, pending requests
- **Faculty Management** — View faculty profiles, workload, and course assignments (cross-department faculty supported)
- **Student Management** — View profiles, attendance, discipline records, and mentor assignments
- **Course Assignment** — Assign any eligible faculty to department courses for specific sections/semesters
- **Mentor Assignment** — Assign/change/remove mentors; track student distribution with Kanban view
- **Class Management** — Create classes, manage sections, and assign Class Advisors
- **Timetable Management** — Drag-and-drop timetable builder with auto faculty linking, conflict detection, and printable view
- **Attendance Monitoring** — Department-wide attendance dashboard, faculty submission status, and shortage alerts
- **Results Monitoring** — Semester and subject-wise pass percentage, top performers, and weak student detection
- **Faculty Leave Approval** — Review, approve, or reject faculty leave requests
- **Faculty Roster** — View comprehensive faculty rosters and workload summaries
- **Late Entry Management** — Record and monitor student late entries across the department
- **Announcements** — Department-scoped announcements to students and faculty
- **Student Leave Approvals** — Process student leave through the multi-step workflow
- **HOD Gate Pass** — Manage faculty gate pass approvals
- **Reports & Analytics** — Faculty workload, attendance shortage, results, and mentor allocation reports

### 🟡 Faculty Portal
- **Dashboard** — Assigned courses, today's schedule, pending evaluations, and at-risk students
- **My Courses** — View all HOD-assigned courses with student rosters and section details
- **LMS Course Manager** — Full learning management per course:
  - **Resources** — Upload/manage PDFs, PPTs, notes, lab manuals, and external links
  - **Assignments** — Create assignments, set due dates and marks, view/grade submissions, publish marks
  - **Announcements** — Post course-specific notices (quizzes, deadline changes, lab updates)
  - **Syllabus Tracking** — Unit-wise progress marking; completion visible to HOD and students
  - **Attendance** — Mark and edit session-wise attendance with analytics and low-attendance detection
  - **Attendance History** — View and review historical attendance records
  - **Gradebook** — CIA 1/2, Model Exam, and Retest marks entry with CSV export
  - **Seminars** — Manage course seminars and guest lectures
  - **Timetable View** — Read-only weekly/daily timetable view
- **Class Advisor Module** — (Conditional) View class student list, process leave requests, monitor attendance/results/discipline
- **Mentorship Module** — (Conditional) View mentee profiles, marks, attendance, discipline history; process mentee requests
- **Faculty Leave Management** — Apply for leave, submit duty arrangements, and track HOD approval status
- **Late Entry Notifications** — Record student late entries for own classes
- **Faculty Gate Pass** — Apply for and manage faculty gate passes
- **Substitute Approvals** — Handle substitute class arrangements
- **My Attendance** — View own attendance records
- **Profile** — Personal info, qualifications, experience, publications, and certifications

### 🔴 Student Portal
- **Dashboard** — Current semester info, mentor/class advisor, attendance %, pending assignments, upcoming assessments
- **Courses** — View all enrolled courses; each course is an LMS workspace
- **LMS Viewer** — Per-course access to resources, assignments, announcements, and syllabus (read-only progress)
- **Assignment Submission** — Submit/re-submit assignments; view submission status and graded marks
- **Attendance** — Overall and subject-wise attendance %, session history, and shortage alerts
- **Results / Marks** — CIA, Model Exam, and Retest marks; subject-wise performance trend analysis
- **Leave Management** — Apply for Casual, Medical, On-Duty leave or Permission; track multi-step approval (Class Advisor → Mentor → HOD)
- **Gate Pass** — Request and download e-gate passes
- **Late Entry Notifications** — View own late-entry records
- **Discipline Records** — View-only personal incident and late-entry history with personal analytics
- **Mentorship** — View mentor contact info, meeting history, and academic guidance notes
- **Student Requests & Grievances** — Raise bonafide certificate, recommendation letter, or general complaints
- **Today's Schedule** — View daily class timetable
- **My Class** — View classmates and class details
- **Messaging** — Internal messaging with faculty and mentors

### 🟣 Higher Authority Portal (Dean / Principal / VP / OM)
- **Institution Dashboard** — College-wide metrics: total students, faculty, departments, active courses, attendance overview, and pending requests
- **Academic Performance Analytics** — Department/year/semester/subject pass percentage with trend analysis
- **Attendance Analytics** — College, department, year, and section-wise attendance with low-attendance student lists
- **Faculty Academic Monitoring** — Attendance/marks submission status, workload monitoring, and pending task tracking
- **Course Progress Monitoring** — Syllabus completion tracking by department with delayed course detection
- **Leave & Permission Monitoring** — Institution-wide student and faculty leave/permission status and trend analysis
- **Announcement & Circular Management** — Publish academic circulars, exam notifications, and institution-wide announcements
- **Discipline Management** — View all college-wide late-entry and incident records with analytics dashboards (view + add only; edit/delete restricted to Admin)
- **Reports & Analytics** — Generate and export academic, attendance, faculty, and leave reports (PDF/Excel)

---

## 🌐 API Reference

The backend exposes a RESTful API under the `/api` prefix. Interactive Swagger docs are available at:

```
http://localhost:8000/docs
```

**Available API namespaces:**

| Prefix | Description |
|---|---|
| `/api/auth` | Login, token refresh, password management |
| `/api/admin` | Admin CRUD + alumni management |
| `/api/departments` | Department management |
| `/api/courses` | Course catalog |
| `/api/course-plan` | Syllabus / course plan management |
| `/api/faculty` | Faculty portal endpoints (attendance, LMS, gradebook, etc.) |
| `/api/hod` | HOD portal endpoints |
| `/api/student-portal` | Student portal endpoints |
| `/api/students` | Student admin management |
| `/api/leave` | Multi-step leave workflow |
| `/api/class-advisor` | Class advisor operations |
| `/api/discipline` | Discipline & incident records |
| `/api/late` | Late entry tracker |
| `/api/gatepass` | Student gate pass |
| `/api/faculty-gatepass` | Faculty gate pass |
| `/api/announcements` | Announcements system |
| `/api/notifications` | Notification center |
| `/api/messaging` | Internal messaging |
| `/api/retest` | Retest marks |
| `/api/authorities` | Higher authority accounts |
| `/api/dashboard` | Cross-role dashboard analytics |

---

## 🚀 Developer Setup

### Prerequisites

| Tool | Version |
|---|---|
| **Node.js** | v18.0.0+ (tested with v22.x) |
| **Python** | v3.10+ (tested with v3.11.x) |
| **PostgreSQL** | v14.0+ |

---

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Campus-Connect
```

---

### 2. Backend Setup (FastAPI)

```bash
cd backend

# Create a virtual environment
python -m venv venv

# Activate the virtual environment
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
# source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

#### Configure Environment Variables

Create a `.env` file in the `backend/` folder:

```env
DATABASE_URL=postgresql://<username>:<password>@localhost:5432/campus_connect
SECRET_KEY=your_super_secret_key_here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
FRONTEND_URL=http://localhost:5173
```

#### Initialize the Database

```bash
# Creates all tables and seeds the default admin user
python init_db.py
```

#### Run the Backend Server

```bash
uvicorn app.main:app --reload --port 8000
```

- **API Base URL:** `http://localhost:8000`
- **Swagger UI (Interactive Docs):** `http://localhost:8000/docs`
- **Health Check:** `http://localhost:8000/health`

> **Note for AI Agents:** Always ensure the virtual environment is activated before running any `pip` or `python` commands in the backend directory.

---

### 3. Frontend Setup (React / Vite)

Open a **new terminal** (separate from the backend):

```bash
cd frontend

# Install Node dependencies
npm install

# Start the development server
npm run dev
```

- **Frontend URL:** `http://localhost:5173`

---

### Quick Start (Both Servers)

**Terminal 1 — Backend:**
```powershell
cd backend
venv\Scripts\activate
uvicorn app.main:app --reload --port 8000
```

**Terminal 2 — Frontend:**
```powershell
cd frontend
npm run dev
```

---

## 🔐 Default Login Credentials

| Role | Email | Password |
|:---|:---|:---|
| **Admin** | `admin@svcet.edu` | `admin123` |
| **Student** | *(import via Admin → Students → Bulk Import CSV)* | `Welcome123` |
| **Faculty** | *(import via Admin → Faculty → Bulk Import CSV)* | `Welcome123` |
| **HOD** | *(assign via Admin → HOD Management)* | `Welcome123` |
| **Dean / Principal / VP / OM** | *(create via Admin → High Authority Management)* | `Welcome123` |

> Sample CSV files are included in the project root: `sample_students.csv` and `dummy_faculty.csv`.

---

## 🌍 Deployment

### Backend — Railway

The backend is configured for **Railway** deployment:

- `Procfile` — defines the web process command
- `nixpacks.toml` — Nix build configuration for Railway
- Set all environment variables (matching the `.env` format above) in the Railway dashboard

### Frontend — Vercel

The frontend is configured for **Vercel** deployment:

- `vercel.json` — handles SPA routing (rewrites all paths to `index.html`)
- Set `VITE_API_BASE_URL` in Vercel environment variables, pointing to the deployed Railway backend URL

---

## 🗺 Development Phases

| Phase | Description | Status |
|---|---|---|
| **Phase 1** | Foundation & Base Wiring | ✅ Complete |
| **Phase 2** | Authentication & Role-Based Routing | ✅ Complete |
| **Phase 2.5** | Database Integration & Live Auth | ✅ Complete |
| **Phase 3** | Admin Portal (Core Infrastructure) | ✅ Complete |
| **Phase 4** | HOD Portal (Academic Routing) | ✅ Complete |
| **Phase 5** | Faculty Portal & LMS | 🔄 In Progress |
| **Phase 6** | Student Portal & Leave Workflow | 🔄 In Progress |
| **Phase 7** | Higher Authority Analytics & Reports | 🔄 Planned |

---

## 📁 Additional Documentation

| File | Description |
|---|---|
| `Portal_Features.md` | Comprehensive feature spec for all 6 portals |
| `progress.md` | Development phase checklist and completion status |
| `FACULTY_ROSTER_README.md` | Faculty roster feature documentation |
| `er_diagram.html` | Interactive Entity-Relationship diagram |
| `frontend/PWA_IMPLEMENTATION.md` | PWA setup documentation |

---

*Built for Sri Venkateswara College of Engineering and Technology (SVCET)*
