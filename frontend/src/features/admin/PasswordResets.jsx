import React, { useState, useEffect } from 'react';
import { ShieldAlert, CheckCircle, RefreshCw } from 'lucide-react';
import axios from 'axios';

export default function PasswordResets() {
  const [requests, setRequests] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [resolvingId, setResolvingId] = useState(null);

  const fetchRequests = async () => {
    setIsLoading(true);
    try {
      const response = await axios.get('/api/admin/password-resets', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      });
      setRequests(response.data);
      setError(null);
    } catch (err) {
      setError("Failed to fetch password reset requests");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchRequests();
  }, []);

  const handleResolve = async (id) => {
    if (!window.confirm("Are you sure you want to mark this request as resolved? Make sure you have manually reset their password!")) {
      return;
    }
    
    setResolvingId(id);
    try {
      await axios.put(`/api/admin/password-resets/${id}/resolve`, {}, {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` }
      });
      await fetchRequests();
    } catch (err) {
      alert("Failed to mark as resolved.");
    } finally {
      setResolvingId(null);
    }
  };

  return (
    <div className="p-6 sm:p-10 max-w-7xl mx-auto">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 tracking-tight flex items-center gap-3">
            <ShieldAlert className="w-8 h-8 text-primary-600" />
            Password Reset Requests
          </h1>
          <p className="mt-2 text-gray-500">Manage user password reset requests from the login page.</p>
        </div>
        <button 
          onClick={fetchRequests}
          className="p-2 text-gray-400 hover:text-primary-600 bg-white border border-gray-200 hover:border-primary-200 rounded-xl transition-all shadow-sm"
        >
          <RefreshCw className={`w-5 h-5 ${isLoading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      {error && (
        <div className="bg-red-50 text-red-600 p-4 rounded-xl text-sm font-medium border border-red-100 mb-6">
          {error}
        </div>
      )}

      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-gray-50/50 border-b border-gray-100">
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider">Date</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider">Role</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider">Name</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider">College ID</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider">Department</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider">Email</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider text-center">Status</th>
                <th className="py-4 px-6 text-[13px] font-semibold text-gray-500 uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {isLoading && requests.length === 0 ? (
                <tr>
                  <td colSpan="8" className="py-12 text-center text-gray-500">
                    <RefreshCw className="w-6 h-6 animate-spin mx-auto mb-2 text-gray-400" />
                    Loading requests...
                  </td>
                </tr>
              ) : requests.length === 0 ? (
                <tr>
                  <td colSpan="8" className="py-12 text-center text-gray-500">
                    No password reset requests found.
                  </td>
                </tr>
              ) : (
                requests.map(req => (
                  <tr key={req.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="py-4 px-6 text-sm text-gray-600">
                      {new Date(req.created_at).toLocaleString()}
                    </td>
                    <td className="py-4 px-6">
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold ${
                        req.role === 'faculty' ? 'bg-indigo-50 text-indigo-700' : 'bg-blue-50 text-blue-700'
                      }`}>
                        {req.role.toUpperCase()}
                      </span>
                    </td>
                    <td className="py-4 px-6 text-sm font-medium text-gray-900">
                      {req.name}
                    </td>
                    <td className="py-4 px-6 text-sm text-gray-600">
                      {req.college_id}
                    </td>
                    <td className="py-4 px-6 text-sm text-gray-600">
                      {req.department || "-"}
                    </td>
                    <td className="py-4 px-6 text-sm text-gray-600">
                      <a href={`mailto:${req.email}`} className="text-primary-600 hover:underline">
                        {req.email}
                      </a>
                    </td>
                    <td className="py-4 px-6 text-center">
                      {req.status === 'resolved' ? (
                        <span className="inline-flex items-center gap-1 text-green-600 text-sm font-medium">
                          <CheckCircle className="w-4 h-4" />
                          Resolved
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1 text-amber-500 text-sm font-medium">
                          <span className="w-2 h-2 rounded-full bg-amber-500"></span>
                          Pending
                        </span>
                      )}
                    </td>
                    <td className="py-4 px-6 text-right">
                      {req.status === 'pending' && (
                        <button
                          onClick={() => handleResolve(req.id)}
                          disabled={resolvingId === req.id}
                          className="px-3 py-1.5 text-xs font-semibold text-white bg-green-600 hover:bg-green-700 rounded-lg shadow-sm transition-all disabled:opacity-50"
                        >
                          {resolvingId === req.id ? 'Resolving...' : 'Mark Resolved'}
                        </button>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
