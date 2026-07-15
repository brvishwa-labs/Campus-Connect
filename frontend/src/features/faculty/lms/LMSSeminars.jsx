import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import { Users, ArrowLeft, Save, Send, CheckCircle, AlertCircle, Calendar, Info } from 'lucide-react';

// Seminar rubric criteria configuration
const RUBRIC_CRITERIA = [
  { key: 'rubric_content_relevance',   label: 'Content Relevance',  max: null, hint: 'Relevance and depth of content' },
  { key: 'rubric_presentation_skills', label: 'Presentation Skills', max: null, hint: 'Clarity and delivery of presentation' },
  { key: 'rubric_resources_used',      label: 'Resources Used',     max: null, hint: 'Quality and variety of references' },
  { key: 'rubric_time_management',     label: 'Time Management',    max: null, hint: 'Adherence to allotted time' },
  { key: 'rubric_question_handling',   label: 'Q&A Handling',       max: 2,    hint: 'Accuracy of answers (max 2)' },
  { key: 'rubric_team_coordination',   label: 'Team Coordination',  max: 1,    hint: 'Collaboration and role clarity (max 1)' },
];

const computeTotal = (row) => {
  const vals = RUBRIC_CRITERIA.map(c => parseFloat(row[c.key] ?? 0) || 0);
  const total = vals.reduce((a, b) => a + b, 0);
  return parseFloat(total.toFixed(2));
};

export const LMSSeminars = () => {
  const { assignmentId } = useParams();

  const [gradeRoster, setGradeRoster] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [publishingTopics, setPublishingTopics] = useState(false);
  const [publishingMarks, setPublishingMarks] = useState(false);
  const [maxMarks, setMaxMarks] = useState(10);
  const [useRubric, setUseRubric] = useState(true);
  const [toast, setToast] = useState(null);

  useEffect(() => {
    const fetchRoster = async () => {
      try {
        const response = await axios.get(`/api/faculty/courses/${assignmentId}/seminars`);
        setGradeRoster(response.data.roster.map(r => ({ ...r, _dirty: false })));
        if (response.data.roster.length > 0) {
          const first = response.data.roster[0];
          // If rubric data exists in the first row, auto-enable rubric mode
          const hasRubric = RUBRIC_CRITERIA.some(c => first[c.key] != null);
          setUseRubric(hasRubric || true);
          setMaxMarks(first.max_marks || 10);
        }
      } catch (err) {
        console.error("Failed to fetch seminar roster:", err);
        setToast({ text: 'Failed to load seminar roster', type: 'error' });
        setTimeout(() => setToast(null), 3000);
      } finally {
        setLoading(false);
      }
    };
    fetchRoster();
  }, [assignmentId]);

  const showToast = (text, type = 'success') => {
    setToast({ text, type });
    setTimeout(() => setToast(null), 3000);
  };

  const handleDateChange = (idx, val) => {
    setGradeRoster(prev => prev.map((r, i) =>
      i === idx ? { ...r, seminar_date: val, _dirty: true } : r
    ));
  };

  const handleTopicChange = (idx, val) => {
    setGradeRoster(prev => prev.map((r, i) =>
      i === idx ? { ...r, seminar_topic: val, _dirty: true } : r
    ));
  };

  const handleMarksChange = (idx, val) => {
    setGradeRoster(prev => prev.map((r, i) =>
      i === idx ? { ...r, marks_obtained: val === '' ? null : Number(val), _dirty: true } : r
    ));
  };

  // Rubric field handler — auto-recalculates total
  const handleRubricChange = (idx, key, val) => {
    setGradeRoster(prev => prev.map((r, i) => {
      if (i !== idx) return r;
      const updated = { ...r, [key]: val === '' ? null : Number(val), _dirty: true };
      updated.marks_obtained = computeTotal(updated);
      return updated;
    }));
  };

  const buildEntries = () => gradeRoster.map(r => ({
    student_id:                 r.student_id,
    seminar_date:               r.seminar_date,
    seminar_topic:              r.seminar_topic,
    marks_obtained:             useRubric ? computeTotal(r) : r.marks_obtained,
    max_marks:                  Number(maxMarks),
    rubric_content_relevance:   useRubric ? (r.rubric_content_relevance ?? null) : null,
    rubric_presentation_skills: useRubric ? (r.rubric_presentation_skills ?? null) : null,
    rubric_resources_used:      useRubric ? (r.rubric_resources_used ?? null) : null,
    rubric_time_management:     useRubric ? (r.rubric_time_management ?? null) : null,
    rubric_question_handling:   useRubric ? (r.rubric_question_handling ?? null) : null,
    rubric_team_coordination:   useRubric ? (r.rubric_team_coordination ?? null) : null,
  }));

  const handleSaveDraft = async () => {
    setSaving(true);
    try {
      await axios.post(`/api/faculty/courses/${assignmentId}/seminars`, { entries: buildEntries() });
      showToast('Seminar details saved successfully!');
      setGradeRoster(prev => prev.map(r => ({ ...r, _dirty: false })));
    } catch (err) {
      console.error(err);
      showToast(err.response?.data?.detail || 'Failed to save seminar details', 'error');
    } finally {
      setSaving(false);
    }
  };

  const handlePublishTopics = async () => {
    if (!window.confirm("Publish seminar dates and topics to student pages?")) return;
    setPublishingTopics(true);
    try {
      await axios.post(`/api/faculty/courses/${assignmentId}/seminars`, { entries: buildEntries() });
      await axios.post(`/api/faculty/courses/${assignmentId}/seminars/publish-topics`);
      showToast('Seminar dates & topics published to students!');
      setGradeRoster(prev => prev.map(r => ({ ...r, is_topic_published: true, _dirty: false })));
    } catch (err) {
      console.error(err);
      showToast('Failed to publish topics', 'error');
    } finally {
      setPublishingTopics(false);
    }
  };

  const handlePublishMarks = async () => {
    if (!window.confirm("Publish seminar marks to students? They will be visible in their grade sheets.")) return;
    setPublishingMarks(true);
    try {
      await axios.post(`/api/faculty/courses/${assignmentId}/seminars`, { entries: buildEntries() });
      await axios.post(`/api/faculty/courses/${assignmentId}/seminars/publish-marks`);
      showToast('Seminar marks published to student portals!');
      setGradeRoster(prev => prev.map(r => ({ ...r, is_marks_published: true, _dirty: false })));
    } catch (err) {
      console.error(err);
      showToast('Failed to publish marks', 'error');
    } finally {
      setPublishingMarks(false);
    }
  };

  const dirtyCount = gradeRoster.filter(r => r._dirty).length;
  const isMarksPublished = gradeRoster.some(r => r.is_marks_published);

  return (
    <div className="max-w-full mx-auto space-y-6 p-4 md:p-6 lg:p-8">
      {/* Toast */}
      {toast && (
        <div className={`fixed top-4 right-4 z-50 flex items-center gap-2 px-4 py-3 rounded-xl shadow-lg text-sm font-semibold
          ${toast.type === 'error' ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'}`}>
          {toast.type === 'error' ? <AlertCircle className="w-4 h-4" /> : <CheckCircle className="w-4 h-4" />}
          {toast.text}
        </div>
      )}

      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <Link
            to={`/faculty/courses/${assignmentId}/lms`}
            className="flex items-center gap-1 text-sm text-gray-500 hover:text-pink-600 font-medium mb-2"
          >
            <ArrowLeft className="w-4 h-4" /> Back to Dashboard
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 tracking-tight flex items-center gap-2">
            <Users className="w-6 h-6 text-pink-600" />
            Seminar Grade Book
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">
            Assign seminar dates, topics, and evaluate student marks using rubric criteria.
          </p>
        </div>

        {/* Actions */}
        <div className="flex flex-wrap gap-2">
          <button
            onClick={handleSaveDraft}
            disabled={saving || dirtyCount === 0}
            className="flex items-center gap-2 bg-gray-950 hover:bg-black disabled:opacity-40 text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors shadow-sm"
          >
            <Save className="w-4 h-4" /> {saving ? 'Saving...' : `Save Draft${dirtyCount ? ` (${dirtyCount})` : ''}`}
          </button>

          <button
            onClick={handlePublishTopics}
            disabled={publishingTopics}
            className="flex items-center gap-2 bg-pink-600 hover:bg-pink-700 disabled:opacity-40 text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors shadow-sm"
          >
            <Calendar className="w-4 h-4" /> {publishingTopics ? 'Publishing...' : 'Publish Topics'}
          </button>

          <button
            onClick={handlePublishMarks}
            disabled={publishingMarks}
            className="flex items-center gap-2 bg-pink-700 hover:bg-pink-800 disabled:opacity-40 text-white text-sm font-semibold px-4 py-2 rounded-lg transition-colors shadow-sm"
          >
            <Send className="w-4 h-4" /> {publishingMarks ? 'Publishing...' : isMarksPublished ? 'Re-Publish Marks' : 'Publish Marks'}
          </button>
        </div>
      </div>

      {/* Settings bar */}
      <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-5 flex flex-wrap items-center gap-6">
        {/* Max Marks */}
        <div className="flex items-center gap-3">
          <div>
            <h3 className="text-[13px] font-bold text-gray-700 uppercase tracking-wide mb-0.5">Max Marks</h3>
            <p className="text-xs text-gray-400">Total for seminar evaluation</p>
          </div>
          <input
            type="number"
            min={1}
            max={1000}
            value={maxMarks}
            onChange={(e) => setMaxMarks(e.target.value === '' ? '' : Number(e.target.value))}
            className="w-24 text-center border border-gray-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-pink-500 focus:border-transparent outline-none font-bold text-gray-800"
          />
        </div>

        {/* Rubric toggle */}
        <div className="flex items-center gap-3 border-l border-gray-100 pl-6">
          <div>
            <h3 className="text-[13px] font-bold text-gray-700 uppercase tracking-wide mb-0.5">Marking Mode</h3>
            <p className="text-xs text-gray-400">Use rubric criteria or enter total directly</p>
          </div>
          <div className="flex rounded-lg overflow-hidden border border-gray-200">
            <button
              onClick={() => setUseRubric(true)}
              className={`px-3 py-1.5 text-xs font-bold transition-colors ${useRubric ? 'bg-pink-600 text-white' : 'bg-white text-gray-600 hover:bg-gray-50'}`}
            >
              Rubric
            </button>
            <button
              onClick={() => setUseRubric(false)}
              className={`px-3 py-1.5 text-xs font-bold transition-colors ${!useRubric ? 'bg-pink-600 text-white' : 'bg-white text-gray-600 hover:bg-gray-50'}`}
            >
              Direct
            </button>
          </div>
        </div>

        {useRubric && (
          <div className="flex items-start gap-2 text-xs text-pink-700 bg-pink-50 border border-pink-100 rounded-lg px-3 py-2">
            <Info className="w-3.5 h-3.5 mt-0.5 flex-shrink-0" />
            <span>Total marks are auto-calculated from rubric scores. Q&amp;A max 2, Team Coordination max 1.</span>
          </div>
        )}
      </div>

      {/* Rubric legend */}
      {useRubric && (
        <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-4">
          <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-3">Rubric Criteria</p>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
            {RUBRIC_CRITERIA.map(c => (
              <div key={c.key} className="bg-pink-50/50 border border-pink-100 rounded-lg p-2.5 text-center">
                <p className="text-[11px] font-bold text-pink-800 mb-0.5">{c.label}</p>
                <p className="text-[10px] text-gray-500">{c.hint}</p>
                {c.max != null && (
                  <span className="inline-block mt-1 text-[10px] font-bold bg-pink-200 text-pink-800 rounded px-1.5">max {c.max}</span>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Table */}
      <div className="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
        {loading ? (
          <div className="flex justify-center items-center h-48">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-pink-600" />
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-100">
                  <th className="px-4 py-3 text-left font-bold text-gray-600 w-10">#</th>
                  <th className="px-4 py-3 text-left font-bold text-gray-600 w-32">Reg. No.</th>
                  <th className="px-4 py-3 text-left font-bold text-gray-600 w-44">Student Name</th>
                  <th className="px-4 py-3 text-left font-bold text-gray-600 w-36">Date</th>
                  <th className="px-4 py-3 text-left font-bold text-gray-600">Seminar Topic</th>
                  {useRubric ? (
                    <>
                      {RUBRIC_CRITERIA.map(c => (
                        <th key={c.key} className="px-3 py-3 text-center font-bold text-gray-600 whitespace-nowrap min-w-[90px]">
                          {c.label}
                          {c.max != null && <span className="block text-[10px] font-normal text-gray-400">max {c.max}</span>}
                        </th>
                      ))}
                      <th className="px-4 py-3 text-center font-bold text-pink-700 w-24">Total</th>
                    </>
                  ) : (
                    <th className="px-4 py-3 text-center font-bold text-gray-600 w-36">Marks Obtained</th>
                  )}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {gradeRoster.map((row, idx) => {
                  const total = computeTotal(row);
                  return (
                    <tr key={row.student_id} className={`hover:bg-gray-50/50 transition-colors ${row._dirty ? 'bg-pink-50/10' : ''}`}>
                      <td className="px-4 py-3 text-gray-400 text-xs">{idx + 1}</td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-700">{row.register_number}</td>
                      <td className="px-4 py-3 font-semibold text-gray-900">
                        {row.first_name} {row.last_name}
                      </td>
                      <td className="px-4 py-3">
                        <input
                          type="date"
                          value={row.seminar_date || ''}
                          onChange={(e) => handleDateChange(idx, e.target.value)}
                          className="w-full border border-gray-200 rounded-lg px-2.5 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-pink-300 text-gray-700"
                        />
                      </td>
                      <td className="px-4 py-3">
                        <input
                          type="text"
                          value={row.seminar_topic || ''}
                          onChange={(e) => handleTopicChange(idx, e.target.value)}
                          placeholder="Enter seminar topic..."
                          className="w-full border border-gray-200 rounded-lg px-3 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-pink-300 text-gray-700 font-medium"
                        />
                      </td>
                      {useRubric ? (
                        <>
                          {RUBRIC_CRITERIA.map(c => (
                            <td key={c.key} className="px-3 py-3 text-center">
                              <input
                                type="number"
                                min={0}
                                max={c.max ?? 100}
                                step={0.5}
                                value={row[c.key] ?? ''}
                                onChange={(e) => handleRubricChange(idx, c.key, e.target.value)}
                                className="w-16 text-center border border-gray-200 rounded-lg px-1.5 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-pink-300 font-semibold text-gray-800"
                                placeholder="—"
                              />
                            </td>
                          ))}
                          <td className="px-4 py-3 text-center">
                            <span className="inline-block font-bold text-sm text-pink-700 bg-pink-50 border border-pink-200 rounded-lg px-2 py-1 min-w-[40px]">
                              {total > 0 ? total : '—'}
                            </span>
                          </td>
                        </>
                      ) : (
                        <td className="px-4 py-3 text-center">
                          <input
                            type="number"
                            min={0}
                            max={maxMarks || 100}
                            step={0.5}
                            value={row.marks_obtained ?? ''}
                            onChange={(e) => handleMarksChange(idx, e.target.value)}
                            className="w-20 text-center border border-gray-200 rounded-lg px-2.5 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-pink-300 font-semibold text-gray-800"
                            placeholder="—"
                          />
                        </td>
                      )}
                    </tr>
                  );
                })}
                {gradeRoster.length === 0 && (
                  <tr>
                    <td colSpan={useRubric ? 6 + RUBRIC_CRITERIA.length + 1 : 7} className="text-center py-12 text-gray-400 text-sm font-medium">
                      No students found in this course section.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};
