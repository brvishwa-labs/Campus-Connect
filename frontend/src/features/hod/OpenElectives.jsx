import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../../context/AuthContext';
import {
  BookOpen, Users, Search, CheckCircle, AlertTriangle, Plus, ChevronDown, UserPlus, Check
} from 'lucide-react';

export const OpenElectives = () => {
  const { user } = useAuth();
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedCourse, setSelectedCourse] = useState(null);
  
  const [batches, setBatches] = useState([]);
  const [loadingBatches, setLoadingBatches] = useState(false);
  const [selectedBatch, setSelectedBatch] = useState(null);

  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [selectedDepartment, setSelectedDepartment] = useState('');
  
  const [activeTab, setActiveTab] = useState('add'); // 'add' or 'view'
  const [enrolledStudents, setEnrolledStudents] = useState([]);
  const [loadingEnrolled, setLoadingEnrolled] = useState(false);
  
  const [isSearching, setIsSearching] = useState(false);
  const [assigning, setAssigning] = useState(null);
  const [successMsg, setSuccessMsg] = useState('');

  useEffect(() => {
    fetchCourses();
    fetchDepartments();
  }, []);

  useEffect(() => {
    if (selectedCourse) {
      fetchBatches(selectedCourse.id);
    } else {
      setBatches([]);
      setSelectedBatch(null);
    }
  }, [selectedCourse]);

  const fetchCourses = async () => {
    try {
      const res = await axios.get('/api/hod/open-electives');
      setCourses(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const fetchDepartments = async () => {
    try {
      const res = await axios.get('/api/hod/departments');
      setDepartments(res.data);
    } catch (err) {
      console.error(err);
    }
  };

  const fetchBatches = async (courseId) => {
    setLoadingBatches(true);
    try {
      const res = await axios.get(`/api/hod/open-electives/${courseId}/batches`);
      setBatches(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoadingBatches(false);
    }
  };

  const performSearch = async (query = searchQuery, deptId = selectedDepartment) => {
    if (!selectedCourse) return;
    setIsSearching(true);
    try {
      const res = await axios.post('/api/hod/open-electives/search-student', { 
        query,
        semester: selectedCourse.semester,
        department_id: deptId ? parseInt(deptId) : null,
        course_id: selectedCourse.id
      });
      setSearchResults(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setIsSearching(false);
    }
  };

  useEffect(() => {
    if (selectedCourse && selectedBatch) {
      if (activeTab === 'add') {
        performSearch();
      } else {
        fetchEnrolledStudents();
      }
    }
  }, [selectedCourse, selectedBatch, selectedDepartment, activeTab]);

  const fetchEnrolledStudents = async () => {
    if (!selectedCourse || !selectedBatch) return;
    setLoadingEnrolled(true);
    try {
      const res = await axios.get(`/api/hod/open-electives/${selectedCourse.id}/batches/${selectedBatch.section.id}/students`);
      setEnrolledStudents(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoadingEnrolled(false);
    }
  };

  const handleSearchChange = (e) => {
    const query = e.target.value;
    setSearchQuery(query);
    performSearch(query, selectedDepartment);
  };

  const handleAssign = async (studentId) => {
    if (!selectedCourse || !selectedBatch) return;
    setAssigning(studentId);
    try {
      await axios.post('/api/hod/open-electives/assign', {
        student_id: studentId,
        course_id: selectedCourse.id,
        section_id: selectedBatch.section.id,
        academic_year: selectedCourse.academic_year || "2023-2024",
        semester: selectedCourse.semester || 1
      });
      setSuccessMsg('Successfully assigned!');
      setTimeout(() => setSuccessMsg(''), 3000);
      
      // Update counts and lists
      fetchBatches(selectedCourse.id);
      if (activeTab === 'add') performSearch();
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || "Failed to assign student");
    } finally {
      setAssigning(null);
    }
  };

  const handleRemoveStudent = async (studentId) => {
    if (!confirm("Are you sure you want to remove this student from the course?")) return;
    
    try {
      await axios.delete(`/api/hod/open-electives/enrollment/${selectedCourse.id}/${studentId}`);
      setSuccessMsg('Successfully removed student!');
      setTimeout(() => setSuccessMsg(''), 3000);
      
      // Update counts and lists
      fetchBatches(selectedCourse.id);
      fetchEnrolledStudents();
    } catch (err) {
      console.error(err);
      alert("Failed to remove student");
    }
  };

  if (loading) {
    return (
      <div className="flex h-[calc(100vh-4rem)] items-center justify-center">
        <div className="flex items-center gap-3 text-gray-500">
          <div className="h-6 w-6 animate-spin rounded-full border-2 border-primary-500 border-t-transparent" />
          <p className="font-medium">Loading open electives...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Manage Open Electives</h1>
          <p className="text-gray-500 mt-1">Assign students from any department to your open elective batches</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column: Course Selection */}
        <div className="lg:col-span-1 space-y-4">
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <h2 className="text-base font-bold text-gray-900 mb-4 flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-primary-500" />
              1. Select Course
            </h2>
            
            <div className="space-y-3">
              {courses?.length === 0 ? (
                <div className="text-sm text-gray-500 italic p-4 bg-gray-50 rounded-xl">
                  No open elective courses found for your department.
                </div>
              ) : (
                courses?.map(course => (
                  <button
                    key={course.id}
                    onClick={() => setSelectedCourse(course)}
                    className={`w-full text-left p-4 rounded-xl border transition-all ${
                      selectedCourse?.id === course.id
                        ? 'bg-primary-50 border-primary-200 ring-2 ring-primary-500/20'
                        : 'bg-white border-gray-200 hover:border-primary-200 hover:bg-gray-50'
                    }`}
                  >
                    <h3 className={`font-semibold ${selectedCourse?.id === course.id ? 'text-primary-700' : 'text-gray-900'}`}>
                      {course.name}
                    </h3>
                    <p className="text-xs text-gray-500 mt-1">{course.code} • Sem {course.semester}</p>
                  </button>
                ))
              )}
            </div>
          </div>
          
          {selectedCourse && (
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 animate-fade-in">
              <h2 className="text-base font-bold text-gray-900 mb-4 flex items-center gap-2">
                <Users className="w-5 h-5 text-primary-500" />
                2. Select Batch
              </h2>
              
              {loadingBatches ? (
                <div className="flex justify-center p-4"><div className="w-5 h-5 animate-spin rounded-full border-2 border-primary-500 border-t-transparent" /></div>
              ) : batches?.length === 0 ? (
                <div className="text-sm text-amber-600 bg-amber-50 p-4 rounded-xl border border-amber-100">
                  No faculty has been assigned to a section for this open elective yet. Please assign a faculty first in the Faculty Assignment tab.
                </div>
              ) : (
                <div className="space-y-3">
                  {batches?.map(batch => (
                    <button
                      key={batch.section.id}
                      onClick={() => setSelectedBatch(batch)}
                      className={`w-full text-left p-4 rounded-xl border transition-all ${
                        selectedBatch?.section?.id === batch.section.id
                          ? 'bg-primary-50 border-primary-200 ring-2 ring-primary-500/20'
                          : 'bg-white border-gray-200 hover:border-primary-200 hover:bg-gray-50'
                      }`}
                    >
                      <div className="flex justify-between items-center mb-1">
                        <h3 className={`font-semibold ${selectedBatch?.section?.id === batch.section.id ? 'text-primary-700' : 'text-gray-900'}`}>
                          {batch.section.name}
                        </h3>
                        <span className="text-xs font-medium bg-gray-100 px-2 py-1 rounded-full text-gray-600">
                          {batch.enrolled_count} Enrolled
                        </span>
                      </div>
                      <p className="text-xs text-gray-500">
                        Faculty: {batch.assignment.faculty?.first_name} {batch.assignment.faculty?.last_name}
                      </p>
                    </button>
                  ))}
                </div>
              )}
            </div>
          )}
        </div>

        {/* Right Column: Search & Assign */}
        <div className="lg:col-span-2">
          {selectedCourse && selectedBatch ? (
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 animate-fade-in">
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-lg font-bold text-gray-900 flex items-center gap-2">
                  <UserPlus className="w-5 h-5 text-primary-500" />
                  3. Manage Students for {selectedBatch.section.name}
                </h2>
                <div className="flex bg-gray-100 rounded-lg p-1">
                  <button
                    onClick={() => setActiveTab('add')}
                    className={`px-4 py-1.5 text-sm font-medium rounded-md transition-colors ${
                      activeTab === 'add' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'
                    }`}
                  >
                    Add Students
                  </button>
                  <button
                    onClick={() => setActiveTab('view')}
                    className={`px-4 py-1.5 text-sm font-medium rounded-md transition-colors ${
                      activeTab === 'view' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'
                    }`}
                  >
                    View Enrolled ({selectedBatch.enrolled_count})
                  </button>
                </div>
              </div>

              {successMsg && (
                <div className="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-xl flex items-center gap-2 text-sm font-medium animate-fade-in">
                  <CheckCircle className="w-5 h-5" />
                  {successMsg}
                </div>
              )}
              
              {activeTab === 'add' ? (
                <>
                  <p className="text-sm text-gray-500 mb-6">Search for eligible unenrolled students to add them to this open elective batch.</p>
                  
                  <div className="flex gap-4 mb-6">
                <div className="relative flex-1">
                  <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <input
                    type="text"
                    value={searchQuery}
                    onChange={handleSearchChange}
                    placeholder="Search by name or reg no (e.g. 23CS001)..."
                    className="w-full pl-12 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none"
                  />
                  {isSearching && (
                    <div className="absolute right-4 top-1/2 -translate-y-1/2">
                      <div className="w-4 h-4 animate-spin rounded-full border-2 border-primary-500 border-t-transparent" />
                    </div>
                  )}
                </div>
                
                <div className="w-64">
                  <select
                    value={selectedDepartment}
                    onChange={(e) => setSelectedDepartment(e.target.value)}
                    className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 outline-none"
                  >
                    <option value="">All Departments</option>
                    {departments?.map(d => (
                      <option key={d.id} value={d.id}>{d.name}</option>
                    ))}
                  </select>
                </div>
              </div>

              {successMsg && (
                <div className="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-xl flex items-center gap-2 text-sm font-medium animate-fade-in">
                  <CheckCircle className="w-5 h-5" />
                  {successMsg}
                </div>
              )}

              <div className="border border-gray-200 rounded-xl overflow-hidden divide-y divide-gray-100">
                {searchResults?.length === 0 ? (
                  <div className="p-6 text-center text-gray-500 text-sm">
                    {searchQuery ? `No students found matching "${searchQuery}"` : "No eligible students found for this semester."}
                  </div>
                ) : (
                    searchResults?.map(student => (
                      <div key={student.id} className="flex items-center justify-between p-4 hover:bg-gray-50 transition-colors">
                        <div>
                          <p className="font-semibold text-gray-900">{student.name}</p>
                          <div className="flex gap-2 text-xs text-gray-500 mt-1">
                            <span className="font-medium text-gray-700">{student.register_number}</span>
                            <span>•</span>
                            <span>{student.department}</span>
                          </div>
                        </div>
                        <button
                          onClick={() => handleAssign(student.id)}
                          disabled={assigning === student.id}
                          className="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white text-sm font-medium rounded-lg transition-colors flex items-center gap-2 disabled:opacity-50"
                        >
                          {assigning === student.id ? (
                            <div className="w-4 h-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                          ) : (
                            <Plus className="w-4 h-4" />
                          )}
                          Add to Course
                        </button>
                      </div>
                    ))
                  )}
                </div>
              </>
            ) : (
                <div className="border border-gray-200 rounded-xl overflow-hidden divide-y divide-gray-100">
                  {loadingEnrolled ? (
                    <div className="p-8 text-center">
                      <div className="w-8 h-8 animate-spin rounded-full border-4 border-primary-500 border-t-transparent mx-auto"></div>
                    </div>
                  ) : enrolledStudents?.length === 0 ? (
                    <div className="p-8 text-center text-gray-500 text-sm flex flex-col items-center">
                      <Users className="w-12 h-12 text-gray-300 mb-3" />
                      <p>No students enrolled yet.</p>
                      <button 
                        onClick={() => setActiveTab('add')}
                        className="mt-4 text-primary-600 hover:text-primary-700 font-medium"
                      >
                        Add students
                      </button>
                    </div>
                  ) : (
                    enrolledStudents?.map(student => (
                      <div key={student.id} className="flex items-center justify-between p-4 hover:bg-gray-50 transition-colors">
                        <div>
                          <p className="font-semibold text-gray-900">{student.name}</p>
                          <div className="flex gap-2 text-xs text-gray-500 mt-1">
                            <span className="font-medium text-gray-700">{student.register_number}</span>
                            <span>•</span>
                            <span>{student.department}</span>
                          </div>
                        </div>
                        <button
                          onClick={() => handleRemoveStudent(student.id)}
                          className="px-4 py-2 text-red-600 hover:bg-red-50 text-sm font-medium rounded-lg transition-colors border border-transparent hover:border-red-200"
                        >
                          Remove
                        </button>
                      </div>
                    ))
                  )}
                </div>
              )}
            </div>
          ) : (
            <div className="bg-gray-50 border border-dashed border-gray-300 rounded-2xl h-full min-h-[400px] flex flex-col items-center justify-center text-center p-8">
              <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center shadow-sm mb-4">
                <Search className="w-8 h-8 text-gray-400" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-2">Select Course & Batch</h3>
              <p className="text-gray-500 max-w-sm">Please select an Open Elective course and a specific batch from the left to start assigning students.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default OpenElectives;
