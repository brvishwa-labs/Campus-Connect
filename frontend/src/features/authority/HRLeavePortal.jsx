import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../../context/AuthContext';
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight, User, AlertCircle, FileText, Clock, Info } from 'lucide-react';
import { format, addMonths, subMonths, startOfMonth, endOfMonth, startOfWeek, endOfWeek, isSameMonth, isSameDay, addDays, parseISO, isWithinInterval, startOfDay, endOfDay } from 'date-fns';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const LeaveStatusBadge = ({ status }) => {
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

const HRLeavePortal = () => {
  const { user } = useAuth();
  const [leaves, setLeaves] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [currentMonth, setCurrentMonth] = useState(new Date());
  const [selectedDates, setSelectedDates] = useState([startOfDay(new Date())]);
  const [lastClickedDate, setLastClickedDate] = useState(startOfDay(new Date()));
  const [selectedLeaveType, setSelectedLeaveType] = useState('All');

  // Include all standard leave types, plus any dynamic ones found in the data
  const standardLeaveTypes = [
    'Academic Leave',
    'Casual Leave',
    'Compensation Leave',
    'Earned Leave',
    'Restricted Leave',
    'Vacation Leave'
  ];
  const dynamicLeaveTypes = leaves.map(l => l.leave_type).filter(Boolean);
  const availableLeaveTypes = ['All', ...new Set([...standardLeaveTypes, ...dynamicLeaveTypes])].sort();


  const fetchLeaves = async () => {
    try {
      setLoading(true);
      setError(null);
      const token = localStorage.getItem('token');
      const response = await axios.get(`${API_BASE_URL}/api/leave/requests`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setLeaves(response.data);
    } catch (err) {
      console.error('Error fetching leave requests:', err);
      setError(err.response?.data?.detail || 'Failed to fetch leave requests');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLeaves();
  }, []);

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

        // Check if anyone is on leave this day
        const isLeaveOnDay = leaves.some(leave => {
          if (leave.status?.toUpperCase() !== 'APPROVED') return false; // Only show dots for approved leaves
          const from = parseISO(leave.from_date);
          const to = parseISO(leave.to_date);
          return cloneDay >= startOfDay(from) && cloneDay <= endOfDay(to);
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
            className={`relative flex flex-col items-center justify-center p-2 h-[52px] cursor-pointer transition-all duration-200
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
            {/* Indicator dot if someone is on leave */}
            {isLeaveOnDay && (
              <span className={`absolute bottom-2 w-1.5 h-1.5 rounded-full z-10 
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

  // Get leaves for the selected dates
  const leavesForSelectedDate = leaves.filter(leave => {
    const from = startOfDay(parseISO(leave.from_date));
    const to = endOfDay(parseISO(leave.to_date));

    // Check if the leave overlaps with ANY selected date
    const isDateMatch = selectedDates.some(selectedDay => {
      return selectedDay >= from && selectedDay <= to;
    });

    if (selectedLeaveType === 'All') return isDateMatch;
    return isDateMatch && leave.leave_type === selectedLeaveType;
  });

  const getSelectedDatesLabel = () => {
    if (selectedDates.length === 0) return 'No dates selected';
    if (selectedDates.length === 1) return `Leaves on ${format(selectedDates[0], 'MMM do, yyyy')}`;
    
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
      return `Leaves from ${format(first, 'MMM do')} to ${format(last, 'MMM do, yyyy')}`;
    }
    
    return `Leaves on ${sorted.length} selected dates`;
  };

  return (
    <div className="max-w-[1200px] mx-auto p-4 md:p-6 lg:p-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Leave Tracking</h1>
        <p className="text-slate-500 mt-1 font-medium">Monitor faculty leave schedules across the college</p>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 rounded-xl p-4 flex items-start gap-3 mb-6">
          <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
          <p className="text-sm text-red-700 font-medium">{error}</p>
        </div>
      )}

      <div className="grid lg:grid-cols-[400px_1fr] gap-8 items-start">
        {/* Left Column: Calendar Widget */}
        <div className="bg-white rounded-[32px] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 p-8">
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
                    <span>Select multiple specific days</span>
                  </li>
                  <li className="flex items-center gap-2">
                    <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Ctrl</kbd> + <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Shift</kbd> + <kbd className="bg-slate-100 border border-slate-200 px-2 py-0.5 rounded text-slate-700 font-mono text-xs">Click</kbd> 
                    <span>Select a continuous date range</span>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* Right Column: Leaves List */}
        <div className="bg-white rounded-[32px] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 p-8 min-h-[500px] flex flex-col">
          <div className="flex items-start justify-between mb-8 pb-4 border-b border-slate-100">
            <div>
              <h3 className="text-xl font-bold text-slate-900">
                {getSelectedDatesLabel()}
              </h3>
              <p className="text-sm text-slate-500 mt-1 font-medium">
                {leavesForSelectedDate.length} {leavesForSelectedDate.length === 1 ? 'staff member' : 'staff members'} on leave
              </p>

              <div className="flex items-center gap-2 mt-4">
                <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Filter:</span>
                <select
                  value={selectedLeaveType}
                  onChange={(e) => setSelectedLeaveType(e.target.value)}
                  className="bg-slate-50 border border-slate-200 text-slate-700 text-sm font-medium rounded-lg focus:ring-indigo-500 focus:border-indigo-500 block px-3 py-1.5 transition-colors cursor-pointer outline-none"
                >
                  {availableLeaveTypes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </select>
              </div>
            </div>
            <div className="w-12 h-12 bg-indigo-50 rounded-2xl flex items-center justify-center flex-shrink-0">
              <CalendarIcon className="w-6 h-6 text-indigo-600" />
            </div>
          </div>

          <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
            {loading ? (
              <div className="flex flex-col items-center justify-center h-48 text-slate-400">
                <div className="w-8 h-8 border-4 border-slate-200 border-t-indigo-600 rounded-full animate-spin mb-4"></div>
                <p className="font-medium text-sm">Loading leave records...</p>
              </div>
            ) : leavesForSelectedDate.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-48 text-center mt-10">
                <div className="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center mb-4">
                  <User className="w-8 h-8 text-slate-300" />
                </div>
                <h4 className="text-lg font-bold text-slate-900 mb-1">No Leaves</h4>
                <p className="text-slate-500 text-sm">No staff members are on leave for this date.</p>
              </div>
            ) : (
              <div className="space-y-4">
                {leavesForSelectedDate.map((leave) => (
                  <div key={leave.id} className="group p-5 rounded-2xl border border-slate-100 bg-slate-50/50 hover:bg-white hover:shadow-[0_4px_20px_rgb(0,0,0,0.03)] hover:border-slate-200 transition-all">
                    <div className="flex justify-between items-start mb-3">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-white font-bold shadow-sm">
                          {leave.faculty_name?.charAt(0) || 'U'}
                        </div>
                        <div>
                          <h4 className="font-bold text-slate-900">{leave.faculty_name}</h4>
                          <span className="inline-block mt-0.5 px-2 py-0.5 bg-blue-50 text-blue-700 font-semibold text-[10px] rounded-md border border-blue-100 uppercase tracking-wider">
                            {leave.leave_type}
                          </span>
                        </div>
                      </div>
                      <LeaveStatusBadge status={leave.status} />
                    </div>

                    <div className="pl-13 ml-13">
                      <div className="flex items-center text-sm text-slate-600 mb-2">
                        <Clock className="w-4 h-4 mr-2 text-slate-400" />
                        <span className="font-medium">
                          {format(parseISO(leave.from_date), 'MMM d')} - {format(parseISO(leave.to_date), 'MMM d, yyyy')}
                        </span>
                        <span className="mx-2 text-slate-300">•</span>
                        <span className="text-slate-500">{leave.duration_days} Day{leave.duration_days > 1 ? 's' : ''}</span>
                      </div>
                      <div className="text-sm text-slate-600 bg-white p-3 rounded-xl border border-slate-100 shadow-sm inline-block w-full">
                        <span className="font-semibold text-slate-700 mr-2">Reason:</span>
                        {leave.reason}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default HRLeavePortal;
