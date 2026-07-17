import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { BookOpen, Plus, Search, X, Edit2, Trash2, ChevronLeft, ChevronRight, Building2, Folder, Calendar, Layers, GraduationCap, Grid3x3 } from 'lucide-react';

// ── CO-PO/PSO Mapping Helpers ───────────────────────────────────────
const CO_PO_VALUE_BADGE = {
  'N': 'bg-gray-100 text-gray-600 border border-gray-200',
  'L': 'bg-blue-100 text-blue-700 border border-blue-200',
  'M': 'bg-amber-100 text-amber-700 border border-amber-200',
  'H': 'bg-green-100 text-green-700 border border-green-200',
};

const getCoPOConfig = (courseType) => ({
  coCount: courseType === 'lab' ? 2 : 10,
  psoCount: courseType === 'lab' ? 2 : 3,
});

const parseMappingJSON = (raw) => {
  if (!raw) return {};
  if (typeof raw === 'object') return raw;
  try { return JSON.parse(raw); } catch { return {}; }
};

/** View-only CO-PO/PSO mapping table (admin view). */
const CoPOViewTable = ({ mapping, courseType }) => {
  const { coCount, psoCount } = getCoPOConfig(courseType);
  const coRows  = Array.from({ length: coCount },  (_, i) => `CO-${i + 1}`);
  const poColumns  = Array.from({ length: 12 }, (_, i) => `PO-${i + 1}`);
  const psoColumns = Array.from({ length: psoCount }, (_, i) => `PSO-${i + 1}`);
  const allCols = [...poColumns, ...psoColumns];

  return (
    <div className="overflow-x-auto border border-gray-200 rounded-xl">
      <table className="text-[11px] border-collapse" style={{ minWidth: '640px' }}>
        <thead>
          {/* Group header row */}
          <tr>
            <th
              className="sticky left-0 z-20 bg-gray-50 border border-gray-200 px-3 py-2 text-gray-500"
              rowSpan={2}
            />
            <th
              colSpan={12}
              className="bg-indigo-50 text-indigo-800 font-bold px-3 py-2 border border-gray-200 text-center"
            >
              Programme Outcomes (POs)
            </th>
            <th
              colSpan={psoCount}
              className="bg-purple-50 text-purple-800 font-bold px-3 py-2 border border-gray-200 text-center"
            >
              Programme Specific Outcomes (PSOs)
            </th>
          </tr>
          {/* Column index row */}
          <tr>
            {poColumns.map(po => (
              <th key={po} className="bg-indigo-50/60 text-indigo-700 font-semibold px-1.5 py-1.5 border border-gray-200 text-center whitespace-nowrap" style={{ minWidth: '42px' }}>
                {po}
              </th>
            ))}
            {psoColumns.map(pso => (
              <th key={pso} className="bg-purple-50/60 text-purple-700 font-semibold px-1.5 py-1.5 border border-gray-200 text-center whitespace-nowrap" style={{ minWidth: '52px' }}>
                {pso}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {coRows.map(co => (
            <tr key={co} className="hover:bg-gray-50/50">
              <td className="sticky left-0 z-10 bg-white border border-gray-200 px-3 py-1.5 font-bold text-gray-700 whitespace-nowrap">
                {co}
              </td>
              {allCols.map(col => {
                const val = mapping?.[co]?.[col] || '';
                return (
                  <td key={col} className="border border-gray-200 px-1 py-1 text-center">
                    {val ? (
                      <span className={`inline-flex items-center justify-center w-6 h-5 rounded text-[11px] font-bold ${CO_PO_VALUE_BADGE[val] || ''}`}>
                        {val}
                      </span>
                    ) : (
                      <span className="text-gray-200">–</span>
                    )}
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
// ── End CO-PO helpers ───────────────────────────────────────────────

export const Courses = () => {
  const [courses, setCourses] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  // View state: null means showing department cards, otherwise it's the selected department object
  const [selectedDept, setSelectedDept] = useState(null);
  const [selectedYear, setSelectedYear] = useState(null);
  const [selectedSemester, setSelectedSemester] = useState(null);

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingId, setEditingId] = useState(null);
  
  // Form state
  const [formData, setFormData] = useState({ 
    department_id: '',
    code: '', 
    name: '',
    short_name: '',
    credits: 3,
    course_type: 'theory',
    semester: 1,
    syllabus: '',
    objectives: '',
    outcomes: '',
    textbooks: '',
    references: '',
    prerequisites: '',
    co_po_mapping: {}
  });
  const [formError, setFormError] = useState(null);
  const [formLoading, setFormLoading] = useState(false);

  // Search state
  const [searchTerm, setSearchTerm] = useState('');

  const fetchData = async () => {
    try {
      setLoading(true);
      const [coursesRes, deptRes] = await Promise.all([
        axios.get('/api/courses/'),
        axios.get('/api/departments/')
      ]);
      setCourses(coursesRes.data);
      setDepartments(deptRes.data);
      setError(null);
    } catch (err) {
      console.error(err);
      setError('Failed to load course data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleOpenModal = (course = null) => {
    if (course) {
      setEditingId(course.id);
      setFormData({
        department_id: course.department_id,
        code: course.code,
        name: course.name,
        short_name: course.short_name || '',
        credits: course.credits,
        course_type: course.course_type,
        semester: course.semester || 1,
        syllabus: course.syllabus || '',
        objectives: course.objectives || '',
        outcomes: course.outcomes || '',
        textbooks: course.textbooks || '',
        references: course.references || '',
        prerequisites: course.prerequisites || '',
        co_po_mapping: parseMappingJSON(course.co_po_mapping)
      });
    } else {
      setEditingId(null);
      setFormData({ 
        department_id: selectedDept ? selectedDept.id : (departments.length > 0 ? departments[0].id : ''),
        code: '', 
        name: '',
        short_name: '',
        credits: 3,
        course_type: 'theory',
        semester: selectedSemester ? selectedSemester : 1,
        syllabus: '',
        objectives: '',
        outcomes: '',
        textbooks: '',
        references: '',
        prerequisites: '',
        co_po_mapping: {}
      });
    }
    setFormError(null);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingId(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormError(null);

    try {
      const payload = {
        ...formData,
        department_id: parseInt(formData.department_id),
        credits: parseInt(formData.credits),
        semester: parseInt(formData.semester),
        // Serialize mapping object back to JSON string for DB storage
        co_po_mapping: JSON.stringify(formData.co_po_mapping || {})
      };

      if (editingId) {
        await axios.put(`/api/courses/${editingId}`, payload);
      } else {
        await axios.post('/api/courses/', payload);
      }
      
      await fetchData();
      handleCloseModal();
    } catch (err) {
      const errorDetail = err.response?.data?.detail;
      const errorMessage = typeof errorDetail === 'string' 
        ? errorDetail 
        : Array.isArray(errorDetail) 
          ? errorDetail.map(e => e.msg).join(', ') 
          : 'Failed to save course';
      setFormError(errorMessage);
    } finally {
      setFormLoading(false);
    }
  };

  const handleDelete = async (id, name) => {
    if (window.confirm(`Are you sure you want to delete ${name}?`)) {
      try {
        await axios.delete(`/api/courses/${id}`);
        await fetchData();
      } catch (err) {
        alert(err.response?.data?.detail || 'Failed to delete course');
      }
    }
  };

  // ----------------------------------------------------
  // Department Cards View
  // ----------------------------------------------------
  if (!selectedDept) {
    return (
      <div className="space-y-6 max-w-7xl mx-auto">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100">
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 bg-indigo-50 rounded-2xl flex items-center justify-center">
              <BookOpen className="w-6 h-6 text-indigo-600" />
            </div>
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Course Management</h1>
              <p className="text-sm text-gray-500 font-medium">Select a department to view or manage its courses</p>
            </div>
          </div>
        </div>

        {loading ? (
          <div className="text-center p-12 text-gray-500 font-medium bg-white rounded-[24px] border border-gray-100">Loading departments...</div>
        ) : error ? (
          <div className="text-center p-12 text-red-500 font-medium bg-white rounded-[24px] border border-gray-100">{error}</div>
        ) : departments.length === 0 ? (
          <div className="text-center p-12 text-gray-500 font-medium bg-white rounded-[24px] border border-gray-100">No departments found. Please add a department first.</div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {departments.map(dept => {
              const deptCoursesCount = courses.filter(c => c.department_id === dept.id).length;
              return (
                <div 
                  key={dept.id}
                  onClick={() => setSelectedDept(dept)}
                  className="bg-white p-6 rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 hover:border-indigo-200 hover:shadow-md transition-all cursor-pointer group flex flex-col justify-between h-40 relative overflow-hidden"
                >
                  <div className="absolute top-0 right-0 w-24 h-24 bg-gradient-to-br from-indigo-50 to-purple-50 rounded-bl-[64px] -z-0 opacity-50 group-hover:scale-110 transition-transform"></div>
                  
                  <div className="flex items-start justify-between relative z-10">
                    <div>
                      <h3 className="text-2xl font-black text-gray-900 mb-1">{dept.code}</h3>
                      <p className="text-sm text-gray-500 font-medium line-clamp-1">{dept.name}</p>
                    </div>
                    <div className="w-10 h-10 bg-indigo-50 text-indigo-600 rounded-xl flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                      <Building2 className="w-5 h-5" />
                    </div>
                  </div>
                  
                  <div className="mt-4 relative z-10 flex items-center text-sm font-bold text-indigo-600">
                    <span className="bg-indigo-50 px-3 py-1.5 rounded-lg border border-indigo-100 group-hover:bg-white transition-colors">
                      {deptCoursesCount} {deptCoursesCount === 1 ? 'Course' : 'Courses'}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    );
  }

  // ----------------------------------------------------
  // Specific Department Courses View
  // ----------------------------------------------------
  
  const filteredCourses = courses.filter(c => {
    const matchDept = c.department_id === selectedDept.id;
    const matchSem = selectedSemester ? c.semester === selectedSemester : true;
    const matchSearch = c.name.toLowerCase().includes(searchTerm.toLowerCase()) || c.code.toLowerCase().includes(searchTerm.toLowerCase());
    return matchDept && matchSem && matchSearch;
  });

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      {/* Header Area */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100">
        <div className="flex items-center space-x-4">
          <div className="w-12 h-12 bg-indigo-50 rounded-2xl flex items-center justify-center">
            <BookOpen className="w-6 h-6 text-indigo-600" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Course Management</h1>
            <p className="text-sm text-gray-500 font-medium">Manage courses across departments, years, and semesters</p>
          </div>
        </div>
        <button 
          onClick={() => handleOpenModal()}
          className="flex items-center px-5 py-2.5 bg-primary-600 text-white text-sm font-bold rounded-xl hover:bg-primary-700 transition-colors shadow-sm"
        >
          <Plus className="w-4 h-4 mr-2" /> Add Course
        </button>
      </div>

      {/* Main Content Area */}
      <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 overflow-hidden min-h-[500px]">
        {/* Toolbar & Breadcrumbs */}
        <div className="p-4 border-b border-gray-100 flex flex-col sm:flex-row justify-between items-center gap-4">
          <div className="flex items-center space-x-2 text-sm font-medium">
            <button 
              onClick={() => { setSelectedDept(null); setSelectedYear(null); setSelectedSemester(null); }}
              className="hover:text-primary-600 transition-colors text-gray-500"
            >
              All Departments
            </button>
            <ChevronRight className="w-4 h-4 text-gray-400" />
            <button 
              onClick={() => { setSelectedYear(null); setSelectedSemester(null); }}
              className={`hover:text-primary-600 transition-colors ${!selectedYear ? 'text-gray-900 font-bold' : 'text-gray-500'}`}
            >
              {selectedDept.code}
            </button>
            {selectedYear && (
              <>
                <ChevronRight className="w-4 h-4 text-gray-400" />
                <button 
                  onClick={() => setSelectedSemester(null)}
                  className={`hover:text-primary-600 transition-colors ${!selectedSemester ? 'text-gray-900 font-bold' : 'text-gray-500'}`}
                >
                  Year {selectedYear}
                </button>
              </>
            )}
            {selectedSemester && (
              <>
                <ChevronRight className="w-4 h-4 text-gray-400" />
                <span className="text-gray-900 font-bold">Semester {selectedSemester}</span>
              </>
            )}
          </div>
          <div className="relative w-full max-w-md">
            <Search className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input 
              type="text" 
              placeholder="Search courses..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border-none rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:bg-white transition-all outline-none"
            />
          </div>
        </div>

        {/* Content View */}
        <div className="overflow-x-auto">
          {error ? (
            <div className="p-8 text-center text-red-500 font-medium">{error}</div>
          ) : loading ? (
            <div className="p-8 text-center text-gray-500 font-medium">Loading courses...</div>
          ) : !selectedYear ? (
            // Year Cards View
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 p-6">
              {[1, 2, 3, 4].map(year => {
                const sems = [year * 2 - 1, year * 2];
                const yearCourses = courses.filter(c => c.department_id === selectedDept.id && sems.includes(c.semester)).length;
                return (
                  <div 
                    key={year}
                    onClick={() => setSelectedYear(year)}
                    className="group bg-white border border-gray-100 p-6 rounded-2xl shadow-sm hover:shadow-md hover:border-primary-100 cursor-pointer transition-all duration-200"
                  >
                    <div className="w-12 h-12 bg-indigo-50 text-indigo-600 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 group-hover:bg-indigo-100 transition-all">
                      <Calendar className="w-6 h-6" />
                    </div>
                    <h3 className="text-xl font-bold text-gray-900 mb-1">Year {year}</h3>
                    <p className="text-sm font-medium text-gray-500 flex items-center">
                      <GraduationCap className="w-4 h-4 mr-1.5" />
                      {yearCourses} Courses
                    </p>
                  </div>
                );
              })}
            </div>
          ) : selectedYear && !selectedSemester ? (
            // Semester Cards View
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 p-6 max-w-4xl mx-auto">
              {[selectedYear * 2 - 1, selectedYear * 2].map(sem => {
                const semCourses = courses.filter(c => c.department_id === selectedDept.id && c.semester === sem).length;
                return (
                  <div 
                    key={sem}
                    onClick={() => setSelectedSemester(sem)}
                    className="group bg-white border border-gray-100 p-6 rounded-2xl shadow-sm hover:shadow-md hover:border-primary-100 cursor-pointer transition-all duration-200"
                  >
                    <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 group-hover:bg-blue-100 transition-all">
                      <Layers className="w-6 h-6" />
                    </div>
                    <h3 className="text-xl font-bold text-gray-900 mb-1">Semester {sem}</h3>
                    <p className="text-sm font-medium text-gray-500 flex items-center">
                      <BookOpen className="w-4 h-4 mr-1.5" />
                      {semCourses} Courses
                    </p>
                  </div>
                );
              })}
            </div>
          ) : filteredCourses.length === 0 ? (
            <div className="p-16 flex flex-col items-center justify-center text-center">
              <div className="w-16 h-16 bg-gray-50 rounded-2xl flex items-center justify-center mb-4">
                <BookOpen className="w-8 h-8 text-gray-400" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-1">No Courses Found</h3>
              <p className="text-gray-500 text-sm">Add a new course for Semester {selectedSemester}.</p>
            </div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-gray-50/50 border-b border-gray-100">
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Course Details</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Credits & Sem</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Type</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredCourses.map((course) => (
                  <tr key={course.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="font-bold text-gray-900 text-sm">{course.name}</div>
                      <div className="text-xs text-gray-500 mt-0.5">Code: {course.code}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-medium text-gray-900">{course.credits} Credits</div>
                      <div className="text-xs text-gray-500 mt-0.5">Semester {course.semester}</div>
                    </td>
                    <td className="px-6 py-4">
                      <span className="px-2.5 py-1 bg-indigo-50 text-indigo-700 font-bold text-xs rounded-lg border border-indigo-100 capitalize">
                        {course.course_type}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <button 
                        onClick={() => handleOpenModal(course)}
                        className="p-2 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors mr-2"
                        title="Edit Course"
                      >
                        <Edit2 className="w-4 h-4" />
                      </button>
                      <button 
                        onClick={() => handleDelete(course.id, course.name)}
                        className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        title="Delete Course"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Add / Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-gray-900/40 backdrop-blur-sm">
          <div className="bg-white rounded-[24px] shadow-2xl w-full max-w-5xl overflow-hidden transform transition-all max-h-[90vh] flex flex-col">
            <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50/50 shrink-0">
              <h3 className="text-lg font-bold text-gray-900">{editingId ? 'Edit Course' : `Add Course to ${selectedDept.code}`}</h3>
              <button 
                onClick={handleCloseModal}
                className="p-1.5 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-xl transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <div className="overflow-y-auto p-6">
              <form id="course-form" onSubmit={handleSubmit} className="space-y-5">
                {formError && (
                  <div className="p-3 bg-red-50 text-red-600 text-sm font-medium rounded-xl border border-red-100">
                    {formError}
                  </div>
                )}
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Name</label>
                    <input 
                      type="text" 
                      required
                      value={formData.name}
                      onChange={(e) => setFormData({...formData, name: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Code</label>
                    <input 
                      type="text" 
                      required
                      value={formData.code}
                      onChange={(e) => setFormData({...formData, code: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                    Short Name <span className="text-gray-400 font-normal normal-case">(e.g. CN for Computer Networks)</span>
                  </label>
                  <input 
                    type="text"
                    maxLength={20}
                    placeholder="e.g. CN, DS, OS"
                    value={formData.short_name}
                    onChange={(e) => setFormData({...formData, short_name: e.target.value.toUpperCase()})}
                    className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Department</label>
                    {/* If editing, allow changing dept. If creating in a specific dept, lock it or show it visually */}
                    <select 
                      required
                      value={formData.department_id}
                      onChange={(e) => setFormData({...formData, department_id: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none disabled:opacity-70 disabled:bg-gray-100"
                      disabled={!editingId} // Disable if adding new course since we are inside a specific department view
                    >
                      {departments.map(dept => (
                        <option key={dept.id} value={dept.id}>{dept.name} ({dept.code})</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Type</label>
                    <select 
                      required
                      value={formData.course_type}
                      onChange={(e) => setFormData({...formData, course_type: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                    >
                      <option value="theory">Theory</option>
                      <option value="lab">Lab</option>
                      <option value="elective">Elective</option>
                      <option value="open_elective">Open Elective</option>
                      <option value="project">Project</option>
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Credits</label>
                    <input 
                      type="number" 
                      required
                      min="1" max="10"
                      value={formData.credits}
                      onChange={(e) => setFormData({...formData, credits: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Semester</label>
                    <input 
                      type="number" 
                      required
                      min="1" max="8"
                      value={formData.semester}
                      onChange={(e) => setFormData({...formData, semester: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                    />
                  </div>
                </div>



                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Objectives</label>
                  <textarea 
                    rows={3}
                    placeholder="Enter course objectives..."
                    value={formData.objectives}
                    onChange={(e) => setFormData({...formData, objectives: e.target.value})}
                    className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[80px]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Outcomes (COs)</label>
                  <textarea 
                    rows={3}
                    placeholder="Enter course outcomes (COs)..."
                    value={formData.outcomes}
                    onChange={(e) => setFormData({...formData, outcomes: e.target.value})}
                    className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[80px]"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                    {formData.course_type === 'lab' ? 'List of Experiments' : 'Syllabus'}
                  </label>
                  <textarea 
                    rows={4}
                    placeholder={formData.course_type === 'lab' ? "Enter the list of experiments for this lab..." : "Enter the syllabus topics and details for this course..."}
                    value={formData.syllabus}
                    onChange={(e) => setFormData({...formData, syllabus: e.target.value})}
                    className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[100px]"
                  />
                </div>

                {formData.course_type !== 'lab' && (
                  <div>
                    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Textbooks</label>
                    <textarea 
                      rows={3}
                      placeholder="Enter textbooks details..."
                      value={formData.textbooks}
                      onChange={(e) => setFormData({...formData, textbooks: e.target.value})}
                      className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[80px]"
                    />
                  </div>
                )}

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
                    {formData.course_type === 'lab' ? 'Resources' : 'References'}
                  </label>
                  <textarea 
                    rows={3}
                    placeholder={formData.course_type === 'lab' ? "Enter resources for this lab..." : "Enter reference books and online links..."}
                    value={formData.references}
                    onChange={(e) => setFormData({...formData, references: e.target.value})}
                    className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[80px]"
                  />
                </div>

                {/* ── CO–PO/PSO Mapping Section (view-only for admin) ── */}
                <div className="border-t border-gray-100 pt-5">
                  <div className="flex items-center gap-3 mb-2">
                    <div className="w-7 h-7 bg-indigo-50 rounded-lg flex items-center justify-center">
                      <Grid3x3 className="w-4 h-4 text-indigo-600" />
                    </div>
                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider">CO–PO/PSO Mapping</label>
                    <span className="text-[10px] bg-amber-50 text-amber-600 font-bold px-2 py-0.5 rounded-full border border-amber-100 tracking-wide">View Only · Editable by Assigned Faculty</span>
                  </div>
                  <p className="text-xs text-gray-400 mb-3 ml-10">This mapping is set by the assigned faculty member in their LMS dashboard.</p>
                  <div className="flex flex-wrap gap-3 text-[10px] font-bold mb-3 ml-10">
                    {['H – High', 'M – Medium', 'L – Low', 'N – No Contribution'].map((label, i) => (
                      <span key={i} className={`px-2 py-0.5 rounded-full border ${
                        i === 0 ? 'bg-green-50 text-green-700 border-green-200' :
                        i === 1 ? 'bg-amber-50 text-amber-700 border-amber-200' :
                        i === 2 ? 'bg-blue-50 text-blue-700 border-blue-200' :
                        'bg-gray-50 text-gray-600 border-gray-200'
                      }`}>{label}</span>
                    ))}
                  </div>
                  <CoPOViewTable
                    mapping={formData.co_po_mapping}
                    courseType={formData.course_type}
                  />
                </div>
              </form>
            </div>

            <div className="p-6 border-t border-gray-100 flex justify-end space-x-3 shrink-0 bg-white">
              <button 
                type="button"
                onClick={handleCloseModal}
                className="px-5 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-100 rounded-xl transition-colors"
              >
                Cancel
              </button>
              <button 
                type="submit"
                form="course-form"
                disabled={formLoading || departments.length === 0}
                className="px-5 py-2.5 bg-primary-600 text-white text-sm font-bold rounded-xl hover:bg-primary-700 transition-colors shadow-sm disabled:opacity-50"
              >
                {formLoading ? 'Saving...' : editingId ? 'Save Changes' : 'Create Course'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
