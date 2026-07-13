import React, { useState, useEffect, useMemo } from 'react';
import axios from 'axios';
import { Users, UserCheck, UserX, Clock, Activity, Briefcase, Calendar } from 'lucide-react';
import { 
  PieChart, Pie, Cell, Tooltip as RechartsTooltip, ResponsiveContainer, 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Legend,
  AreaChart, Area
} from 'recharts';
import { isSameDay, parseISO, startOfDay, endOfDay, format, subDays, isSameMonth } from 'date-fns';

const API_BASE_URL = 'http://localhost:8000';

const HRDashboard = () => {
  const [faculty, setFaculty] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [leaves, setLeaves] = useState([]);
  const [gatepasses, setGatepasses] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const token = localStorage.getItem('token');
        const headers = { Authorization: `Bearer ${token}` };
        
        const [facRes, deptRes, leaveRes, gatepassRes] = await Promise.all([
          axios.get(`${API_BASE_URL}/api/faculty`, { headers }).catch(() => ({ data: [] })),
          axios.get(`${API_BASE_URL}/api/departments`, { headers }).catch(() => ({ data: [] })),
          axios.get(`${API_BASE_URL}/api/leave/requests`, { headers }).catch(() => ({ data: [] })),
          axios.get(`${API_BASE_URL}/api/faculty-gatepass/tracking`, { headers }).catch(() => ({ data: [] }))
        ]);
        
        setFaculty(facRes.data);
        setDepartments(deptRes.data);
        setLeaves(leaveRes.data);
        setGatepasses(gatepassRes.data);
      } catch (err) {
        console.error('Error fetching HR dashboard data:', err);
      } finally {
        setLoading(false);
      }
    };
    
    fetchData();
  }, []);

  const analytics = useMemo(() => {
    const today = new Date();
    const totalFaculty = faculty.length;
    
    // Calculate who is absent today
    const absentFacultyList = leaves.filter(l => {
      if (!l.from_date || l.status?.toUpperCase() !== 'APPROVED') return false;
      const from = startOfDay(parseISO(l.from_date));
      const to = l.to_date ? endOfDay(parseISO(l.to_date)) : endOfDay(parseISO(l.from_date));
      return today >= from && today <= to;
    });
    
    const absentCount = absentFacultyList.length;
    const presentCount = totalFaculty - absentCount;

    // Today's gatepasses
    const todayGatepasses = gatepasses.filter(g => {
      if (!g.out_time || g.status?.toUpperCase() !== 'APPROVED') return false;
      return isSameDay(parseISO(g.out_time), today);
    });
    const gatepassCount = todayGatepasses.length;

    // Present distribution by department
    const deptAttendanceCounts = {};
    faculty.forEach(f => {
      let deptName = 'Unknown';
      if (f.department?.code) {
        deptName = f.department.code;
      } else if (f.department_id) {
        const d = departments.find(dep => dep.id === f.department_id);
        if (d && d.code) deptName = d.code;
      }
      
      if (deptName !== 'Unknown') {
        const isAbsent = absentFacultyList.some(l => l.faculty_id === f.id);
        if (!isAbsent) {
          deptAttendanceCounts[deptName] = (deptAttendanceCounts[deptName] || 0) + 1;
        }
      }
    });
    const deptAttendanceData = Object.keys(deptAttendanceCounts).map(dept => ({
      name: dept,
      Present: deptAttendanceCounts[dept]
    })).sort((a,b) => b.Present - a.Present);

    // Leave Types Distribution (Donut Chart) strictly for Current Month
    const currentMonthLeaves = leaves.filter(l => {
        if (l.status?.toUpperCase() !== 'APPROVED' || !l.from_date) return false;
        return isSameMonth(parseISO(l.from_date), today);
    });
    const leaveTypesCount = {};
    currentMonthLeaves.forEach(l => {
        const type = l.leave_type || 'Other';
        leaveTypesCount[type] = (leaveTypesCount[type] || 0) + 1;
    });
    const leaveTypesData = Object.keys(leaveTypesCount).map(type => ({
        name: type,
        value: leaveTypesCount[type]
    }));

    // 7-Day Attendance Trend (Present Only)
    const trendData = [];
    for (let i = 6; i >= 0; i--) {
        const targetDate = subDays(today, i);
        const dayLabel = format(targetDate, 'dd MMM');
        
        const absences = leaves.filter(l => {
            if (!l.from_date || l.status?.toUpperCase() !== 'APPROVED') return false;
            const from = startOfDay(parseISO(l.from_date));
            const to = l.to_date ? endOfDay(parseISO(l.to_date)) : endOfDay(parseISO(l.from_date));
            return targetDate >= from && targetDate <= to;
        }).length;
        
        trendData.push({
            name: dayLabel,
            Present: totalFaculty - absences
        });
    }

    // Recent Activity Feed (Gatepasses) - Strictly Today only
    const recentActivity = [...gatepasses]
        .filter(g => {
            if (!g.out_time || g.status?.toUpperCase() !== 'APPROVED') return false;
            return isSameDay(parseISO(g.out_time), today);
        })
        .sort((a, b) => new Date(b.out_time) - new Date(a.out_time))
        .slice(0, 5);

    return {
      totalFaculty,
      presentCount,
      absentCount,
      gatepassCount,
      deptAttendanceData,
      leaveTypesData,
      trendData,
      recentActivity
    };
  }, [faculty, leaves, gatepasses]);

  const PIE_COLORS = ['#8b5cf6', '#ec4899', '#f59e0b', '#06b6d4', '#10b981'];

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="animate-spin rounded-full h-12 w-12 border-4 border-indigo-500 border-t-transparent"></div>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-[28px] font-bold text-gray-900 tracking-tight mb-1">
            HR Analytics Overview 📈
          </h1>
          <p className="text-[14px] text-gray-500">
            Live attendance and activity tracking for {format(new Date(), 'MMMM d, yyyy')}
          </p>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex items-center gap-4">
          <div className="p-3 bg-blue-50 text-blue-600 rounded-2xl"><Users size={24} /></div>
          <div>
            <p className="text-sm font-medium text-gray-500">Total Staff</p>
            <h3 className="text-2xl font-bold text-gray-900">{analytics.totalFaculty}</h3>
          </div>
        </div>

        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex items-center gap-4">
          <div className="p-3 bg-emerald-50 text-emerald-600 rounded-2xl"><UserCheck size={24} /></div>
          <div>
            <p className="text-sm font-medium text-gray-500">Present Today</p>
            <h3 className="text-2xl font-bold text-gray-900">{analytics.presentCount}</h3>
          </div>
        </div>

        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex items-center gap-4">
          <div className="p-3 bg-rose-50 text-rose-600 rounded-2xl"><UserX size={24} /></div>
          <div>
            <p className="text-sm font-medium text-gray-500">On Leave</p>
            <h3 className="text-2xl font-bold text-gray-900">{analytics.absentCount}</h3>
          </div>
        </div>

        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex items-center gap-4">
          <div className="p-3 bg-purple-50 text-purple-600 rounded-2xl"><Clock size={24} /></div>
          <div>
            <p className="text-sm font-medium text-gray-500">Active Gatepasses</p>
            <h3 className="text-2xl font-bold text-gray-900">{analytics.gatepassCount}</h3>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Area: Charts */}
        <div className="lg:col-span-2 space-y-8">
          
          {/* Departmental Present Distribution */}
          <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2.5 bg-emerald-50 text-emerald-600 rounded-xl"><UserCheck size={20} /></div>
                <div>
                  <h3 className="font-bold text-slate-900 text-lg">Present Faculty Distribution</h3>
                  <p className="text-sm text-slate-500">Number of present faculty today across departments</p>
                </div>
              </div>
            </div>
            <div className="h-[300px] w-full">
              {analytics.deptAttendanceData.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={analytics.deptAttendanceData} margin={{ top: 20, right: 30, left: 0, bottom: 5 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fill: '#94a3b8', fontSize: 12 }} dy={10} />
                    <YAxis axisLine={false} tickLine={false} tick={{ fill: '#94a3b8', fontSize: 12 }} allowDecimals={false} />
                    <RechartsTooltip cursor={{fill: '#f8fafc'}} contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.1)' }} />
                    <Bar dataKey="Present" fill="#10b981" radius={[6, 6, 0, 0]} maxBarSize={60} />
                  </BarChart>
                </ResponsiveContainer>
              ) : (
                <div className="h-full flex items-center justify-center text-gray-400">
                  No faculty present today.
                </div>
              )}
            </div>
          </div>

          {/* 7-Day Trend and Leave Types Container */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {/* 7-Day Trend */}
            <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8">
              <div className="mb-6">
                <h3 className="font-bold text-slate-900 text-lg">7-Day Attendance</h3>
                <p className="text-sm text-slate-500">Historical trend of present faculty</p>
              </div>
              <div className="h-[200px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={analytics.trendData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <defs>
                      <linearGradient id="colorPresent" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#10b981" stopOpacity={0.3}/>
                        <stop offset="95%" stopColor="#10b981" stopOpacity={0}/>
                      </linearGradient>
                    </defs>
                    <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fill: '#94a3b8', fontSize: 10 }} dy={10} />
                    <YAxis axisLine={false} tickLine={false} tick={{ fill: '#94a3b8', fontSize: 10 }} domain={['dataMin - 1', 'dataMax + 1']} />
                    <RechartsTooltip contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.1)' }} />
                    <Area type="monotone" dataKey="Present" stroke="#10b981" strokeWidth={3} fillOpacity={1} fill="url(#colorPresent)" />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Leave Types Donut */}
            <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8">
              <div className="mb-2">
                <h3 className="font-bold text-slate-900 text-lg">Monthly Leaves</h3>
                <p className="text-sm text-slate-500">Breakdown for {format(new Date(), 'MMMM')}</p>
              </div>
              <div className="h-[220px] w-full flex items-center justify-center">
                {analytics.leaveTypesData.length > 0 ? (
                  <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                      <Pie data={analytics.leaveTypesData} cx="50%" cy="50%" innerRadius={50} outerRadius={80} paddingAngle={5} dataKey="value">
                        {analytics.leaveTypesData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={PIE_COLORS[index % PIE_COLORS.length]} />
                        ))}
                      </Pie>
                      <RechartsTooltip contentStyle={{ borderRadius: '16px', border: 'none', boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.1)' }} />
                      <Legend verticalAlign="bottom" height={36} iconType="circle" wrapperStyle={{ fontSize: '11px' }} />
                    </PieChart>
                  </ResponsiveContainer>
                ) : (
                  <div className="text-gray-400 text-sm">No leaves this month</div>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Side Panel: Live Feed */}
        <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8 flex flex-col">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2.5 bg-sky-50 text-sky-600 rounded-xl"><Briefcase size={20} /></div>
            <div>
              <h3 className="font-bold text-slate-900 text-lg">Live Gatepass Feed</h3>
              <p className="text-sm text-slate-500">Today's off-campus activity</p>
            </div>
          </div>

          <div className="flex-1 overflow-y-auto pr-2 space-y-6">
            {analytics.recentActivity.length > 0 ? (
              analytics.recentActivity.map((activity, idx) => (
                <div key={idx} className="relative pl-6 border-l-2 border-indigo-100 last:border-transparent pb-6 last:pb-0">
                  <div className="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-indigo-500 border-4 border-white shadow-sm"></div>
                  <div className="-mt-1.5">
                    <p className="text-sm font-semibold text-gray-900">
                      {activity.faculty?.first_name} {activity.faculty?.last_name}
                    </p>
                    <p className="text-xs text-indigo-600 font-medium mb-1">
                      {format(parseISO(activity.out_time), 'hh:mm a')}
                    </p>
                    <p className="text-sm text-gray-600">
                      Reason: <span className="italic">{activity.reason}</span>
                    </p>
                  </div>
                </div>
              ))
            ) : (
              <div className="text-center text-gray-400 py-10 flex flex-col items-center">
                <Calendar className="w-12 h-12 mb-3 text-gray-200" />
                <p>No gatepasses issued today.</p>
              </div>
            )}
          </div>
        </div>

      </div>
    </div>
  );
};

export default HRDashboard;
