import { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import api from '../../api/axios';
import { 
  Users, Building2, BookOpen, UserCheck, 
  TrendingUp, TrendingDown 
} from 'lucide-react';
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  LineChart, Line
} from 'recharts';
import { format } from 'date-fns';

const weeklyData = [
  { name: 'Mon', attend: 90, assign: 80, quiz: 70 },
  { name: 'Tue', attend: 85, assign: 90, quiz: 60 },
  { name: 'Wed', attend: 92, assign: 70, quiz: 85 },
  { name: 'Thu', attend: 75, assign: 85, quiz: 90 },
  { name: 'Fri', attend: 88, assign: 78, quiz: 75 },
  { name: 'Sat', attend: 60, assign: 65, quiz: 55 },
  { name: 'Sun', attend: 45, assign: 40, quiz: 50 },
];

export default function Dashboard() {
  const { user } = useAuth();
  const [stats, setStats] = useState({
    total_students: 0,
    total_faculty: 0,
    total_departments: 0,
    total_courses: 0
  });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const res = await api.get('/dashboard/admin');
        setStats(res.data.stats);
      } catch (err) {
        console.warn("Backend unavailable, using mock dashboard stats");
        setStats({
          total_students: 4520,
          total_faculty: 315,
          total_departments: 12,
          total_courses: 148
        });
      }
    };
    fetchStats();
  }, []);

  return (
    <div className="space-y-6">
      <div className="flex items-end justify-between">
        <div>
          <p className="text-sm font-medium text-slate-500 mb-1">Good afternoon,</p>
          <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Admin 👋</h1>
          <p className="text-slate-500 mt-1">Here's a snapshot of your institution today.</p>
        </div>
        <div className="text-right">
          <p className="font-semibold text-indigo-600">{format(new Date(), 'EEEE')}</p>
          <p className="text-sm text-slate-500">{format(new Date(), 'MMMM d, yyyy')}</p>
        </div>
      </div>

      {/* Stat Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="glass-card rounded-xl p-6 flex flex-col justify-between hover:-translate-y-1 transition-transform cursor-default">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 bg-orange-50 rounded-lg flex items-center justify-center text-orange-500">
              <Users className="w-6 h-6" />
            </div>
            <span className="flex items-center gap-1 text-xs font-semibold text-emerald-600 bg-emerald-50 px-2 py-1 rounded-md">
              <TrendingUp className="w-3 h-3" /> 2.4%
            </span>
          </div>
          <div>
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Students</p>
            <h3 className="text-3xl font-bold text-slate-900">{stats.total_students}</h3>
          </div>
        </div>

        <div className="glass-card rounded-xl p-6 flex flex-col justify-between hover:-translate-y-1 transition-transform cursor-default">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 bg-blue-50 rounded-lg flex items-center justify-center text-blue-500">
              <UserCheck className="w-6 h-6" />
            </div>
            <span className="flex items-center gap-1 text-xs font-semibold text-emerald-600 bg-emerald-50 px-2 py-1 rounded-md">
              <TrendingUp className="w-3 h-3" /> 1.2%
            </span>
          </div>
          <div>
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Faculty</p>
            <h3 className="text-3xl font-bold text-slate-900">{stats.total_faculty}</h3>
          </div>
        </div>

        <div className="glass-card rounded-xl p-6 flex flex-col justify-between hover:-translate-y-1 transition-transform cursor-default">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 bg-purple-50 rounded-lg flex items-center justify-center text-purple-500">
              <Building2 className="w-6 h-6" />
            </div>
            <span className="flex items-center gap-1 text-xs font-semibold text-emerald-600 bg-emerald-50 px-2 py-1 rounded-md">
              <TrendingUp className="w-3 h-3" /> 3.1%
            </span>
          </div>
          <div>
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Departments</p>
            <h3 className="text-3xl font-bold text-slate-900">{stats.total_departments}</h3>
          </div>
        </div>

        <div className="glass-card rounded-xl p-6 flex flex-col justify-between hover:-translate-y-1 transition-transform cursor-default">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 bg-pink-50 rounded-lg flex items-center justify-center text-pink-500">
              <BookOpen className="w-6 h-6" />
            </div>
            <span className="flex items-center gap-1 text-xs font-semibold text-red-600 bg-red-50 px-2 py-1 rounded-md">
              <TrendingDown className="w-3 h-3" /> 0.8%
            </span>
          </div>
          <div>
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Active Courses</p>
            <h3 className="text-3xl font-bold text-slate-900">{stats.total_courses}</h3>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Performance Breakdown - Simulated for Admin */}
        <div className="glass-card rounded-xl p-6">
          <h3 className="text-lg font-bold text-slate-900 mb-6">Institution Performance Breakdown</h3>
          
          <div className="space-y-6">
            <div>
              <div className="flex justify-between items-end mb-2">
                <span className="text-sm font-semibold text-slate-700 flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-emerald-500"></div> Average Attendance
                </span>
                <span className="text-sm font-bold text-emerald-500">88%</span>
              </div>
              <div className="w-full bg-slate-100 rounded-full h-3">
                <div className="bg-emerald-500 h-3 rounded-full" style={{ width: '88%' }}></div>
              </div>
            </div>

            <div>
              <div className="flex justify-between items-end mb-2">
                <span className="text-sm font-semibold text-slate-700 flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-orange-500"></div> Course Completion
                </span>
                <span className="text-sm font-bold text-orange-500">93%</span>
              </div>
              <div className="w-full bg-slate-100 rounded-full h-3">
                <div className="bg-orange-500 h-3 rounded-full" style={{ width: '93%' }}></div>
              </div>
            </div>

            <div>
              <div className="flex justify-between items-end mb-2">
                <span className="text-sm font-semibold text-slate-700 flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-purple-500"></div> Exam Pass Rate
                </span>
                <span className="text-sm font-bold text-purple-500">75%</span>
              </div>
              <div className="w-full bg-slate-100 rounded-full h-3">
                <div className="bg-purple-500 h-3 rounded-full" style={{ width: '75%' }}></div>
              </div>
            </div>
          </div>
          
          <div className="mt-8 p-4 bg-amber-50 rounded-lg border border-amber-100 flex items-center gap-3">
            <TrendingUp className="w-5 h-5 text-amber-500" />
            <span className="text-sm font-medium text-amber-700">Good progress. Focus on improving exam pass rates in weaker departments.</span>
          </div>
        </div>

        {/* Weekly Activity Chart */}
        <div className="glass-card rounded-xl p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-bold text-slate-900">Weekly Activity</h3>
            <div className="flex items-center gap-4 text-xs font-semibold">
              <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-indigo-500"></div> Login</div>
              <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-blue-400"></div> Submit</div>
              <div className="flex items-center gap-1.5"><div className="w-2 h-2 rounded-full bg-emerald-400"></div> Grade</div>
            </div>
          </div>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={weeklyData} margin={{ top: 0, right: 0, left: -20, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} dy={10} />
                <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} />
                <Tooltip cursor={{ fill: '#f8fafc' }} contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)' }} />
                <Bar dataKey="attend" fill="#6366f1" radius={[4, 4, 0, 0]} barSize={10} />
                <Bar dataKey="assign" fill="#60a5fa" radius={[4, 4, 0, 0]} barSize={10} />
                <Bar dataKey="quiz" fill="#34d399" radius={[4, 4, 0, 0]} barSize={10} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  );
}
