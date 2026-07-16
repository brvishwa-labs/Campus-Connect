import React, { useState } from 'react';
import axios from 'axios';
import { Settings, Save, AlertCircle, CheckCircle2 } from 'lucide-react';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

const HRSetLeaveLimits = () => {
  const [limits, setLimits] = useState(() => {
    const saved = localStorage.getItem('globalLeaveLimits');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch (e) {}
    }
    return {
      casual_leaves_total: 12,
      restricted_leaves_total: 2,
      earned_leaves_total: 30,
      vacation_leaves_total: 12,
      academic_leaves_total: 10,
      compensation_leaves_total: 5
    };
  });

  const [isSaving, setIsSaving] = useState(false);
  const [statusMessage, setStatusMessage] = useState(null);
  const [statusType, setStatusType] = useState('success');

  const handleLimitChange = (key, value) => {
    setLimits(prev => ({
      ...prev,
      [key]: value === '' ? '' : parseInt(value, 10)
    }));
  };

  const handleApplyAll = async () => {
    setIsSaving(true);
    setStatusMessage(null);
    try {
      const token = localStorage.getItem('token');
      const response = await axios.put(`${API_BASE_URL}/api/leave/admin/balances/bulk`, limits, {
        headers: { Authorization: `Bearer ${token}` }
      });
      localStorage.setItem('globalLeaveLimits', JSON.stringify(limits));
      setStatusType('success');
      setStatusMessage(`Successfully updated leave limits for ${response.data.updated_count} faculty members.`);
    } catch (error) {
      setStatusType('error');
      const detail = error.response?.data?.detail;
      const message = typeof detail === 'string' ? detail : (Array.isArray(detail) ? detail[0].msg : 'Failed to update leave limits. Please try again.');
      setStatusMessage(message);
    } finally {
      setIsSaving(false);
    }
  };

  const leaveTypes = [
    { label: 'Casual Leave', key: 'casual_leaves_total', desc: 'Standard casual leave allowance' },
    { label: 'Restricted Leave', key: 'restricted_leaves_total', desc: 'Restricted holiday allowance' },
    { label: 'Earned Leave', key: 'earned_leaves_total', desc: 'Accrued earned leaves' },
    { label: 'Vacation Leave', key: 'vacation_leaves_total', desc: 'Vacation period allowance' },
    { label: 'Academic Leave', key: 'academic_leaves_total', desc: 'For academic conferences/workshops' },
    { label: 'Compensation Leave', key: 'compensation_leaves_total', desc: 'Compensatory off allowance' }
  ];

  return (
    <div className="max-w-[1000px] mx-auto p-4 md:p-6 lg:p-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight flex items-center gap-3">
          <Settings className="w-8 h-8 text-indigo-600" />
          Global Leave Limits
        </h1>
        <p className="text-slate-500 mt-2 text-lg">
          Configure the default leave balances for all faculty members in the system.
        </p>
      </div>

      {statusMessage && (
        <div className={`mb-6 p-4 rounded-2xl flex items-center gap-3 font-medium ${
          statusType === 'success' ? 'bg-emerald-50 text-emerald-700' : 'bg-red-50 text-red-700'
        }`}>
          {statusType === 'success' ? <CheckCircle2 className="w-5 h-5" /> : <AlertCircle className="w-5 h-5" />}
          {statusMessage}
        </div>
      )}

      <div className="bg-white rounded-3xl p-6 md:p-8 border border-slate-100 shadow-sm">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          {leaveTypes.map((leave) => (
            <div key={leave.key} className="bg-slate-50/50 p-5 rounded-2xl border border-slate-100 transition-all focus-within:border-indigo-300 focus-within:bg-indigo-50/30">
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="font-bold text-slate-900">{leave.label}</h3>
                  <p className="text-sm text-slate-500 mt-1">{leave.desc}</p>
                </div>
              </div>
              <div className="flex items-center">
                <span className="text-slate-400 mr-3 text-sm font-bold uppercase tracking-wider">Total Limit</span>
                <input
                  type="number"
                  min="0"
                  value={limits[leave.key]}
                  onChange={(e) => handleLimitChange(leave.key, e.target.value)}
                  className="w-full bg-white border border-slate-200 rounded-xl px-4 py-2 text-lg font-bold text-slate-800 focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-100 transition-all"
                />
              </div>
            </div>
          ))}
        </div>

        <div className="flex justify-end border-t border-slate-100 pt-6">
          <button
            onClick={handleApplyAll}
            disabled={isSaving}
            className="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-bold text-sm flex items-center gap-2 transition-all shadow-sm disabled:opacity-70 disabled:cursor-not-allowed"
          >
            <Save className="w-5 h-5" />
            {isSaving ? 'Applying...' : 'Apply for All Faculty'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default HRSetLeaveLimits;
