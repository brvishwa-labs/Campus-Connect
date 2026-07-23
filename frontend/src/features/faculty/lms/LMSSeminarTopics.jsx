import React, { useState, useEffect, useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import { ArrowLeft, Save, Plus, Trash2, SeparatorHorizontal, CheckCircle2, AlertTriangle, Users } from 'lucide-react';

export const LMSSeminarTopics = () => {
  const { assignmentId } = useParams();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);

  const [courseAssignment, setCourseAssignment] = useState(null);

  // Array of row items. Row types: 'topic' | 'separator'
  // Item structure for topic: { id: string, members_list: [{ register_no: string, name: string }], register_no: string, student_names: string, seminar_topic: string }
  // Item structure for separator: { id: string, type: 'separator', label: string }
  const [rows, setRows] = useState([]);

  const getParticipantsList = useCallback((row) => {
    if (Array.isArray(row.members_list) && row.members_list.length > 0) {
      return row.members_list;
    }
    if (Array.isArray(row.participants_list) && row.participants_list.length > 0) {
      return row.participants_list;
    }
    const regNos = (row.register_no || '').split(/[\n,]+/).map(s => s.trim());
    const names = (row.student_names || '').split(/[\n,]+/).map(s => s.trim());
    const maxLen = Math.max(regNos.length, names.length, 1);
    const list = [];
    for (let i = 0; i < maxLen; i++) {
      list.push({ register_no: regNos[i] || '', name: names[i] || '' });
    }
    return list;
  }, []);

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const coursesRes = await axios.get('/api/faculty/me/courses?t=' + Date.now());
      const foundCourse = coursesRes.data.find(c => c.id.toString() === assignmentId);
      if (!foundCourse) throw new Error('Course Assignment not found.');
      setCourseAssignment(foundCourse);

      const rawData = foundCourse.course?.seminar_topics_data;
      if (rawData) {
        try {
          const parsed = JSON.parse(rawData);
          if (Array.isArray(parsed)) {
            setRows(parsed);
          }
        } catch {
          setRows([]);
        }
      } else {
        setRows([]);
      }
    } catch (err) {
      console.error(err);
      setError(err.message || 'Failed to load seminar topics data.');
    } finally {
      setLoading(false);
    }
  }, [assignmentId]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const addTopicRow = () => {
    const newRow = {
      id: 'topic_' + Date.now() + '_' + Math.random().toString(36).substr(2, 4),
      type: 'topic',
      members_list: [{ register_no: '', name: '' }],
      register_no: '',
      student_names: '',
      seminar_topic: ''
    };
    setRows(prev => [...prev, newRow]);
  };

  const addSeparatorRow = () => {
    const newRow = {
      id: 'sep_' + Date.now() + '_' + Math.random().toString(36).substr(2, 4),
      type: 'separator',
      label: 'Seminar Group Break / Separator'
    };
    setRows(prev => [...prev, newRow]);
  };

  const addParticipantToTopic = (topicId) => {
    setRows(prev => prev.map(row => {
      if (row.id !== topicId) return row;
      const current = getParticipantsList(row);
      const updated = [...current, { register_no: '', name: '' }];
      return {
        ...row,
        members_list: updated,
        register_no: updated.map(m => m.register_no).filter(Boolean).join('\n'),
        student_names: updated.map(m => m.name).filter(Boolean).join('\n'),
      };
    }));
  };

  const removeParticipantFromTopic = (topicId, pIdx) => {
    setRows(prev => prev.map(row => {
      if (row.id !== topicId) return row;
      const current = getParticipantsList(row);
      if (current.length <= 1) return row;
      const updated = current.filter((_, idx) => idx !== pIdx);
      return {
        ...row,
        members_list: updated,
        register_no: updated.map(m => m.register_no).filter(Boolean).join('\n'),
        student_names: updated.map(m => m.name).filter(Boolean).join('\n'),
      };
    }));
  };

  const updateParticipant = (topicId, pIdx, field, value) => {
    setRows(prev => prev.map(row => {
      if (row.id !== topicId) return row;
      const current = getParticipantsList(row);
      const updated = current.map((m, idx) =>
        idx === pIdx ? { ...m, [field]: value } : m
      );
      return {
        ...row,
        members_list: updated,
        register_no: updated.map(m => m.register_no).filter(Boolean).join('\n'),
        student_names: updated.map(m => m.name).filter(Boolean).join('\n'),
      };
    }));
  };

  const updateRow = (id, field, value) => {
    setRows(prev => prev.map(row => row.id === id ? { ...row, [field]: value } : row));
  };

  const deleteRow = (id) => {
    setRows(prev => prev.filter(row => row.id !== id));
  };

  const handleSave = async () => {
    if (!courseAssignment?.course?.id) return;
    setSaving(true);
    setSuccess(false);
    setError(null);
    try {
      const sanitizedRows = rows.map(row => {
        if (row.type !== 'separator') {
          const pList = getParticipantsList(row);
          return {
            ...row,
            members_list: pList,
            register_no: pList.map(m => m.register_no).filter(Boolean).join('\n'),
            student_names: pList.map(m => m.name).filter(Boolean).join('\n'),
          };
        }
        return row;
      });

      const serialized = JSON.stringify(sanitizedRows);
      await axios.put('/api/courses/' + courseAssignment.course.id, {
        seminar_topics_data: serialized
      });
      setCourseAssignment(prev => prev ? {
        ...prev,
        course: { ...prev.course, seminar_topics_data: serialized }
      } : prev);
      setSuccess(true);
      setTimeout(() => setSuccess(false), 3000);
    } catch (err) {
      console.error(err);
      setError(err.response?.data?.detail || 'Failed to save seminar topics.');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  const course = courseAssignment?.course || {};

  return (
    <div className="max-w-7xl mx-auto p-4 md:p-6 lg:p-8 space-y-6">
      {/* Top Navigation & Title */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <Link
            to={`/faculty/courses/${assignmentId}/lms`}
            className="text-gray-500 hover:text-primary-600 transition-colors flex items-center gap-1 text-sm font-medium mb-2"
          >
            <ArrowLeft className="w-4 h-4" /> Back to Dashboard
          </Link>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-amber-50 text-amber-600 rounded-xl flex items-center justify-center">
              <Users className="w-5 h-5" />
            </div>
            <div>
              <h1 className="text-2xl font-extrabold text-gray-900 tracking-tight">Seminar Topics</h1>
              <p className="text-xs text-gray-500 font-medium">
                {course.code ? `${course.code} - ${course.name}` : course.name}
              </p>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={addTopicRow}
            className="flex items-center gap-1.5 px-4 py-2 bg-amber-50 text-amber-700 font-bold text-sm rounded-xl border border-amber-200 hover:bg-amber-100 transition-colors"
          >
            <Plus className="w-4 h-4" /> Add Topic Row
          </button>
          <button
            onClick={addSeparatorRow}
            className="flex items-center gap-1.5 px-4 py-2 bg-gray-100 text-gray-700 font-bold text-sm rounded-xl border border-gray-200 hover:bg-gray-200 transition-colors"
          >
            <SeparatorHorizontal className="w-4 h-4" /> Add Separator
          </button>
          <button
            onClick={handleSave}
            disabled={saving}
            className="flex items-center gap-2 px-5 py-2 bg-primary-600 text-white font-bold text-sm rounded-xl hover:bg-primary-700 transition-colors shadow-sm disabled:opacity-50"
          >
            <Save className="w-4 h-4" /> {saving ? 'Saving...' : 'Save Topics'}
          </button>
        </div>
      </div>

      {/* Alerts */}
      {success && (
        <div className="flex items-center gap-2 p-4 bg-green-50 text-green-700 border border-green-200 rounded-xl text-sm font-medium">
          <CheckCircle2 className="w-5 h-5 text-green-600 shrink-0" />
          Seminar topics saved successfully!
        </div>
      )}
      {error && (
        <div className="flex items-center gap-2 p-4 bg-red-50 text-red-700 border border-red-200 rounded-xl text-sm font-medium">
          <AlertTriangle className="w-5 h-5 text-red-600 shrink-0" />
          {error}
        </div>
      )}

      {/* Main Card */}
      <div className="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden p-6">
        <p className="text-xs text-gray-500 mb-4 font-medium">
          Enter seminar topics and participant details below. Click <span className="font-bold text-amber-700">+</span> next to any roll number / student name box to add additional participants for that topic.
        </p>

        <div className="overflow-x-auto border border-gray-200 rounded-xl">
          <table className="w-full text-left text-sm border-collapse">
            <thead>
              <tr className="bg-gray-50 border-b border-gray-200 text-gray-700 font-bold text-xs uppercase tracking-wider">
                <th className="py-3 px-4 w-12 text-center">#</th>
                <th className="py-3 px-4 w-48">Register No.</th>
                <th className="py-3 px-4">Student Name(s)</th>
                <th className="py-3 px-4 w-64">Seminar Topic</th>
                <th className="py-3 px-4 w-28 text-center">Signature</th>
                <th className="py-3 px-4 w-16 text-center">Action</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {rows.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 text-center text-gray-400 font-medium italic">
                    No seminar topics added yet. Click "Add Topic Row" to begin.
                  </td>
                </tr>
              ) : (
                rows.map((row, idx) => {
                  if (row.type === 'separator') {
                    return (
                      <tr key={row.id} className="bg-amber-50/60 border-y-2 border-amber-200">
                        <td className="py-2.5 px-4 text-center font-bold text-amber-700 text-xs">{idx + 1}</td>
                        <td colSpan={4} className="py-2.5 px-4">
                          <input
                            type="text"
                            value={row.label || ''}
                            onChange={(e) => updateRow(row.id, 'label', e.target.value)}
                            placeholder="Separator Label (e.g., Seminar Group A / Day 1)"
                            className="w-full bg-transparent font-bold text-amber-800 text-xs border-b border-dashed border-amber-300 focus:outline-none focus:border-amber-600"
                          />
                        </td>
                        <td className="py-2.5 px-4 text-center">
                          <button
                            onClick={() => deleteRow(row.id)}
                            className="p-1 text-red-500 hover:text-red-700 hover:bg-red-50 rounded transition-colors"
                            title="Delete Separator"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </td>
                      </tr>
                    );
                  }

                  const participants = getParticipantsList(row);

                  return (
                    <tr key={row.id} className="hover:bg-gray-50/50 transition-colors align-top">
                      <td className="py-3 px-4 text-center font-bold text-gray-500 text-xs pt-4">{idx + 1}</td>
                      
                      {/* Paired Register No and Student Name inputs */}
                      <td colSpan={2} className="py-3 px-4">
                        <div className="space-y-2">
                          {participants.map((m, pIdx) => (
                            <div key={pIdx} className="flex items-center gap-2">
                              <span className="text-[11px] font-bold text-amber-600 w-5 text-right shrink-0">{pIdx + 1}.</span>
                              <div className="w-44 shrink-0">
                                <input
                                  type="text"
                                  value={m.register_no || ''}
                                  onChange={(e) => updateParticipant(row.id, pIdx, 'register_no', e.target.value)}
                                  placeholder="Register No. (e.g. 21CSE005)"
                                  className="w-full px-3 py-1.5 bg-gray-50 border border-gray-200 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all outline-none"
                                />
                              </div>
                              <div className="flex-1">
                                <input
                                  type="text"
                                  value={m.name || ''}
                                  onChange={(e) => updateParticipant(row.id, pIdx, 'name', e.target.value)}
                                  placeholder="Student Name"
                                  className="w-full px-3 py-1.5 bg-gray-50 border border-gray-200 rounded-lg text-xs font-medium focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all outline-none"
                                />
                              </div>
                              <button
                                type="button"
                                onClick={() => addParticipantToTopic(row.id)}
                                className="px-2 py-1.5 bg-amber-50 text-amber-700 hover:bg-amber-100 rounded-lg transition-colors border border-amber-200 flex items-center gap-1 shrink-0 text-xs font-bold shadow-xs"
                                title="Add next participant (+)"
                              >
                                <Plus className="w-3.5 h-3.5" />
                              </button>
                              {participants.length > 1 && (
                                <button
                                  type="button"
                                  onClick={() => removeParticipantFromTopic(row.id, pIdx)}
                                  className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors shrink-0"
                                  title="Remove participant"
                                >
                                  <Trash2 className="w-3.5 h-3.5" />
                                </button>
                              )}
                            </div>
                          ))}
                        </div>
                      </td>

                      <td className="py-3 px-4 pt-4">
                        <input
                          type="text"
                          value={row.seminar_topic || ''}
                          onChange={(e) => updateRow(row.id, 'seminar_topic', e.target.value)}
                          placeholder="Enter Seminar Topic Title"
                          className="w-full px-3 py-1.5 bg-gray-50 border border-gray-200 rounded-lg text-xs font-medium focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all outline-none"
                        />
                      </td>
                      <td className="py-3 px-4 text-center text-xs text-gray-400 italic pt-4">
                        Blank for print
                      </td>
                      <td className="py-3 px-4 text-center pt-4">
                        <button
                          onClick={() => deleteRow(row.id)}
                          className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                          title="Delete Topic Row"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
