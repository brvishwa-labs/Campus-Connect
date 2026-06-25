# Campus Connect ERP — Project Status & Roadmap

> [!NOTE]
> As requested, the database configuration has been reverted to **PostgreSQL**. You will need to ensure PostgreSQL is installed and running on your machine with a database named `campus_connect` before spinning up the backend server.

## ✅ What is Done

### Backend (FastAPI + PostgreSQL)
- **Database Architecture**: Set up SQLAlchemy ORM with async PostgreSQL support (`asyncpg`).
- **Data Models (7 total)**: `User`, `Department`, `Faculty`, `Student`, `Course`, `Announcement`, `AuditLog`.
- **Authentication**: JWT-based auth (access & refresh tokens), bcrypt password hashing, and role-based access control (RBAC).
- **Admin APIs**: Built out CRUD endpoints for 12 Admin portal modules (Dashboard, Departments, Faculty, Students, Courses, Announcements, HODs, Roles, etc.).
- **Configuration**: Reverted `.env` back to `postgresql+asyncpg://postgres:postgres@localhost:5432/campus_connect`.

### Frontend (React + Vite + Tailwind v4)
- **Design System**: Implemented the premium "Academix" style reference with a clean light theme, custom colors, glassmorphism cards, and colored tags.
- **API Integration**: Axios interceptors for automatic token injection and refresh logic.
- **Core Navigation**: Sidebar layout with role-based links and active-state styling.
- **Completed Pages**:
  - **Login Page**: Working JWT integration (currently with mock fallback).
  - **Dashboard**: Advanced UI with statistics, charts, and activity feeds.
  - **Announcements**: Dynamic grid layout with colored category tagging.
  - **Department Management**: Complete with a reusable `DataTable` (search, pagination) and a reusable `Modal` form to add new departments.

---

## 🚀 What Should Be Done Next

### 1. Database Initialization (Action Required)
> [!IMPORTANT]
> Since we've switched back to PostgreSQL, you need to:
> 1. Ensure PostgreSQL is installed.
> 2. Create a database: `CREATE DATABASE campus_connect;`
> 3. Run the backend seed script to populate the admin user:
>    ```bash
>    cd backend
>    pip install -r requirements.txt
>    python seed.py
>    ```

### 2. Frontend — Complete Remaining Admin Modules
We will use our new reusable `DataTable` and `Modal` components to build out the remaining pages replacing the "Coming Soon" placeholders:
- **Faculty Management**: Table view, "Add Faculty" modal, assigning faculty to departments.
- **Student Management**: Table view, batch filtering by year/semester.
- **Course Management**: Table view of courses and credits.
- **HOD & High Authorities Management**: Role assignment interface.

### 3. Frontend — Integrate Live Data
- Once the PostgreSQL database is populated via the backend, we will remove the `catch(err)` mock fallbacks from the React components (`Departments.jsx`, `Dashboard.jsx`, etc.) so the frontend exclusively streams real data from the database.

### 4. Phase 2 Features (Future)
- **Faculty Portal**: Attendance tracking, grade entry, assignment uploads.
- **Student Portal**: Viewing grades, downloading resources, tracking attendance.
