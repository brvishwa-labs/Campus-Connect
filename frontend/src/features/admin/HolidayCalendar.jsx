import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import {
  CalendarDays, ChevronLeft, ChevronRight,
  Plus, Trash2, Save, X, Loader2, Info
} from 'lucide-react';

/* ────────────────────────────────────────────────────────────────
   Helpers
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

/* Derive academic year string from today (June→next May) */
function currentAcademicYear() {
  const today = new Date();
  const year = today.getMonth() >= 5 ? today.getFullYear() : today.getFullYear() - 1;
  return { startYear: year, endYear: year + 1 };
}

/* Build list of all months in the academic year */
function buildAcademicMonths(startYear, endYear) {
  const months = [];
  // June→December of startYear
  for (let m = 5; m <= 11; m++) months.push({ year: startYear, month: m });
  // January→May of endYear
  for (let m = 0; m <= 4; m++) months.push({ year: endYear, month: m });
  return months;
}

/* ────────────────────────────────────────────────────────────────
   Main Component
──────────────────────────────────────────────────────────────── */
export const HolidayCalendar = () => {
  const { startYear, endYear } = currentAcademicYear();
  const academicMonths = buildAcademicMonths(startYear, endYear);

  // Which month is currently shown (index into academicMonths)
  const [monthIdx, setMonthIdx] = useState(() => {
    const today = new Date();
    const idx = academicMonths.findIndex(
      (m) => m.year === today.getFullYear() && m.month === today.getMonth()
    );
    return idx >= 0 ? idx : 0;
  });

  // Map of dateStr → holiday name (from DB)
  const [holidayMap, setHolidayMap] = useState({});
  const [loading, setLoading] = useState(true);

  // Local pending changes: dateStr → name string ('' means delete)
  const [pendingAdd, setPendingAdd] = useState({});    // dateStr → name to add
  const [pendingDel, setPendingDel] = useState({});    // dateStr → true (to delete)

  // Modal state for naming a holiday
  const [nameModal, setNameModal] = useState(null);    // dateStr | null
  const [nameInput, setNameInput] = useState('');

  const [saving, setSaving] = useState(false);
  const [saveMsg, setSaveMsg] = useState(null);        // { type: 'success'|'error', text }

  /* Fetch holidays from backend */
  const fetchHolidays = useCallback(() => {
    setLoading(true);
    axios
      .get(`/api/admin/holidays?academic_year=${startYear}-${endYear}`)
      .then((r) => {
        const map = {};
        (r.data.holidays || []).forEach((h) => { map[h.date] = h.name; });
        setHolidayMap(map);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [startYear, endYear]);

  useEffect(() => { fetchHolidays(); }, [fetchHolidays]);

  /* Derived state */
  const { year, month } = academicMonths[monthIdx];
  const daysInMonth = getDaysInMonth(year, month);
  const firstDay = getFirstDayOfMonth(year, month);

  const isHolidayDate = (dateStr) => {
    if (isSundayStr(dateStr)) return true;
    if (pendingAdd[dateStr]) return true;
    if (pendingDel[dateStr]) return false;
    return dateStr in holidayMap;
  };

  const getHolidayLabel = (dateStr) => {
    if (isSundayStr(dateStr)) return 'Sunday';
    if (pendingAdd[dateStr]) return pendingAdd[dateStr];
    if (pendingDel[dateStr]) return null;
    return holidayMap[dateStr] || null;
  };

  const hasPendingChanges =
    Object.keys(pendingAdd).length > 0 || Object.keys(pendingDel).length > 0;

  /* Click on a date cell */
  const handleDayClick = (dateStr) => {
    if (isSundayStr(dateStr)) return; // can't toggle Sundays

    // If it's already a holiday (DB or pending add) → start delete flow
    if (dateStr in holidayMap && !pendingDel[dateStr]) {
      setPendingDel((prev) => ({ ...prev, [dateStr]: true }));
      setPendingAdd((prev) => { const n = { ...prev }; delete n[dateStr]; return n; });
      return;
    }

    // If we had queued it for delete → undo
    if (pendingDel[dateStr]) {
      setPendingDel((prev) => { const n = { ...prev }; delete n[dateStr]; return n; });
      return;
    }

    // If it's a pending-add → remove it
    if (pendingAdd[dateStr]) {
      setPendingAdd((prev) => { const n = { ...prev }; delete n[dateStr]; return n; });
      return;
    }

    // Otherwise → open name modal
    setNameModal(dateStr);
    setNameInput('');
  };

  const confirmName = () => {
    if (!nameInput.trim()) return;
    setPendingAdd((prev) => ({ ...prev, [nameModal]: nameInput.trim() }));
    setNameModal(null);
  };

  /* Save all pending changes */
  const handleSave = async () => {
    setSaving(true);
    setSaveMsg(null);
    try {
      // Deletions first
      await Promise.all(
        Object.keys(pendingDel).map((dateStr) =>
          axios.delete(`/api/admin/holidays/${dateStr}`).catch(() => {})
        )
      );
      // Additions
      await Promise.all(
        Object.entries(pendingAdd).map(([dateStr, name]) =>
          axios.post('/api/admin/holidays', { date: dateStr, name })
        )
      );
      setPendingAdd({});
      setPendingDel({});
      setSaveMsg({ type: 'success', text: 'Holiday calendar saved!' });
      fetchHolidays();
    } catch (e) {
      setSaveMsg({ type: 'error', text: e.response?.data?.detail || 'Failed to save some changes.' });
    } finally {
      setSaving(false);
    }
  };

  const discardChanges = () => {
    setPendingAdd({});
    setPendingDel({});
    setSaveMsg(null);
  };

  /* ── Render ── */
  return (
    <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.04)] border border-gray-100 p-6 md:p-8 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="w-11 h-11 rounded-[14px] bg-red-50 flex items-center justify-center flex-shrink-0">
            <CalendarDays className="w-5 h-5 text-red-500" />
          </div>
          <div>
            <h3 className="text-[17px] font-bold text-gray-900">Holiday Calendar</h3>
            <p className="text-xs text-gray-500 mt-0.5">
              Academic Year {startYear}–{endYear} &nbsp;·&nbsp; Sundays are auto-holidays
            </p>
          </div>
        </div>

        {/* Save / Discard */}
        <div className="flex items-center gap-2">
          {hasPendingChanges && (
            <button
              onClick={discardChanges}
              className="flex items-center gap-1.5 px-4 py-2 text-sm font-semibold text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-xl transition-colors"
            >
              <X className="w-4 h-4" /> Discard
            </button>
          )}
          <button
            onClick={handleSave}
            disabled={!hasPendingChanges || saving}
            className={`flex items-center gap-1.5 px-5 py-2 text-sm font-bold rounded-xl transition-all shadow-sm ${
              hasPendingChanges && !saving
                ? 'bg-red-500 hover:bg-red-600 text-white cursor-pointer'
                : 'bg-gray-100 text-gray-400 cursor-not-allowed'
            }`}
          >
            {saving ? (
              <><Loader2 className="w-4 h-4 animate-spin" /> Saving…</>
            ) : (
              <><Save className="w-4 h-4" /> Save Calendar</>
            )}
          </button>
        </div>
      </div>

      {/* Save message */}
      {saveMsg && (
        <div className={`flex items-center gap-2 px-4 py-3 rounded-xl text-sm font-semibold border ${
          saveMsg.type === 'success'
            ? 'bg-green-50 text-green-700 border-green-100'
            : 'bg-red-50 text-red-700 border-red-100'
        }`}>
          <Info className="w-4 h-4 flex-shrink-0" />
          {saveMsg.text}
        </div>
      )}

      {/* Pending changes badge */}
      {hasPendingChanges && (
        <div className="flex flex-wrap gap-2 text-xs">
          {Object.entries(pendingAdd).map(([d, name]) => (
            <span key={d} className="px-3 py-1 bg-amber-50 text-amber-700 border border-amber-100 rounded-full font-semibold flex items-center gap-1">
              <Plus className="w-3 h-3" /> {d} — {name}
            </span>
          ))}
          {Object.entries(pendingDel).map(([d]) => (
            <span key={d} className="px-3 py-1 bg-gray-100 text-gray-500 border border-gray-200 rounded-full font-semibold flex items-center gap-1 line-through">
              <Trash2 className="w-3 h-3" /> {d}
            </span>
          ))}
        </div>
      )}

      {/* Legend */}
      <div className="flex flex-wrap gap-4 text-xs font-semibold text-gray-500">
        <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-red-400 inline-block" /> Sunday (auto)</span>
        <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-orange-400 inline-block" /> Custom holiday</span>
        <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-amber-300 inline-block" /> Pending add</span>
        <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-gray-300 inline-block border border-dashed border-gray-400" /> Pending delete</span>
        <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-full bg-blue-200 inline-block" /> Today</span>
        <span className="ml-auto italic text-gray-400">Click a date to mark/unmark holiday</span>
      </div>

      {/* Month navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => setMonthIdx((i) => Math.max(0, i - 1))}
          disabled={monthIdx === 0}
          className="w-9 h-9 flex items-center justify-center rounded-xl border border-gray-200 text-gray-500 hover:bg-gray-50 disabled:opacity-30 transition-colors"
        >
          <ChevronLeft className="w-5 h-5" />
        </button>
        <span className="text-base font-bold text-gray-800">
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

      {/* Calendar grid */}
      {loading ? (
        <div className="flex items-center justify-center h-48 text-gray-400 gap-2">
          <Loader2 className="w-5 h-5 animate-spin" /> Loading…
        </div>
      ) : (
        <div>
          {/* Day headers */}
          <div className="grid grid-cols-7 mb-2">
            {DAY_NAMES.map((d) => (
              <div
                key={d}
                className={`text-center text-[11px] font-bold uppercase tracking-wider py-1 ${
                  d === 'Sun' ? 'text-red-400' : 'text-gray-400'
                }`}
              >
                {d}
              </div>
            ))}
          </div>

          {/* Date cells */}
          <div className="grid grid-cols-7 gap-1">
            {/* Empty cells before first day */}
            {Array.from({ length: firstDay }).map((_, i) => (
              <div key={`empty-${i}`} />
            ))}

            {Array.from({ length: daysInMonth }).map((_, i) => {
              const day = i + 1;
              const dateStr = toDateStr(year, month, day);
              const todayStr = new Date().toISOString().split('T')[0];
              const isToday = dateStr === todayStr;
              const isSun = isSundayStr(dateStr);
              const isHol = isHolidayDate(dateStr);
              const label = getHolidayLabel(dateStr);
              const isPendAdd = !!pendingAdd[dateStr];
              const isPendDel = !!pendingDel[dateStr];
              const isDbHol = !isSun && dateStr in holidayMap && !isPendDel;

              let cellClass =
                'relative flex flex-col items-center justify-start pt-1 pb-1 rounded-xl border transition-all cursor-pointer select-none min-h-[52px] ';

              if (isSun) {
                cellClass += 'bg-red-50 border-red-100 cursor-default text-red-600 ';
              } else if (isPendDel) {
                cellClass += 'bg-gray-50 border-gray-200 border-dashed text-gray-400 line-through ';
              } else if (isPendAdd) {
                cellClass += 'bg-amber-50 border-amber-300 text-amber-800 hover:bg-amber-100 ';
              } else if (isDbHol) {
                cellClass += 'bg-orange-50 border-orange-200 text-orange-700 hover:bg-orange-100 ';
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
                  title={label ? `${dateStr}: ${label}` : dateStr}
                >
                  <span className="text-[13px] font-bold leading-none mt-1">{day}</span>
                  {label && (
                    <span className="text-[9px] font-semibold leading-tight text-center px-0.5 mt-0.5 max-w-full truncate">
                      {label}
                    </span>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Holiday naming modal */}
      {nameModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-sm">
          <div className="bg-white rounded-2xl shadow-2xl border border-gray-100 p-6 w-full max-w-sm mx-4 space-y-4">
            <div className="flex items-center justify-between">
              <h4 className="text-base font-bold text-gray-900">Mark as Holiday</h4>
              <button
                onClick={() => setNameModal(null)}
                className="text-gray-400 hover:text-gray-600 transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <p className="text-sm text-gray-500">
              Date: <span className="font-semibold text-gray-800">{nameModal}</span>
            </p>
            <div>
              <label className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1.5 block">
                Holiday Name
              </label>
              <input
                type="text"
                autoFocus
                value={nameInput}
                onChange={(e) => setNameInput(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && confirmName()}
                placeholder="e.g. Diwali, Republic Day…"
                className="w-full px-4 py-2.5 border border-gray-200 rounded-xl text-sm font-medium text-gray-800 focus:outline-none focus:ring-2 focus:ring-red-300 focus:border-red-300 transition"
              />
            </div>
            <div className="flex gap-3">
              <button
                onClick={() => setNameModal(null)}
                className="flex-1 px-4 py-2.5 text-sm font-semibold text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-xl transition-colors"
              >
                Cancel
              </button>
              <button
                onClick={confirmName}
                disabled={!nameInput.trim()}
                className={`flex-1 px-4 py-2.5 text-sm font-bold rounded-xl transition-colors ${
                  nameInput.trim()
                    ? 'bg-red-500 hover:bg-red-600 text-white'
                    : 'bg-gray-100 text-gray-400 cursor-not-allowed'
                }`}
              >
                <Plus className="w-4 h-4 inline mr-1" />
                Add Holiday
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
