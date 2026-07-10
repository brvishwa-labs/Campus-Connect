import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Clock, CheckCircle, XCircle, FileText, Send, Calendar, AlertCircle } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';

export default function FacultyGatePass() {
  const { user } = useAuth();
  const [requests, setRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  
  const [formData, setFormData] = useState({
    reason: '',
    out_time: '',
    expected_in_time: ''
  });

  useEffect(() => {
    fetchRequests();
  }, []);

  const fetchRequests = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await axios.get('/api/faculty-gatepass/me', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setRequests(res.data);
    } catch (err) {
      console.error('Error fetching gate passes:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      // format dates to ISO string
      const payload = {
        reason: formData.reason,
        out_time: new Date(formData.out_time).toISOString(),
        expected_in_time: formData.expected_in_time ? new Date(formData.expected_in_time).toISOString() : null
      };
      await axios.post('/api/faculty-gatepass/', payload, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setFormData({ reason: '', out_time: '', expected_in_time: '' });
      fetchRequests();
      alert('Gate pass request raised successfully!');
    } catch (err) {
      console.error(err);
      alert('Failed to raise request. Please check your inputs.');
    }
  };

  const getStatusColor = (status) => {
    switch(status) {
      case 'pending_hod': return 'text-orange-600 bg-orange-100';
      case 'pending_dean': return 'text-yellow-600 bg-yellow-100';
      case 'pending_om': return 'text-blue-600 bg-blue-100';
      case 'approved': return 'text-green-600 bg-green-100';
      case 'rejected': return 'text-red-600 bg-red-100';
      default: return 'text-gray-600 bg-gray-100';
    }
  };

  const getStatusLabel = (status) => {
    switch(status) {
      case 'pending_hod': return 'Pending HOD';
      case 'pending_dean': return 'Pending Dean';
      case 'pending_om': return 'Pending OM';
      case 'approved': return 'Approved';
      case 'rejected': return 'Rejected';
      default: return 'Unknown';
    }
  };

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-8">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Faculty Gate Pass</h1>
          <p className="text-gray-500 dark:text-gray-400">Raise and track your gate pass requests</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Form Section */}
        <div className="lg:col-span-1">
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 p-6">
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center mb-4">
              <Send className="w-5 h-5 mr-2 text-indigo-600" />
              Raise Request
            </h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Reason <span className="text-red-500">*</span>
                </label>
                <textarea
                  required
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-transparent text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow"
                  rows="3"
                  placeholder="Specify reason for gate pass..."
                  value={formData.reason}
                  onChange={(e) => setFormData({...formData, reason: e.target.value})}
                ></textarea>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Out Time <span className="text-red-500">*</span>
                </label>
                <input
                  type="datetime-local"
                  required
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-transparent text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow"
                  value={formData.out_time}
                  onChange={(e) => setFormData({...formData, out_time: e.target.value})}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Expected In Time (Optional)
                </label>
                <input
                  type="datetime-local"
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-transparent text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 outline-none transition-shadow"
                  value={formData.expected_in_time}
                  onChange={(e) => setFormData({...formData, expected_in_time: e.target.value})}
                />
              </div>

              <button
                type="submit"
                className="w-full py-2.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium transition-colors focus:ring-4 focus:ring-indigo-500/20"
              >
                Submit Request
              </button>
            </form>
          </div>
        </div>

        {/* Tracking Section */}
        <div className="lg:col-span-2 space-y-6">
          {loading ? (
            <div className="animate-pulse space-y-4">
              {[1, 2, 3].map(i => (
                <div key={i} className="h-32 bg-gray-200 dark:bg-gray-700 rounded-xl"></div>
              ))}
            </div>
          ) : requests.length === 0 ? (
            <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700">
              <FileText className="w-12 h-12 text-gray-400 mx-auto mb-3" />
              <p className="text-gray-500 dark:text-gray-400 text-lg">No gate pass requests found</p>
            </div>
          ) : (
            requests.map(req => (
              <div key={req.id} className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 p-6 overflow-hidden relative">
                
                <div className="flex justify-between items-start mb-6">
                  <div>
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">{req.reason}</h3>
                    <div className="flex items-center space-x-4 mt-2 text-sm text-gray-500 dark:text-gray-400">
                      <span className="flex items-center"><Clock className="w-4 h-4 mr-1"/> Out: {new Date(req.out_time).toLocaleString()}</span>
                      {req.expected_in_time && (
                        <span className="flex items-center"><Calendar className="w-4 h-4 mr-1"/> Exp In: {new Date(req.expected_in_time).toLocaleString()}</span>
                      )}
                    </div>
                  </div>
                  <span className={`px-3 py-1 rounded-full text-xs font-medium border ${getStatusColor(req.status)} border-current`}>
                    {getStatusLabel(req.status)}
                  </span>
                </div>

                {/* Professional Tracking Timeline */}
                <div className="relative pt-4">
                  <div className="absolute top-8 left-6 w-[calc(100%-3rem)] h-0.5 bg-gray-200 dark:bg-gray-700 -z-10"></div>
                  
                  <div className="flex justify-between relative z-10">
                    
                    {/* HOD Step */}
                    <div className="flex flex-col items-center">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${req.hod_approved_at ? 'bg-green-500 text-white' : req.status === 'rejected' && req.status.includes('hod') ? 'bg-red-500 text-white' : req.status === 'pending_hod' ? 'bg-orange-500 text-white animate-pulse' : 'bg-gray-200 dark:bg-gray-700 text-gray-500'}`}>
                        {req.hod_approved_at ? <CheckCircle className="w-5 h-5"/> : req.status === 'rejected' && req.status.includes('hod') ? <XCircle className="w-5 h-5"/> : <Clock className="w-4 h-4"/>}
                      </div>
                      <span className="mt-2 text-xs font-medium text-gray-900 dark:text-white">HOD</span>
                      {req.hod_approved_at && <span className="text-[10px] text-gray-500 mt-1">{new Date(req.hod_approved_at).toLocaleDateString()}</span>}
                    </div>

                    {/* Dean Step */}
                    <div className="flex flex-col items-center">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${req.dean_approved_at ? 'bg-green-500 text-white' : req.status === 'rejected' && req.status.includes('dean') ? 'bg-red-500 text-white' : req.status === 'pending_dean' ? 'bg-yellow-500 text-white animate-pulse' : 'bg-gray-200 dark:bg-gray-700 text-gray-500'}`}>
                        {req.dean_approved_at ? <CheckCircle className="w-5 h-5"/> : req.status === 'rejected' && req.status.includes('dean') ? <XCircle className="w-5 h-5"/> : <Clock className="w-4 h-4"/>}
                      </div>
                      <span className="mt-2 text-xs font-medium text-gray-900 dark:text-white">Dean</span>
                      {req.dean_approved_at && <span className="text-[10px] text-gray-500 mt-1">{new Date(req.dean_approved_at).toLocaleDateString()}</span>}
                    </div>

                    {/* OM Step */}
                    <div className="flex flex-col items-center">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${req.om_approved_at ? 'bg-green-500 text-white' : req.status === 'rejected' && req.status.includes('om') ? 'bg-red-500 text-white' : req.status === 'pending_om' ? 'bg-blue-500 text-white animate-pulse' : 'bg-gray-200 dark:bg-gray-700 text-gray-500'}`}>
                        {req.om_approved_at ? <CheckCircle className="w-5 h-5"/> : req.status === 'rejected' && req.status.includes('om') ? <XCircle className="w-5 h-5"/> : <Clock className="w-4 h-4"/>}
                      </div>
                      <span className="mt-2 text-xs font-medium text-gray-900 dark:text-white">OM</span>
                      {req.om_approved_at && <span className="text-[10px] text-gray-500 mt-1">{new Date(req.om_approved_at).toLocaleDateString()}</span>}
                    </div>

                  </div>
                </div>

                {req.rejection_reason && (
                  <div className="mt-4 p-3 bg-red-50 dark:bg-red-900/20 rounded-lg flex items-start space-x-2">
                    <AlertCircle className="w-5 h-5 text-red-500 shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-medium text-red-800 dark:text-red-200">Rejection Reason</p>
                      <p className="text-sm text-red-600 dark:text-red-300">{req.rejection_reason}</p>
                    </div>
                  </div>
                )}
              </div>
            ))
          )}
        </div>

      </div>
    </div>
  );
}
