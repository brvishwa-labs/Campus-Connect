import React, { useState, useEffect, useMemo } from 'react';
import axios from 'axios';
import { useAuth } from '../../context/AuthContext';
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight, User, AlertCircle, Clock, Info, Shield, Users, BarChart2, X, ChevronRight as ArrowRight } from 'lucide-react';
import { format, addMonths, subMonths, startOfMonth, endOfMonth, startOfWeek, endOfWeek, isSameMonth, isSameDay, addDays, parseISO, startOfDay, endOfDay } from 'date-fns';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer, Legend, BarChart, Bar } from 'recharts';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const GatepassStatusBadge = ({ status }) => {
  let colorClass = 'bg-gray-100 text-gray-700 border-gray-200';
  const upperStatus = status?.toUpperCase() || '';

  if (upperStatus === 'APPROVED') {
    colorClass = 'bg-emerald-50 text-emerald-700 border-emerald-200';
  } else if (upperStatus === 'REJECTED') {
    colorClass = 'bg-red-50 text-red-700 border-red-200';
  } else if (upperStatus.startsWith('PENDING')) {
    colorClass = 'bg-amber-50 text-amber-700 border-amber-200';
  }

  return (
    <span className={`px-2.5 py-1 text-[10px] font-bold rounded-md border uppercase tracking-wider ${colorClass}`}>
      {status?.replace('_', ' ')}
    </span>
  );
};

const PersonGatepassModal = ({ data, onClose }) => {
  if (!data) return null;
  const { person, gatepasses } = data;
  const personName = `${person.first_name} ${person.last_name}`;
  const totalApproved = gatepasses.filter(g => g.status?.toUpperCase() === 'APPROVED').length;

  // Analysis Data: Group by Month (Last 6 Months)
  const analysisData = useMemo(() => {
    const map = {};
    const now = new Date();
    // Initialize last 6 months
    for (let i = 5; i >= 0; i--) {
      map[format(subMonths(now, i), 'MMM yy')] = 0;
    }
    
    gatepasses.forEach(gp => {
      if (gp.status?.toUpperCase() === 'APPROVED' && gp.out_time) {
        const d = parseISO(gp.out_time);
        const key = format(d, 'MMM yy');
        if (map[key] !== undefined) {
          map[key] += 1;
        }
      }
    });

    return Object.keys(map).map(k => ({ name: k, Gatepasses: map[k] }));
  }, [gatepasses]);

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-gray-900/40 backdrop-blur-sm p-4">
      <div className="bg-white w-full max-w-4xl rounded-[32px] shadow-2xl flex flex-col max-h-[90vh] overflow-hidden transform transition-all">
        
        {/* Modal Header */}
        <div className="flex items-center justify-between p-6 border-b border-slate-100 bg-slate-50/50">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-white text-xl font-bold shadow-md shadow-indigo-200">
              {personName.charAt(0)}
            </div>
            <div>
              <h3 className="text-2xl font-bold text-slate-900">{personName}</h3>
              <p className="text-sm font-semibold text-slate-500 uppercase tracking-wider mt-1">
                Faculty Member
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

        <div className="flex flex-col md:flex-row flex-1 overflow-hidden">
          
          {/* Left Side: Analysis Chart */}
          <div className="w-full md:w-2/5 p-6 bg-slate-50 border-r border-slate-100 flex flex-col">
            <div className="mb-6">
              <h4 className="text-lg font-bold text-slate-900">Personal Analysis</h4>
              <p className="text-sm text-slate-500 font-medium mt-1">Gatepass trends over the last 6 months</p>
            </div>
            
            <div className="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm mb-6 flex items-center justify-between">
              <div>
                <p className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Approved</p>
                <p className="text-3xl font-black text-indigo-600">{totalApproved}</p>
              </div>
              <div className="w-12 h-12 bg-indigo-50 rounded-xl flex items-center justify-center">
                <Shield className="w-6 h-6 text-indigo-500" />
              </div>
            </div>

            <div className="flex-1 min-h-[200px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={analysisData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                  <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#64748b' }} dy={10} />
                  <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#64748b' }} allowDecimals={false} />
                  <RechartsTooltip 
                    cursor={{ fill: '#f8fafc' }}
                    contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 20px rgba(0,0,0,0.08)' }}
                  />
                  <Bar dataKey="Gatepasses" fill="#4f46e5" radius={[4, 4, 0, 0]} maxBarSize={30} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Right Side: Timeline */}
          <div className="w-full md:w-3/5 p-6 overflow-y-auto custom-scrollbar bg-white">
            <div className="mb-6">
              <h4 className="text-lg font-bold text-slate-900">Gatepass History</h4>
              <p className="text-sm text-slate-500 font-medium mt-1">Chronological record of all requests</p>
            </div>

            <div className="space-y-4">
              {gatepasses.length === 0 ? (
                <p className="text-slate-500">No history available.</p>
              ) : (
                gatepasses.map((gp, idx) => (
                  <div key={gp.id} className="relative pl-6 pb-6 border-l-2 border-slate-100 last:border-transparent last:pb-0">
                    <div className="absolute left-[-9px] top-0 w-4 h-4 rounded-full border-4 border-white bg-indigo-500 shadow-sm"></div>
                    
                    <div className="bg-white rounded-2xl border border-slate-200 p-4 shadow-sm hover:border-indigo-200 transition-colors">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <Clock className="w-4 h-4 text-indigo-500" />
                          <span className="font-bold text-slate-700 text-sm">
                            {format(parseISO(gp.out_time), 'MMM do, yyyy')}
                          </span>
                        </div>
                        <GatepassStatusBadge status={gp.status} />
                      </div>
                      
                      <div className="grid grid-cols-2 gap-4 mb-3">
                        <div className="bg-slate-50 rounded-xl p-3 border border-slate-100">
                          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Out Time</p>
                          <p className="text-sm font-semibold text-slate-700">{format(parseISO(gp.out_time), 'h:mm a')}</p>
                        </div>
                        {gp.expected_in_time && (
                          <div className="bg-slate-50 rounded-xl p-3 border border-slate-100">
                            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Expected In</p>
                            <p className="text-sm font-semibold text-slate-700">{format(parseISO(gp.expected_in_time), 'h:mm a')}</p>
                          </div>
                        )}
                      </div>

                      <div>
                        <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Reason</p>
                        <p className="text-sm text-slate-700">{gp.reason}</p>
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>

        </div>
      </div>
    </div>
  );
};

const HRGatepassPortal = () => {
  const { user } = useAuth();
  const [facultyGatepasses, setFacultyGatepasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [currentMonth, setCurrentMonth] = useState(new Date());
  const [selectedDates, setSelectedDates] = useState([startOfDay(new Date())]);
  const [lastClickedDate, setLastClickedDate] = useState(startOfDay(new Date()));

  const [selectedPerson, setSelectedPerson] = useState(null);

  const fetchGatepasses = async () => {
    try {
      setLoading(true);
      setError(null);
      const token = localStorage.getItem('token');
      
      const facRes = await axios.get(`${API_BASE_URL}/api/faculty-gatepass/tracking`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      
      setFacultyGatepasses(facRes.data);
    } catch (err) {
      console.error('Error fetching gatepasses:', err);
      setError(err.response?.data?.detail || 'Failed to fetch gatepass requests');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchGatepasses();
  }, []);

  const currentGatepasses = facultyGatepasses;
  
  // Conditional rendering flag based on selection length
  const isRangeView = selectedDates.length > 2;

  // Calendar logic
  const renderHeader = () => {
    return (
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-[22px] font-bold text-slate-900 tracking-tight">
          {format(currentMonth, 'MMMM yyyy')}
        </h2>
        <div className="flex gap-2">
          <button
            onClick={() => setCurrentMonth(subMonths(currentMonth, 1))}
            className="p-1.5 rounded-lg hover:bg-slate-100 text-slate-500 transition-colors"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>
          <button
            onClick={() => setCurrentMonth(addMonths(currentMonth, 1))}
            className="p-1.5 rounded-lg hover:bg-slate-100 text-slate-500 transition-colors"
          >
            <ChevronRight className="w-5 h-5" />
          </button>
        </div>
      </div>
    );
  };

  const renderDays = () => {
    const days = [];
    const startDate = startOfWeek(currentMonth);

    for (let i = 0; i < 7; i++) {
      days.push(
        <div key={i} className="text-center text-[13px] font-semibold text-slate-400 mb-4 uppercase tracking-wider">
          {format(addDays(startDate, i), 'EE')}
        </div>
      );
    }
    return <div className="grid grid-cols-7">{days}</div>;
  };

  const renderCells = () => {
    const monthStart = startOfMonth(currentMonth);
    const monthEnd = endOfMonth(monthStart);
    const startDate = startOfWeek(monthStart);
    const endDate = endOfWeek(monthEnd);

    const dateFormat = 'd';
    const rows = [];
    let days = [];
    let day = startDate;
    let formattedDate = '';

    while (day <= endDate) {
      for (let i = 0; i < 7; i++) {
        formattedDate = format(day, dateFormat);
        const cloneDay = day;

        const isGatepassOnDay = currentGatepasses.some(gp => {
          if (gp.status?.toUpperCase() !== 'APPROVED') return false; 
          if (!gp.out_time) return false;
          
          const outTime = parseISO(gp.out_time);
          return isSameDay(cloneDay, outTime);
        });

        const isSelected = selectedDates.some(d => isSameDay(d, cloneDay));

        days.push(
          <div
            key={day}
            onClick={(e) => {
              const normalizedClick = startOfDay(cloneDay);
              if (e.ctrlKey && e.shiftKey) {
                const newSelected = [];
                const start = lastClickedDate < normalizedClick ? lastClickedDate : normalizedClick;
                const end = lastClickedDate < normalizedClick ? normalizedClick : lastClickedDate;
                let curr = start;
                while (curr <= end) {
                  newSelected.push(curr);
                  curr = addDays(curr, 1);
                }
                setSelectedDates(newSelected);
              } else if (e.ctrlKey) {
                setSelectedDates(prev => {
                  const exists = prev.some(d => isSameDay(d, normalizedClick));
                  if (exists) return prev.filter(d => !isSameDay(d, normalizedClick));
                  return [...prev, normalizedClick];
                });
                setLastClickedDate(normalizedClick);
              } else {
                setSelectedDates([normalizedClick]);
                setLastClickedDate(normalizedClick);
              }
            }}
            className={`relative flex flex-col items-center justify-center p-2 h-[48px] cursor-pointer transition-all duration-200
              ${!isSameMonth(day, monthStart) ? 'text-slate-300' :
                isSelected ? 'text-white' : 'text-slate-700 hover:bg-slate-50 rounded-xl'
              }
            `}
          >
            {isSelected && (
              <div className="absolute inset-1 bg-indigo-600 rounded-full shadow-md shadow-indigo-200"></div>
            )}
            <span className={`relative z-10 text-[15px] ${isSelected ? 'font-bold' : 'font-medium'}`}>
              {formattedDate}
            </span>
            {isGatepassOnDay && (
              <span className={`absolute bottom-1 w-1.5 h-1.5 rounded-full z-10 
                ${isSelected ? 'bg-white' : 'bg-indigo-400'}
              `}></span>
            )}
          </div>
        );
        day = addDays(day, 1);
      }
      rows.push(
        <div className="grid grid-cols-7 gap-y-1 gap-x-1" key={day}>
          {days}
        </div>
      );
      days = [];
    }
    return <div>{rows}</div>;
  };

  // 1. Get gatepasses for the selected dates
  const gatepassesForSelectedDate = currentGatepasses.filter(gp => {
    if (gp.status?.toUpperCase() !== 'APPROVED') return false;
    if (!gp.out_time) return false;
    
    const outTime = startOfDay(parseISO(gp.out_time));
    return selectedDates.some(selectedDay => isSameDay(selectedDay, outTime));
  });

  // 2. Group them by person ID (Used when isRangeView is true)
  const groupedPersons = useMemo(() => {
    if (!isRangeView) return [];
    
    const groupMap = new Map();
    gatepassesForSelectedDate.forEach(gp => {
      const personId = gp.faculty_id;
      if (!groupMap.has(personId)) {
        groupMap.set(personId, {
          id: personId,
          person: gp.faculty,
          gatepassCount: 1
        });
      } else {
        groupMap.get(personId).gatepassCount += 1;
      }
    });
    return Array.from(groupMap.values());
  }, [gatepassesForSelectedDate, isRangeView]);

  const handlePersonClick = (personId) => {
    // Get ALL gatepasses for this person from the entire history
    const allPersonGatepasses = currentGatepasses.filter(gp => {
      return gp.faculty_id === personId;
    }).sort((a, b) => new Date(b.out_time) - new Date(a.out_time));

    const person = allPersonGatepasses[0].faculty;
      
    setSelectedPerson({
      id: personId,
      person,
      gatepasses: allPersonGatepasses
    });
  };

  const getSelectedDatesLabel = () => {
    if (selectedDates.length === 0) return 'No dates selected';
    if (selectedDates.length === 1) return `Gatepasses on ${format(selectedDates[0], 'MMM do, yyyy')}`;
    
    const sorted = [...selectedDates].sort((a, b) => a - b);
    const first = sorted[0];
    const last = sorted[sorted.length - 1];
    
    let isContinuous = true;
    for (let i = 1; i < sorted.length; i++) {
      if (!isSameDay(sorted[i], addDays(sorted[i-1], 1))) {
        isContinuous = false;
        break;
      }
    }
    
    if (isContinuous) {
      return `Gatepasses from ${format(first, 'MMM do')} to ${format(last, 'MMM do, yyyy')}`;
    }
    
    return `Gatepasses on ${sorted.length} selected dates`;
  };

  // Graphical Analysis Data Generation (Daily Graph)
  const getDailyGraphData = () => {
    const data = [];
    const monthStart = startOfMonth(currentMonth);
    const monthEnd = endOfMonth(currentMonth);
    
    let currentDay = monthStart;
    while (currentDay <= monthEnd) {
      data.push({
        date: currentDay,
        name: format(currentDay, 'd MMM'),
        dayFormat: format(currentDay, 'd'),
        Faculty: 0
      });
      currentDay = addDays(currentDay, 1);
    }
    
    const process = (passes, type) => {
      passes.forEach(gp => {
        if (gp.status?.toUpperCase() === 'APPROVED' && gp.out_time) {
          const d = parseISO(gp.out_time);
          if (isSameMonth(d, currentMonth)) {
             const dayIndex = d.getDate() - 1; 
             if (data[dayIndex]) {
               data[dayIndex][type] += 1;
             }
          }
        }
      });
    };

    process(facultyGatepasses, 'Faculty');
    return data;
  };

  const getSummaryData = () => {
    let fac = 0;
    facultyGatepasses.forEach(gp => {
      if (gp.status?.toUpperCase() === 'APPROVED' && gp.out_time && isSameMonth(parseISO(gp.out_time), currentMonth)) fac++;
    });
    return fac;
  };

  const graphData = getDailyGraphData();
  const totalMonthlyFaculty = getSummaryData();

  return (
    <div className="max-w-[1200px] mx-auto p-4 md:p-6 lg:p-8">
      
      {/* Modal Integration (Only active for range views where grouping happens) */}
      {selectedPerson && (
        <PersonGatepassModal 
          data={selectedPerson} 
          onClose={() => setSelectedPerson(null)} 
        />
      )}

      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Faculty Gatepass Tracking</h1>
        <p className="text-slate-500 mt-1 font-medium">Monitor approved faculty gatepasses across the college</p>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 rounded-xl p-4 flex items-start gap-3 mb-6">
          <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
          <p className="text-sm text-red-700 font-medium">{error}</p>
        </div>
      )}

      <div className="flex flex-col gap-8">
        
        {/* Top Section: Split Layout (Calendar | Analysis) */}
        <div className="grid lg:grid-cols-2 gap-8">
          {/* Left: Calendar Widget */}
          <div className="bg-white rounded-[32px] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 p-8 flex flex-col">
            <div className="max-w-[450px] mx-auto w-full">
              {renderHeader()}
              {renderDays()}
              {renderCells()}
              
              {/* Shortcuts Info */}
              <div className="mt-8 pt-6 border-t border-slate-100">
                <div className="flex items-start gap-3">
                  <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Info className="w-4 h-4 text-blue-500" />
                  </div>
                  <div>
                    <p className="font-semibold text-slate-800 text-sm mb-2">Selection Shortcuts</p>
                    <ul className="space-y-2 text-[13px] text-slate-600">
                      <li className="flex items-center gap-2">
                        <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Click</kbd> 
                        <span>Select a single day</span>
                      </li>
                      <li className="flex items-center gap-2">
                        <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Ctrl</kbd> + <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Click</kbd> 
                        <span>Select multiple days</span>
                      </li>
                      <li className="flex items-center gap-2">
                        <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Ctrl</kbd> + <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Shift</kbd> + <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Click</kbd> 
                        <span>Select a range</span>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Right: Graphical Analysis */}
          <div className="bg-white rounded-[32px] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 p-8 flex flex-col">
            <div className="flex items-center justify-between mb-8">
              <div>
                <h3 className="text-xl font-bold text-slate-900">Monthly Analysis</h3>
                <p className="text-sm text-slate-500 mt-1 font-medium">{format(currentMonth, 'MMMM yyyy')} Summary</p>
              </div>
              <div className="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center flex-shrink-0">
                <BarChart2 className="w-6 h-6 text-blue-600" />
              </div>
            </div>

            <div className="flex-1 min-h-[250px] mb-8">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={graphData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="colorFaculty" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#4f46e5" stopOpacity={0.3}/>
                      <stop offset="95%" stopColor="#4f46e5" stopOpacity={0}/>
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                  <XAxis dataKey="dayFormat" axisLine={false} tickLine={false} tick={{ fontSize: 10, fill: '#64748b' }} dy={10} interval="preserveStartEnd" minTickGap={10} />
                  <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#64748b' }} allowDecimals={false} />
                  <RechartsTooltip 
                    cursor={{ stroke: '#cbd5e1', strokeWidth: 1, strokeDasharray: '4 4' }}
                    contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 20px rgba(0,0,0,0.08)' }}
                    labelFormatter={(value, payload) => payload?.[0]?.payload?.name || value}
                  />
                  <Legend iconType="circle" wrapperStyle={{ paddingTop: '20px' }} />
                  <Area type="monotone" dataKey="Faculty" stroke="#4f46e5" strokeWidth={2} fillOpacity={1} fill="url(#colorFaculty)" />
                </AreaChart>
              </ResponsiveContainer>
            </div>

            <div className="pt-6 border-t border-slate-100">
              <div className="flex items-center gap-4 bg-indigo-50/50 p-4 rounded-2xl border border-indigo-100/50">
                <div className="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center flex-shrink-0">
                  <Users className="w-5 h-5 text-indigo-600" />
                </div>
                <div>
                  <p className="text-sm font-semibold text-slate-600">Total Faculty Gatepasses This Month</p>
                  <p className="text-2xl font-bold text-indigo-700">{totalMonthlyFaculty}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Bottom Section: Gatepass / Person List */}
        <div className="bg-white rounded-[32px] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 p-8 flex flex-col min-h-[400px]">
          
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-6 mb-8 pb-6 border-b border-slate-100">
            <div>
              <h3 className="text-2xl font-bold text-slate-900">
                {getSelectedDatesLabel()}
              </h3>
              <p className="text-sm text-slate-500 mt-1.5 font-medium">
                {isRangeView 
                  ? `${groupedPersons.length} ${groupedPersons.length === 1 ? 'faculty recorded' : 'faculties recorded'}`
                  : `${gatepassesForSelectedDate.length} ${gatepassesForSelectedDate.length === 1 ? 'approved gatepass' : 'approved gatepasses'}`
                }
              </p>
            </div>
          </div>

          <div className="flex-1 custom-scrollbar">
            {loading ? (
              <div className="flex flex-col items-center justify-center py-20 text-slate-400">
                <div className="w-10 h-10 border-4 border-slate-200 border-t-indigo-600 rounded-full animate-spin mb-4"></div>
                <p className="font-medium text-[15px]">Loading gatepass records...</p>
              </div>
            ) : gatepassesForSelectedDate.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-20 text-center">
                <div className="w-20 h-20 bg-slate-50 rounded-full flex items-center justify-center mb-5 border border-slate-100">
                  <Shield className="w-10 h-10 text-slate-300" />
                </div>
                <h4 className="text-xl font-bold text-slate-900 mb-1">No Records</h4>
                <p className="text-slate-500 text-[15px]">No faculty member has approved gatepasses on the selected dates.</p>
              </div>
            ) : isRangeView ? (
              // Grouped Range View
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
                {groupedPersons.map((group) => {
                  const { id, person, gatepassCount } = group;
                  const personName = person ? `${person.first_name} ${person.last_name}` : 'Unknown';
                  const roleLabel = 'Faculty Member';

                  return (
                    <div 
                      key={id} 
                      onClick={() => handlePersonClick(id)}
                      className="group p-6 rounded-3xl border border-slate-200/60 bg-white hover:border-indigo-200 hover:shadow-[0_8px_30px_rgb(79,70,229,0.12)] transition-all duration-300 cursor-pointer flex items-center justify-between"
                    >
                      <div className="flex items-center gap-4">
                        <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-white text-lg font-bold shadow-md shadow-indigo-200 group-hover:scale-110 transition-transform">
                          {personName.charAt(0)}
                        </div>
                        <div>
                          <h4 className="font-bold text-slate-900 text-[17px]">{personName}</h4>
                          <p className="text-slate-500 text-xs font-semibold uppercase tracking-wider mt-0.5">{roleLabel}</p>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <span className="flex items-center justify-center px-3 py-1 bg-indigo-50 text-indigo-700 font-bold text-xs rounded-xl border border-indigo-100/50">
                          {gatepassCount} GP
                        </span>
                        <ArrowRight className="w-5 h-5 text-slate-300 group-hover:text-indigo-500 transition-colors" />
                      </div>
                    </div>
                  );
                })}
              </div>
            ) : (
              // Individual Date View (Single or Double dates)
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
                {gatepassesForSelectedDate.map((gp) => {
                  const personName = gp.faculty ? `${gp.faculty.first_name} ${gp.faculty.last_name}` : 'Unknown Faculty';
                  
                  return (
                    <div key={gp.id} className="group p-6 rounded-3xl border border-slate-200/60 bg-white hover:border-indigo-200 hover:shadow-[0_8px_30px_rgb(79,70,229,0.08)] transition-all duration-300">
                      <div className="flex justify-between items-start mb-5">
                        <div className="flex items-center gap-4">
                          <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-white text-lg font-bold shadow-md shadow-indigo-200">
                            {personName.charAt(0)}
                          </div>
                          <div>
                            <h4 className="font-bold text-slate-900 text-[17px]">{personName}</h4>
                            <span className="inline-block mt-1 px-2.5 py-1 bg-indigo-50 text-indigo-700 font-bold text-[10px] rounded-lg border border-indigo-100/50 uppercase tracking-wider">
                              Faculty Gatepass
                            </span>
                          </div>
                        </div>
                        <GatepassStatusBadge status={gp.status} />
                      </div>

                      <div className="bg-slate-50/80 rounded-2xl p-4 border border-slate-100">
                        <div className="flex items-center text-[13px] font-semibold text-slate-600 mb-3 pb-3 border-b border-slate-200/60">
                          <Clock className="w-4 h-4 mr-2 text-indigo-500" />
                          <span>
                            Out: {format(parseISO(gp.out_time), 'h:mm a')}
                          </span>
                          {gp.expected_in_time && (
                            <>
                              <span className="mx-2.5 text-slate-300">•</span>
                              <span>Exp In: {format(parseISO(gp.expected_in_time), 'h:mm a')}</span>
                            </>
                          )}
                        </div>
                        <div className="text-[14px] text-slate-700 font-medium leading-relaxed">
                          <span className="text-slate-400 font-semibold mr-1.5">Reason:</span>
                          {gp.reason}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default HRGatepassPortal;
