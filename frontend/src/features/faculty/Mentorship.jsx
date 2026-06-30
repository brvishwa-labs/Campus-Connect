import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import { Users, BookOpen, Clock, Plus, ChevronRight } from 'lucide-react';

// ── Mentee list item ──────────────────────────────────────────────────────────
const MenteeItem = ({ mentee, selected, onClick }) => (
  <button
    onClick={onClick}
    className={`w-full text-left px-4 py-3 border-b border-gray-100 hover:bg-gray-50 transition-colors ${
      selected ? 'bg-primary-50 border-l-4 border-l-primary-600' : ''
    }`}
  >
    <p className="font-semibold text-gray-900 text-sm">
      {mentee.first_name} {mentee.last_name}
    </p>
    <p className="text-xs text-gray-500 mt-0.5">
      Roll: {mentee.register_number} &nbsp;·&nbsp; Att:{' '}
      {mentee.attendance_pct != null ? `${mentee.attendance_pct}%` : '%'}
    </p>
  </button>
);

// ── Main component ────────────────────────────────────────────────────────────
export const Mentorship = () => {
  const [mentees, setMentees]             = useState([]);
  const [selected, setSelected]           = useState(null);
  const [loadingList, setLoadingList]     = useState(true);
  const [loadingDetail, setLoadingDetail] = useState(false);
  const [note, setNote]                   = useState('');
  const [addingNote, setAddingNote]       = useState(false);

  // ── Fetch mentees list ──────────────────────────────────────────────────────
  useEffect(() => {
    axios.get('/api/faculty/me/mentees')
      .then(res => setMentees(res.data))
      .catch(err => console.error('Failed to load mentees', err))
      .finally(() => setLoadingList(false));
  }, []);

  // ── Fetch selected mentee detail ────────────────────────────────────────────
  const loadDetail = useCallback((studentId) => {
    setLoadingDetail(true);
    axios.get(`/api/faculty/me/mentees/${studentId}`)
      .then(res => setSelected(res.data))
      .catch(err => console.error('Failed to load mentee detail', err))
      .finally(() => setLoadingDetail(false));
  }, []);

  // ── Add advising log ────────────────────────────────────────────────────────
  const handleAddLog = async () => {
    if (!note.trim() || !selected) return;
    setAddingNote(true);
    try {
      await axios.post(`/api/faculty/me/mentees/${selected.id}/logs`, { note });
      setNote('');
      loadDetail(selected.id);
    } catch (err) {
      console.error('Failed to add log', err);
    } finally {
      setAddingNote(false);
    }
  };

  // ── Render ──────────────────────────────────────────────────────────────────
  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900 tracking-tight mb-1">
          Mentorship &amp; Advising Panel
        </h1>
        <p className="text-sm text-gray-500">
          Monitor attendance percentages, backlog counts, and register direct advising notes.
        </p>
      </div>

      <div className="flex gap-6 h-[calc(100vh-200px)] min-h-[500px]">
        {/* ── Left: mentee list ─────────────────────────────────────────────── */}
        <div className="w-72 flex-shrink-0 bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden flex flex-col">
          <div className="px-4 py-3 border-b border-gray-100">
            <h2 className="text-sm font-bold text-gray-700">My Mentees</h2>
          </div>

          <div className="overflow-y-auto flex-1">
            {loadingList ? (
              <div className="flex justify-center items-center h-32">
                <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary-600" />
              </div>
            ) : mentees.length === 0 ? (
              <div className="p-6 text-center text-sm text-gray-400">
                <Users className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                No mentees assigned yet.
              </div>
            ) : (
              mentees.map(m => (
                <MenteeItem
                  key={m.id}
                  mentee={m}
                  selected={selected?.id === m.id}
                  onClick={() => loadDetail(m.id)}
                />
              ))
            )}
          </div>
        </div>

        {/* ── Right: detail panel ───────────────────────────────────────────── */}
        <div className="flex-1 overflow-y-auto space-y-5">
          {!selected && !loadingDetail && (
            <div className="flex flex-col items-center justify-center h-full text-gray-400">
              <ChevronRight className="w-10 h-10 mb-2 text-gray-200" />
              <p className="text-sm">Select a mentee to view details</p>
            </div>
          )}

          {loadingDetail && (
            <div className="flex justify-center items-center h-32">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600" />
            </div>
          )}

          {selected && !loadingDetail && (
            <>
              {/* Student header card */}
              <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-5">
                <h2 className="text-lg font-bold text-gray-900">
                  {selected.first_name} {selected.last_name}
                </h2>
                <p className="text-sm text-gray-500 mt-0.5">
                  Dept: {selected.department ?? '—'} &nbsp;·&nbsp; Semester: {selected.current_semester ?? '—'} &nbsp;·&nbsp; {selected.college_email}
                </p>
              </div>

              {/* Stats */}
              <div className="grid grid-cols-3 gap-4">
                {[
                  { label: 'Current CGPA',   value: '—' },
                  { label: 'Attendance Rate', value: selected.attendance_percentage != null ? `${selected.attendance_percentage}%` : '—' },
                  { label: 'Backlogs Count',  value: selected.backlog_count ?? '—' },
                ].map(stat => (
                  <div key={stat.label} className="bg-white rounded-xl border border-gray-100 shadow-sm p-4 text-center">
                    <p className="text-xs text-gray-500 uppercase tracking-wide font-medium mb-1">{stat.label}</p>
                    <p className="text-2xl font-bold text-primary-600">{stat.value}</p>
                  </div>
                ))}
              </div>

              {/* Register Advising Note */}
              <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-5">
                <h3 className="text-sm font-bold text-gray-700 flex items-center gap-2 mb-4">
                  <BookOpen className="w-4 h-4 text-primary-500" />
                  Register Advising Note
                </h3>
                <textarea
                  value={note}
                  onChange={e => setNote(e.target.value)}
                  rows={4}
                  placeholder="Document key takeaways, performance reviews, or personal challenges..."
                  className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary-300 resize-none"
                />
                <button
                  onClick={handleAddLog}
                  disabled={addingNote || !note.trim()}
                  className="mt-3 bg-primary-600 hover:bg-primary-700 disabled:opacity-50 text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors flex items-center gap-2"
                >
                  <Plus className="w-4 h-4" />
                  {addingNote ? 'Adding...' : 'Add Log Entry'}
                </button>
              </div>

              {/* Previous Advising Logs */}
              <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-5">
                <h3 className="text-sm font-bold text-gray-700 flex items-center gap-2 mb-4">
                  <BookOpen className="w-4 h-4 text-gray-400" />
                  Previous Advising Logs
                </h3>
                {selected.advising_logs.length === 0 ? (
                  <p className="text-sm text-gray-400 italic">No advising logs exist for this student.</p>
                ) : (
                  <div className="space-y-3">
                    {selected.advising_logs.map(log => (
                      <div key={log.id} className="border-l-2 border-primary-200 pl-3 py-1">
                        <p className="text-sm text-gray-700">{log.note}</p>
                        <p className="text-xs text-gray-400 mt-0.5 flex items-center gap-1">
                          <Clock className="w-3 h-3" />
                          {new Date(log.created_at).toLocaleString()}
                        </p>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
};
