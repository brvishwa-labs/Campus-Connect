import React, { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import axios from 'axios';
import {
  ArrowLeft, User as UserIcon, Calendar, AlertCircle,
  CheckCircle, BookOpen, ChevronDown, Plus, Trash2,
  Info, Briefcase, Shield
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';

// ─── Main Component ──────────────────────────────────────────────────────────
export const HODLeaveApply = () => {
  const navigate = useNavigate();
  const { user } = useAuth();

  const [facultyProfile, setFacultyProfile] = useState(null);
  const [leaveData, setLeaveData] = useState(null);
  const [balance, setBalance] = useState(null);

  const [formData, setFormData] = useState({
    leave_type: 'Casual Leave',
    from_date: '',
    to_date: '',
    reason: '',
    alternate_hod_faculty_id: '',
    proof_link: ''
  });

  const [arrangements, setArrangements] = useState([]);
  const [showSubstitutes, setShowSubstitutes] = useState(false);

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  useEffect(() => {
    if (formData.from_date && formData.to_date) {
      if (new Date(formData.from_date) > new Date(formData.to_date)) {
        setError('To Date cannot be earlier than From Date.');
      } else {
        setError('');
      }
    }
  }, [formData.from_date, formData.to_date]);

  const fetchData = async () => {
    try {
      const [facRes, prepRes, balRes] = await Promise.all([
        axios.get('/api/auth/profile'),
        axios.get('/api/leave/hod-leave-preparation-data'),
        axios.get('/api/leave/balances').catch(() => ({ data: null }))
      ]);
      setFacultyProfile(facRes.data);
      setLeaveData(prepRes.data);
      setBalance(balRes.data);

      // Auto-populate arrangements for courses HOD teaches
      if (prepRes.data.my_courses && prepRes.data.my_courses.length > 0) {
        const autoArr = prepRes.data.my_courses.map(course => ({
          substitute_faculty_id: '',
          subject: course.course_code,
          class_section: course.class_section,
          section_id: course.section_id,
          period: 'All Periods',
          day: 'All Days',
          compensation_date: '',
          compensation_period: ''
        }));
        setArrangements(autoArr);
        setShowSubstitutes(true);
      }
    } catch (err) {
      console.error(err);
      setError('Failed to load preparation data. Ensure you are logged in as HOD.');
    }
  };

  const getTodayStr = () => new Date().toISOString().split('T')[0];

  const getDurationDays = () => {
    if (!formData.from_date || !formData.to_date) return 0;
    const diff = (new Date(formData.to_date) - new Date(formData.from_date)) / (1000 * 60 * 60 * 24);
    return diff >= 0 ? Math.round(diff) + 1 : 0;
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleArrangementChange = (index, field, value) => {
    const newArr = [...arrangements];
    newArr[index][field] = value;
    setArrangements(newArr);
  };

  const addArrangementRow = () => {
    setArrangements([...arrangements, {
      substitute_faculty_id: '', subject: '', class_section: '',
      period: 'All Periods', day: 'All Days', compensation_date: '', compensation_period: ''
    }]);
  };

  const removeArrangementRow = (index) => {
    const newArr = [...arrangements];
    newArr.splice(index, 1);
    setArrangements(newArr);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError('');

    if (new Date(formData.from_date) > new Date(formData.to_date)) {
      setError('To Date cannot be earlier than From Date.');
      setIsSubmitting(false);
      return;
    }

    if (!formData.alternate_hod_faculty_id) {
      setError('You must assign a faculty member to delegate department responsibilities.');
      setIsSubmitting(false);
      return;
    }

    const validArrangements = arrangements
      .filter(a => a.substitute_faculty_id !== '')
      .map(a => ({
        ...a,
        section_id: a.section_id ? parseInt(a.section_id) : null,
        compensation_date: a.compensation_date || null,
        compensation_period: a.compensation_period || null,
        day: a.day || null,
      }));

    try {
      const payload = {
        leave_type: formData.leave_type,
        from_date: formData.from_date,
        to_date: formData.to_date,
        reason: formData.reason,
        alternate_hod_faculty_id: parseInt(formData.alternate_hod_faculty_id),
        attachment_url: formData.proof_link || null,
        arrangements: validArrangements
      };
      await axios.post('/api/leave/hod-leave-request', payload);
      setSuccess('Leave request submitted successfully! The selected faculty will be notified to accept delegation.');
      setTimeout(() => navigate('/hod/my-leave'), 1500);
    } catch (err) {
      console.error(err);
      const detail = err.response?.data?.detail || err.response?.data?.message || 'Failed to submit leave request.';
      setError(typeof detail === 'string' ? detail : JSON.stringify(detail));
    } finally {
      setIsSubmitting(false);
    }
  };

  const alternateCandidates = leaveData?.alternate_candidates || [];
  const duration = getDurationDays();

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      {/* Header */}
      <div className="mb-2">
        <Link to="/hod/my-leave" className="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors mb-4">
          <ArrowLeft className="w-4 h-4 mr-1.5" /> Back to My Leaves
        </Link>
        <h1 className="text-3xl font-bold text-[#0f172a] tracking-tight">Apply HOD Leave</h1>
        <p className="text-sm text-gray-500 mt-1">Submit a leave request, delegate responsibilities, and arrange class substitutes.</p>
      </div>

      {/* Error/Success Banners */}
      {error && (
        <div className="bg-red-50 text-red-700 p-4 rounded-xl flex items-start gap-3 border border-red-200 animate-in fade-in">
          <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}
      {success && (
        <div className="bg-emerald-50 text-emerald-700 p-4 rounded-xl flex items-start gap-3 border border-emerald-200">
          <CheckCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
          <p className="text-sm font-medium">{success}</p>
        </div>
      )}

      <div className="flex flex-col lg:flex-row gap-6">
        {/* ── Left: Main Form ── */}
        <div className="flex-1 space-y-6">

          {/* HOD Info */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex items-center bg-gray-50/50">
              <UserIcon className="w-5 h-5 text-gray-500 mr-2" />
              <h2 className="text-sm font-bold text-gray-800">HOD Information</h2>
            </div>
            <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-5">
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Name</p>
                <p className="text-sm font-semibold text-gray-900">
                  {facultyProfile ? `${facultyProfile.first_name} ${facultyProfile.last_name}` : user?.name || '—'}
                </p>
              </div>
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Department</p>
                <p className="text-sm font-semibold text-gray-900">
                  {leaveData?.department_name || facultyProfile?.department_name || '—'}
                </p>
              </div>
              <div>
                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Designation</p>
                <p className="text-sm font-semibold text-gray-900">
                  {facultyProfile?.designation || 'Head of Department'}
                </p>
              </div>
            </div>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">

            {/* Leave Details */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-visible">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center bg-gray-50/50 rounded-t-xl">
                <Calendar className="w-5 h-5 text-gray-500 mr-2" />
                <h2 className="text-sm font-bold text-gray-800">Leave Details</h2>
                {duration > 0 && (
                  <span className="ml-auto text-xs font-bold text-primary-600 bg-primary-50 px-2.5 py-0.5 rounded-full">
                    {duration} Day{duration !== 1 ? 's' : ''}
                  </span>
                )}
              </div>
              <div className="p-6 space-y-5">
                {/* Leave Type */}
                <div>
                  <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">Leave Type</label>
                  <select
                    name="leave_type"
                    value={formData.leave_type}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2.5 bg-blue-50 border border-blue-200 rounded-lg text-sm font-medium text-slate-700 focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-200/30 transition-all appearance-none"
                    required
                  >
                    <option value="Casual Leave">Casual Leave</option>
                    <option value="Earned Leave">Earned Leave</option>
                    <option value="Vacation Leave">Vacation Leave</option>
                    <option value="Academic Leave">Academic Leave</option>
                    <option value="Compensation Leave">Compensation Leave</option>
                    <option value="On Duty">On Duty (HOD)</option>
                  </select>
                </div>

                {formData.leave_type === 'On Duty' && (
                  <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 flex items-start gap-3">
                    <Info className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
                    <p className="text-xs text-amber-800">
                      For On Duty leave, please provide a proof link (certificate, event URL, etc.) below. Evidence can also be submitted after the OD period.
                    </p>
                  </div>
                )}

                {/* Dates */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                  <div>
                    <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">From Date</label>
                    <input
                      type="date"
                      name="from_date"
                      value={formData.from_date}
                      min={getTodayStr()}
                      max={formData.to_date || undefined}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2.5 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                      required
                    />
                  </div>
                  <div>
                    <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">To Date</label>
                    <input
                      type="date"
                      name="to_date"
                      value={formData.to_date}
                      min={formData.from_date || getTodayStr()}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2.5 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                      required
                    />
                  </div>
                </div>

                {/* Reason */}
                <div>
                  <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">
                    {formData.leave_type === 'On Duty' ? 'Description of Duty' : 'Reason for Leave'}
                  </label>
                  <textarea
                    name="reason"
                    value={formData.reason}
                    onChange={handleInputChange}
                    placeholder="Please provide a brief justification..."
                    rows={3}
                    maxLength={500}
                    className="w-full px-4 py-3 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all resize-none"
                    required
                  />
                  <p className="text-[10px] text-gray-400 mt-1 text-right">{formData.reason.length}/500</p>
                </div>

                {/* Proof Link (OD) */}
                {formData.leave_type === 'On Duty' && (
                  <div>
                    <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">Proof / Evidence Link (Optional)</label>
                    <input
                      type="url"
                      name="proof_link"
                      value={formData.proof_link}
                      onChange={handleInputChange}
                      placeholder="https://example.com/certificate"
                      className="w-full px-4 py-2.5 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                    />
                  </div>
                )}
              </div>
            </div>

            {/* Mandatory Delegation Section */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-visible border-l-4 border-l-amber-500">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center bg-amber-50/30 rounded-tr-xl">
                <Briefcase className="w-5 h-5 text-amber-600 mr-2" />
                <h2 className="text-sm font-bold text-gray-800">Delegate Department Responsibilities</h2>
                <span className="ml-2 text-[10px] font-bold text-amber-700 bg-amber-100 px-2 py-0.5 rounded-full">Required</span>
              </div>
              <div className="p-6 space-y-4">
                <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
                  <div className="flex items-start gap-3">
                    <Shield className="w-4 h-4 text-amber-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <h4 className="text-[13px] font-bold text-amber-900 mb-1">What this delegation entails</h4>
                      <ul className="text-xs text-amber-800 space-y-1 list-disc list-inside">
                        <li>The selected faculty will be notified to accept or reject this delegation</li>
                        <li>Delegation activates only after your leave request is <strong>fully approved</strong></li>
                        <li>They will be able to approve faculty leave requests, student leaves, and gate passes</li>
                        <li>Temporary HOD access expires automatically when your leave period ends</li>
                        <li>Only one delegation can be assigned per leave request</li>
                      </ul>
                    </div>
                  </div>
                </div>

                <div>
                  <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">
                    Select Delegate Faculty <span className="text-red-500">*</span>
                  </label>
                  {alternateCandidates.length === 0 ? (
                    <div className="flex items-center gap-2 p-3 bg-gray-50 rounded-lg border border-gray-200">
                      <AlertCircle className="w-4 h-4 text-gray-400" />
                      <p className="text-xs text-gray-500">No faculty available in your department.</p>
                    </div>
                  ) : (
                    <select
                      name="alternate_hod_faculty_id"
                      value={formData.alternate_hod_faculty_id}
                      onChange={handleInputChange}
                      className="w-full px-4 py-2.5 bg-amber-50/50 border border-amber-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 transition-all"
                      required
                    >
                      <option value="">— Select a Faculty Member to Delegate —</option>
                      {alternateCandidates.map(f => (
                        <option key={f.id} value={f.id}>
                          {f.name} · {f.designation}
                        </option>
                      ))}
                    </select>
                  )}
                </div>

                {formData.alternate_hod_faculty_id && formData.from_date && formData.to_date && (
                  <div className="flex items-center gap-3 p-3 bg-emerald-50 border border-emerald-200 rounded-lg">
                    <CheckCircle className="w-4 h-4 text-emerald-600 flex-shrink-0" />
                    <div>
                      <p className="text-xs font-bold text-emerald-800">
                        {alternateCandidates.find(f => String(f.id) === String(formData.alternate_hod_faculty_id))?.name} will be notified
                      </p>
                      <p className="text-[10px] text-emerald-700">
                        Delegation period: {formData.from_date} to {formData.to_date} ({duration} day{duration !== 1 ? 's' : ''})
                      </p>
                    </div>
                  </div>
                )}
              </div>
            </div>

            {/* Class Substitute Arrangements (Optional) */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div
                className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50/50 cursor-pointer select-none"
                onClick={() => setShowSubstitutes(v => !v)}
              >
                <div className="flex items-center">
                  <BookOpen className="w-5 h-5 text-gray-500 mr-2" />
                  <h2 className="text-sm font-bold text-gray-800">Class Substitutes</h2>
                  <span className="ml-2 text-[10px] font-medium text-gray-400 bg-gray-100 px-2 py-0.5 rounded-full">Optional</span>
                  {arrangements.length > 0 && (
                    <span className="ml-2 text-[10px] font-bold text-primary-700 bg-primary-50 px-2 py-0.5 rounded-full">
                      {arrangements.length} class{arrangements.length !== 1 ? 'es' : ''}
                    </span>
                  )}
                </div>
                <ChevronDown className={`w-4 h-4 text-gray-400 transition-transform ${showSubstitutes ? 'rotate-180' : ''}`} />
              </div>

              {showSubstitutes && (
                <div className="p-6">
                  <p className="text-xs text-gray-500 mb-4">
                    If you teach courses, assign substitute faculty for each class during your absence. This section is optional.
                  </p>

                  <div className="space-y-4">
                    {arrangements.map((arr, idx) => (
                      <div key={idx} className="bg-slate-50 rounded-xl p-4 border border-slate-200 shadow-sm space-y-3">
                        <div className="flex justify-between items-center">
                          <span className="text-[10px] font-bold text-gray-500 uppercase tracking-wider">Class #{idx + 1}</span>
                          <button
                            type="button"
                            onClick={() => removeArrangementRow(idx)}
                            className="text-gray-400 hover:text-red-500 transition-colors p-1 rounded"
                            title="Remove"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                          <div>
                            <label className="block text-[10px] text-gray-500 mb-1 uppercase tracking-wider">Substitute Faculty</label>
                            <select
                              value={arr.substitute_faculty_id}
                              onChange={(e) => handleArrangementChange(idx, 'substitute_faculty_id', e.target.value)}
                              className="w-full px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500/20"
                            >
                              <option value="">Select Substitute...</option>
                              {alternateCandidates.map(f => (
                                <option key={f.id} value={f.id}>{f.name}</option>
                              ))}
                            </select>
                          </div>
                          <div>
                            <label className="block text-[10px] text-gray-500 mb-1 uppercase tracking-wider">Subject / Course</label>
                            <input
                              type="text"
                              value={arr.subject}
                              onChange={(e) => handleArrangementChange(idx, 'subject', e.target.value)}
                              className="w-full px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs focus:outline-none focus:border-primary-500"
                              placeholder="e.g. CS401"
                            />
                          </div>
                          <div>
                            <label className="block text-[10px] text-gray-500 mb-1 uppercase tracking-wider">Class / Section</label>
                            <input
                              type="text"
                              value={arr.class_section}
                              onChange={(e) => handleArrangementChange(idx, 'class_section', e.target.value)}
                              className="w-full px-3 py-2 bg-white border border-gray-200 rounded-lg text-xs focus:outline-none focus:border-primary-500"
                              placeholder="e.g. CSE Year-3 A"
                            />
                          </div>
                        </div>
                      </div>
                    ))}

                    {arrangements.length === 0 && (
                      <div className="text-center py-6 bg-gray-50 border border-dashed border-gray-200 rounded-xl">
                        <BookOpen className="w-8 h-8 text-gray-200 mx-auto mb-2" />
                        <p className="text-sm text-gray-400">No class substitutes added</p>
                        <p className="text-xs text-gray-400 mt-0.5">Add one if you have teaching commitments during leave</p>
                      </div>
                    )}
                  </div>

                  <button
                    type="button"
                    onClick={addArrangementRow}
                    className="mt-4 inline-flex items-center gap-1.5 text-xs font-bold text-primary-600 hover:text-primary-800 transition-colors"
                  >
                    <Plus className="w-3.5 h-3.5" /> Add Class Row
                  </button>
                </div>
              )}
            </div>

            {/* Submit */}
            <div className="flex flex-col sm:flex-row justify-end gap-3 pt-2">
              <Link
                to="/hod/my-leave"
                className="px-5 py-2.5 bg-white border border-gray-200 text-gray-600 font-medium text-sm rounded-lg hover:bg-gray-50 transition-all text-center"
              >
                Cancel
              </Link>
              <button
                type="submit"
                disabled={isSubmitting || !formData.alternate_hod_faculty_id}
                className="px-8 py-2.5 bg-primary-600 text-white font-semibold text-sm rounded-lg hover:bg-primary-700 focus:ring-4 focus:ring-primary-500/20 disabled:opacity-50 disabled:cursor-not-allowed transition-all flex items-center gap-2"
              >
                {isSubmitting ? (
                  <>
                    <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                    Submitting...
                  </>
                ) : (
                  <>
                    <CheckCircle className="w-4 h-4" />
                    Submit Leave Request
                  </>
                )}
              </button>
            </div>
          </form>
        </div>

        {/* ── Right: Sidebar ── */}
        <div className="lg:w-72 space-y-5 flex-shrink-0">

          {/* Balance Summary — matches Faculty portal style */}
          <div className="bg-[#1e3a5f] rounded-xl shadow-sm overflow-hidden text-white">
            <div className="px-6 py-5 border-b border-white/10">
              <h2 className="text-base font-bold">Balance Summary</h2>
            </div>
            <div className="p-6 space-y-4 text-sm font-medium">
              <div className="flex justify-between items-center border-b border-white/10 pb-3">
                <div className="flex flex-col">
                  <span className="text-blue-100">Casual Leave</span>
                  <span className="text-[10px] text-blue-200">1 per month</span>
                </div>
                <span className="text-lg font-bold">
                  {(balance?.casual_leaves_total || 1) - (balance?.casual_leaves_used || 0)}/{balance?.casual_leaves_total || 1}
                </span>
              </div>
              <div className="flex justify-between items-center border-b border-white/10 pb-3">
                <div className="flex flex-col">
                  <span className="text-blue-100">Earned Leave</span>
                  <span className="text-[10px] text-blue-200">1 per month (accrued)</span>
                </div>
                <span className="text-lg font-bold">
                  {(balance?.earned_leaves_total || 1) - (balance?.earned_leaves_used || 0)}/{balance?.earned_leaves_total || 1}
                </span>
              </div>
              <div className="flex justify-between items-center border-b border-white/10 pb-3">
                <span className="text-blue-100">Vacation Leave</span>
                <span className="text-lg font-bold">
                  {(balance?.vacation_leaves_total || 12) - (balance?.vacation_leaves_used || 0)}/{balance?.vacation_leaves_total || 12}
                </span>
              </div>
              <div className="flex justify-between items-center border-b border-white/10 pb-3">
                <span className="text-blue-100">Academic Leave</span>
                <span className="text-lg font-bold">
                  {(balance?.academic_leaves_total || 10) - (balance?.academic_leaves_used || 0)}/{balance?.academic_leaves_total || 10}
                </span>
              </div>
              <div className="flex justify-between items-center pb-1">
                <span className="text-blue-100">Compensation Leave</span>
                <span className="text-lg font-bold">
                  {(balance?.compensation_leaves_total || 5) - (balance?.compensation_leaves_used || 0)}/{balance?.compensation_leaves_total || 5}
                </span>
              </div>
            </div>
            <div className="px-6 py-4 bg-black/10">
              <p className="text-[10px] text-blue-200 italic leading-relaxed">
                Calculated based on the current academic year.
              </p>
            </div>
          </div>

          {/* Submission Tips — matches Faculty portal style */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100">
              <h2 className="text-sm font-bold text-gray-800">Submission Tips</h2>
            </div>
            <div className="p-6 space-y-4 text-sm text-gray-600">
              <div className="flex items-start">
                <div className="mt-0.5 mr-3 w-4 h-4 rounded-full border border-red-200 text-red-500 flex items-center justify-center text-[10px] flex-shrink-0 font-bold">!</div>
                <p><strong>Important:</strong> Your leave request is forwarded to Dean only <strong>after the delegate accepts</strong> the HOD duty assignment.</p>
              </div>
              <div className="flex items-start">
                <div className="mt-0.5 mr-3 w-4 h-4 rounded-full border border-blue-200 text-blue-500 flex items-center justify-center text-[10px] flex-shrink-0">i</div>
                <p>Inform the selected faculty member before submitting so they expect the delegation request.</p>
              </div>
              <div className="flex items-start">
                <div className="mt-0.5 mr-3 w-4 h-4 rounded-full border border-blue-200 text-blue-500 flex items-center justify-center text-[10px] flex-shrink-0">i</div>
                <p>Delegation activates only after <strong>full approval</strong> by Dean → OM → Principal.</p>
              </div>
              <div className="flex items-start">
                <div className="mt-0.5 mr-3 w-4 h-4 rounded-full border border-blue-200 text-blue-500 flex items-center justify-center text-[10px] flex-shrink-0">i</div>
                <p>For On Duty leave, submit supporting evidence (certificate, event URL) in the proof link field.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default HODLeaveApply;
