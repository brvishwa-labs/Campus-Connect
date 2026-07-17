import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Plus, Clock, CheckCircle, XCircle, Calendar, ArrowLeft } from 'lucide-react';
import { Link } from 'react-router-dom';

export const CompensationRegistry = () => {
  const [requests, setRequests] = useState([]);
  const [facultyList, setFacultyList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [showDropdown, setShowDropdown] = useState(false);
  const [formData, setFormData] = useState({
    peer_faculty_id: '',
    date_worked: '',
    classes_substituted: ''
  });

  useEffect(() => {
    fetchData();
  }, []);

  const filteredFaculty = facultyList.filter(f => 
    f.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
    (f.employee_id && f.employee_id.toLowerCase().includes(searchTerm.toLowerCase()))
  );

  const fetchData = async () => {
    try {
      const token = localStorage.getItem('token');
      const [reqRes, facRes] = await Promise.all([
        axios.get('/api/leave/compensation-registry/my-requests', { headers: { Authorization: `Bearer ${token}` } }),
        axios.get('/api/leave/faculty', { headers: { Authorization: `Bearer ${token}` } })
      ]);
      setRequests(reqRes.data);
      setFacultyList(facRes.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const token = localStorage.getItem('token');
      await axios.post('/api/leave/compensation-registry', formData, { headers: { Authorization: `Bearer ${token}` } });
      alert('Compensation request submitted for peer approval.');
      setShowModal(false);
      setFormData({ peer_faculty_id: '', date_worked: '', classes_substituted: '' });
      setSearchTerm('');
      fetchData();
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || 'Failed to submit compensation request');
    } finally {
      setSubmitting(false);
    }
  };

  const getStatusBadge = (status) => {
    switch(status) {
      case 'approved': return <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"><CheckCircle className="w-3.5 h-3.5 mr-1" /> Approved</span>;
      case 'rejected': return <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"><XCircle className="w-3.5 h-3.5 mr-1" /> Rejected</span>;
      default: return <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800"><Clock className="w-3.5 h-3.5 mr-1" /> Pending</span>;
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center p-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div className="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <Link to="/faculty/leave" className="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors mb-4">
            <ArrowLeft className="w-4 h-4 mr-1.5" /> Back to Requests
          </Link>
          <h1 className="text-3xl font-bold text-[#0f172a] tracking-tight">Compensation Registry</h1>
          <p className="text-sm text-gray-500 mt-1">Log overtime and extra duties to earn Compensation Leave.</p>
        </div>
        <button 
          onClick={() => setShowModal(true)}
          className="inline-flex items-center justify-center bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded-xl transition-colors"
        >
          <Plus className="w-5 h-5 mr-2" /> Add Compensation
        </button>
      </div>

      <div className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="overflow-x-auto">
          {requests.length === 0 ? (
            <div className="text-center py-12">
              <Calendar className="w-12 h-12 text-slate-300 mx-auto mb-3" />
              <h3 className="text-lg font-bold text-slate-900 mb-1">No Registry Items</h3>
              <p className="text-slate-500">You haven't submitted any compensation requests yet.</p>
            </div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-slate-50 border-b border-slate-200">
                  <th className="py-3 px-4 text-xs font-bold text-slate-500 uppercase tracking-wider">Date Worked</th>
                  <th className="py-3 px-4 text-xs font-bold text-slate-500 uppercase tracking-wider">Details</th>
                  <th className="py-3 px-4 text-xs font-bold text-slate-500 uppercase tracking-wider">Peer Approver</th>
                  <th className="py-3 px-4 text-xs font-bold text-slate-500 uppercase tracking-wider text-right">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {requests.map(req => (
                  <tr key={req.id} className="hover:bg-slate-50/50 transition-colors">
                    <td className="py-3 px-4">
                      <div className="text-sm font-bold text-slate-800">
                        {new Date(req.date_worked).toLocaleDateString()}
                      </div>
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-600 max-w-xs">
                      {req.classes_substituted || 'No details provided'}
                    </td>
                    <td className="py-3 px-4">
                      <div className="text-sm font-semibold text-slate-700">{req.peer_faculty_name}</div>
                    </td>
                    <td className="py-3 px-4 text-right">
                      {getStatusBadge(req.status)}
                      {req.status === 'approved' && (
                        <div className="text-[10px] font-bold text-indigo-600 mt-1 uppercase">
                          {req.is_used ? 'Used' : 'Available'}
                        </div>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Add Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
          <div className="bg-white rounded-3xl shadow-xl border border-slate-200 w-full max-w-lg overflow-hidden flex flex-col max-h-[90vh]">
            <div className="px-6 py-5 border-b border-slate-100 flex items-center justify-between">
              <h2 className="text-xl font-bold text-slate-900">Add Compensation</h2>
              <button onClick={() => { setShowModal(false); setSearchTerm(''); }} className="text-slate-400 hover:text-slate-700">
                <XCircle className="w-6 h-6" />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 overflow-y-auto">
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-bold text-slate-700 mb-1.5">Date Worked <span className="text-red-500">*</span></label>
                  <input
                    type="date"
                    required
                    value={formData.date_worked}
                    onChange={(e) => setFormData({...formData, date_worked: e.target.value})}
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-200 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 outline-none transition-all text-slate-700 font-medium"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-bold text-slate-700 mb-1.5">Peer Faculty (Approver) <span className="text-red-500">*</span></label>
                  <div className="relative">
                    <input
                      type="text"
                      required={!formData.peer_faculty_id}
                      value={searchTerm}
                      onChange={(e) => {
                        setSearchTerm(e.target.value);
                        setShowDropdown(true);
                        if (formData.peer_faculty_id) {
                          setFormData({ ...formData, peer_faculty_id: '' });
                        }
                      }}
                      onFocus={() => setShowDropdown(true)}
                      onBlur={() => setTimeout(() => setShowDropdown(false), 200)}
                      placeholder="Search and select peer..."
                      className="w-full px-4 py-2.5 rounded-xl border border-slate-200 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 outline-none transition-all text-slate-700 font-medium bg-white"
                    />
                    {showDropdown && (
                      <div className="absolute z-10 mt-1 w-full max-h-60 overflow-auto bg-white border border-slate-200 rounded-xl shadow-lg">
                        {filteredFaculty.length > 0 ? (
                          filteredFaculty.map(f => (
                            <div
                              key={f.id}
                              className="px-4 py-2 cursor-pointer hover:bg-indigo-50 text-slate-700 text-sm"
                              onMouseDown={(e) => {
                                e.preventDefault();
                                setFormData({ ...formData, peer_faculty_id: f.id });
                                setSearchTerm(`${f.name} (${f.employee_id})`);
                                setShowDropdown(false);
                              }}
                            >
                              {f.name} ({f.employee_id})
                            </div>
                          ))
                        ) : (
                          <div className="px-4 py-2 text-slate-500 text-sm">No matches found</div>
                        )}
                      </div>
                    )}
                  </div>
                  <p className="text-xs text-slate-500 mt-1.5 font-medium">Select the faculty member who can verify your extra work.</p>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-700 mb-1.5">Details of Duty</label>
                  <textarea
                    rows={3}
                    required
                    value={formData.classes_substituted}
                    onChange={(e) => setFormData({...formData, classes_substituted: e.target.value})}
                    placeholder="e.g. Special Class for II Year, Exam Duty..."
                    className="w-full px-4 py-2.5 rounded-xl border border-slate-200 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 outline-none transition-all text-slate-700 font-medium resize-none"
                  ></textarea>
                </div>
              </div>

              <div className="mt-8 flex items-center justify-end gap-3 pt-4 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => { setShowModal(false); setSearchTerm(''); }}
                  className="px-5 py-2.5 rounded-xl text-sm font-bold text-slate-600 hover:bg-slate-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={submitting}
                  className="px-5 py-2.5 rounded-xl text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                >
                  {submitting ? 'Submitting...' : 'Submit Request'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
