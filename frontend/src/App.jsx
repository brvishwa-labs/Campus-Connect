import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import DashboardLayout from './layouts/DashboardLayout';
import Login from './features/auth/Login';
import { 
  AdminDashboard, 
  HodDashboard, 
  FacultyDashboard, 
  StudentDashboard, 
  AuthorityDashboard 
} from './features/dashboards/Dashboards';
import { Departments } from './features/admin/Departments';
import { Faculty } from './features/admin/Faculty';
import { Students } from './features/admin/Students';
import { Authorities } from './features/admin/Authorities';

// A simple protective wrapper that forces login and checks roles
const ProtectedRoute = ({ children, allowedRole }) => {
  const { user } = useAuth();
  
  if (!user) {
    return <Navigate to="/login" replace />;
  }
  
  if (allowedRole && user.role !== allowedRole) {
    // Redirect to their actual role's dashboard if they try to access another
    return <Navigate to={`/${user.role}`} replace />;
  }
  
  return children;
};

// Root redirector based on user state
const RootRedirect = () => {
  const { user } = useAuth();
  return user ? <Navigate to={`/${user.role}`} replace /> : <Navigate to="/login" replace />;
};

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<RootRedirect />} />
      <Route path="/login" element={<Login />} />
      
      <Route element={<DashboardLayout />}>
        {/* Admin Routes */}
        <Route path="/admin" element={
          <ProtectedRoute allowedRole="admin">
            <AdminDashboard />
          </ProtectedRoute>
        } />
        <Route path="/admin/departments" element={
          <ProtectedRoute allowedRole="admin">
            <Departments />
          </ProtectedRoute>
        } />
        <Route path="/admin/faculty" element={
          <ProtectedRoute allowedRole="admin">
            <Faculty />
          </ProtectedRoute>
        } />
        <Route path="/admin/students" element={
          <ProtectedRoute allowedRole="admin">
            <Students />
          </ProtectedRoute>
        } />
        <Route path="/admin/authorities" element={
          <ProtectedRoute allowedRole="admin">
            <Authorities />
          </ProtectedRoute>
        } />
        
        {/* HOD Routes */}
        <Route path="/hod" element={
          <ProtectedRoute allowedRole="hod">
            <HodDashboard />
          </ProtectedRoute>
        } />
        
        {/* Faculty Routes */}
        <Route path="/faculty" element={
          <ProtectedRoute allowedRole="faculty">
            <FacultyDashboard />
          </ProtectedRoute>
        } />
        
        {/* Student Routes */}
        <Route path="/student" element={
          <ProtectedRoute allowedRole="student">
            <StudentDashboard />
          </ProtectedRoute>
        } />
        
        {/* Authority Routes */}
        <Route path="/authority" element={
          <ProtectedRoute allowedRole="authority">
            <AuthorityDashboard />
          </ProtectedRoute>
        } />
        
        {/* Catch-all for sub-routes during Phase 2 (shows empty page) */}
        <Route path="/:role/*" element={
          <ProtectedRoute>
            <div className="p-8 text-center text-gray-500">
              <h2 className="text-2xl font-bold">Coming Soon</h2>
              <p>This module will be built in the upcoming phases.</p>
            </div>
          </ProtectedRoute>
        } />
      </Route>
    </Routes>
  );
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <AppRoutes />
      </BrowserRouter>
    </AuthProvider>
  );
}
