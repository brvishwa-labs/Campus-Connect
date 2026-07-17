import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Calendar, Check, X, AlertCircle, Clock, Info } from 'lucide-react';

export const HODDutySubstitute = () => {
  const [requests, setRequests] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [processingId, setProcessingId] = useState(null);

  useEffect(() => {
    fetchRequests();
  }, []);

  const fetchRequests = async () => {
    try {
      const res = await axios.get('/api/leave/hod-substitute-pending');
      setRequests(res.data);
    } catch (err) {
      console.error(err);
      setError('Failed to fetch pending HOD duty requests.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleResponse = async (arrId, status) => {
    setProcessingId(arrId);
    try {
      await axios.put(`/api/leave/hod-duty/${arrId}?status=${status}`);
      // Remove the processed request from the list
      // Since one request might have multiple arrangements, we just re-fetch to be safe
      fetchRequests();
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || 'Failed to process response.');
    } finally {
      setProcessingId(null);
    }
  };

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-[#0f172a] tracking-tight">HOD Duty Delegation Requests</h1>
        <p className="text-sm text-gray-500 mt-1">Accept or reject requests from your HOD to handle their duties during their leave.</p>
      </div>

      {error && (
        <div className="bg-red-50 text-red-700 p-4 rounded-lg flex items-start gap-3">
          <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {isLoading ? (
        <div className="text-center py-10">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600 mx-auto"></div>
          <p className="mt-2 text-sm text-gray-500">Loading requests...</p>
        </div>
      ) : requests.length === 0 ? (
        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-10 text-center">
          <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4">
            <Check className="w-8 h-8 text-gray-300" />
          </div>
          <h3 className="text-lg font-medium text-gray-900">All caught up!</h3>
          <p className="text-sm text-gray-500 mt-1">You have no pending HOD duty requests to review.</p>
        </div>
      ) : (
        <div className="space-y-4">
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 flex items-start gap-3">
            <Info className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div>
              <h4 className="text-[13px] font-bold text-blue-900">About HOD Duty Delegation</h4>
              <p className="text-xs text-blue-800 mt-1">
                By accepting this request, you agree to handle incoming HOD approvals and administrative tasks for your department during the specified leave period. The HOD's leave request will remain pending until you respond.
              </p>
            </div>
          </div>

          {requests.map((req) => {
            // Find the specific arrangement for HOD Duties assigned to the current user
            // We assume the backend only sends requests where this user has a pending arrangement
            const arr = req.arrangements.find(a => a.subject === "HOD Duties" && a.status.toUpperCase() === "PENDING");
            
            if (!arr) return null; // Should not happen based on backend logic

            return (
              <div key={req.id} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="p-6">
                  <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    
                    <div className="space-y-4 flex-1">
                      <div>
                        <h3 className="text-lg font-bold text-gray-900">{req.faculty_name}</h3>
                        <p className="text-sm text-gray-500">Head of Department • Leave Request</p>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div className="bg-gray-50 rounded-lg p-3">
                          <div className="flex items-center text-xs font-bold text-gray-500 uppercase tracking-wider mb-1">
                            <Calendar className="w-3.5 h-3.5 mr-1" /> Period
                          </div>
                          <p className="text-sm font-medium text-gray-900">
                            {new Date(req.from_date).toLocaleDateString()} to {new Date(req.to_date).toLocaleDateString()}
                          </p>
                          <p className="text-xs text-gray-500 mt-0.5">{req.duration_days} Day(s)</p>
                        </div>
                        <div className="bg-gray-50 rounded-lg p-3">
                          <div className="flex items-center text-xs font-bold text-gray-500 uppercase tracking-wider mb-1">
                            <Clock className="w-3.5 h-3.5 mr-1" /> Type & Reason
                          </div>
                          <p className="text-sm font-medium text-gray-900">{req.leave_type}</p>
                          <p className="text-xs text-gray-500 mt-0.5 truncate" title={req.reason}>{req.reason}</p>
                        </div>
                      </div>
                    </div>

                    <div className="flex flex-row md:flex-col gap-3 md:min-w-[140px]">
                      <button
                        onClick={() => handleResponse(arr.id, 'accepted')}
                        disabled={processingId === arr.id}
                        className="flex-1 inline-flex justify-center items-center px-4 py-2 bg-green-600 hover:bg-green-700 text-white text-sm font-medium rounded-lg transition-colors disabled:opacity-50"
                      >
                        {processingId === arr.id ? 'Processing...' : (
                          <><Check className="w-4 h-4 mr-1.5" /> Accept</>
                        )}
                      </button>
                      <button
                        onClick={() => handleResponse(arr.id, 'rejected')}
                        disabled={processingId === arr.id}
                        className="flex-1 inline-flex justify-center items-center px-4 py-2 bg-white border border-red-200 text-red-600 hover:bg-red-50 text-sm font-medium rounded-lg transition-colors disabled:opacity-50"
                      >
                        <X className="w-4 h-4 mr-1.5" /> Reject
                      </button>
                    </div>

                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

export default HODDutySubstitute;
