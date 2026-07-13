import React, { useState, useEffect, useMemo } from 'react';
import axios from 'axios';
import { 
  Users, UserCheck, UserX, Clock, Building, Calendar as CalendarIcon, FileText
} from 'lucide-react';
import { 
  PieChart, Pie, Cell, Tooltip as RechartsTooltip, ResponsiveContainer, 
  XAxis, YAxis, CartesianGrid, Legend, AreaChart, Area
} from 'recharts';
import { format, parseISO, startOfDay, endOfDay, isSameDay, getDaysInMonth, setDate } from 'date-fns';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const HRDashboard = () => {
  const [facultyList, setFacultyList] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [leaves, setLeaves] = useState([]);
  const [gatepasses, setGatepasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const token = localStorage.getItem('token');
        const headers = { Authorization: `Bearer ${token}` };
        
        const [facRes, deptRes, leaveRes, gatepassRes] = await Promise.all([
          axios.get(`${API_BASE_URL}/api/faculty`, { headers }),
          axios.get(`${API_BASE_URL}/api/departments`, { headers }),
          axios.get(`${API_BASE_URL}/api/leave/requests`, { headers }).catch(() => ({ data: [] })),
          axios.get(`${API_BASE_URL}/api/faculty-gatepass/tracking`, { headers }).catch(() => ({ data: [] }))
        ]);
        
        setFacultyList(facRes.data);
        setDepartments(deptRes.data);
        setLeaves(leaveRes.data);
        setGatepasses(gatepassRes.data);
      } catch (err) {
        console.error('Error fetching data:', err);
        setError('Failed to load dashboard data');
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const today = new Date();

  const { todayAbsent, todayPresent, todayGatepasses, gatepassTrend } = useMemo(() => {
    if (!facultyList.length) return { todayAbsent: [], todayPresent: [], todayGatepasses: [], gatepassTrend: [] };

    // Today's Date bounds
    const todayStart = startOfDay(today);
    const todayEnd = endOfDay(today);

    // Filter active and approved leaves for today
    const absentFacultyIds = new Set();
    const activeLeavesToday = leaves.filter(l => {
      if (!l.from_date || l.status?.toUpperCase() !== 'APPROVED') return false;
      const from = startOfDay(parseISO(l.from_date));
      const to = l.to_date ? endOfDay(parseISO(l.to_date)) : endOfDay(parseISO(l.from_date));
      if (today >= from && today <= to) {
        absentFacultyIds.add(l.faculty_id);
        return true;
      }
      return false;
    });

    const todayGatepasses = gatepasses.filter(g => {
      if (!g.out_time || g.status?.toUpperCase() !== 'APPROVED') return false;
      return isSameDay(parseISO(g.out_time), today);
    });

    const todayAbsent = facultyList.filter(f => absentFacultyIds.has(f.id)).map(f => {
      const leaveInfo = activeLeavesToday.find(l => l.faculty_id === f.id);
      return { ...f, leaveInfo };
    });
    
    const todayPresent = facultyList.filter(f => !absentFacultyIds.has(f.id));

    // Gatepass Monthly Trend for Area Chart
    const daysInMonth = getDaysInMonth(today);
    const gatepassTrend = [];
    let maxGatepasses = 0;
    
    for (let i = 1; i <= daysInMonth; i++) {
      const dayDate = setDate(today, i);
      const gatepassesOnDay = gatepasses.filter(g => {
        if (!g.out_time || g.status?.toUpperCase() !== 'APPROVED') return false;
        return isSameDay(parseISO(g.out_time), dayDate);
      }).length;
      
      maxGatepasses = Math.max(maxGatepasses, gatepassesOnDay);
      gatepassTrend.push({
        name: format(dayDate, 'dd'),
        Gatepasses: gatepassesOnDay
      });
    }

    return { todayAbsent, todayPresent, todayGatepasses, gatepassTrend };
  }, [facultyList, leaves, gatepasses, departments]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  const COLORS = ['#10b981', '#f43f5e']; // Emerald for Present, Rose for Absent
  const pieData = [
    { name: 'Present', value: todayPresent.length },
    { name: 'Absent', value: todayAbsent.length }
  ];

  // Tick calculation for gatepass trend y-axis
  const maxActivity = Math.max(...gatepassTrend.map(d => d.Gatepasses), 4);
  const maxEven = Math.ceil(maxActivity / 2) * 2;
  const yTicks = [];
  for (let i = 0; i <= maxEven; i += 2) {
    yTicks.push(i);
  }

  const deptMap = {};
  departments.forEach(d => deptMap[d.id] = d);

  return (
    <div className="space-y-6 max-w-7xl mx-auto p-4 md:p-6 lg:p-8 animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-[28px] font-bold text-slate-900 tracking-tight mb-1">
            HR Dashboard 👥
          </h1>
          <p className="text-[14px] text-slate-500 font-medium">
            Live attendance and analytics for {format(today, 'MMMM do, yyyy')}
          </p>
        </div>
      </div>

      {error && (
        <div className="bg-red-50 text-red-600 p-4 rounded-2xl font-medium border border-red-100">
          {error}
        </div>
      )}

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100 flex items-center justify-between hover:shadow-md transition-shadow">
          <div>
            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Faculty</p>
            <p className="text-3xl font-black text-slate-800">{facultyList.length}</p>
          </div>
          <div className="w-14 h-14 bg-indigo-50 rounded-2xl flex items-center justify-center text-indigo-600">
            <Users className="w-7 h-7" />
          </div>
        </div>

        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100 flex items-center justify-between hover:shadow-md transition-shadow">
          <div>
            <p className="text-xs font-bold text-emerald-500 uppercase tracking-wider mb-1">Present Today</p>
            <p className="text-3xl font-black text-emerald-700">{todayPresent.length}</p>
          </div>
          <div className="w-14 h-14 bg-emerald-50 rounded-2xl flex items-center justify-center text-emerald-500">
            <UserCheck className="w-7 h-7" />
          </div>
        </div>

        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100 flex items-center justify-between hover:shadow-md transition-shadow">
          <div>
            <p className="text-xs font-bold text-rose-500 uppercase tracking-wider mb-1">On Leave Today</p>
            <p className="text-3xl font-black text-rose-700">{todayAbsent.length}</p>
          </div>
          <div className="w-14 h-14 bg-rose-50 rounded-2xl flex items-center justify-center text-rose-500">
            <UserX className="w-7 h-7" />
          </div>
        </div>

        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100 flex items-center justify-between hover:shadow-md transition-shadow">
          <div>
            <p className="text-xs font-bold text-sky-500 uppercase tracking-wider mb-1">Active Gatepasses</p>
            <p className="text-3xl font-black text-sky-700">{todayGatepasses?.length || 0}</p>
          </div>
          <div className="w-14 h-14 bg-sky-50 rounded-2xl flex items-center justify-center text-sky-500">
            <Clock className="w-7 h-7" />
          </div>
        </div>
      </div>

      {/* Visualizations */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Attendance Donut */}
        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100 flex flex-col hover:shadow-md transition-shadow">
          <h3 className="font-bold text-slate-800 text-lg mb-6">Today's Attendance</h3>
          <div className="flex-1 flex items-center justify-center min-h-[250px]">
            <ResponsiveContainer width="100%" height={250}>
              <PieChart>
                <Pie
                  data={pieData}
                  cx="50%"
                  cy="50%"
                  innerRadius={70}
                  outerRadius={100}
                  paddingAngle={5}
                  dataKey="value"
                  stroke="none"
                >
                  {pieData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <RechartsTooltip 
                  contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.1)' }}
                  itemStyle={{ fontWeight: 'bold' }}
                />
                <Legend iconType="circle" wrapperStyle={{ fontSize: '13px', paddingTop: '20px' }} />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Gatepass Trend */}
        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100 lg:col-span-2 flex flex-col hover:shadow-md transition-shadow">
          <h3 className="font-bold text-slate-800 text-lg mb-6">Monthly Gatepass Volume</h3>
          <div className="flex-1 min-h-[250px] w-full">
            <ResponsiveContainer width="100%" height={250}>
              <AreaChart data={gatepassTrend} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                <defs>
                  <linearGradient id="colorGatepassesDashboard" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#0ea5e9" stopOpacity={0.3}/>
                    <stop offset="95%" stopColor="#0ea5e9" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                <XAxis 
                  dataKey="name" 
                  axisLine={false} 
                  tickLine={false} 
                  tick={{ fill: '#94a3b8', fontSize: 12 }} 
                  dy={10} 
                />
                <YAxis 
                  axisLine={false} 
                  tickLine={false} 
                  tick={{ fill: '#94a3b8', fontSize: 12 }} 
                  ticks={yTicks}
                  domain={[0, yTicks[yTicks.length - 1]]}
                />
                <RechartsTooltip 
                  contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.1)' }}
                />
                <Area type="monotone" dataKey="Gatepasses" stroke="#0ea5e9" strokeWidth={3} fillOpacity={1} fill="url(#colorGatepassesDashboard)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>

      {/* Detailed Lists */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 pb-12">
        
        {/* Absent List */}
        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-rose-50 rounded-xl flex items-center justify-center text-rose-500">
                <UserX className="w-5 h-5" />
              </div>
              <div>
                <h3 className="font-bold text-slate-800 text-lg">Currently on Leave</h3>
                <p className="text-xs text-slate-500">Staff marked absent today</p>
              </div>
            </div>
            <span className="px-3 py-1 bg-rose-50 text-rose-600 font-bold text-xs rounded-lg">{todayAbsent.length} Staff</span>
          </div>
          
          <div className="space-y-3 max-h-[350px] overflow-y-auto pr-2 custom-scrollbar">
            {todayAbsent.length === 0 ? (
              <div className="text-center py-10 bg-slate-50/50 rounded-2xl border border-slate-100 border-dashed">
                <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center mx-auto mb-3 shadow-sm">
                  <UserCheck className="w-6 h-6 text-emerald-500" />
                </div>
                <p className="text-slate-600 font-bold text-sm">Everyone is present today! 🎉</p>
                <p className="text-slate-400 text-xs mt-1">No active leaves recorded for this date.</p>
              </div>
            ) : (
              todayAbsent.map(f => (
                <div key={f.id} className="flex items-center justify-between p-3 bg-white rounded-xl border border-slate-100 shadow-sm hover:border-indigo-100 transition-colors group">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-indigo-50 to-purple-50 flex items-center justify-center text-indigo-700 font-bold text-sm shrink-0 ring-1 ring-indigo-100 group-hover:ring-indigo-300 transition-all">
                      {f.first_name.charAt(0)}{f.last_name.charAt(0)}
                    </div>
                    <div>
                      <p className="font-bold text-slate-800 text-sm group-hover:text-indigo-600 transition-colors">{f.first_name} {f.last_name}</p>
                      <p className="text-[11px] text-slate-500 font-semibold uppercase tracking-wider mt-0.5">{deptMap[f.department_id]?.code || 'N/A'}</p>
                    </div>
                  </div>
                  <span className="px-2.5 py-1 bg-slate-50 border border-slate-200 text-slate-600 font-bold text-[10px] rounded-lg">
                    {f.leaveInfo?.leave_type || 'Leave'}
                  </span>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Gatepass List */}
        <div className="bg-white rounded-[24px] p-6 shadow-sm border border-slate-100">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-sky-50 rounded-xl flex items-center justify-center text-sky-500">
                <Clock className="w-5 h-5" />
              </div>
              <div>
                <h3 className="font-bold text-slate-800 text-lg">Today's Gatepasses</h3>
                <p className="text-xs text-slate-500">Active and completed out-passes</p>
              </div>
            </div>
            <span className="px-3 py-1 bg-sky-50 text-sky-600 font-bold text-xs rounded-lg">{todayGatepasses.length} Passes</span>
          </div>
          
          <div className="space-y-3 max-h-[350px] overflow-y-auto pr-2 custom-scrollbar">
            {!todayGatepasses || todayGatepasses.length === 0 ? (
              <div className="text-center py-10 bg-slate-50/50 rounded-2xl border border-slate-100 border-dashed">
                <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center mx-auto mb-3 shadow-sm">
                  <Building className="w-6 h-6 text-slate-400" />
                </div>
                <p className="text-slate-600 font-bold text-sm">No gatepasses issued today.</p>
                <p className="text-slate-400 text-xs mt-1">All faculty are on campus.</p>
              </div>
            ) : (
              todayGatepasses.map(g => {
                const f = g.faculty;
                return (
                  <div key={g.id} className="flex items-center justify-between p-3 bg-white rounded-xl border border-slate-100 shadow-sm hover:border-sky-100 transition-colors group">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-sky-50 to-blue-50 flex items-center justify-center text-sky-700 font-bold text-sm shrink-0 ring-1 ring-sky-100 group-hover:ring-sky-300 transition-all">
                        {f?.first_name?.charAt(0) || 'U'}{f?.last_name?.charAt(0) || ''}
                      </div>
                      <div>
                        <p className="font-bold text-slate-800 text-sm group-hover:text-sky-600 transition-colors">{f?.first_name} {f?.last_name}</p>
                        <p className="text-[11px] text-slate-500 font-medium truncate max-w-[150px] sm:max-w-[200px] mt-0.5">{g.reason || g.purpose || 'No reason specified'}</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-xs font-bold text-slate-800">
                        {g.out_time ? format(parseISO(g.out_time), 'h:mm a') : '--:--'}
                      </p>
                      <p className="text-[9px] text-slate-400 font-bold uppercase tracking-wider mt-0.5">Out Time</p>
                    </div>
                  </div>
                )
              })
            )}
          </div>
        </div>

      </div>
    </div>
  );
};

export default HRDashboard;
