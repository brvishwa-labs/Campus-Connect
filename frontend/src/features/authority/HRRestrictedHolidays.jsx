import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import { 
  CalendarDays, ChevronLeft, ChevronRight,
  Plus, Trash2, Edit2, X, Info, AlertCircle, CheckCircle2 
} from 'lucide-react';
import { format, parseISO } from 'date-fns';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

/* ────────────────────────────────────────────────────────────────
   Helpers matching admin HolidayCalendar
   ──────────────────────────────────────────────────────────────── */
const MONTH_NAMES = [
  'January','February','March','April','May','June',
  'July','August','September','October','November','December'
];

const DAY_NAMES = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

function getDaysInMonth(year, month) {
  return new Date(year, month + 1, 0).getDate();
}

function getFirstDayOfMonth(year, month) {
  return new Date(year, month, 1).getDay(); // 0=Sun
}

function toDateStr(year, month, day) {
  return `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

function isSundayStr(dateStr) {
  return new Date(dateStr + 'T00:00:00').getDay() === 0;
}

function buildAcademicMonths(startYear, endYear) {
  const months = [];
  // June→December of startYear
  for (let m = 5; m <= 11; m++) months.push({ year: startYear, month: m });
  // January→May of endYear
  for (let m = 0; m <= 4; m++) months.push({ year: endYear, month: m });
  return months;
}

const HRRestrictedHolidays = () => {
  const [academicYear, setAcademicYear] = useState('2023-2024');
  const [holidays, setHolidays] = useState([]);
  const [loading, setLoading] = useState(true);
  const [statusMessage, setStatusMessage] = useState(null);
  const [statusType, setStatusType] = useState('success');
  const [showAddModal, setShowAddModal] = useState(false);
  const [editingHoliday, setEditingHoliday] = useState(null);

  // Derive start and end years
  const [startYear, endYear] = academicYear.split('-').map(Number);
  const academicMonths = buildAcademicMonths(startYear, endYear);

  // Month index into academicMonths
  const [monthIdx, setMonthIdx] = useState(0);

  // Form State
  const [formData, setFormData] = useState({
    name: '',
    date: '',
    description: ''
  });

  // Set default monthIdx when academicYear changes
  useEffect(() => {
    const today = new Date();
    const idx = academicMonths.findIndex(
      (m) => m.year === today.getFullYear() && m.month === today.getMonth()
    );
    setMonthIdx(idx >= 0 ? idx : 0);
  }, [academicYear]);

  const fetchHolidays = async () => {
    setLoading(true);
    try {
      const token = localStorage.getItem('token');
      const res = await axios.get(`${API_BASE_URL}/api/leave/restricted-holidays`, {
        params: { academic_year: academicYear },
        headers: { Authorization: `Bearer ${token}` }
      });
      setHolidays(res.data);
    } catch (err) {
      console.error('Error fetching restricted holidays:', err);
      setStatusType('error');
      setStatusMessage('Failed to load restricted holidays.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchHolidays();
  }, [academicYear]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const showStatus = (type, message) => {
    setStatusType(type);
    setStatusMessage(message);
    setTimeout(() => setStatusMessage(null), 5000);
  };

  const handleAddSubmit = async (e) => {
    if (e) e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      const payload = {
        name: formData.name,
        date: formData.date,
        academic_year: academicYear,
        description: formData.description || null
      };

      await axios.post(`${API_BASE_URL}/api/leave/restricted-holidays`, payload, {
        headers: { Authorization: `Bearer ${token}` }
      });

      showStatus('success', 'Restricted holiday added successfully!');
      setShowAddModal(false);
      setFormData({ name: '', date: '', description: '' });
      fetchHolidays();
    } catch (err) {
      console.error('Error adding holiday:', err);
      showStatus('error', err.response?.data?.detail || 'Failed to add restricted holiday.');
    }
  };

  const handleEditSubmit = async (e) => {
    if (e) e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      const payload = {
        name: formData.name,
        date: formData.date,
        academic_year: academicYear,
        description: formData.description || null
      };

      await axios.put(`${API_BASE_URL}/api/leave/restricted-holidays/${editingHoliday.id}`, payload, {
        headers: { Authorization: `Bearer ${token}` }
      });

      showStatus('success', 'Restricted holiday updated successfully!');
      setEditingHoliday(null);
      setFormData({ name: '', date: '', description: '' });
      fetchHolidays();
    } catch (err) {
      console.error('Error updating holiday:', err);
      showStatus('error', err.response?.data?.detail || 'Failed to update restricted holiday.');
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this restricted holiday?')) return;
    try {
      const token = localStorage.getItem('token');
      await axios.delete(`${API_BASE_URL}/api/leave/restricted-holidays/${id}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      showStatus('success', 'Restricted holiday deleted successfully!');
      fetchHolidays();
    } catch (err) {
      console.error('Error deleting holiday:', err);
      showStatus('error', err.response?.data?.detail || 'Failed to delete restricted holiday.');
    }
  };

  const openEditModal = (holiday) => {
    setEditingHoliday(holiday);
    setFormData({
      name: holiday.name,
      date: holiday.date,
      description: holiday.description || ''
    });
  };

  const handleDayClick = (dateStr) => {
    if (isSundayStr(dateStr)) return;

    const existingHoliday = holidays.find(h => h.date === dateStr);
    if (existingHoliday) {
      openEditModal(existingHoliday);
    } else {
      setEditingHoliday(null);
      setFormData({
        name: '',
        date: dateStr,
        description: ''
      });
      setShowAddModal(true);
    }
  };

  // Current Month Data derived exactly like admin calendar
  const { year, month } = academicMonths[monthIdx] || { year: startYear, month: 5 };
  const daysInMonth = getDaysInMonth(year, month);
  const firstDay = getFirstDayOfMonth(year, month);

  return (
    <div className="max-w-[1200px] mx-auto p-4 md:p-6 lg:p-8">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-8 gap-4">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-[16px] bg-indigo-50 flex items-center justify-center flex-shrink-0 shadow-sm border border-indigo-100">
            <CalendarDays className="w-6 h-6 text-indigo-600" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900 tracking-tight">Restricted Holidays Calendar</h1>
            <p className="text-xs text-gray-500 mt-0.5">
              Academic Year {academicYear} &nbsp;·&nbsp; Click a date to add or edit Restricted Holidays
            </p>
          </div>
        </div>
      </div>

      {statusMessage && (
        <div className={`mb-6 p-4 rounded-xl flex items-center gap-3 font-semibold text-sm ${
          statusType === 'success' ? 'bg-emerald-50 text-emerald-700 border border-emerald-100' : 'bg-red-50 text-red-700 border border-red-100'
        }`}>
          {statusType === 'success' ? <CheckCircle2 className="w-5 h-5" /> : <AlertCircle className="w-5 h-5" />}
          {statusMessage}
        </div>
      )}

      {/* Configuration & Filters */}
      <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm mb-6 flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-3.5 w-full sm:w-auto">
          <span className="text-slate-400 text-xs font-bold uppercase tracking-wider whitespace-nowrap">Academic Year</span>
          <select
            value={academicYear}
            onChange={(e) => setAcademicYear(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-slate-800 font-bold focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100 transition-all w-full sm:w-52 text-sm cursor-pointer"
          >
            <option value="2023-2024">2023-2024</option>
            <option value="2024-2025">2024-2025</option>
            <option value="2025-2026">2025-2026</option>
            <option value="2026-2027">2026-2027</option>
          </select>
        </div>

        {/* Legend */}
        <div className="flex flex-wrap gap-4 text-xs font-semibold text-gray-500">
          <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-red-400 inline-block" /> Sunday</span>
          <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-indigo-500 inline-block" /> Restricted Holiday</span>
          <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-blue-400 inline-block" /> Today</span>
        </div>
      </div>

      {/* Main Layout Split */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Calendar Pane */}
        <div className="lg:col-span-2 bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-150 p-6 md:p-8 space-y-6">
          
          {/* Month Navigation */}
          <div className="flex items-center justify-between border-b border-gray-100 pb-4">
            <button
              onClick={() => setMonthIdx((i) => Math.max(0, i - 1))}
              disabled={monthIdx === 0}
              className="w-9 h-9 flex items-center justify-center rounded-xl border border-gray-200 text-gray-500 hover:bg-gray-50 disabled:opacity-30 transition-colors"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>
            <span className="text-lg font-bold text-gray-800">
              {MONTH_NAMES[month]} {year}
            </span>
            <button
              onClick={() => setMonthIdx((i) => Math.min(academicMonths.length - 1, i + 1))}
              disabled={monthIdx === academicMonths.length - 1}
              className="w-9 h-9 flex items-center justify-center rounded-xl border border-gray-200 text-gray-500 hover:bg-gray-50 disabled:opacity-30 transition-colors"
            >
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>

          {loading ? (
            <div className="flex items-center justify-center h-48 text-gray-400 font-semibold animate-pulse">
              Loading calendar view...
            </div>
          ) : (
            <div>
              {/* Day Headers */}
              <div className="grid grid-cols-7 mb-2">
                {DAY_NAMES.map((d) => (
                  <div
                    key={d}
                    className={`text-center text-[11px] font-bold uppercase tracking-wider py-1 ${
                      d === 'Sun' ? 'text-red-405 font-extrabold' : 'text-gray-400'
                    }`}
                  >
                    {d}
                  </div>
                ))}
              </div>

              {/* Date Cells */}
              <div className="grid grid-cols-7 gap-1">
                {/* Empty cells before first day */}
                {Array.from({ length: firstDay }).map((_, i) => (
                  <div key={`empty-${i}`} className="bg-slate-50/20 border border-transparent min-h-[52px]" />
                ))}

                {/* Days of Month */}
                {Array.from({ length: daysInMonth }).map((_, i) => {
                  const dayNum = i + 1;
                  const dateStr = toDateStr(year, month, dayNum);
                  const todayStr = new Date().toISOString().split('T')[0];
                  
                  const isToday = dateStr === todayStr;
                  const isSun = isSundayStr(dateStr);
                  
                  const dayHoliday = holidays.find(h => h.date === dateStr);

                  let cellClass =
                    'relative flex flex-col items-center justify-start pt-1 pb-1 rounded-xl border transition-all cursor-pointer select-none min-h-[52px] ';

                  if (isSun) {
                    cellClass += 'bg-red-50 border-red-100 cursor-default text-red-600 ';
                  } else if (dayHoliday) {
                    cellClass += 'bg-indigo-55/80 border-indigo-300 text-indigo-900 hover:bg-indigo-100/90 font-semibold ';
                  } else if (isToday) {
                    cellClass += 'bg-blue-50 border-blue-200 text-blue-700 hover:bg-blue-100 font-bold ';
                  } else {
                    cellClass += 'bg-white border-gray-100 text-gray-700 hover:bg-gray-50 hover:border-gray-200 ';
                  }

                  return (
                    <div
                      key={dateStr}
                      className={cellClass}
                      onClick={() => handleDayClick(dateStr)}
                      title={dayHoliday ? `${dateStr}: ${dayHoliday.name}` : dateStr}
                    >
                      <span className="text-[13px] font-bold leading-none mt-1">{dayNum}</span>
                      {dayHoliday && (
                        <span className="text-[9px] font-bold leading-tight text-center px-1 mt-1 max-w-full truncate bg-indigo-600 text-white rounded py-0.5 mx-0.5 shadow-sm">
                          {dayHoliday.name}
                        </span>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>

        {/* Holidays List Pane */}
        <div className="bg-white rounded-[20px] p-6 border border-gray-150 shadow-sm flex flex-col h-full max-h-[580px] overflow-hidden">
          <h3 className="font-bold text-slate-800 text-base mb-4 pb-2 border-b border-gray-100 flex justify-between items-center">
            <span>List of Holidays</span>
            <span className="text-xs bg-indigo-50 text-indigo-700 font-bold px-2 py-0.5 rounded-full border border-indigo-100">
              {holidays.length}
            </span>
          </h3>

          <div className="flex-1 overflow-y-auto space-y-3.5 pr-1 scrollbar-thin">
            {holidays.length === 0 ? (
              <p className="text-slate-400 text-sm italic py-8 text-center">No holidays configured for this academic year.</p>
            ) : (
              holidays.map(holiday => (
                <div key={holiday.id} className="bg-slate-50/60 border border-gray-150 rounded-xl p-3.5 flex justify-between items-start hover:border-indigo-200 hover:bg-indigo-50/10 transition-all duration-300 relative group">
                  <div className="absolute top-0 left-0 bottom-0 w-1 bg-indigo-500 rounded-l-xl"></div>
                  <div className="flex-1 min-w-0 pl-2 pr-1">
                    <p className="font-bold text-slate-800 truncate text-sm">{holiday.name}</p>
                    <p className="text-[11px] font-bold text-indigo-600 mt-0.5">
                      {format(parseISO(holiday.date), 'dd MMM yyyy')}
                    </p>
                    {holiday.description && (
                      <p className="text-xs text-slate-500 mt-1 line-clamp-2 leading-relaxed bg-white border border-gray-100 rounded p-1.5 font-medium">{holiday.description}</p>
                    )}
                  </div>
                  
                  <div className="flex gap-1 flex-shrink-0">
                    <button
                      onClick={() => openEditModal(holiday)}
                      className="p-1 text-slate-400 hover:text-indigo-600 hover:bg-white rounded border border-transparent hover:border-gray-200 transition-all"
                      title="Edit"
                    >
                      <Edit2 className="w-3.5 h-3.5" />
                    </button>
                    <button
                      onClick={() => handleDelete(holiday.id)}
                      className="p-1 text-slate-400 hover:text-rose-600 hover:bg-white rounded border border-transparent hover:border-gray-200 transition-all"
                      title="Delete"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>

      {/* Add Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[1000] flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl border border-gray-150 w-full max-w-[420px] overflow-hidden transform transition-all">
            <div className="px-5 py-4 border-b border-gray-100 flex justify-between items-center bg-slate-50/50">
              <h3 className="font-bold text-slate-900 text-base">Add Restricted Holiday</h3>
              <button
                onClick={() => setShowAddModal(false)}
                className="p-1.5 hover:bg-slate-100 rounded-xl text-slate-400 hover:text-slate-600 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <form onSubmit={handleAddSubmit} className="p-5 space-y-4">
              <div>
                <label className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Holiday Date</label>
                <p className="text-sm font-bold text-indigo-700 bg-indigo-50 border border-indigo-100 rounded-xl px-4 py-2">
                  {formData.date ? format(parseISO(formData.date), 'dd MMMM yyyy (EEEE)') : ''}
                </p>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Holiday Name</label>
                <input
                  type="text"
                  name="name"
                  value={formData.name}
                  onChange={handleInputChange}
                  placeholder="e.g. Maha Shivarathri"
                  required
                  autoFocus
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-slate-800 focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100 transition-all font-semibold text-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Description (Optional)</label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleInputChange}
                  placeholder="Provide brief details about this holiday..."
                  rows="3"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-slate-800 focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100 transition-all font-semibold text-sm resize-none"
                />
              </div>

              <div className="flex justify-end gap-2.5 pt-4 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => setShowAddModal(false)}
                  className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl text-sm transition-all"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4.5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-sm transition-all shadow-sm"
                >
                  Add Holiday
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Edit Modal */}
      {editingHoliday && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[1000] flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl border border-gray-150 w-full max-w-[420px] overflow-hidden transform transition-all">
            <div className="px-5 py-4 border-b border-gray-100 flex justify-between items-center bg-slate-50/50">
              <h3 className="font-bold text-slate-900 text-base">Edit Restricted Holiday</h3>
              <button
                onClick={() => setEditingHoliday(null)}
                className="p-1.5 hover:bg-slate-100 rounded-xl text-slate-400 hover:text-slate-600 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <form onSubmit={handleEditSubmit} className="p-5 space-y-4">
              <div>
                <label className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Holiday Date</label>
                <p className="text-sm font-bold text-indigo-700 bg-indigo-50 border border-indigo-100 rounded-xl px-4 py-2">
                  {formData.date ? format(parseISO(formData.date), 'dd MMMM yyyy (EEEE)') : ''}
                </p>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Holiday Name</label>
                <input
                  type="text"
                  name="name"
                  value={formData.name}
                  onChange={handleInputChange}
                  placeholder="e.g. Maha Shivarathri"
                  required
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-slate-800 focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100 transition-all font-semibold text-sm"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-400 uppercase tracking-wider mb-2">Description (Optional)</label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleInputChange}
                  placeholder="Provide brief details about this holiday..."
                  rows="3"
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-slate-800 focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100 transition-all font-semibold text-sm resize-none"
                />
              </div>

              <div className="flex justify-between items-center pt-4 border-t border-gray-100">
                <button
                  type="button"
                  onClick={() => handleDelete(editingHoliday.id)}
                  className="px-3.5 py-2 bg-rose-50 hover:bg-rose-100 text-rose-600 font-bold rounded-xl text-sm transition-all flex items-center gap-1.5"
                >
                  <Trash2 className="w-4 h-4" /> Delete
                </button>
                
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => setEditingHoliday(null)}
                    className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl text-sm transition-all"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-4.5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl text-sm transition-all shadow-sm"
                  >
                    Save
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default HRRestrictedHolidays;
