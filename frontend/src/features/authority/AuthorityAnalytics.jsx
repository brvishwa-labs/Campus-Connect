import React, { useEffect, useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { 
  Users, UserCheck, RefreshCw, AlertCircle, Award, Clock, PieChart as PieChartIcon
} from 'lucide-react';
import {
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer,
  BarChart as RechartsBarChart, Bar, Legend,
  Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis,
  LineChart, Line, PieChart, Pie, Cell
} from 'recharts';
import axios from 'axios';

const COLORS = ['#4f46e5', '#ec4899', '#10b981', '#f59e0b'];
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const AuthorityAnalytics = () => {
  const { user } = useAuth();
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedDept, setSelectedDept] = useState("ALL");
  const [selectedYear, setSelectedYear] = useState("ALL");
  const [selectedSection, setSelectedSection] = useState("ALL");

  // Reset dependent dropdowns when parent changes
  useEffect(() => {
    setSelectedYear("ALL");
    setSelectedSection("ALL");
  }, [selectedDept]);

  useEffect(() => {
    setSelectedSection("ALL");
  }, [selectedYear]);

  const fetchDashboardStats = async () => {
    setError(null);
    try {
      const token = localStorage.getItem('token');
      // Using dean stats endpoint for data source
      const response = await axios.get(`${API_BASE_URL}/api/dashboard/dean/stats`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      setStats(response.data);
    } catch (error) {
      console.error('Error fetching dashboard stats:', error);
      setError(error.response?.data?.detail || error.message || 'Failed to load analytics data');
    } finally {
      setLoading(false);
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

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <RefreshCw className="w-8 h-8 text-primary-500 animate-spin mx-auto mb-3" />
          <p className="text-gray-500">Loading analytics...</p>
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
            <h4 className="font-semibold text-red-900 text-sm">Unable to load analytics data</h4>
            <p className="text-xs text-red-700 mt-1">{error}</p>
          </div>
        </div>
      )}

      {/* ═══════════════════════════════════════════════════════════
          DETAILED ANALYSIS SECTION
      ═══════════════════════════════════════════════════════════ */}
      <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 gap-4">
          <div>
            <h3 className="text-[18px] font-extrabold text-gray-900">Detailed Analysis</h3>
            <p className="text-[12px] text-gray-500">Department-wise demographic & faculty breakdowns</p>
          </div>
          <div>
            <select
              value={selectedDept}
              onChange={(e) => setSelectedDept(e.target.value)}
              className="bg-gray-50 border border-gray-200 text-gray-700 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full p-2.5"
            >
              <option value="ALL">All Departments</option>
              {stats?.attendance_by_department?.map(dept => (
                <option key={dept.department_code} value={dept.department_code}>
                  {dept.department_name} ({dept.department_code})
                </option>
              ))}
            </select>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* 30-Day Student Attendance Trend (Area Chart) */}
          <div className="bg-gray-50/50 rounded-xl p-4 border border-gray-100">
            <h4 className="text-sm font-bold text-gray-800 mb-4 flex items-center gap-2">
              <Users className="w-4 h-4 text-indigo-500" />
              30-Day Student Attendance Trend
            </h4>
            <div className="h-[280px]">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={stats?.monthly_attendance_trend?.[selectedDept] || []} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="colorBoys" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#4f46e5" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="#4f46e5" stopOpacity={0}/>
                    </linearGradient>
                    <linearGradient id="colorGirls" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#ec4899" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="#ec4899" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <XAxis 
                    dataKey="date" 
                    axisLine={false} 
                    tickLine={false} 
                    tick={{ fontSize: 10, fill: '#6b7280' }} 
                    dy={10}
                    interval={1}
                    tickFormatter={(str) => {
                      const date = new Date(str);
                      return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                    }}
                  />
                  <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dx={-10} />
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                  <RechartsTooltip 
                    content={({ active, payload, label }) => {
                      if (active && payload && payload.length) {
                        return (
                          <div className="bg-white p-3 rounded-xl border border-gray-100 shadow-lg">
                            <p className="text-gray-600 font-medium mb-2">{new Date(label).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}</p>
                            {payload.map((entry, index) => {
                               const isBoys = entry.name.includes("Boys");
                               const pct = isBoys ? entry.payload.boys_percent : entry.payload.girls_percent;
                               const total = isBoys ? entry.payload.boys_total : entry.payload.girls_total;
                               return (
                                 <div key={index} className="flex items-center gap-2 mb-1 text-sm">
                                    <span style={{color: entry.color}}>●</span>
                                    <span className="font-semibold" style={{color: entry.color}}>{entry.name}:</span>
                                    <span className="text-gray-700">{entry.value} / {total} present ({pct}%)</span>
                                 </div>
                               );
                            })}
                          </div>
                        );
                      }
                      return null;
                    }}
                  />
                  <Legend iconType="circle" wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }} />
                  <Area type="monotone" dataKey="boys_present" name="Boys" stroke="#4f46e5" strokeWidth={3} fillOpacity={1} fill="url(#colorBoys)" activeDot={{ r: 5 }} />
                  <Area type="monotone" dataKey="girls_present" name="Girls" stroke="#ec4899" strokeWidth={3} fillOpacity={1} fill="url(#colorGirls)" activeDot={{ r: 5 }} />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* 30-Day Faculty Presence Trend (Area Chart) */}
          <div className="bg-gray-50/50 rounded-xl p-4 border border-gray-100">
            <h4 className="text-sm font-bold text-gray-800 mb-4 flex items-center gap-2">
              <UserCheck className="w-4 h-4 text-emerald-500" />
              30-Day Faculty Presence Trend
            </h4>
            <div className="h-[280px]">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={stats?.monthly_attendance_trend?.[selectedDept] || []} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="colorFac" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#10b981" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="#10b981" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <XAxis 
                    dataKey="date" 
                    axisLine={false} 
                    tickLine={false} 
                    tick={{ fontSize: 10, fill: '#6b7280' }} 
                    dy={10}
                    tickFormatter={(str) => {
                      const date = new Date(str);
                      return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                    }}
                    minTickGap={20}
                  />
                  <YAxis domain={[0, 100]} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dx={-10} />
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                  <RechartsTooltip 
                    contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                    labelFormatter={(label) => new Date(label).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}
                  />
                  <Legend iconType="circle" wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }} />
                  <Area type="monotone" dataKey="faculty_present_percent" name="Faculty Present (%)" stroke="#10b981" strokeWidth={3} fillOpacity={1} fill="url(#colorFac)" />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </div>
          
        </div>
      </div>

      {/* ═══════════════════════════════════════════════════════════
          ACADEMIC PERFORMANCE & LATE ARRIVALS
      ═══════════════════════════════════════════════════════════ */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* Academic Performance (Radar/Bar Chart) */}
        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex flex-col">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-4 gap-4">
            <div>
              <h4 className="text-sm font-bold text-gray-800 flex items-center gap-2">
                <Award className="w-4 h-4 text-yellow-500" />
                Academic Performance Matrix
              </h4>
              <p className="text-[12px] text-gray-500">Pass percentage distribution</p>
            </div>
            
            {/* Drill Down Filters */}
            <div className="flex items-center gap-2">
              {selectedDept !== "ALL" && (
                <select
                  value={selectedYear}
                  onChange={(e) => setSelectedYear(e.target.value)}
                  className="bg-gray-50 border border-gray-200 text-gray-700 text-xs rounded-md focus:ring-primary-500 focus:border-primary-500 p-1.5"
                >
                  <option value="ALL">All Years</option>
                  {(stats?.academic_performance || [])
                    .find(d => d.department_code === selectedDept)?.years.map(y => (
                      <option key={y.year} value={y.year}>Year {y.year}</option>
                  ))}
                </select>
              )}
              {selectedDept !== "ALL" && selectedYear !== "ALL" && (
                <select
                  value={selectedSection}
                  onChange={(e) => setSelectedSection(e.target.value)}
                  className="bg-gray-50 border border-gray-200 text-gray-700 text-xs rounded-md focus:ring-primary-500 focus:border-primary-500 p-1.5"
                >
                  <option value="ALL">All Sections</option>
                  {(stats?.academic_performance || [])
                    .find(d => d.department_code === selectedDept)
                    ?.years.find(y => y.year.toString() === selectedYear)
                    ?.sections.map(s => (
                      <option key={s.section_name} value={s.section_name}>Section {s.section_name}</option>
                  ))}
                </select>
              )}
            </div>
          </div>
          
          <div className="h-[280px]">
            <ResponsiveContainer width="100%" height="100%">
              {(() => {
                if (selectedDept === "ALL") {
                  // Level 1: All Departments Radar Chart
                  return (
                    <RadarChart cx="50%" cy="50%" outerRadius="70%" data={stats?.academic_performance || []}>
                      <PolarGrid stroke="#e5e7eb" />
                      <PolarAngleAxis dataKey="department_code" tick={{ fill: '#6b7280', fontSize: 12 }} />
                      <PolarRadiusAxis angle={30} domain={[0, 100]} tick={{ fill: '#9ca3af', fontSize: 10 }} />
                      <Radar name="Pass %" dataKey="pass_percent" stroke="#f59e0b" fill="#f59e0b" fillOpacity={0.5} />
                      <RechartsTooltip contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }} />
                    </RadarChart>
                  );
                } else if (selectedYear === "ALL") {
                  // Level 2: Years within a Department
                  const deptData = (stats?.academic_performance || []).find(d => d.department_code === selectedDept);
                  const yearData = deptData?.years?.map(y => ({ name: `Year ${y.year}`, pass_percent: y.pass_percent })) || [];
                  return (
                    <RechartsBarChart data={yearData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                      <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dy={10} />
                      <YAxis domain={[0, 100]} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dx={-10} />
                      <RechartsTooltip cursor={{ fill: '#f3f4f6' }} contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }} />
                      <Legend iconType="circle" wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }} />
                      <Bar dataKey="pass_percent" name="Pass %" fill="#f59e0b" radius={[4, 4, 0, 0]} maxBarSize={60} />
                    </RechartsBarChart>
                  );
                } else if (selectedSection === "ALL") {
                  // Level 3: Sections within a Year
                  const deptData = (stats?.academic_performance || []).find(d => d.department_code === selectedDept);
                  const yearData = deptData?.years?.find(y => y.year.toString() === selectedYear);
                  const sectionData = yearData?.sections?.map(s => ({ name: `Section ${s.section_name}`, pass_percent: s.pass_percent })) || [];
                  return (
                    <RechartsBarChart data={sectionData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                      <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dy={10} />
                      <YAxis domain={[0, 100]} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dx={-10} />
                      <RechartsTooltip cursor={{ fill: '#f3f4f6' }} contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }} />
                      <Legend iconType="circle" wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }} />
                      <Bar dataKey="pass_percent" name="Pass %" fill="#ec4899" radius={[4, 4, 0, 0]} maxBarSize={60} />
                    </RechartsBarChart>
                  );
                } else {
                  // Level 4: Specific Section
                  const deptData = (stats?.academic_performance || []).find(d => d.department_code === selectedDept);
                  const yearData = deptData?.years?.find(y => y.year.toString() === selectedYear);
                  const sectionData = yearData?.sections?.find(s => s.section_name === selectedSection);
                  const singleData = sectionData ? [{ name: `Sec ${sectionData.section_name}`, pass_percent: sectionData.pass_percent }] : [];
                  return (
                    <RechartsBarChart data={singleData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                      <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dy={10} />
                      <YAxis domain={[0, 100]} axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dx={-10} />
                      <RechartsTooltip cursor={{ fill: '#f3f4f6' }} contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }} />
                      <Legend iconType="circle" wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }} />
                      <Bar dataKey="pass_percent" name="Pass %" fill="#10b981" radius={[4, 4, 0, 0]} maxBarSize={60} />
                    </RechartsBarChart>
                  );
                }
              })()}
            </ResponsiveContainer>
          </div>
        </div>

        {/* Campus Discipline & Late Trends (Line Chart) */}
        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
          <h4 className="text-sm font-bold text-gray-800 mb-4 flex items-center gap-2">
            <Clock className="w-4 h-4 text-red-500" />
            Late Arrival Trends (30 Days)
          </h4>
          <p className="text-[12px] text-gray-500 mb-4">Tracking campus punctuality over the last month</p>
          <div className="h-[280px]">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={stats?.late_trend?.[selectedDept] || []} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                <defs>
                  <linearGradient id="colorBoysLate" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#4f46e5" stopOpacity={0.3}/>
                    <stop offset="95%" stopColor="#4f46e5" stopOpacity={0}/>
                  </linearGradient>
                  <linearGradient id="colorGirlsLate" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#ec4899" stopOpacity={0.3}/>
                    <stop offset="95%" stopColor="#ec4899" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                <XAxis 
                  dataKey="date" 
                  tickFormatter={(str) => {
                    const date = new Date(str);
                    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
                  }}
                  axisLine={false} tickLine={false} tick={{ fontSize: 10, fill: '#6b7280' }} dy={10} interval={1}
                />
                <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} dx={-10} />
                <RechartsTooltip 
                  content={({ active, payload, label }) => {
                    if (active && payload && payload.length) {
                      return (
                        <div className="bg-white p-3 rounded-xl border border-gray-100 shadow-lg">
                          <p className="text-gray-600 font-medium mb-2">{new Date(label).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}</p>
                          {payload.map((entry, index) => {
                             return (
                               <div key={index} className="flex items-center gap-2 mb-1 text-sm">
                                  <span style={{color: entry.color}}>●</span>
                                  <span className="font-semibold" style={{color: entry.color}}>{entry.name}:</span>
                                  <span className="text-gray-700">{entry.value} late</span>
                               </div>
                             );
                          })}
                        </div>
                      );
                    }
                    return null;
                  }}
                />
                <Legend iconType="circle" wrapperStyle={{ fontSize: '12px', paddingTop: '10px' }} />
                <Area type="monotone" dataKey="boys_late" name="Boys" stroke="#4f46e5" strokeWidth={3} fillOpacity={1} fill="url(#colorBoysLate)" activeDot={{ r: 5 }} />
                <Area type="monotone" dataKey="girls_late" name="Girls" stroke="#ec4899" strokeWidth={3} fillOpacity={1} fill="url(#colorGirlsLate)" activeDot={{ r: 5 }} />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>

      {/* ═══════════════════════════════════════════════════════════
          STUDENT DEMOGRAPHICS (Donut Charts)
      ═══════════════════════════════════════════════════════════ */}
      <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between mb-6 gap-4">
          <div>
            <h3 className="text-[18px] font-extrabold text-gray-900">Student Logistics & Demographics</h3>
            <p className="text-[12px] text-gray-500">Overview of student accommodation and transportation distribution</p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          {/* Accommodation Donut */}
          <div className="bg-gray-50/50 rounded-xl p-4 border border-gray-100 flex flex-col items-center">
            <h4 className="text-sm font-bold text-gray-800 mb-2 flex items-center gap-2 self-start">
              <PieChartIcon className="w-4 h-4 text-blue-500" />
              Accommodation Status
            </h4>
            <div className="h-[250px] w-full">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={stats?.demographics?.[selectedDept]?.accommodation || []}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={90}
                    paddingAngle={5}
                    dataKey="value"
                    labelLine={false}
                  >
                    {(stats?.demographics?.[selectedDept]?.accommodation || []).map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                    ))}
                  </Pie>
                  <RechartsTooltip contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }} />
                  <Legend verticalAlign="bottom" height={36} iconType="circle" wrapperStyle={{ fontSize: '12px' }} />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Transportation Donut */}
          <div className="bg-gray-50/50 rounded-xl p-4 border border-gray-100 flex flex-col items-center">
            <h4 className="text-sm font-bold text-gray-800 mb-2 flex items-center gap-2 self-start">
              <PieChartIcon className="w-4 h-4 text-cyan-500" />
              Transportation Medium
            </h4>
            <div className="h-[250px] w-full">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={stats?.demographics?.[selectedDept]?.transportation || []}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={90}
                    paddingAngle={5}
                    dataKey="value"
                    labelLine={false}
                  >
                    {(stats?.demographics?.[selectedDept]?.transportation || []).map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS[(index + 2) % COLORS.length]} />
                    ))}
                  </Pie>
                  <RechartsTooltip contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }} />
                  <Legend verticalAlign="bottom" height={36} iconType="circle" wrapperStyle={{ fontSize: '12px' }} />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>
          
        </div>
      </div>
    </div>
  );
};

export default AuthorityAnalytics;
