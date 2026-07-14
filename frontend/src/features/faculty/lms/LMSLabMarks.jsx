import React, { useState, useEffect, useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import {
  ArrowLeft, ClipboardList, Save, Send,
  CheckCircle, AlertCircle, FlaskConical,
} from 'lucide-react';

// ── Helpers ───────────────────────────────────────────────────────────────────
const fmt = (v) => (v != null ? Number(v).toFixed(2) : '—');

const Badge = ({ children, color }) => {
  const colors = {
    green:  'bg-green-100 text-green-700',
    red:    'bg-red-100   text-red-700',
    yellow: 'bg-yellow-100 text-yellow-700',
    gray:   'bg-gray-100  text-gray-500',
    blue:   'bg-blue-100  text-blue-700',
  };
  return (
    <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${colors[color] ?? colors.gray}`}>
      {children}
    </span>
  );
};

// ── Column config ─────────────────────────────────────────────────────────────
const COLUMNS = [
  { key: 'record_marks', label: 'Record', max: 30, editable: true },
  { key: 'ia1_marks',    label: 'IA-1',   max: 15, editable: true },
  { key: 'ia2_marks',    label: 'IA-2',   max: 15, editable: true },
  { key: 'avg_ia',       label: 'Avg IA', max: 15, editable: false },
  { key: 'viva_marks',   label: 'Viva',   max: 5,  editable: true },
  { key: 'att_pct',      label: 'Att %',  max: null, editable: false },
  { key: 'att_marks',    label: 'Att (10)', max: 10, editable: false },
  { key: 'total',        label: 'Total',  max: 60, editable: false },
];

// ── Main component ────────────────────────────────────────────────────────────
export const LMSLabMarks = () => {
  const { assignmentId } = useParams();

  const [data, setData]         = useState(null);
  const [rows, setRows]         = useState([]);
  const [loading, setLoading]   = useState(false);
  const [saving, setSaving]     = useState(false);
  const [toast, setToast]       = useState(null);

  const showToast = (msg, type = 'success') => {
    setToast({ msg, type });
    setTimeout(() => setToast(null), 3500);
  };

  // ── Fetch roster ────────────────────────────────────────────────────────────
  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const res = await axios.get(`/api/faculty/courses/${assignmentId}/lab-marks`);
      setData(res.data);
      setRows(res.data.roster.map(r => ({ ...r, _dirty: false })));
    } catch (err) {
      showToast('Failed to load lab marks', 'error');
    } finally {
      setLoading(false);
    }
  }, [assignmentId]);

  useEffect(() => { fetchData(); }, [fetchData]);

  // ── Cell change handler ──────────────────────────────────────────────────────
  const handleChange = (idx, field, raw) => {
    setRows(prev => prev.map((r, i) => {
      if (i !== idx) return r;
      const val = raw === '' ? null : Math.min(Number(raw), COLUMNS.find(c => c.key === field)?.max ?? Infinity);
      const updated = { ...r, [field]: val, _dirty: true };
      // Recompute avg_ia on the fly
      const ia1 = field === 'ia1_marks' ? val : updated.ia1_marks;
      const ia2 = field === 'ia2_marks' ? val : updated.ia2_marks;
      updated.avg_ia = (ia1 != null && ia2 != null) ? Math.round((ia1 + ia2) / 2 * 100) / 100 : null;
      // Recompute total
      const rec  = field === 'record_marks' ? val : updated.record_marks;
      const viva = field === 'viva_marks'   ? val : updated.viva_marks;
      const attM = r.att_marks ?? 0;
      updated.total = (rec != null && updated.avg_ia != null && viva != null)
        ? Math.round((rec + updated.avg_ia + viva + attM) * 100) / 100
        : null;
      return updated;
    }));
  };

  // ── Save draft ───────────────────────────────────────────────────────────────
  const handleSave = async () => {
    setSaving(true);
    try {
      await axios.post(`/api/faculty/courses/${assignmentId}/lab-marks`, {
        entries: rows.map(r => ({
          student_id:   r.student_id,
          record_marks: r.record_marks,
          ia1_marks:    r.ia1_marks,
          ia2_marks:    r.ia2_marks,
          viva_marks:   r.viva_marks,
        })),
      });
      showToast('Lab marks saved successfully');
      fetchData();
    } catch (err) {
      showToast(err.response?.data?.detail || 'Save failed', 'error');
    } finally {
      setSaving(false);
    }
  };

  const dirtyCount   = rows.filter(r => r._dirty).length;

  // ── Summary stats ────────────────────────────────────────────────────────────
  const stats = [
    { label: 'Total Students', value: rows.length,                                          color: 'text-gray-700' },
    { label: 'Marks Entered',  value: rows.filter(r => r.record_marks != null).length,      color: 'text-blue-600' },
    { label: 'Pass (≥30/60)', value: rows.filter(r => r.total != null && r.total >= 30).length, color: 'text-green-600' },
    { label: 'Below Pass',    value: rows.filter(r => r.total != null && r.total < 30).length,  color: 'text-red-500' },
  ];

  return (
    <div className="max-w-full mx-auto space-y-6 p-4 md:p-6">

      {/* Toast */}
      {toast && (
        <div className={`fixed top-4 right-4 z-50 flex items-center gap-2 px-4 py-3 rounded-xl shadow-lg text-sm font-semibold
          ${toast.type === 'error'
            ? 'bg-red-50 text-red-700 border border-red-200'
            : 'bg-green-50 text-green-700 border border-green-200'}`}>
          {toast.type === 'error'
            ? <AlertCircle className="w-4 h-4" />
            : <CheckCircle className="w-4 h-4" />}
          {toast.msg}
        </div>
      )}

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
        <div>
          <Link
            to={`/faculty/courses/${assignmentId}/lms`}
            className="flex items-center gap-1 text-sm text-gray-500 hover:text-primary-600 font-medium mb-2"
          >
            <ArrowLeft className="w-4 h-4" /> Back to Course Dashboard
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 tracking-tight flex items-center gap-2">
            <FlaskConical className="w-6 h-6 text-emerald-600" />
            Lab Mark Entry
          </h1>
          {data && (
            <p className="text-sm text-gray-500 mt-0.5">
              {data.course_code} — {data.course_name} &nbsp;·&nbsp; {data.section}
            </p>
          )}
        </div>

        {/* Action buttons */}
        <div className="flex flex-wrap gap-2 flex-shrink-0">
          <button
            onClick={handleSave}
            disabled={saving || dirtyCount === 0}
            className="flex items-center gap-2 bg-gray-900 hover:bg-gray-800 disabled:opacity-40 text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors"
          >
            <Save className="w-4 h-4" />
            {saving ? 'Saving...' : `Save Marks${dirtyCount ? ` (${dirtyCount})` : ''}`}
          </button>
        </div>
      </div>

      {/* Mark schema info */}
      <div className="bg-blue-50 border border-blue-100 rounded-xl px-4 py-3">
        <p className="text-xs font-bold text-blue-700 uppercase tracking-wide mb-2">Mark Scheme — Total: 60</p>
        <div className="flex flex-wrap gap-3">
          {[
            { label: 'Record',  max: 30 },
            { label: 'IA-1',    max: 15 },
            { label: 'IA-2',    max: 15 },
            { label: 'Avg IA',  max: 15, note: 'auto' },
            { label: 'Viva',    max: 5  },
            { label: 'Att',     max: 10, note: 'auto' },
          ].map(c => (
            <span key={c.label} className="inline-flex items-center gap-1 bg-white border border-blue-100 rounded-lg px-3 py-1 text-xs font-semibold text-blue-800">
              {c.label} <span className="text-blue-400 font-normal">/{c.max}</span>
              {c.note && <span className="text-blue-400 font-normal ml-1">({c.note})</span>}
            </span>
          ))}
        </div>
        <p className="text-xs text-blue-500 mt-2">
          Attendance marks: ≥90%→10 | ≥85%→8 | ≥80%→6 | ≥75%→4 | &lt;75%→0
        </p>
      </div>

      {/* Table */}
      <div className="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
        {loading ? (
          <div className="flex justify-center items-center h-40">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600" />
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-100">
                  <th className="px-3 py-3 text-left font-bold text-gray-500 text-xs w-8">#</th>
                  <th className="px-3 py-3 text-left font-bold text-gray-600 text-xs">Reg. No.</th>
                  <th className="px-3 py-3 text-left font-bold text-gray-600 text-xs">Name</th>
                  {COLUMNS.map(col => (
                    <th key={col.key}
                        className={`px-2 py-3 text-center font-bold text-xs
                          ${col.key === 'total' ? 'text-emerald-700 bg-emerald-50'
                            : col.editable ? 'text-gray-700'
                            : 'text-gray-400'}`}>
                      {col.label}
                      {col.max && <span className="font-normal opacity-60 ml-0.5">/{col.max}</span>}
                    </th>
                  ))}
                  <th className="px-3 py-3 text-center font-bold text-gray-500 text-xs">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {rows.map((row, idx) => {
                  const isFail = row.total != null && row.total < 30;
                  return (
                    <tr
                      key={row.student_id}
                      className={`transition-colors
                        ${row._dirty ? 'bg-blue-50/40' : ''}
                        ${isFail ? 'bg-red-50/30 hover:bg-red-50/60' : 'hover:bg-gray-50'}`}
                    >
                      <td className="px-3 py-2.5 text-gray-400 text-xs">{idx + 1}</td>
                      <td className="px-3 py-2.5 font-mono text-xs text-gray-600">{row.register_number}</td>
                      <td className="px-3 py-2.5 font-semibold text-gray-900 whitespace-nowrap">
                        {row.first_name} {row.last_name}
                      </td>

                      {COLUMNS.map(col => (
                        <td key={col.key} className="px-2 py-2.5 text-center">
                          {col.editable ? (
                            <input
                              type="number"
                              min={0}
                              max={col.max}
                              step={0.5}
                              value={row[col.key] ?? ''}
                              onChange={e => handleChange(idx, col.key, e.target.value)}
                              className="w-16 text-center border border-gray-200 rounded-lg px-1.5 py-1
                                         text-sm focus:outline-none focus:ring-2 focus:ring-emerald-300
                                         hover:border-emerald-300"
                              placeholder="—"
                            />
                          ) : (
                            <span className={`font-mono text-sm
                              ${col.key === 'total'
                                ? isFail ? 'text-red-600 font-bold' : 'text-emerald-700 font-bold'
                                : 'text-gray-500'}`}>
                              {col.key === 'att_pct'
                                ? (row.att_pct != null ? `${row.att_pct}%` : '—')
                                : fmt(row[col.key])}
                            </span>
                          )}
                        </td>
                      ))}

                      <td className="px-3 py-2.5 text-center">
                        {row.record_marks != null
                          ? <Badge color="green">Entered</Badge>
                          : <Badge color="gray">Not entered</Badge>}
                      </td>
                    </tr>
                  );
                })}
                {rows.length === 0 && (
                  <tr>
                    <td colSpan={COLUMNS.length + 4}
                        className="text-center py-12 text-gray-400 text-sm">
                      No students enrolled in this course.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Summary stats */}
      {!loading && rows.length > 0 && (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {stats.map(s => (
            <div key={s.label} className="bg-white rounded-xl border border-gray-100 shadow-sm p-4 text-center">
              <p className="text-xs text-gray-500 font-medium uppercase tracking-wide mb-1">{s.label}</p>
              <p className={`text-2xl font-bold ${s.color}`}>{s.value}</p>
            </div>
          ))}
        </div>
      )}

    </div>
  );
};
