import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Users, ChevronRight } from 'lucide-react';
import { FacultyProfileModal } from '../../components/FacultyProfileModal';

export const FacultyList = () => {
  const [faculty, setFaculty] = useState([]);
  const [leaves, setLeaves] = useState([]);
  const [gatepasses, setGatepasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedFaculty, setSelectedFaculty] = useState(null);
  const [selectedWorkload, setSelectedWorkload] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [facRes, leaveRes, gatepassRes] = await Promise.all([
          axios.get('/api/hod/faculty'),
          axios.get('/api/leave/requests').catch(() => ({ data: [] })),
          axios.get('/api/faculty-gatepass/tracking').catch(() => ({ data: [] }))
        ]);
        setFaculty(facRes.data);
        setLeaves(leaveRes.data);
        setGatepasses(gatepassRes.data);
      } catch (err) {
        setError('Failed to load faculty directory');
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const handleRowClick = async (facultyMember) => {
    setSelectedFaculty(facultyMember);
    try {
      const res = await axios.get(`/api/faculty/${facultyMember.id}/workload`);
      setSelectedWorkload(res.data);
    } catch (err) {
      console.error('Failed to load workload:', err);
      setSelectedWorkload({ error: 'Failed to load workload data' });
    }
  };

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100">
        <div className="flex items-center space-x-4">
          <div className="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center"><Users className="w-6 h-6 text-blue-600" /></div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Faculty Management</h1>
            <p className="text-sm text-gray-500 font-medium">View and monitor faculty in your department</p>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 overflow-hidden">
        <div className="overflow-x-auto">
          {error ? (
            <div className="p-8 text-center text-red-500 font-medium">{error}</div>
          ) : loading ? (
            <div className="p-8 text-center text-gray-500 font-medium">Loading...</div>
          ) : faculty.length === 0 ? (
            <div className="p-16 flex flex-col items-center justify-center text-center">
              <Users className="w-12 h-12 text-gray-300 mb-4" />
              <h3 className="text-lg font-bold text-gray-900 mb-1">No Faculty Yet</h3>
              <p className="text-gray-500 text-sm">Faculty assigned to your department will appear here.</p>
            </div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-gray-50/50 border-b border-gray-100">
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Faculty ID</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Name & Designation</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Contact</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {faculty.map(f => (
                  <tr 
                    key={f.id} 
                    onClick={() => handleRowClick(f)}
                    className="hover:bg-indigo-50/50 cursor-pointer transition-colors group"
                  >
                    <td className="px-6 py-4 font-bold text-gray-900 group-hover:text-indigo-600 transition-colors">{f.employee_id}</td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-bold text-gray-900 group-hover:text-indigo-600 transition-colors">{f.first_name} {f.last_name}</div>
                      <div className="text-xs text-gray-500 font-medium uppercase tracking-wide mt-0.5">{f.designation || 'Faculty'}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-medium text-gray-900">{f.college_email}</div>
                      <div className="text-xs text-gray-500 mt-0.5">{f.phone}</div>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <ChevronRight className="w-5 h-5 text-gray-300 inline-block group-hover:text-indigo-600 transition-colors" />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {selectedFaculty && (
        <FacultyProfileModal 
          faculty={selectedFaculty} 
          department={{ name: selectedFaculty.department_name }}
          leaves={leaves} 
          gatepasses={gatepasses} 
          workload={selectedWorkload}
          onClose={() => {
            setSelectedFaculty(null);
            setSelectedWorkload(null);
          }} 
        />
      )}


    </div>
  );
};
