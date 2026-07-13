import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { 
  Users, UserCheck, Building2, BookOpen,
  TrendingUp, TrendingDown, AlertCircle, Clock,
  FileText, ShieldAlert, RefreshCw, ChevronRight,
  BarChart3, PieChart, Activity, Sun, Sunrise, Moon, Bell,
  Megaphone, Zap, Calendar, UserX, MessageSquare
} from 'lucide-react';
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer,
  BarChart as RechartsBarChart, Bar, Legend
} from 'recharts';
import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const getGreeting = () => {
  const h = new Date().getHours();
  if (h < 12) return { text: 'Good Morning', Icon: Sunrise, color: 'text-amber-300' };
  if (h < 17) return { text: 'Good Afternoon', Icon: Sun, color: 'text-amber-200' };
  return { text: 'Good Evening', Icon: Moon, color: 'text-indigo-200' };
};

const getAcademicYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1;
  if (month >= 6) {
    return `${year}–${String(year + 1).slice(2)}`;
  }
  return `${year - 1}–${String(year).slice(2)}`;
};

const formatFullDate = () =>
  new Date().toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });

// Stat Card Component
const StatCard = ({ title, value, icon: Icon, colorClass, bgColorClass, subtitle }) => (
  <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 transition-all hover:shadow-lg">
    <div className="flex items-center gap-4">
      <div className={`w-14 h-14 rounded-[16px] ${bgColorClass} flex items-center justify-center flex-shrink-0`}>
        <Icon className={`w-7 h-7 ${colorClass}`} strokeWidth={1.5} />
      </div>
      <div className="flex-1">
        <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mb-1">{title}</p>
        <p className="text-[28px] font-extrabold text-gray-900 leading-none">{value}</p>
        {subtitle && (
          <p className="text-[10px] text-gray-500 mt-1">{subtitle}</p>
        )}
      </div>
    </div>
  </div>
);

// Department Performance Card
const DepartmentCard = ({ name, code, value, type = "attendance", rank }) => {
  const isGood = value >= 75;
  const isAverage = value >= 60 && value < 75;
  
  return (
    <div className={`p-4 rounded-xl border-2 transition-all ${
      isGood ? 'bg-emerald-50 border-emerald-200' : 
      isAverage ? 'bg-amber-50 border-amber-200' : 
      'bg-red-50 border-red-200'
    }`}>
      <div className="flex items-center justify-between mb-2">
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold text-gray-400">#{rank}</span>
          <h4 className="font-bold text-sm text-gray-900">{code}</h4>
        </div>
        <div className={`flex items-center gap-1 ${
          isGood ? 'text-emerald-600' : 
          isAverage ? 'text-amber-600' : 
          'text-red-600'
        }`}>
          {isGood ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
          <span className="text-lg font-extrabold">{value}%</span>
        </div>
      </div>
      <p className="text-xs text-gray-600 truncate">{name}</p>
      <div className="mt-2 bg-gray-200 rounded-full h-1.5 overflow-hidden">
        <div 
          className={`h-full transition-all ${
            isGood ? 'bg-emerald-500' : 
            isAverage ? 'bg-amber-500' : 
            'bg-red-500'
          }`}
          style={{ width: `${value}%` }}
        />
      </div>
    </div>
  );
};

// Detailed Attendance Card
const DetailedAttendanceCard = ({ name, code, percent, sp, sa, fp, fa, rank }) => {
  return (
    <div className="p-4 rounded-xl border-2 bg-white border-gray-100 shadow-sm hover:shadow-md transition-all hover:border-blue-200">
      <div className="flex items-center justify-between mb-3 border-b border-gray-100 pb-2">
        <div className="flex items-center gap-2">
          <span className="w-5 h-5 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center text-[10px] font-bold">#{rank}</span>
          <h4 className="font-bold text-sm text-gray-900">{code}</h4>
        </div>
        <div className="text-blue-600 font-extrabold text-sm bg-blue-50 px-2 py-0.5 rounded-md">{percent}%</div>
      </div>
      
      <div className="grid grid-cols-2 gap-4">
        <div>
          <p className="text-[10px] font-bold text-gray-400 uppercase mb-1.5">Students</p>
          <div className="flex flex-col gap-1 text-xs font-semibold">
            <span className="text-emerald-600 flex items-center gap-1"><UserCheck className="w-3.5 h-3.5"/> {sp} Present</span>
            <span className="text-rose-600 flex items-center gap-1"><UserX className="w-3.5 h-3.5"/> {sa} Absent</span>
          </div>
        </div>
        <div>
          <p className="text-[10px] font-bold text-gray-400 uppercase mb-1.5">Faculty</p>
          <div className="flex flex-col gap-1 text-xs font-semibold">
            <span className="text-emerald-600 flex items-center gap-1"><UserCheck className="w-3.5 h-3.5"/> {fp} Present</span>
            <span className="text-rose-600 flex items-center gap-1"><UserX className="w-3.5 h-3.5"/> {fa} Absent</span>
          </div>
        </div>
      </div>
      <p className="text-[10px] text-gray-400 mt-3 truncate">{name}</p>
    </div>
  );
};

// Alert Item Component
const AlertItem = ({ alert }) => {
  const getIcon = () => {
    switch(alert.type) {
      case 'discipline': return <ShieldAlert className="w-4 h-4" />;
      case 'gatepass': return <FileText className="w-4 h-4" />;
      case 'leave': return <FileText className="w-4 h-4" />;
      default: return <AlertCircle className="w-4 h-4" />;
    }
  };
  
  const getColor = () => {
    switch(alert.severity) {
      case 'high': return 'text-red-600 bg-red-50 border-red-200';
      case 'medium': return 'text-amber-600 bg-amber-50 border-amber-200';
      default: return 'text-blue-600 bg-blue-50 border-blue-200';
    }
  };
  
  const formatTime = (timestamp) => {
    const date = new Date(timestamp);
    const now = new Date();
    const diff = Math.floor((now - date) / 1000); // seconds
    
    if (diff < 60) return 'Just now';
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
    return `${Math.floor(diff / 86400)}d ago`;
  };
  
  return (
    <div className={`flex items-start gap-3 p-3 rounded-xl border ${getColor()}`}>
      <div className="mt-0.5">{getIcon()}</div>
      <div className="flex-1 min-w-0">
        <p className="text-xs font-semibold text-gray-900">{alert.message}</p>
        <p className="text-xs text-gray-600 mt-0.5">
          {alert.student_name || alert.faculty_name}
        </p>
      </div>
      <span className="text-[10px] text-gray-500 whitespace-nowrap">
        {formatTime(alert.timestamp)}
      </span>
    </div>
  );
};

const DeanDashboard = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [lastUpdated, setLastUpdated] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState(null);

  const greeting = React.useMemo(() => getGreeting(), []);

  const fetchDashboardStats = async (showRefreshing = false) => {
    if (showRefreshing) setRefreshing(true);
    setError(null);
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get(`${API_BASE_URL}/api/dashboard/dean/stats`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      setStats(response.data);
      setLastUpdated(new Date());
    } catch (error) {
      console.error('Error fetching dashboard stats:', error);
      setError(error.response?.data?.detail || error.message || 'Failed to load dashboard data');
    } finally {
      setLoading(false);
      if (showRefreshing) setRefreshing(false);
    }
  };

  useEffect(() => {
    fetchDashboardStats();
    
    // Auto-refresh every 30 seconds for live updates
    const interval = setInterval(() => {
      fetchDashboardStats();
    }, 30000);

    return () => clearInterval(interval);
  }, []);

  const handleRefresh = () => {
    fetchDashboardStats(true);
  };

  const formatTime = (date) => {
    if (!date) return '';
    return date.toLocaleTimeString('en-US', { 
      hour: '2-digit', 
      minute: '2-digit',
      second: '2-digit'
    });
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <RefreshCw className="w-8 h-8 text-primary-500 animate-spin mx-auto mb-3" />
          <p className="text-gray-500">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Error Banner */}
      {error && (
        <div className="bg-red-50 border border-red-200 rounded-xl p-4 flex items-start gap-3">
          <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
          <div>
            <h4 className="font-semibold text-red-900 text-sm">Unable to load dashboard data</h4>
            <p className="text-xs text-red-700 mt-1">{error}</p>
          </div>
        </div>
      )}

      {/* ═══════════════════════════════════════════════════════════
          WELCOME HEADER (Enhanced Executive Theme)
      ═══════════════════════════════════════════════════════════ */}
      <div className="relative bg-gradient-to-br from-indigo-950 via-slate-900 to-violet-900 rounded-[2rem] p-6 sm:p-8 md:p-10 overflow-hidden shadow-2xl shadow-indigo-900/20 hover:shadow-indigo-900/30 transition-all duration-500 mb-6">
        
        {/* Subtle background decoration (5-8% opacity) */}
        <div className="absolute inset-0 pointer-events-none overflow-hidden opacity-[0.08] select-none mix-blend-overlay">
          <svg className="absolute -right-16 -top-16 w-[450px] h-[450px] text-[#ffffff]" fill="currentColor" viewBox="0 0 100 100">
            <circle cx="50" cy="50" r="40" />
          </svg>
          <svg className="absolute -left-20 -bottom-20 w-[350px] h-[350px] text-[#ffffff]" fill="currentColor" viewBox="0 0 100 100">
            <polygon points="50,15 90,85 10,85" />
          </svg>
          {/* Subtle Grid / Dot pattern */}
          <div className="absolute inset-0 bg-[radial-gradient(#ffffff_2px,transparent_2px)] [background-size:32px_32px] opacity-70" />
        </div>

        <div className="relative flex flex-col sm:flex-row sm:items-start justify-between gap-6 z-10">
          
          {/* Left Column: Greeting, Details, Academic Info, Status Badge */}
          <div className="space-y-6 text-left max-w-xl text-[#ffffff]">
            
            {/* Working Day Status & Current Date */}
            <div className="flex flex-wrap items-center gap-3">
              <span className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold bg-white/10 border border-white/20 text-[#ffffff] backdrop-blur-md shadow-inner">
                {new Date().getDay() === 0 ? '🔴 Holiday' : '🟢 Working Day'}
              </span>
              
              <span className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold bg-white/10 border border-white/20 text-[#ffffff] backdrop-blur-md shadow-inner">
                {formatFullDate()}
              </span>
            </div>
            
            {/* Typography Hierarchy */}
            <div className="space-y-2">
              <h1 className="text-2xl sm:text-3xl font-black tracking-tight leading-tight bg-clip-text text-transparent bg-gradient-to-r from-white to-white/80">
                {greeting.text}, Dean
              </h1>
              <p className="text-white/80 text-[#ffffff]/80 text-xs font-bold tracking-wide">
                Ph.D., M.E., B.Tech.
              </p>
              <div className="pt-2">
                <p className="text-white/90 text-[#ffffff]/90 text-xs font-bold uppercase tracking-widest text-indigo-200">
                  DEAN OF ACADEMICS
                </p>
                <p className="text-[#ffffff] text-lg sm:text-xl font-extrabold tracking-wide uppercase mt-1">
                  CAMPUS ADMINISTRATION
                </p>
              </div>
            </div>

            {/* Academic Info */}
            <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-white/90 text-[#ffffff]/90 text-xs font-semibold pt-1">
              <span>Academic Year : {getAcademicYear()}</span>
            </div>

          </div>

          {/* Right Column: Requests Notification Badge & Refresh Button */}
          <div className="flex flex-col items-end gap-3 self-start shrink-0 sm:pt-2">
            <button
              className="inline-flex items-center gap-2.5 bg-white/15 border border-white/20 px-4 py-2 rounded-full backdrop-blur-md hover:bg-white/25 hover:scale-[1.02] active:scale-[0.98] transition-all duration-300 shadow-sm text-[#ffffff] focus:outline-none cursor-pointer"
            >
              <Bell className="w-4 h-4 text-[#ffffff] fill-white/10" />
              <span className="text-xs font-bold tracking-wide">Requests</span>
              {((stats?.pending_faculty_leaves || 0) + (stats?.pending_complaints || 0)) > 0 && (
                <span className="bg-rose-500 text-[#ffffff] text-[10px] font-black px-2 py-0.5 rounded-full min-w-[20px] text-center animate-pulse">
                  {(stats?.pending_faculty_leaves || 0) + (stats?.pending_complaints || 0)}
                </span>
              )}
            </button>
            <button
              onClick={handleRefresh}
              disabled={refreshing}
              className="inline-flex items-center gap-2 px-3 py-1.5 bg-white/10 border border-white/10 rounded-xl hover:bg-white/20 transition-colors disabled:opacity-50 shadow-sm text-[#ffffff] mt-4"
            >
              <RefreshCw className={`w-3.5 h-3.5 ${refreshing ? 'animate-spin' : ''}`} />
              <span className="text-xs font-semibold">Refresh</span>
            </button>
            {lastUpdated && (
              <span className="text-[10px] text-white/60">Updated: {formatTime(lastUpdated)}</span>
            )}
          </div>
        </div>
      </div>

      {/* 1. TOP NUMBERS (Stat Cards) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard 
          title="Total Students" 
          value={stats?.total_students?.toLocaleString() || '0'} 
          icon={Users} 
          colorClass="text-blue-600" 
          bgColorClass="bg-blue-50"
          subtitle="Enrolled & Active"
        />
        <StatCard 
          title="Total Faculty" 
          value={stats?.total_faculty?.toLocaleString() || '0'} 
          icon={UserCheck} 
          colorClass="text-emerald-600" 
          bgColorClass="bg-emerald-50"
          subtitle="Teaching Staff"
        />
        <StatCard 
          title="Departments" 
          value={stats?.total_departments || '0'} 
          icon={Building2} 
          colorClass="text-purple-600" 
          bgColorClass="bg-purple-50"
          subtitle="Academic Units"
        />
        <StatCard 
          title="Active Courses" 
          value={stats?.active_courses || '0'} 
          icon={BookOpen} 
          colorClass="text-amber-600" 
          bgColorClass="bg-amber-50"
          subtitle="This Semester"
        />
      </div>

      {/* QUICK ACTIONS */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
        <button onClick={() => navigate('/dean/messaging')} className="flex items-center gap-3 p-4 bg-white rounded-2xl border border-gray-100 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all group cursor-pointer text-left focus:outline-none">
          <div className="p-2 bg-indigo-50 text-indigo-600 rounded-lg group-hover:scale-110 transition-transform">
            <MessageSquare className="w-5 h-5" />
          </div>
          <div>
            <p className="font-bold text-gray-900 text-sm">Messaging</p>
            <p className="text-[10px] text-gray-500">Student messages</p>
          </div>
        </button>
        <button onClick={() => navigate('/authority/faculty')} className="flex items-center gap-3 p-4 bg-white rounded-2xl border border-gray-100 shadow-sm hover:border-emerald-300 hover:shadow-md transition-all group cursor-pointer text-left focus:outline-none">
          <div className="p-2 bg-emerald-50 text-emerald-600 rounded-lg group-hover:scale-110 transition-transform">
            <Users className="w-5 h-5" />
          </div>
          <div>
            <p className="font-bold text-gray-900 text-sm">Faculty DB</p>
            <p className="text-[10px] text-gray-500">View directory</p>
          </div>
        </button>
        <button onClick={() => navigate('/authority/leave')} className="flex items-center gap-3 p-4 bg-white rounded-2xl border border-gray-100 shadow-sm hover:border-amber-300 hover:shadow-md transition-all group cursor-pointer text-left focus:outline-none">
          <div className="p-2 bg-amber-50 text-amber-600 rounded-lg group-hover:scale-110 transition-transform">
            <Zap className="w-5 h-5" />
          </div>
          <div>
            <p className="font-bold text-gray-900 text-sm">Quick Approvals</p>
            <p className="text-[10px] text-gray-500">Manage requests</p>
          </div>
        </button>
        <button onClick={() => navigate('/authority/announcements')} className="flex items-center gap-3 p-4 bg-white rounded-2xl border border-gray-100 shadow-sm hover:border-rose-300 hover:shadow-md transition-all group cursor-pointer text-left focus:outline-none">
          <div className="p-2 bg-rose-50 text-rose-600 rounded-lg group-hover:scale-110 transition-transform">
            <Megaphone className="w-5 h-5" />
          </div>
          <div>
            <p className="font-bold text-gray-900 text-sm">Announce</p>
            <p className="text-[10px] text-gray-500">Broadcast message</p>
          </div>
        </button>
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Left Column - Attendance & Performance */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* 2. ATTENDANCE OVERVIEW (Detailed) */}
          <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
            <div className="flex items-center justify-between mb-5">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-[12px] bg-blue-50 flex items-center justify-center">
                  <Activity className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <h3 className="text-[16px] font-bold text-gray-900">Today's Attendance Status</h3>
                  <p className="text-[11px] text-gray-500">Department wise present/absent for Student & Faculty</p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-[11px] text-gray-400 uppercase tracking-wider">Overall</p>
                <p className="text-[24px] font-extrabold text-blue-600">
                  {stats?.overall_attendance_percent || 0}%
                </p>
              </div>
            </div>
            
            {/* Department Detailed Attendance */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {stats?.attendance_by_department?.sort((a, b) => b.attendance_percent - a.attendance_percent).map((dept, idx) => (
                <DetailedAttendanceCard 
                  key={dept.department_code}
                  name={dept.department_name}
                  code={dept.department_code}
                  percent={dept.attendance_percent}
                  sp={dept.student_present_today || 0}
                  sa={dept.student_absent_today || 0}
                  fp={dept.faculty_present_today || 0}
                  fa={dept.faculty_absent_today || 0}
                  rank={idx + 1}
                />
              ))}
            </div>
          </div>

          {/* 3. ACADEMIC PERFORMANCE */}
          <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
            <div className="flex items-center justify-between mb-5">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-[12px] bg-emerald-50 flex items-center justify-center">
                  <BarChart3 className="w-5 h-5 text-emerald-600" />
                </div>
                <div>
                  <h3 className="text-[16px] font-bold text-gray-900">Academic Performance</h3>
                  <p className="text-[11px] text-gray-500">Pass percentage by department</p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-[11px] text-gray-400 uppercase tracking-wider">Overall</p>
                <p className="text-[24px] font-extrabold text-emerald-600">
                  {stats?.overall_pass_percent || 0}%
                </p>
              </div>
            </div>
            
            {/* Department Performance */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {stats?.performance_by_department?.sort((a, b) => b.pass_percent - a.pass_percent).map((dept, idx) => (
                <DepartmentCard 
                  key={dept.department_code}
                  name={dept.department_name}
                  code={dept.department_code}
                  value={dept.pass_percent}
                  type="performance"
                  rank={idx + 1}
                />
              ))}
            </div>
          </div>

        </div>

        {/* Right Column - Pending Requests & Announcements */}
        <div className="space-y-6">
          
          {/* REQUEST MANAGEMENT */}
          <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
            <div className="flex items-center gap-3 mb-5">
              <div className="w-10 h-10 rounded-[12px] bg-amber-50 flex items-center justify-center">
                <FileText className="w-5 h-5 text-amber-600" />
              </div>
              <div>
                <h3 className="text-[16px] font-bold text-gray-900">Request Management</h3>
                <p className="text-[11px] text-gray-500">Faculty pending approvals</p>
              </div>
            </div>
            
            <div className="space-y-3">
              <div className="flex items-center justify-between p-4 bg-gradient-to-r from-amber-50 to-orange-50 rounded-xl border border-amber-200">
                <div>
                  <p className="text-xs font-semibold text-gray-600">Faculty Leaves</p>
                  <p className="text-2xl font-extrabold text-amber-700 mt-1">
                    {stats?.pending_faculty_leaves || 0}
                  </p>
                </div>
                <FileText className="w-8 h-8 text-amber-400 opacity-80" />
              </div>
              
              <div className="flex items-center justify-between p-4 bg-gradient-to-r from-indigo-50 to-blue-50 rounded-xl border border-indigo-200">
                <div>
                  <p className="text-xs font-semibold text-gray-600">Gate Passes</p>
                  <p className="text-2xl font-extrabold text-indigo-700 mt-1">
                    {stats?.pending_gate_passes || 0}
                  </p>
                </div>
                <UserCheck className="w-8 h-8 text-indigo-400 opacity-80" />
              </div>
            </div>
          </div>

          {/* RECENT ANNOUNCEMENTS */}
          <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex-1 flex flex-col">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-[12px] bg-purple-50 flex items-center justify-center">
                  <Megaphone className="w-5 h-5 text-purple-600" />
                </div>
                <div>
                  <h3 className="text-[16px] font-bold text-gray-900">Announcements</h3>
                  <p className="text-[11px] text-gray-500">Recent campus notices</p>
                </div>
              </div>
              <button className="text-purple-600 bg-purple-50 hover:bg-purple-100 p-1.5 rounded-lg transition-colors cursor-pointer">
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
            
            <div className="space-y-3 max-h-[400px] overflow-y-auto pr-2">
              {stats?.announcements && stats.announcements.length > 0 ? (
                stats.announcements.map((ann, idx) => (
                  <div key={idx} className="p-3 border-l-4 border-purple-500 bg-purple-50/30 rounded-r-xl border-t border-b border-r border-gray-100">
                    <div className="flex justify-between items-start mb-1">
                      <h4 className="text-sm font-bold text-gray-900">{ann.title}</h4>
                      <span className="text-[10px] text-gray-500 bg-white px-1.5 py-0.5 rounded shadow-sm">
                        {new Date(ann.created_at).toLocaleDateString()}
                      </span>
                    </div>
                    <p className="text-xs text-gray-600 line-clamp-2">{ann.content}</p>
                  </div>
                ))
              ) : (
                <div className="text-center py-8">
                  <Megaphone className="w-10 h-10 text-gray-200 mx-auto mb-2" />
                  <p className="text-sm text-gray-400">No recent announcements</p>
                </div>
              )}
            </div>
          </div>

        </div>
      </div>

      {/* View-Only Notice */}
      <div className="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-4 border border-blue-200">
        <div className="flex items-center gap-3">
          <PieChart className="w-5 h-5 text-blue-600" />
          <p className="text-sm text-gray-700">
            <span className="font-semibold">View-Only Access:</span> This dashboard provides real-time monitoring. 
            All data updates automatically every 30 seconds.
          </p>
        </div>
      </div>
    </div>
  );
};

export default DeanDashboard;
