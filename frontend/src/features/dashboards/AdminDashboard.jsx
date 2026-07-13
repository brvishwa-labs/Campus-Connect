import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../../context/AuthContext';
import { BookOpen, Users, Edit3, TrendingUp, Building2, GraduationCap } from 'lucide-react';
import { HolidayCalendar } from '../admin/HolidayCalendar';


const KPICard = ({ title, value, icon: Icon, colorClass, bgColorClass }) => (
  <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex items-center space-x-5 transition-transform hover:translate-y-[-2px]">
    <div className={`w-14 h-14 rounded-[16px] ${bgColorClass} flex items-center justify-center flex-shrink-0`}>
      <Icon className={`w-7 h-7 ${colorClass}`} strokeWidth={1.5} />
    </div>
    <div>
      <p className="text-[12px] font-bold text-gray-400 uppercase tracking-wider mb-1">{title}</p>
      <p className="text-[32px] font-extrabold text-gray-900 leading-none">{value}</p>
    </div>
  </div>
);

export const AdminDashboard = () => {
  const { user } = useAuth();
  const [stats, setStats] = useState({
    departments: 0,
    faculty: 0,
    students: 0,
    courses: 0,
    total_records: 0,
    active_users: 0
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await axios.get('/api/admin/stats');
        setStats(response.data);
      } catch (err) {
        setError("Failed to load dashboard metrics.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
  }, []);

  return (
    <div className="space-y-8">
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-[32px] font-bold text-gray-900 tracking-tight mb-2">
            Welcome back, {user?.name || 'Admin'}! 👋
          </h1>
          <p className="text-[15px] text-gray-500">
            Here is your live administrative overview of Campus Connect.
          </p>
        </div>
      </div>
      
      {error && (
        <div className="bg-red-50 text-red-600 p-4 rounded-xl text-sm font-medium border border-red-100">
          {error}
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <KPICard 
          title="Departments" 
          value={loading ? "..." : stats.departments} 
          icon={Building2} 
          colorClass="text-blue-600" 
          bgColorClass="bg-blue-50" 
        />
        <KPICard 
          title="Faculty Members" 
          value={loading ? "..." : stats.faculty} 
          icon={Users} 
          colorClass="text-emerald-600" 
          bgColorClass="bg-emerald-50" 
        />
        <KPICard 
          title="Registered Students" 
          value={loading ? "..." : stats.students} 
          icon={GraduationCap} 
          colorClass="text-purple-600" 
          bgColorClass="bg-purple-50" 
        />
        <KPICard 
          title="Active Courses" 
          value={loading ? "..." : stats.courses} 
          icon={BookOpen} 
          colorClass="text-amber-600" 
          bgColorClass="bg-amber-50" 
        />
      </div>
      
      {/* Overview Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-8">
        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8">
           <h3 className="text-lg font-bold text-gray-900 mb-2">System Health</h3>
           <p className="text-sm text-gray-500 mb-6">Real-time metrics on user accounts and total database records.</p>
           
           <div className="space-y-6">
              <div>
                 <div className="flex justify-between mb-2">
                    <span className="text-sm font-bold text-gray-700">Active System Users</span>
                    <span className="text-sm font-bold text-primary-600">{stats.active_users}</span>
                 </div>
                 <div className="w-full bg-gray-100 rounded-full h-2">
                    <div className="bg-primary-500 h-2 rounded-full" style={{ width: '80%' }}></div>
                 </div>
              </div>
              
              <div>
                 <div className="flex justify-between mb-2">
                    <span className="text-sm font-bold text-gray-700">Total Database Records</span>
                    <span className="text-sm font-bold text-emerald-600">{stats.total_records}</span>
                 </div>
                 <div className="w-full bg-gray-100 rounded-full h-2">
                    <div className="bg-emerald-500 h-2 rounded-full" style={{ width: '65%' }}></div>
                 </div>
              </div>
           </div>
        </div>
        
        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8 flex flex-col items-center justify-center text-center">
            <div className="w-16 h-16 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mb-4">
                <Edit3 className="w-8 h-8" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-2">Quick Actions</h3>
            <p className="text-sm text-gray-500 mb-6 max-w-sm">
                Get started by managing the core college infrastructure from the sidebar menus.
            </p>
            <div className="flex gap-4">
                <button className="px-5 py-2.5 bg-gray-50 hover:bg-gray-100 text-gray-700 font-bold text-sm rounded-xl transition-colors border border-gray-200">
                    Add Department
                </button>
                <button className="px-5 py-2.5 bg-primary-600 hover:bg-primary-700 text-white font-bold text-sm rounded-xl transition-colors shadow-sm">
                    Onboard Faculty
                </button>
            </div>
        </div>
      </div>

      {/* ── Holiday Calendar ─────────────────────────── */}
      <HolidayCalendar />
    </div>
  );
};

