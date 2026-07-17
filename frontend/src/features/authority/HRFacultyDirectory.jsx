import React, { useState, useEffect, useMemo } from 'react';
import axios from 'axios';
import { 
  Users, Search, Mail, Phone, Building, Briefcase, X, 
  FileText, Clock, ChevronLeft, ChevronRight, Activity, Calendar as CalendarIcon
} from 'lucide-react';
import { 
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, 
  ResponsiveContainer, BarChart, Bar, Legend
} from 'recharts';
import { format, parseISO, subMonths, isSameMonth, startOfMonth, getDaysInMonth, addDays, startOfDay, endOfDay, isSameDay, addMonths } from 'date-fns';
import { FacultyProfileModal } from '../../components/FacultyProfileModal';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';




const HRFacultyDirectory = () => {
  const [facultyList, setFacultyList] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [leaves, setLeaves] = useState([]);
  const [gatepasses, setGatepasses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedDeptId, setSelectedDeptId] = useState(null);
  const [selectedFaculty, setSelectedFaculty] = useState(null);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const token = localStorage.getItem('token');
        const headers = { Authorization: `Bearer ${token}` };
        
        const [facRes, deptRes, leaveRes, gatepassRes] = await Promise.all([
          axios.get(`${API_BASE_URL}/api/faculty`, { headers }),
          axios.get(`${API_BASE_URL}/api/departments`, { headers }),
          axios.get(`${API_BASE_URL}/api/leave/requests`, { headers }).catch(() => ({ data: [] })),
          axios.get(`${API_BASE_URL}/api/faculty-gatepass/tracking`, { headers }).catch(() => ({ data: [] }))
        ]);
        
        setFacultyList(facRes.data);
        setDepartments(deptRes.data);
        setLeaves(leaveRes.data);
        setGatepasses(gatepassRes.data);
      } catch (err) {
        console.error('Error fetching data:', err);
        setError('Failed to load faculty directory');
      } finally {
        setLoading(false);
      }
    };
    
    fetchData();
  }, []);

  const deptMap = useMemo(() => {
    const map = {};
    departments.forEach(d => {
      map[d.id] = d;
    });
    return map;
  }, [departments]);

  const displayedFaculty = useMemo(() => {
    let list = facultyList;
    if (selectedDeptId) {
      list = list.filter(f => f.department_id === selectedDeptId);
    }
    if (searchTerm) {
      list = list.filter(f => 
        `${f.first_name} ${f.last_name}`.toLowerCase().includes(searchTerm.toLowerCase()) ||
        f.employee_id?.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }
    return list.sort((a, b) => `${a.first_name}`.localeCompare(`${b.first_name}`));
  }, [facultyList, selectedDeptId, searchTerm]);

  const getFacultyCountForDept = (deptId) => {
    return facultyList.filter(f => f.department_id === deptId).length;
  };

  const isGlobalSearchView = !selectedDeptId && searchTerm.length > 0;
  const isDepartmentHomeView = !selectedDeptId && searchTerm.length === 0;

  return (
    <div className="max-w-[1000px] mx-auto p-4 md:p-6 lg:p-8">
          {selectedFaculty && (
            <FacultyProfileModal 
              faculty={selectedFaculty} 
              department={deptMap[selectedFaculty?.department_id]}
              leaves={leaves} 
              gatepasses={gatepasses} 
              onClose={() => setSelectedFaculty(null)} 
              allowEdit={true}
            />
          )}{/* Header */}
      
      <div className="mb-8">
        {!selectedDeptId ? (
          <div>
            <h1 className="text-3xl font-bold text-slate-900 tracking-tight flex items-center gap-3">
              {isGlobalSearchView ? (
                <>
                  <Search className="w-8 h-8 text-indigo-600" />
                  Search Results
                </>
              ) : (
                <>
                  <Building className="w-8 h-8 text-indigo-600" />
                  Faculty Directory
                </>
              )}
            </h1>
            <p className="text-slate-500 mt-2 font-medium">
              {isGlobalSearchView 
                ? `Found ${displayedFaculty.length} staff members matching "${searchTerm}"`
                : 'Select a department to view its faculty members'
              }
            </p>
          </div>
        ) : (
          <div className="flex items-center gap-4">
            <button 
              onClick={() => {
                setSelectedDeptId(null);
                setSearchTerm('');
              }}
              className="w-10 h-10 rounded-full bg-white border border-slate-200 flex items-center justify-center text-slate-600 hover:bg-slate-50 hover:text-indigo-600 transition-colors shadow-sm shrink-0"
            >
              <ChevronLeft className="w-6 h-6" />
            </button>
            <div>
              <h1 className="text-3xl font-bold text-slate-900 tracking-tight flex items-center gap-3">
                {deptMap[selectedDeptId]?.name} Staff
              </h1>
              <p className="text-slate-500 mt-2 font-medium">
                {searchTerm 
                  ? `Found ${displayedFaculty.length} staff members matching "${searchTerm}"`
                  : `${displayedFaculty.length} members total`
                }
              </p>
            </div>
          </div>
        )}
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 p-4 rounded-xl mb-6 flex items-center gap-2">
          <span>{error}</span>
        </div>
      )}

      {/* Controls */}
      <div className="bg-white p-4 rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 mb-8">
        <div className="relative w-full">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
          <input 
            type="text" 
            placeholder={selectedDeptId ? "Search staff by name or ID..." : "Search for any staff globally by name or ID..."}
            className="w-full pl-12 pr-4 py-3 rounded-xl border border-slate-200 focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-all outline-none font-medium text-slate-700 bg-slate-50 focus:bg-white"
            value={searchTerm}
            onChange={e => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      {/* Main Content Area */}
      {loading ? (
        <div className="flex justify-center items-center py-20">
          <div className="w-10 h-10 border-4 border-slate-200 border-t-indigo-600 rounded-full animate-spin"></div>
        </div>
      ) : isDepartmentHomeView ? (
        
        // VIEW 1: DEPARTMENT CARDS
        departments.length === 0 ? (
          <div className="bg-white rounded-[32px] border border-slate-100 p-16 text-center shadow-sm">
            <Building className="w-16 h-16 text-slate-300 mx-auto mb-4" />
            <h3 className="text-xl font-bold text-slate-800 mb-2">No departments found</h3>
            <p className="text-slate-500">There are no departments in the system.</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {departments.map(dept => {
              const staffCount = getFacultyCountForDept(dept.id);
              return (
                <div 
                  key={dept.id}
                  onClick={() => {
                    setSelectedDeptId(dept.id);
                    setSearchTerm('');
                  }}
                  className="bg-white rounded-3xl p-6 border border-slate-200/60 shadow-sm hover:shadow-[0_8px_30px_rgb(79,70,229,0.12)] hover:border-indigo-300 transition-all cursor-pointer group relative overflow-hidden"
                >
                  <div className="absolute -right-4 -top-4 w-24 h-24 bg-indigo-50 rounded-full blur-2xl group-hover:bg-indigo-100 transition-colors"></div>
                  
                  <div className="flex items-start justify-between relative z-10">
                    <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center text-white shadow-md shadow-indigo-200 shrink-0">
                      <Building className="w-6 h-6" />
                    </div>
                  </div>
                  
                  <div className="mt-5 relative z-10">
                    <h3 className="font-bold text-slate-900 text-xl truncate pr-4 group-hover:text-indigo-700 transition-colors">
                      {dept.code}
                    </h3>
                    <p className="text-sm font-semibold text-slate-500 mt-1 line-clamp-1">
                      {dept.name}
                    </p>
                  </div>
                  
                  <div className="mt-6 flex items-center justify-between border-t border-slate-100 pt-4 relative z-10">
                    <div className="flex items-center gap-2 text-slate-600">
                      <Users className="w-4 h-4 text-indigo-400" />
                      <span className="text-sm font-bold">{staffCount} Staff Members</span>
                    </div>
                    <div className="w-8 h-8 rounded-full bg-slate-50 flex items-center justify-center group-hover:bg-indigo-50 transition-colors">
                      <ChevronRight className="w-4 h-4 text-slate-400 group-hover:text-indigo-600" />
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )
      ) : (
        
        // VIEW 2: FACULTY LIST (Global Search OR Specific Department)
        displayedFaculty.length === 0 ? (
          <div className="bg-white rounded-[32px] border border-slate-100 p-16 text-center shadow-sm">
            <Users className="w-16 h-16 text-slate-300 mx-auto mb-4" />
            <h3 className="text-xl font-bold text-slate-800 mb-2">No staff found</h3>
            <p className="text-slate-500">No staff members match your criteria.</p>
          </div>
        ) : (
          <div className="flex flex-col gap-3">
            {displayedFaculty.map(faculty => (
              <div 
                key={faculty.id} 
                onClick={() => setSelectedFaculty(faculty)}
                className="bg-white rounded-2xl p-4 border border-slate-200/60 shadow-sm hover:shadow-md hover:border-indigo-300 transition-all cursor-pointer flex flex-col sm:flex-row sm:items-center justify-between group gap-4"
              >
                <div className="flex items-center gap-5">
                  <div className="w-12 h-12 rounded-full bg-indigo-50 border border-indigo-100 flex items-center justify-center text-indigo-600 text-lg font-bold group-hover:bg-indigo-600 group-hover:text-white transition-colors shrink-0">
                    {faculty.first_name?.charAt(0) || 'U'}
                  </div>
                  <div>
                    <h3 className="font-bold text-slate-900 text-[17px]">
                      {faculty.first_name} {faculty.last_name}
                    </h3>
                    <div className="flex items-center gap-3 mt-1">
                      <p className="text-xs text-slate-500 font-semibold uppercase tracking-wider">
                        {faculty.employee_id || 'ID N/A'}
                      </p>
                      <span className="text-slate-300 text-xs">•</span>
                      <p className="text-xs text-indigo-600 font-semibold uppercase tracking-wider truncate max-w-[150px] sm:max-w-[200px]">
                        {deptMap[faculty.department_id]?.code || 'Unassigned'}
                      </p>
                    </div>
                  </div>
                </div>
                
                <div className="flex items-center justify-between sm:justify-end w-full sm:w-auto gap-4 border-t sm:border-t-0 border-slate-100 pt-3 sm:pt-0">
                  <span className="inline-block px-3 py-1 bg-slate-50 border border-slate-200 text-slate-600 text-[11px] font-bold rounded-lg uppercase tracking-wider">
                    {faculty.designation || 'Faculty'}
                  </span>
                  <ChevronRight className="w-5 h-5 text-slate-300 group-hover:text-indigo-600 transition-colors hidden sm:block" />
                </div>
              </div>
            ))}
          </div>
        )
      )}
    </div>
  );
};

export default HRFacultyDirectory;
