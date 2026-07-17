import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { FacultyLeaveApprovals } from './FacultyLeaveApprovals';
import { StudentLeaveApprovals } from './StudentLeaveApprovals';

export const LeaveApprovals = () => {
  const [activeTab, setActiveTab] = useState('faculty');
  const [counts, setCounts] = useState({ faculty: 0, student: 0 });

  useEffect(() => {
    const fetchCounts = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) return;
        const res = await axios.get('/api/notifications/badge-counts', {
          headers: { Authorization: `Bearer ${token}` }
        });
        setCounts({
          faculty: res.data['/hod/leave/faculty'] || 0,
          student: res.data['/hod/leave/student'] || 0
        });
      } catch (err) {
        console.error('Failed to fetch counts for tabs', err);
      }
    };

    fetchCounts();
    window.addEventListener('refetch-badges', fetchCounts);
    return () => window.removeEventListener('refetch-badges', fetchCounts);
  }, []);

  return (
    <div className="space-y-6">
      {/* Tab Navigation */}
      <div className="max-w-5xl mx-auto flex border-b border-gray-200">
        <button
          onClick={() => setActiveTab('faculty')}
          className={`py-3 px-6 font-semibold text-[14px] border-b-2 transition-colors flex items-center gap-2 ${
            activeTab === 'faculty'
              ? 'border-violet-600 text-violet-700'
              : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
          }`}
        >
          Faculty Leaves
          {counts.faculty > 0 && (
            <span className="bg-red-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full">
              {counts.faculty}
            </span>
          )}
        </button>
        <button
          onClick={() => setActiveTab('student')}
          className={`py-3 px-6 font-semibold text-[14px] border-b-2 transition-colors flex items-center gap-2 ${
            activeTab === 'student'
              ? 'border-violet-600 text-violet-700'
              : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
          }`}
        >
          Student Leaves
          {counts.student > 0 && (
            <span className="bg-red-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full">
              {counts.student}
            </span>
          )}
        </button>
      </div>

      {/* Tab Content */}
      <div>
        {activeTab === 'faculty' && <FacultyLeaveApprovals />}
        {activeTab === 'student' && <StudentLeaveApprovals />}
      </div>
    </div>
  );
};
