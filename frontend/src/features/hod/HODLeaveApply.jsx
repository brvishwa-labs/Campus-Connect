import React, { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import axios from 'axios';
import { ArrowLeft, User as UserIcon, Calendar, Users, AlertCircle } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';

export const HODLeaveApply = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  
  const [facultyProfile, setFacultyProfile] = useState(null);
  const [alternateCandidates, setAlternateCandidates] = useState([]);
  const [leaveData, setLeaveData] = useState(null); // my_courses and department info
  
  const [formData, setFormData] = useState({
    leave_type: 'Casual Leave',
    from_date: '',
    to_date: '',
    reason: '',
    alternate_hod_faculty_id: '',
    proof_link: ''
  });
  
  const [arrangements, setArrangements] = useState([]);
  
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');

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
      const [facRes, prepRes] = await Promise.all([
        axios.get('/api/auth/profile'),
        axios.get('/api/leave/hod-leave-preparation-data')
      ]);
      setFacultyProfile(facRes.data);
      setLeaveData(prepRes.data);
      setAlternateCandidates(prepRes.data.alternate_candidates || []);
      
      // Auto-populate arrangements if there are courses to cover
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
      }
    } catch (err) {
      console.error(err);
      setError('Failed to fetch preparation data. Only HODs can access this form.');
    }
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
    setArrangements([...arrangements, { substitute_faculty_id: '', subject: '', class_section: '', period: '', day: '', compensation_date: '', compensation_period: '' }]);
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
      setError('You must select an alternate staff to handle HOD duties.');
      setIsSubmitting(false);
      return;
    }
    
    // Only send arrangements where a substitute was actually chosen
    const validArrangements = arrangements
      .filter(a => a.substitute_faculty_id !== '')
      .map(a => ({
        ...a,
        section_id: a.section_id ? parseInt(a.section_id) : null,
      }));
      
    try {
      const payload = {
        ...formData,
        alternate_hod_faculty_id: parseInt(formData.alternate_hod_faculty_id),
        arrangements: validArrangements
      };
      await axios.post('/api/leave/hod-leave-request', payload);
      navigate('/hod/my-leave');
    } catch (err) {
      console.error(err);
      const detail = err.response?.data?.detail || err.response?.data?.message || 'Failed to submit leave request.';
      setError(typeof detail === 'string' ? detail : JSON.stringify(detail));
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="mb-6">
        <Link to="/hod/my-leave" className="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors mb-4">
          <ArrowLeft className="w-4 h-4 mr-1.5" /> Back to My Leaves
        </Link>
        <h1 className="text-3xl font-bold text-[#0f172a] tracking-tight">Apply HOD Leave</h1>
        <p className="text-sm text-gray-500 mt-1">Submit a leave request and delegate your HOD duties to an alternate staff.</p>
      </div>

      {error && (
        <div className="bg-red-50 text-red-700 p-4 rounded-lg flex items-start gap-3">
          <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      <div className="flex flex-col lg:flex-row gap-6">
        <div className="flex-1 space-y-6">
          <form onSubmit={handleSubmit} className="space-y-6">
            
            {/* Leave Details */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-visible">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center bg-gray-50/50 rounded-t-xl">
                <Calendar className="w-5 h-5 text-gray-500 mr-2" />
                <h2 className="text-sm font-bold text-gray-800">Leave Details</h2>
              </div>
              <div className="p-6 space-y-5">
                <div>
                  <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">Leave Type</label>
                  <select 
                    name="leave_type" 
                    value={formData.leave_type}
                    onChange={handleInputChange}
                    className="w-full px-4 py-2.5 bg-blue-50 border border-blue-200 rounded-lg text-sm font-medium text-slate-700 focus:outline-none focus:border-blue-300 transition-all appearance-none"
                    required
                  >
                    <option value="Casual Leave">Casual Leave</option>
                    <option value="Earned Leave">Earned Leave</option>
                    <option value="Vacation Leave">Vacation Leave</option>
                    <option value="Academic Leave">Academic Leave</option>
                    <option value="On Duty">On Duty (HOD)</option>
                  </select>
                </div>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                  <div>
                    <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">From Date</label>
                    <input 
                      type="date" 
                      name="from_date"
                      value={formData.from_date}
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
                      onChange={handleInputChange}
                      className="w-full px-4 py-2.5 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                      required
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">Reason</label>
                  <textarea 
                    name="reason"
                    value={formData.reason}
                    onChange={handleInputChange}
                    placeholder="Brief justification..."
                    rows={3}
                    className="w-full px-4 py-3 bg-white border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all resize-none"
                    required
                  />
                </div>
              </div>
            </div>

            {/* Delegate HOD Duties */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-visible border-l-4 border-l-amber-500">
              <div className="px-6 py-4 border-b border-gray-100 flex items-center bg-gray-50/50 rounded-tr-xl">
                <Users className="w-5 h-5 text-amber-500 mr-2" />
                <h2 className="text-sm font-bold text-gray-800">Delegate HOD Duties</h2>
              </div>
              <div className="p-6 space-y-2">
                <p className="text-xs text-gray-600 mb-4">
                  Select a faculty member from your department to handle incoming HOD approvals and duties during your absence.
                  Your request will remain pending until this staff member accepts the delegation.
                </p>
                <label className="block text-[10px] font-bold text-gray-500 uppercase tracking-wider mb-2">Alternate HOD Staff *</label>
                <select 
                  name="alternate_hod_faculty_id"
                  value={formData.alternate_hod_faculty_id}
                  onChange={handleInputChange}
                  className="w-full px-4 py-2.5 bg-amber-50/50 border border-amber-200 rounded-lg text-sm font-medium focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 transition-all"
                  required
                >
                  <option value="">Select Alternate Staff...</option>
                  {alternateCandidates.map(f => (
                    <option key={f.id} value={f.id}>{f.name} - {f.designation}</option>
                  ))}
                </select>
              </div>
            </div>

            {/* Class Substitute Arrangements (Optional) */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
                <div className="flex items-center">
                  <Calendar className="w-5 h-5 text-gray-500 mr-2" />
                  <h2 className="text-sm font-bold text-gray-800">Class Substitutes (Optional)</h2>
                </div>
                <button type="button" onClick={addArrangementRow} className="text-xs font-bold text-primary-600 hover:text-primary-800 transition-colors">
                  + Add Class Row
                </button>
              </div>
              
              <div className="p-6">
                <p className="text-xs text-gray-500 mb-4">If you teach courses and need to arrange substitutes, specify them here. Leave blank if not needed.</p>
                
                <div className="space-y-4">
                  {arrangements.map((arr, idx) => (
                    <div key={idx} className="bg-slate-50/50 rounded-xl p-4 border border-slate-200 shadow-sm space-y-3">
                      <div className="flex justify-between items-center mb-2">
                        <span className="text-xs font-bold text-gray-500 uppercase tracking-wider">Class #{idx + 1}</span>
                        <button type="button" onClick={() => removeArrangementRow(idx)} className="text-gray-400 hover:text-red-500 transition-colors">
                          <AlertCircle className="w-4 h-4" /> {/* Or trash icon */}
                        </button>
                      </div>
                      
                      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div className="col-span-1">
                          <label className="block text-[10px] text-gray-500 mb-1 uppercase tracking-wider">Substitute Faculty</label>
                          <select 
                            value={arr.substitute_faculty_id}
                            onChange={(e) => handleArrangementChange(idx, 'substitute_faculty_id', e.target.value)}
                            className="w-full px-3 py-2 bg-white border border-gray-200 rounded text-xs focus:outline-none focus:border-primary-500"
                          >
                            <option value="">Select Substitute...</option>
                            {alternateCandidates.map(f => (
                              <option key={f.id} value={f.id}>{f.name}</option>
                            ))}
                          </select>
                        </div>
                        <div className="col-span-1">
                          <label className="block text-[10px] text-gray-500 mb-1 uppercase tracking-wider">Subject</label>
                          <input type="text" value={arr.subject} onChange={(e) => handleArrangementChange(idx, 'subject', e.target.value)} className="w-full px-3 py-2 bg-white border border-gray-200 rounded text-xs focus:outline-none focus:border-primary-500" placeholder="e.g. CS101" />
                        </div>
                        <div className="col-span-1">
                          <label className="block text-[10px] text-gray-500 mb-1 uppercase tracking-wider">Class / Section</label>
                          <input type="text" value={arr.class_section} onChange={(e) => handleArrangementChange(idx, 'class_section', e.target.value)} className="w-full px-3 py-2 bg-white border border-gray-200 rounded text-xs focus:outline-none focus:border-primary-500" placeholder="e.g. CSE-A" />
                        </div>
                      </div>
                    </div>
                  ))}
                  {arrangements.length === 0 && (
                    <div className="text-center py-6 bg-gray-50 border border-dashed border-gray-200 rounded-lg">
                      <p className="text-sm text-gray-500">No class substitutes specified.</p>
                      <button type="button" onClick={addArrangementRow} className="text-xs font-medium text-primary-600 mt-2">Add Substitute</button>
                    </div>
                  )}
                </div>
              </div>
            </div>

            <div className="flex justify-end pt-4">
              <button 
                type="submit" 
                disabled={isSubmitting}
                className="px-6 py-2.5 bg-primary-600 text-white font-medium text-sm rounded-lg hover:bg-primary-700 focus:ring-4 focus:ring-primary-500/20 disabled:opacity-50 transition-all"
              >
                {isSubmitting ? 'Submitting...' : 'Submit Leave Request'}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default HODLeaveApply;
