import React, { useState, useEffect, useMemo } from 'react';
import axios from 'axios';
import {
  Users, Search, ChevronDown, ChevronUp, AlertTriangle,
  Loader2, RefreshCw, BarChart2, Briefcase
} from 'lucide-react';

const FacultyRoster = () => {
  const [faculty, setFaculty] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [expandedDepts, setExpandedDepts] = useState({});
  const [assignments, setAssignments] = useState([]);

  // Fetch data on mount
  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [facultyRes, deptRes, assignmentRes] = await Promise.all([
        axios.get('/api/hod/faculty'),
        axios.get('/api/admin/departments'),
        axios.get('/api/hod/assignments'),
      ]);
      setFaculty(facultyRes.data);
      setDepartments(deptRes.data);
      setAssignments(assignmentRes.data);
      setError(null);
      
      // Expand first department by default
      if (deptRes.data.length > 0) {
        setExpandedDepts({ [deptRes.data[0].id]: true });
      }
    } catch (err) {
      setError('Failed to load faculty roster');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  // Get course count for a faculty member
  const getFacultyWorkload = (facultyId) => {
    return assignments.filter(a => a.faculty_id === facultyId).length;
  };

  // Get workload status badge styling
  const getWorkloadBadge = (count) => {
    if (count === 0) return 'bg-emerald-50 text-emerald-700 border-emerald-200';
    if (count <= 2) return 'bg-blue-50 text-blue-700 border-blue-200';
    if (count <= 4) return 'bg-amber-50 text-amber-700 border-amber-200';
    return 'bg-red-50 text-red-700 border-red-200';
  };

  const getWorkloadLabel = (count) => {
    if (count === 0) return 'Available';
    if (count <= 2) return 'Available';
    if (count <= 4) return 'Moderate';
    return 'Heavy';
  };

  // Group faculty by department and filter by search term
  const groupedFaculty = useMemo(() => {
    return departments.map(dept => {
      const deptFaculty = faculty.filter(f => f.department_id === dept.id);
      
      const filtered = deptFaculty.filter(f => {
        const fullName = `${f.first_name} ${f.last_name}`.toLowerCase();
        const searchLower = searchTerm.toLowerCase();
        return fullName.includes(searchLower) || 
               f.designation?.toLowerCase().includes(searchLower) ||
               dept.name.toLowerCase().includes(searchLower);
      });

      return {
        ...dept,
        faculty: filtered,
        totalFaculty: deptFaculty.length,
      };
    }).filter(dept => dept.faculty.length > 0 || dept.totalFaculty > 0);
  }, [faculty, departments, searchTerm]);

  // Toggle department expansion
  const toggleDept = (deptId) => {
    setExpandedDepts(prev => ({
      ...prev,
      [deptId]: !prev[deptId]
    }));
  };

  // Department color scheme
  const getDeptColor = (index) => {
    const colors = [
      { bg: 'bg-blue-50', border: 'border-blue-200', dot: 'bg-blue-500', icon: 'text-blue-600' },
      { bg: 'bg-emerald-50', border: 'border-emerald-200', dot: 'bg-emerald-500', icon: 'text-emerald-600' },
      { bg: 'bg-purple-50', border: 'border-purple-200', dot: 'bg-purple-500', icon: 'text-purple-600' },
      { bg: 'bg-rose-50', border: 'border-rose-200', dot: 'bg-rose-500', icon: 'text-rose-600' },
      { bg: 'bg-amber-50', border: 'border-amber-200', dot: 'bg-amber-500', icon: 'text-amber-600' },
      { bg: 'bg-cyan-50', border: 'border-cyan-200', dot: 'bg-cyan-500', icon: 'text-cyan-600' },
      { bg: 'bg-indigo-50', border: 'border-indigo-200', dot: 'bg-indigo-500', icon: 'text-indigo-600' },
      { bg: 'bg-pink-50', border: 'border-pink-200', dot: 'bg-pink-500', icon: 'text-pink-600' },
    ];
    return colors[index % colors.length];
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-96 bg-white rounded-[24px] border border-gray-100">
        <Loader2 className="w-8 h-8 text-primary-400 animate-spin mb-3" />
        <p className="text-gray-400 font-medium">Loading faculty roster...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-6 bg-white rounded-[24px] border border-red-100 flex items-center gap-3">
        <AlertTriangle className="w-5 h-5 text-red-500 flex-shrink-0" />
        <div>
          <p className="font-bold text-red-700">{error}</p>
          <button
            onClick={fetchData}
            className="text-sm text-red-600 hover:text-red-700 font-medium mt-1 underline"
          >
            Try again
          </button>
        </div>
      </div>
    );
  }

  const totalFaculty = faculty.length;
  const totalAvailable = faculty.filter(f => getFacultyWorkload(f.id) === 0).length;
  const filteredCount = groupedFaculty.reduce((sum, dept) => sum + dept.faculty.length, 0);

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="bg-white p-6 rounded-[24px] border border-gray-100 shadow-sm">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
          <div>
            <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-3">
              <Users className="w-6 h-6 text-primary-500" />
              Faculty Roster
            </h1>
            <p className="text-sm text-gray-500 mt-1 font-medium">Manage and view all faculty across departments</p>
          </div>
          <button
            onClick={fetchData}
            className="p-2.5 text-gray-400 hover:text-gray-700 hover:bg-gray-100 rounded-xl transition-colors"
            title="Refresh roster"
          >
            <RefreshCw className={`w-5 h-5 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6">
          <div className="bg-gradient-to-br from-blue-50 to-blue-100/50 border border-blue-200 rounded-[16px] p-4">
            <p className="text-xs font-bold text-blue-600 uppercase tracking-wider">Total Faculty</p>
            <p className="text-2xl font-black text-blue-900 mt-1">{totalFaculty}</p>
          </div>
          <div className="bg-gradient-to-br from-emerald-50 to-emerald-100/50 border border-emerald-200 rounded-[16px] p-4">
            <p className="text-xs font-bold text-emerald-600 uppercase tracking-wider">Available</p>
            <p className="text-2xl font-black text-emerald-900 mt-1">{totalAvailable}</p>
          </div>
          <div className="bg-gradient-to-br from-amber-50 to-amber-100/50 border border-amber-200 rounded-[16px] p-4">
            <p className="text-xs font-bold text-amber-600 uppercase tracking-wider">Departments</p>
            <p className="text-2xl font-black text-amber-900 mt-1">{departments.length}</p>
          </div>
          <div className="bg-gradient-to-br from-purple-50 to-purple-100/50 border border-purple-200 rounded-[16px] p-4">
            <p className="text-xs font-bold text-purple-600 uppercase tracking-wider">Showing</p>
            <p className="text-2xl font-black text-purple-900 mt-1">{filteredCount}</p>
          </div>
        </div>

        {/* Search */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            placeholder="Search by name, designation, or department..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-[12px] text-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:bg-white transition-all"
          />
          {searchTerm && (
            <button
              onClick={() => setSearchTerm('')}
              className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
            >
              ✕
            </button>
          )}
        </div>
      </div>

      {/* Department Groups */}
      <div className="space-y-4">
        {groupedFaculty.length === 0 ? (
          <div className="bg-white p-12 rounded-[24px] border border-dashed border-gray-200 text-center">
            <Search className="w-10 h-10 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-500 font-medium">No faculty found matching "{searchTerm}"</p>
          </div>
        ) : (
          groupedFaculty.map((dept, deptIndex) => {
            const color = getDeptColor(deptIndex);
            const isExpanded = expandedDepts[dept.id];
            const visibleFaculty = dept.faculty;

            return (
              <div
                key={dept.id}
                className="bg-white border border-gray-100 rounded-[20px] shadow-sm overflow-hidden transition-all hover:shadow-md"
              >
                {/* Department Header */}
                <button
                  onClick={() => toggleDept(dept.id)}
                  className={`w-full px-6 py-5 flex items-center justify-between hover:bg-gray-50 transition-colors ${color.bg} border-b border-gray-100`}
                >
                  <div className="flex items-center gap-4 flex-1">
                    <div className={`w-10 h-10 ${color.bg} border-2 ${color.border} rounded-2xl flex items-center justify-center flex-shrink-0`}>
                      <Briefcase className={`w-5 h-5 ${color.icon}`} />
                    </div>
                    <div className="text-left">
                      <h3 className="font-bold text-gray-900 text-sm sm:text-base">{dept.name}</h3>
                      <p className="text-xs text-gray-500 font-medium mt-0.5">
                        {visibleFaculty.length} of {dept.totalFaculty} faculty
                        {searchTerm && ` (filtered)`}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-3">
                    <span className={`text-xs font-bold px-3 py-1.5 rounded-full ${color.bg} ${color.icon}`}>
                      {visibleFaculty.length}
                    </span>
                    {isExpanded ? (
                      <ChevronUp className={`w-5 h-5 text-gray-400 flex-shrink-0`} />
                    ) : (
                      <ChevronDown className={`w-5 h-5 text-gray-400 flex-shrink-0`} />
                    )}
                  </div>
                </button>

                {/* Faculty List */}
                {isExpanded && (
                  <div className="divide-y divide-gray-50 max-h-96 overflow-y-auto">
                    {visibleFaculty.map((f, index) => {
                      const workload = getFacultyWorkload(f.id);
                      const badgeStyle = getWorkloadBadge(workload);
                      const label = getWorkloadLabel(workload);

                      return (
                        <div
                          key={f.id}
                          className="px-6 py-4 hover:bg-gray-50 transition-colors flex items-center gap-4"
                        >
                          {/* Avatar */}
                          <div className={`w-10 h-10 rounded-full ${color.bg} flex items-center justify-center font-bold text-sm flex-shrink-0 ${color.icon}`}>
                            {f.first_name[0]}{f.last_name[0]}
                          </div>

                          {/* Faculty Info */}
                          <div className="flex-1 min-w-0">
                            <div className="flex items-center gap-2 flex-wrap">
                              <h4 className="font-bold text-gray-900 text-sm sm:text-base truncate">
                                {f.first_name} {f.last_name}
                              </h4>
                              {f.employee_id && (
                                <span className="text-xs text-gray-400 font-medium">({f.employee_id})</span>
                              )}
                            </div>
                            <p className="text-xs text-gray-500 mt-0.5">{f.designation || 'Faculty'}</p>
                            {f.college_email && (
                              <p className="text-xs text-gray-400 mt-0.5 truncate">{f.college_email}</p>
                            )}
                          </div>

                          {/* Status & Workload */}
                          <div className="text-right flex-shrink-0">
                            <span className={`text-[11px] font-bold px-2.5 py-1 rounded-full border inline-block ${badgeStyle}`}>
                              {label}
                            </span>
                            <p className="text-[10px] text-gray-400 mt-1.5 text-center font-medium">
                              {workload} course{workload !== 1 ? 's' : ''}
                            </p>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
              </div>
            );
          })
        )}
      </div>

      {/* Footer Info */}
      <div className="text-center py-4 text-xs text-gray-400 font-medium">
        Showing {filteredCount} faculty member{filteredCount !== 1 ? 's' : ''} across {groupedFaculty.length} department{groupedFaculty.length !== 1 ? 's' : ''}
      </div>
    </div>
  );
};

export default FacultyRoster;
