import React, { useState, useMemo, useEffect } from 'react';
import axios from 'axios';
import { 
  Users, Mail, Phone, Building, Briefcase, X, 
  FileText, Clock, ChevronLeft, ChevronRight, Activity, Calendar as CalendarIcon,
  BookOpen, GraduationCap, Edit2, Save, Check
} from 'lucide-react';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';
import { 
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, 
  ResponsiveContainer, Legend
} from 'recharts';
import { format, parseISO, subMonths, isSameMonth, startOfMonth, getDaysInMonth, addDays, startOfDay, endOfDay, isSameDay, addMonths } from 'date-fns';

export const FacultyProfileModal = ({ faculty, department, leaves = [], gatepasses = [], workload = null, allowEdit = false, onClose }) => {
  if (!faculty) return null;

  const [currentMonth, setCurrentMonth] = useState(new Date());
  
  const [leaveBalances, setLeaveBalances] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editBalances, setEditBalances] = useState({});
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    const fetchBalances = async () => {
      try {
        const token = localStorage.getItem('token');
        const res = await axios.get(`${API_BASE_URL}/api/leave/admin/balances/${faculty.id}`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setLeaveBalances(res.data);
      } catch (err) {
        console.error('Failed to fetch leave balances:', err);
      }
    };
    fetchBalances();
  }, [faculty.id]);

  const facultyLeaves = leaves.filter(l => l.faculty_id === faculty.id);
  const facultyGatepasses = gatepasses.filter(g => g.faculty_id === faculty.id);

  const handleSaveBalances = async () => {
    try {
      setIsSaving(true);
      const token = localStorage.getItem('token');
      const res = await axios.put(`${API_BASE_URL}/api/leave/admin/balances/${faculty.id}`, editBalances, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setLeaveBalances(res.data);
      setIsEditing(false);
    } catch (err) {
      console.error('Failed to update leave balances:', err);
      alert('Failed to update balances. Please try again.');
    } finally {
      setIsSaving(false);
    }
  };

  // Filter for the selected month
  const monthlyLeaves = facultyLeaves.filter(l => {
    if (!l.from_date) return false;
    return isSameMonth(parseISO(l.from_date), currentMonth);
  });
  
  const monthlyGatepasses = facultyGatepasses.filter(g => {
    if (!g.out_time) return false;
    return isSameMonth(parseISO(g.out_time), currentMonth);
  });

  const approvedLeaves = monthlyLeaves.filter(l => l.status?.toUpperCase() === 'APPROVED').length;
  const pendingLeaves = monthlyLeaves.filter(l => l.status?.toUpperCase().startsWith('PENDING')).length;
  
  const approvedGatepasses = monthlyGatepasses.filter(g => g.status?.toUpperCase() === 'APPROVED').length;
  const pendingGatepasses = monthlyGatepasses.filter(g => g.status?.toUpperCase().startsWith('PENDING')).length;

  // Process data for the selected month (daily breakdown)
  const chartData = useMemo(() => {
    const data = [];
    const daysInMonth = getDaysInMonth(currentMonth);
    const monthStart = startOfMonth(currentMonth);
    
    for (let i = 0; i < daysInMonth; i++) {
      const dayDate = addDays(monthStart, i);
      const dayLabel = format(dayDate, 'dd'); 
      
      const leavesOnDay = monthlyLeaves.filter(l => {
        if (!l.from_date || l.status?.toUpperCase() !== 'APPROVED') return false;
        const from = startOfDay(parseISO(l.from_date));
        const to = l.to_date ? endOfDay(parseISO(l.to_date)) : endOfDay(parseISO(l.from_date));
        return dayDate >= from && dayDate <= to;
      }).length;
      
      const gatepassesOnDay = monthlyGatepasses.filter(g => {
        if (!g.out_time || g.status?.toUpperCase() !== 'APPROVED') return false;
        return isSameDay(parseISO(g.out_time), dayDate);
      }).length;

      data.push({
        name: dayLabel,
        Leaves: leavesOnDay,
        Gatepasses: gatepassesOnDay
      });
    }
    return data;
  }, [monthlyLeaves, monthlyGatepasses, currentMonth]);

  // Calculate dynamic ticks that are multiples of 2
  const yTicks = useMemo(() => {
    const maxActivity = Math.max(
      ...chartData.map(d => Math.max(d.Leaves || 0, d.Gatepasses || 0)),
      4 // Ensure it goes up to at least 4 for visual padding
    );
    const maxEven = Math.ceil(maxActivity / 2) * 2;
    const ticks = [];
    for (let i = 0; i <= maxEven; i += 2) {
      ticks.push(i);
    }
    return ticks;
  }, [chartData]);

  // Separate history lists (using monthly data)
  const leaveHistory = useMemo(() => {
    return monthlyLeaves
      .map(l => ({
        id: l.id,
        date: l.from_date,
        type: l.leave_type || 'Leave',
        reason: l.reason,
        status: l.status,
        rawDate: l.from_date ? new Date(l.from_date).getTime() : 0
      }))
      .sort((a, b) => b.rawDate - a.rawDate);
  }, [monthlyLeaves]);

  const gatepassHistory = useMemo(() => {
    return monthlyGatepasses
      .map(g => ({
        id: g.id,
        date: g.out_time,
        reason: g.purpose,
        status: g.status,
        rawDate: g.out_time ? new Date(g.out_time).getTime() : 0
      }))
      .sort((a, b) => b.rawDate - a.rawDate);
  }, [monthlyGatepasses]);

  const StatusBadge = ({ status }) => {
    const s = status?.toUpperCase() || '';
    if (s === 'APPROVED') return <span className="px-2 py-1 text-[10px] font-bold rounded-md bg-emerald-50 text-emerald-700 border border-emerald-200 uppercase">Approved</span>;
    if (s.startsWith('PENDING')) return <span className="px-2 py-1 text-[10px] font-bold rounded-md bg-amber-50 text-amber-700 border border-amber-200 uppercase">Pending</span>;
    if (s === 'REJECTED') return <span className="px-2 py-1 text-[10px] font-bold rounded-md bg-red-50 text-red-700 border border-red-200 uppercase">Rejected</span>;
    return <span className="px-2 py-1 text-[10px] font-bold rounded-md bg-slate-50 text-slate-700 border border-slate-200 uppercase">{status}</span>;
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/40 backdrop-blur-sm p-4 md:p-6">
      <div className="bg-white w-full max-w-[90vw] md:max-w-7xl h-[90vh] md:h-[85vh] rounded-[32px] shadow-2xl overflow-hidden transform transition-all animate-in fade-in zoom-in duration-200 flex flex-col">
        
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-slate-100 bg-slate-50/50 shrink-0">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-white text-2xl font-bold shadow-md shadow-indigo-200">
              {faculty.first_name?.charAt(0) || 'U'}
            </div>
            <div>
              <h3 className="text-2xl font-bold text-slate-900">{faculty.first_name} {faculty.last_name}</h3>
              <p className="text-sm font-semibold text-slate-500 uppercase tracking-wider mt-1">
                {faculty.employee_id || 'ID N/A'}
              </p>
            </div>
          </div>
          <button 
            onClick={onClose}
            className="w-10 h-10 rounded-full bg-white border border-slate-200 flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-50 transition-colors shadow-sm"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content Body - Scrollable */}
        <div className="flex-1 overflow-y-auto p-6 flex flex-col lg:flex-row gap-8 bg-slate-50/30">
          
          {/* Left Column (Profile & Stats) */}
          <div className="w-full lg:w-[320px] shrink-0 space-y-6 pb-8">
            
            <div className="bg-white rounded-3xl p-5 border border-slate-100 shadow-sm">
              <h4 className="text-[12px] font-bold text-slate-400 uppercase tracking-wider mb-4 px-1">Professional Info</h4>
              <div className="space-y-3">
                <div className="flex items-center gap-4 p-3 rounded-2xl hover:bg-slate-50 transition-colors">
                  <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center shrink-0">
                    <Building className="w-5 h-5 text-indigo-600" />
                  </div>
                  <div className="min-w-0">
                    <p className="text-[11px] font-bold text-slate-400 uppercase">Department</p>
                    <p className="font-semibold text-slate-800 truncate">{department?.name || 'Unassigned'}</p>
                  </div>
                </div>
                <div className="flex items-center gap-4 p-3 rounded-2xl hover:bg-slate-50 transition-colors">
                  <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center shrink-0">
                    <Briefcase className="w-5 h-5 text-indigo-600" />
                  </div>
                  <div className="min-w-0">
                    <p className="text-[11px] font-bold text-slate-400 uppercase">Designation</p>
                    <p className="font-semibold text-slate-800 truncate">{faculty.designation || 'Faculty Member'}</p>
                  </div>
                </div>
                <div className="flex items-center gap-4 p-3 rounded-2xl hover:bg-slate-50 transition-colors">
                  <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center shrink-0">
                    <Mail className="w-5 h-5 text-indigo-600" />
                  </div>
                  <div className="min-w-0">
                    <p className="text-[11px] font-bold text-slate-400 uppercase">Email</p>
                    <p className="font-semibold text-slate-800 truncate">{faculty.college_email || 'Not provided'}</p>
                  </div>
                </div>
                <div className="flex items-center gap-4 p-3 rounded-2xl hover:bg-slate-50 transition-colors">
                  <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center shrink-0">
                    <Phone className="w-5 h-5 text-indigo-600" />
                  </div>
                  <div className="min-w-0">
                    <p className="text-[11px] font-bold text-slate-400 uppercase">Phone</p>
                    <p className="font-semibold text-slate-800 truncate">{faculty.phone || 'Not provided'}</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-3xl p-5 border border-slate-100 shadow-sm space-y-4">
              <h4 className="text-[12px] font-bold text-slate-400 uppercase tracking-wider mb-2 px-1">Activity for {format(currentMonth, 'MMM yyyy')}</h4>
              
              <div className="p-4 rounded-2xl border border-indigo-100 bg-indigo-50/50">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-8 h-8 bg-indigo-500 rounded-lg flex items-center justify-center text-white shadow-sm">
                    <FileText className="w-4 h-4" />
                  </div>
                  <span className="font-bold text-indigo-900 text-[15px]">Leave Records</span>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div className="bg-white p-2.5 rounded-xl border border-indigo-100 text-center">
                    <div className="text-xl font-black text-indigo-600">{approvedLeaves}</div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase mt-0.5">Approved</div>
                  </div>
                  <div className="bg-white p-2.5 rounded-xl border border-indigo-100 text-center">
                    <div className="text-xl font-black text-amber-500">{pendingLeaves}</div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase mt-0.5">Pending</div>
                  </div>
                </div>
              </div>

              <div className="p-4 rounded-2xl border border-sky-100 bg-sky-50/50">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-8 h-8 bg-sky-500 rounded-lg flex items-center justify-center text-white shadow-sm">
                    <Clock className="w-4 h-4" />
                  </div>
                  <span className="font-bold text-sky-900 text-[15px]">Gatepass Records</span>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div className="bg-white p-2.5 rounded-xl border border-sky-100 text-center">
                    <div className="text-xl font-black text-sky-600">{approvedGatepasses}</div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase mt-0.5">Approved</div>
                  </div>
                  <div className="bg-white p-2.5 rounded-xl border border-sky-100 text-center">
                    <div className="text-xl font-black text-amber-500">{pendingGatepasses}</div>
                    <div className="text-[10px] font-bold text-slate-500 uppercase mt-0.5">Pending</div>
                  </div>
                </div>
              </div>

            </div>
          </div>

          {/* Right Column (Graph & Histories) */}
          <div className="flex-1 space-y-6 min-w-0 pb-8">
            
            {/* Month Selector */}
            <div className="flex items-center justify-between bg-white p-4 rounded-3xl border border-slate-100 shadow-sm">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-600">
                  <CalendarIcon className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 text-base">Monthly Report</h3>
                  <p className="text-xs text-slate-500">Showing data for {format(currentMonth, 'MMMM yyyy')}</p>
                </div>
              </div>
              
              <div className="flex items-center gap-2">
                <button 
                  onClick={() => setCurrentMonth(subMonths(currentMonth, 1))}
                  className="p-2 rounded-xl bg-slate-50 hover:bg-slate-100 text-slate-600 transition-colors border border-slate-100"
                >
                  <ChevronLeft className="w-5 h-5" />
                </button>
                <span className="font-bold text-slate-700 min-w-[120px] text-center">
                  {format(currentMonth, 'MMMM yyyy')}
                </span>
                <button 
                  onClick={() => setCurrentMonth(addMonths(currentMonth, 1))}
                  className="p-2 rounded-xl bg-slate-50 hover:bg-slate-100 text-slate-600 transition-colors border border-slate-100"
                >
                  <ChevronRight className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Graph Analysis */}
            <div className="bg-white rounded-3xl p-6 border border-slate-100 shadow-sm">
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 bg-violet-100 rounded-xl flex items-center justify-center text-violet-600">
                  <Activity className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 text-lg">Activity Trend</h3>
                  <p className="text-sm text-slate-500">Daily breakdown for {format(currentMonth, 'MMMM yyyy')}</p>
                </div>
              </div>
              <div className="h-[250px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={chartData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <defs>
                      <linearGradient id="colorLeaves" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#6366f1" stopOpacity={0.3}/>
                        <stop offset="95%" stopColor="#6366f1" stopOpacity={0}/>
                      </linearGradient>
                      <linearGradient id="colorGatepasses" x1="0" y1="0" x2="0" y2="1">
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
                    <Legend iconType="circle" wrapperStyle={{ fontSize: '13px', paddingTop: '10px' }} />
                    <Area type="monotone" dataKey="Leaves" stroke="#6366f1" strokeWidth={3} fillOpacity={1} fill="url(#colorLeaves)" />
                    <Area type="monotone" dataKey="Gatepasses" stroke="#0ea5e9" strokeWidth={3} fillOpacity={1} fill="url(#colorGatepasses)" />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Leave Balances Section */}
            {leaveBalances && (
              <div className="bg-white rounded-3xl p-6 border border-slate-100 shadow-sm">
                <div className="flex items-center justify-between mb-6">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center text-emerald-600">
                      <Check className="w-5 h-5" />
                    </div>
                    <div>
                      <h3 className="font-bold text-slate-900 text-lg">Leave Balances</h3>
                      <p className="text-sm text-slate-500">Academic Year {leaveBalances.academic_year}</p>
                    </div>
                  </div>
                  {allowEdit && (
                    <div className="flex items-center gap-2">
                      {isEditing && (
                        <button
                          onClick={() => setIsEditing(false)}
                          disabled={isSaving}
                          className="px-3 py-1.5 bg-slate-100 text-slate-600 hover:bg-slate-200 rounded-lg text-sm font-bold transition-colors"
                        >
                          Cancel
                        </button>
                      )}
                      <button
                        onClick={() => {
                          if (isEditing) {
                            handleSaveBalances();
                          } else {
                            setEditBalances({
                              casual_leaves_total: leaveBalances.casual_leaves_total,
                              restricted_leaves_total: leaveBalances.restricted_leaves_total,
                              earned_leaves_total: leaveBalances.earned_leaves_total,
                              vacation_leaves_total: leaveBalances.vacation_leaves_total,
                              academic_leaves_total: leaveBalances.academic_leaves_total,
                              compensation_leaves_total: leaveBalances.compensation_leaves_total,
                            });
                            setIsEditing(true);
                          }
                        }}
                        disabled={isSaving}
                        className="flex items-center gap-2 px-3 py-1.5 bg-indigo-50 text-indigo-700 hover:bg-indigo-100 rounded-lg text-sm font-bold transition-colors"
                      >
                        {isEditing ? (
                          <>{isSaving ? 'Saving...' : <><Save className="w-4 h-4" /> Save</>}</>
                        ) : (
                          <><Edit2 className="w-4 h-4" /> Edit</>
                        )}
                      </button>
                    </div>
                  )}
                </div>

                <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                  {[
                    { label: 'Casual Leave', key_total: 'casual_leaves_total', key_used: 'casual_leaves_used' },
                    { label: 'Restricted Leave', key_total: 'restricted_leaves_total', key_used: 'restricted_leaves_used' },
                    { label: 'Earned Leave', key_total: 'earned_leaves_total', key_used: 'earned_leaves_used' },
                    { label: 'Vacation Leave', key_total: 'vacation_leaves_total', key_used: 'vacation_leaves_used' },
                    { label: 'Academic Leave', key_total: 'academic_leaves_total', key_used: 'academic_leaves_used' }
                  ].map((leave) => (
                    <div key={leave.label} className="bg-slate-50/50 p-4 rounded-2xl border border-slate-100 flex flex-col justify-between">
                      <p className="text-[11px] font-bold text-slate-500 uppercase tracking-wide mb-2">{leave.label}</p>
                      <div className="flex items-end justify-between mt-auto">
                        <div className="text-sm font-semibold text-slate-700">
                          <span className="text-slate-400">Used:</span> {leaveBalances[leave.key_used]}
                        </div>
                        <div className="flex items-center text-lg font-bold text-slate-900">
                          {isEditing ? (
                            <div className="flex items-center gap-1">
                              <span className="text-indigo-600">{editBalances[leave.key_total] - leaveBalances[leave.key_used]}</span>
                              <span className="text-slate-300 mx-1">/</span>
                              <input
                                type="number"
                                className="w-16 p-1 border border-slate-300 rounded text-center text-sm font-bold bg-white"
                                value={editBalances[leave.key_total] || 0}
                                onChange={(e) => setEditBalances({...editBalances, [leave.key_total]: parseInt(e.target.value) || 0})}
                                min="0"
                              />
                            </div>
                          ) : (
                            <>
                              <span className="text-indigo-600 mr-1">
                                {leaveBalances[leave.key_total] - leaveBalances[leave.key_used]}
                              </span>
                              <span className="text-slate-300 mx-1">/</span>
                              <span>{leaveBalances[leave.key_total]}</span>
                            </>
                          )}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
                
                {/* Separated Compensation Leave */}
                <div className="mt-4 bg-indigo-50/50 p-4 rounded-2xl border border-indigo-100 flex flex-col justify-between">
                  <p className="text-[12px] font-bold text-indigo-900 uppercase tracking-wide mb-2">Compensation Leave (Earned via Registry)</p>
                  <div className="flex items-end justify-between mt-auto">
                    <div className="text-sm font-semibold text-indigo-700">
                      <span className="text-indigo-400">Used:</span> {leaveBalances.compensation_leaves_used}
                    </div>
                    <div className="flex items-center text-lg font-bold text-indigo-900">
                      {isEditing ? (
                        <div className="flex items-center gap-1">
                          <span className="text-indigo-600">{editBalances.compensation_leaves_total - leaveBalances.compensation_leaves_used}</span>
                          <span className="text-indigo-300 mx-1">/</span>
                          <input
                            type="number"
                            className="w-16 p-1 border border-indigo-300 rounded text-center text-sm font-bold bg-white"
                            value={editBalances.compensation_leaves_total || 0}
                            onChange={(e) => setEditBalances({...editBalances, compensation_leaves_total: parseInt(e.target.value) || 0})}
                            min="0"
                          />
                        </div>
                      ) : (
                        <>
                          <span className="text-indigo-600 mr-1">
                            {leaveBalances.compensation_leaves_total - leaveBalances.compensation_leaves_used}
                          </span>
                          <span className="text-indigo-300 mx-1">/</span>
                          <span>{leaveBalances.compensation_leaves_total}</span>
                        </>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Separated History Tables */}
            <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
              
              {/* Leaves Table */}
              <div className="bg-white rounded-3xl p-6 border border-slate-100 shadow-sm">
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-10 h-10 bg-indigo-100 rounded-xl flex items-center justify-center text-indigo-600">
                    <FileText className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="font-bold text-slate-900 text-lg">Leaves History</h3>
                    <p className="text-sm text-slate-500">Recent leave requests</p>
                  </div>
                </div>
                
                <div className="overflow-x-auto">
                  {leaveHistory.length === 0 ? (
                    <div className="text-center py-8">
                      <p className="text-slate-500 font-medium text-sm">No leaves found.</p>
                    </div>
                  ) : (
                    <table className="w-full text-left border-collapse">
                      <thead>
                        <tr className="border-b border-slate-100">
                          <th className="py-2 px-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider">Date & Type</th>
                          <th className="py-2 px-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider">Reason</th>
                          <th className="py-2 px-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider text-right">Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        {leaveHistory.map(item => (
                          <tr key={item.id} className="border-b border-slate-50 hover:bg-slate-50/50 transition-colors">
                            <td className="py-3 px-2">
                              <div className="text-sm font-semibold text-slate-700">
                                {item.date ? format(parseISO(item.date), 'dd MMM yyyy') : 'N/A'}
                              </div>
                              <div className="text-[11px] font-medium text-indigo-600 mt-0.5">
                                {item.type}
                              </div>
                            </td>
                            <td className="py-3 px-2 text-[13px] font-medium text-slate-600 max-w-[150px] truncate">
                              {item.reason || '—'}
                            </td>
                            <td className="py-3 px-2 text-right">
                              <StatusBadge status={item.status} />
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  )}
                </div>
              </div>

              {/* Gatepasses Table */}
              <div className="bg-white rounded-3xl p-6 border border-slate-100 shadow-sm">
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-10 h-10 bg-sky-100 rounded-xl flex items-center justify-center text-sky-600">
                    <Clock className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="font-bold text-slate-900 text-lg">Gatepass History</h3>
                    <p className="text-sm text-slate-500">Recent gatepass requests</p>
                  </div>
                </div>
                
                <div className="overflow-x-auto">
                  {gatepassHistory.length === 0 ? (
                    <div className="text-center py-8">
                      <p className="text-slate-500 font-medium text-sm">No gatepasses found.</p>
                    </div>
                  ) : (
                    <table className="w-full text-left border-collapse">
                      <thead>
                        <tr className="border-b border-slate-100">
                          <th className="py-2 px-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider">Date</th>
                          <th className="py-2 px-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider">Purpose</th>
                          <th className="py-2 px-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider text-right">Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        {gatepassHistory.map(item => (
                          <tr key={item.id} className="border-b border-slate-50 hover:bg-slate-50/50 transition-colors">
                            <td className="py-3 px-2 text-sm font-semibold text-slate-700">
                              {item.date ? format(parseISO(item.date), 'dd MMM yyyy') : 'N/A'}
                            </td>
                            <td className="py-3 px-2 text-[13px] font-medium text-slate-600 max-w-[150px] truncate">
                              {item.reason || '—'}
                            </td>
                            <td className="py-3 px-2 text-right">
                              <StatusBadge status={item.status} />
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  )}
                </div>
              </div>

            </div>
            
            {/* Workload Section (Optional) */}
            {workload && (
              <div className="bg-white rounded-3xl p-6 border border-slate-100 shadow-sm mt-6">
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-10 h-10 bg-fuchsia-100 rounded-xl flex items-center justify-center text-fuchsia-600">
                    <BookOpen className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="font-bold text-slate-900 text-lg">Assigned Workload</h3>
                    <p className="text-sm text-slate-500">Current active courses and sections</p>
                  </div>
                </div>

                {workload.error ? (
                  <div className="bg-red-50 text-red-600 p-4 rounded-xl text-sm font-medium border border-red-100">
                    {workload.error}
                  </div>
                ) : (
                  <div className="space-y-6">
                    {/* Summary Cards */}
                    <div className="grid grid-cols-2 gap-4">
                      <div className="bg-fuchsia-50/50 p-4 rounded-2xl border border-fuchsia-100">
                        <div className="flex items-center justify-between">
                          <div>
                            <p className="text-[11px] font-bold text-fuchsia-600 uppercase tracking-wide mb-1">Total Courses</p>
                            <p className="text-3xl font-bold text-fuchsia-900">{workload.total_active_courses}</p>
                          </div>
                          <BookOpen className="w-8 h-8 text-fuchsia-300" />
                        </div>
                      </div>
                      <div className="bg-pink-50/50 p-4 rounded-2xl border border-pink-100">
                        <div className="flex items-center justify-between">
                          <div>
                            <p className="text-[11px] font-bold text-pink-600 uppercase tracking-wide mb-1">Total Hours</p>
                            <p className="text-3xl font-bold text-pink-900">{workload.total_hours}</p>
                          </div>
                          <GraduationCap className="w-8 h-8 text-pink-300" />
                        </div>
                      </div>
                    </div>

                    {/* Course List */}
                    {workload.courses?.length === 0 ? (
                      <div className="bg-slate-50 rounded-2xl p-8 text-center border border-slate-100">
                        <BookOpen className="w-10 h-10 text-slate-300 mx-auto mb-3" />
                        <h3 className="text-base font-bold text-slate-900 mb-1">No Courses Assigned</h3>
                        <p className="text-slate-500 text-sm">This faculty member has no active course assignments.</p>
                      </div>
                    ) : (
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        {workload.courses?.map((course) => (
                          <div key={course.id} className="bg-white border border-slate-200 rounded-2xl p-4 hover:border-fuchsia-200 hover:shadow-md transition-all group">
                            <div className="flex flex-wrap gap-2 mb-3">
                              <span className="bg-indigo-50 text-indigo-700 text-[10px] font-bold px-2 py-1 rounded uppercase tracking-wide">
                                {course.course_code}
                              </span>
                              <span className="bg-slate-100 text-slate-700 text-[10px] font-bold px-2 py-1 rounded uppercase tracking-wide">
                                Sem {course.semester}
                              </span>
                              <span className="bg-fuchsia-50 text-fuchsia-700 text-[10px] font-bold px-2 py-1 rounded uppercase tracking-wide">
                                {course.periods} {course.periods === 1 ? 'Hour' : 'Hours'}/Week
                              </span>
                            </div>
                            <h4 className="text-sm font-bold text-slate-900 mb-2 leading-snug group-hover:text-indigo-600 transition-colors">{course.course_name}</h4>
                            <div className="flex items-center space-x-4 text-xs text-slate-500 font-medium">
                              <span className="flex items-center gap-1.5">
                                <Users className="w-3.5 h-3.5" />
                                {course.section}
                              </span>
                              <span className="flex items-center gap-1.5">
                                <BookOpen className="w-3.5 h-3.5" />
                                {course.course_type}
                              </span>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}

            {/* Bottom Spacer */}
            <div className="h-4 w-full shrink-0"></div>
          </div>
        </div>
      </div>
    </div>
  );
};
