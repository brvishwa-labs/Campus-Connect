import { Routes, Route, Navigate } from 'react-router-dom';
import { ProtectedRoute } from './components/ui/ProtectedRoute';
import DashboardLayout from './layouts/DashboardLayout';

// Pages
import Login from './pages/auth/Login';
import Dashboard from './pages/admin/Dashboard';
import Announcements from './pages/admin/Announcements';

import Departments from './pages/admin/Departments';

// Placeholders for other pages for Phase 1 routing structure
const Placeholder = ({ title }) => (
  <div className="p-8 glass-card rounded-2xl h-96 flex items-center justify-center">
    <h1 className="text-2xl font-bold text-slate-400">{title} Module Coming Soon</h1>
  </div>
);

function App() {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="/login" element={<Login />} />
      
      {/* Admin Routes */}
      <Route element={<ProtectedRoute allowedRoles={['admin']} />}>
        <Route path="/admin" element={<DashboardLayout />}>
          <Route index element={<Navigate to="dashboard" replace />} />
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="announcements" element={<Announcements />} />
          <Route path="departments" element={<Departments />} />
          <Route path="faculty" element={<Placeholder title="Faculty" />} />
          <Route path="students" element={<Placeholder title="Students" />} />
          <Route path="courses" element={<Placeholder title="Courses" />} />
          <Route path="hods" element={<Placeholder title="HOD Management" />} />
          <Route path="authorities" element={<Placeholder title="High Authorities" />} />
          <Route path="roles" element={<Placeholder title="Role Management" />} />
          <Route path="discipline" element={<Placeholder title="Discipline Management" />} />
          <Route path="audit" element={<Placeholder title="Audit Logs" />} />
        </Route>
      </Route>

      {/* Unauthorized / 404 */}
      <Route path="/unauthorized" element={<div className="p-10 text-center">Unauthorized Access</div>} />
      <Route path="*" element={<div className="p-10 text-center">404 Not Found</div>} />
    </Routes>
  );
}

export default App;
