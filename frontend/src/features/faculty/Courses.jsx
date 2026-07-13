import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { BookOpen, Users, Clock, Layout, RefreshCw } from 'lucide-react';

export const Courses = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchCourses = async () => {
      try {
        const response = await axios.get('/api/faculty/me/courses');
        setCourses(response.data);
      } catch (err) {
        console.error("Failed to fetch courses:", err);
        setError("Failed to load your assigned courses. Please try again later.");
      } finally {
        setLoading(false);
      }
    };

    fetchCourses();
  }, []);

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-50 text-red-600 p-4 rounded-xl text-sm font-medium border border-red-100">
        {error}
      </div>
    );
  }

  const ownCourses = courses.filter(c => !c.is_substitute);
  const substituteCourses = courses.filter(c => c.is_substitute);
  const activeCourses = ownCourses.filter(c => c.is_active);
  const archivedCourses = ownCourses.filter(c => !c.is_active);

  const renderCourseCard = (assignment, isArchived) => (
    <div
      key={`own-${assignment.id}`}
      onClick={() => navigate(`/faculty/courses/${assignment.id}/lms`)}
      className={`bg-white rounded-xl shadow-sm border overflow-hidden transition-all cursor-pointer active:scale-[0.99] ${
        isArchived 
          ? 'border-gray-200 opacity-80 hover:opacity-100 hover:shadow-md' 
          : 'border-gray-100 hover:shadow-md hover:border-primary-100'
      }`}
    >
      <div className={`h-2 ${isArchived ? 'bg-gray-400' : 'bg-primary-600'}`}></div>
      <div className="p-6">
        <div className="flex justify-between items-start mb-4">
          <div className={`${isArchived ? 'bg-gray-100 text-gray-600' : 'bg-primary-50 text-primary-700'} text-xs font-bold px-2.5 py-1 rounded-md uppercase tracking-wide`}>
            {assignment.course.code}
          </div>
          <div className="flex gap-2">
            {isArchived && (
              <div className="bg-red-50 text-red-600 text-xs font-bold px-2.5 py-1 rounded-md">
                Archived
              </div>
            )}
            <div className="bg-gray-100 text-gray-700 text-xs font-bold px-2.5 py-1 rounded-md">
              {assignment.academic_year} • Sem {assignment.semester}
            </div>
          </div>
        </div>
        
        <h3 className={`text-lg font-bold leading-tight mb-2 ${isArchived ? 'text-gray-600' : 'text-gray-900'}`}>
          {assignment.course.name}
        </h3>
        
        <div className="space-y-2 mt-4">
          <div className="flex items-center text-sm text-gray-600">
            <Layout className="w-4 h-4 mr-2 text-gray-400" />
            <span className="font-medium mr-1">Section:</span>
            {assignment.section ? `${assignment.section.year} Year ${assignment.section.name}` : "N/A"}
          </div>
          <div className="flex items-center text-sm text-gray-600">
            <BookOpen className="w-4 h-4 mr-2 text-gray-400" />
            <span className="font-medium mr-1">Credits:</span>
            {assignment.course.credits}
          </div>
          <div className="flex items-center text-sm text-gray-600">
            <Clock className="w-4 h-4 mr-2 text-gray-400" />
            <span className="font-medium mr-1">Type:</span>
            <span className="capitalize">{assignment.course.course_type}</span>
          </div>
        </div>
      </div>
    </div>
  );

  const renderSubstituteCard = (assignment) => (
    <div
      key={`sub-${assignment.id}`}
      onClick={() => navigate(`/faculty/courses/${assignment.id}/lms`)}
      className="bg-white rounded-xl shadow-sm border border-amber-200 overflow-hidden transition-all cursor-pointer active:scale-[0.99] hover:shadow-md hover:border-amber-300 ring-1 ring-amber-100"
    >
      <div className="h-2 bg-gradient-to-r from-amber-400 to-orange-400"></div>
      <div className="p-6">
        <div className="flex justify-between items-start mb-4">
          <div className="bg-amber-50 text-amber-700 text-xs font-bold px-2.5 py-1 rounded-md uppercase tracking-wide">
            {assignment.course.code}
          </div>
          <div className="flex gap-2">
            <div className="bg-amber-100 text-amber-800 text-xs font-bold px-2.5 py-1 rounded-md flex items-center gap-1">
              <RefreshCw className="w-3 h-3" /> Substitute
            </div>
          </div>
        </div>
        
        <h3 className="text-lg font-bold leading-tight mb-2 text-gray-900">
          {assignment.course.name}
        </h3>

        {assignment.original_faculty_name && (
          <div className="flex items-center gap-2 text-xs font-semibold text-amber-700 bg-amber-50 px-3 py-1.5 rounded-lg border border-amber-100 mb-3">
            <Users className="w-3.5 h-3.5" />
            Covering for: {assignment.original_faculty_name}
          </div>
        )}
        
        <div className="space-y-2 mt-4">
          <div className="flex items-center text-sm text-gray-600">
            <Layout className="w-4 h-4 mr-2 text-gray-400" />
            <span className="font-medium mr-1">Section:</span>
            {assignment.section ? `${assignment.section.year} Year ${assignment.section.name}` : "N/A"}
          </div>
          <div className="flex items-center text-sm text-gray-600">
            <BookOpen className="w-4 h-4 mr-2 text-gray-400" />
            <span className="font-medium mr-1">Credits:</span>
            {assignment.course.credits}
          </div>
          <div className="flex items-center text-sm text-gray-600">
            <Clock className="w-4 h-4 mr-2 text-gray-400" />
            <span className="font-medium mr-1">Type:</span>
            <span className="capitalize">{assignment.course.course_type}</span>
          </div>
        </div>
      </div>
    </div>
  );

  return (
    <div className="space-y-8 pb-12">
      <div className="flex justify-between items-end">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 tracking-tight mb-1">My Courses</h1>
          <p className="text-sm text-gray-500">View and manage your active and past course assignments.</p>
        </div>
      </div>

      {courses.length === 0 ? (
        <div className="bg-white rounded-xl border border-gray-100 p-12 text-center shadow-sm">
          <BookOpen className="w-12 h-12 text-gray-300 mx-auto mb-4" />
          <h3 className="text-lg font-bold text-gray-900 mb-1">No Courses Found</h3>
          <p className="text-gray-500 text-sm">You have not been assigned any courses yet. Please contact your HOD.</p>
        </div>
      ) : (
        <div className="space-y-10">
          {/* Substitute Courses — Today Only */}
          {substituteCourses.length > 0 && (
            <div>
              <h2 className="text-lg font-bold text-amber-700 mb-4 flex items-center gap-2">
                <RefreshCw className="w-5 h-5 text-amber-500" />
                Substitute Duty — Today
              </h2>
              <p className="text-xs text-amber-600 -mt-3 mb-4 ml-7">
                These courses are temporarily assigned to you because the original faculty is on approved leave today.
              </p>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {substituteCourses.map(c => renderSubstituteCard(c))}
              </div>
            </div>
          )}

          {/* Active Courses */}
          {activeCourses.length > 0 && (
            <div>
              <h2 className="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-green-500"></span>
                Active Courses
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {activeCourses.map(c => renderCourseCard(c, false))}
              </div>
            </div>
          )}

          {/* Archived Courses */}
          {archivedCourses.length > 0 && (
            <div>
              <h2 className="text-lg font-bold text-gray-500 mb-4 flex items-center gap-2 pt-4 border-t border-gray-100">
                <span className="w-2 h-2 rounded-full bg-gray-400"></span>
                Archived Courses
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {archivedCourses.map(c => renderCourseCard(c, true))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};
