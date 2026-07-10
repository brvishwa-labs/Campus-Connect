import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import { useAuth } from '../../context/AuthContext';
import { BookOpen, Users, Edit3, Clock, TrendingUp, Award, ChevronRight, GraduationCap, Calendar, MapPin } from 'lucide-react';
import StudentCourseService from '../student/StudentCourseService';

const KPICard = ({ title, value, icon: Icon, colorClass, bgColorClass }) => (
  <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 flex items-center space-x-5 transition-transform hover:translate-y-[-2px]">
    <div className={`w-14 h-14 rounded-[16px] ${bgColorClass} flex items-center justify-center flex-shrink-0`}>
      <Icon className={`w-7 h-7 ${colorClass}`} strokeWidth={1.5} />
    </div>
    <div>
      <p className="text-[12px] font-bold text-gray-400 uppercase tracking-wider mb-1">{title}</p>
      <p className="text-[32px] font-extrabold text-gray-900 leading-none">{value}</p>
    </div>
  </div>
);

// Simplified placeholders for the other dashboards for now, using the same design language
const SimpleDashboard = ({ title, role }) => {
  const { user } = useAuth();
  return (
    <div className="space-y-8">
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-[32px] font-bold text-gray-900 tracking-tight mb-2">
            Welcome back, {user?.name || role}! 👋
          </h1>
          <p className="text-[15px] text-gray-500">
            Here is your {role.toLowerCase()} overview for today.
          </p>
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <KPICard title="Total Records" value="1,240" icon={BookOpen} colorClass="text-blue-600" bgColorClass="bg-blue-50" />
        <KPICard title="Active Users" value="842" icon={Users} colorClass="text-emerald-600" bgColorClass="bg-emerald-50" />
        <KPICard title="Pending Tasks" value="12" icon={Edit3} colorClass="text-amber-600" bgColorClass="bg-amber-50" />
        <KPICard title="System Status" value="99%" icon={TrendingUp} colorClass="text-purple-600" bgColorClass="bg-purple-50" />
      </div>
    </div>
  );
};

export { AdminDashboard } from './AdminDashboard';
export { HodDashboard } from '../hod/HodDashboard';
export { FacultyDashboard } from './FacultyDashboardNew';
export const AuthorityDashboard = () => <SimpleDashboard title="Higher Authority Portal" role="Authority" />;

// ─── Student Dashboard ─────────────────────────────────
export const StudentDashboard = () => {
  const { user } = useAuth();
  const [profile, setProfile] = useState(null);
  const [courseCount, setCourseCount] = useState(null);
  const [loading, setLoading] = useState(true);

  const [todaysClasses, setTodaysClasses] = useState([]);
  const [scheduleLoading, setScheduleLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      StudentCourseService.getMyProfile(),
      StudentCourseService.getMyCourses(),
    ])
      .then(([profileData, courses]) => {
        setProfile(profileData);
        setCourseCount(courses.length);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  // Fetch student section classes
  useEffect(() => {
    const fetchClassInfo = async () => {
      try {
        const response = await axios.get('/api/student-portal/my-class');
        const timetable = response.data.timetable || [];
        const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        const currentDay = daysOfWeek[new Date().getDay()];
        const todaySlots = timetable
          .filter(t => t.day === currentDay)
          .sort((a, b) => a.start_time.localeCompare(b.start_time));
        setTodaysClasses(todaySlots);
      } catch (err) {
        console.error('Failed to fetch timetable info', err);
      } finally {
        setScheduleLoading(false);
      }
    };
    fetchClassInfo();
  }, []);

  const getMinutes = (timeStr) => {
    if (!timeStr) return 0;
    const [h, m] = timeStr.split(':').map(Number);
    return h * 60 + m;
  };

  const now = new Date();
  const currentTotalMinutes = now.getHours() * 60 + now.getMinutes();

  const ongoingClass = todaysClasses.find(slot => {
    const startMins = getMinutes(slot.start_time);
    const endMins = getMinutes(slot.end_time);
    return currentTotalMinutes >= startMins && currentTotalMinutes < endMins;
  });

  const upcomingClasses = todaysClasses.filter(slot => {
    const startMins = getMinutes(slot.start_time);
    return currentTotalMinutes < startMins;
  });

  const formatTime = (timeStr) => {
    if (!timeStr) return '';
    const [hours, minutes] = timeStr.split(':');
    const h = parseInt(hours, 10);
    const ampm = h >= 12 ? 'PM' : 'AM';
    const displayH = h % 12 || 12;
    return `${displayH}:${minutes} ${ampm}`;
  };

  const studentName = profile
    ? `${profile.first_name} ${profile.last_name}`
    : user?.name || user?.email?.split('@')[0] || 'Student';

  return (
    <div className="space-y-8">
      {/* Welcome Header */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
          <h1 className="text-[28px] sm:text-[32px] font-bold text-gray-900 tracking-tight mb-2">
            Welcome back, {studentName}! 👋
          </h1>
          <p className="text-[14px] sm:text-[15px] text-gray-500">
            {profile
              ? `Semester ${profile.current_semester} · ${profile.department?.name || ''} · Batch ${profile.batch}`
              : 'Here is your student portal overview.'}
          </p>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 sm:gap-6">
        <KPICard
          title="Enrolled Courses"
          value={loading ? '—' : String(courseCount ?? 0)}
          icon={BookOpen}
          colorClass="text-blue-600"
          bgColorClass="bg-blue-50"
        />
        <KPICard
          title="Current Semester"
          value={loading ? '—' : String(profile?.current_semester ?? '—')}
          icon={GraduationCap}
          colorClass="text-emerald-600"
          bgColorClass="bg-emerald-50"
        />
        <KPICard
          title="Current Year"
          value={loading ? '—' : String(profile?.current_year ?? '—')}
          icon={Award}
          colorClass="text-purple-600"
          bgColorClass="bg-purple-50"
        />
        <KPICard
          title="Batch"
          value={loading ? '—' : (profile?.batch || '—')}
          icon={Users}
          colorClass="text-amber-600"
          bgColorClass="bg-amber-50"
        />
      </div>

      {/* Quick Links — My Courses + My Marks */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 sm:p-8">
            <h3 className="text-[16px] font-bold text-gray-900 mb-4 flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-primary-500" />
              My Courses
            </h3>
            {loading ? (
              <div className="space-y-3 animate-pulse">
                {[1,2,3].map(i => <div key={i} className="h-12 bg-gray-100 rounded-xl" />)}
              </div>
            ) : courseCount === 0 ? (
              <p className="text-[14px] text-gray-400">No courses enrolled for your current semester.</p>
            ) : (
              <p className="text-[14px] text-gray-500 mb-5">
                You have <span className="font-bold text-gray-800">{courseCount}</span> course{courseCount !== 1 ? 's' : ''} enrolled for Semester {profile?.current_semester}.
              </p>
            )}
            <div className="flex flex-wrap gap-3 mt-2">
              <Link
                to="/student/courses"
                className="inline-flex items-center gap-2 text-[13px] font-bold text-primary-600 hover:text-primary-700 bg-primary-50 hover:bg-primary-100 px-4 py-2.5 rounded-xl transition-colors"
              >
                View All Courses
                <ChevronRight className="w-4 h-4" />
              </Link>
              <Link
                to="/student/marks"
                className="inline-flex items-center gap-2 text-[13px] font-bold text-amber-600 hover:text-amber-700 bg-amber-50 hover:bg-amber-100 px-4 py-2.5 rounded-xl transition-colors"
              >
                <Award className="w-4 h-4" />
                My Marks
              </Link>
            </div>
          </div>

          {/* Today's Schedule */}
          <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 overflow-hidden">
            <div className="px-6 py-5 border-b border-gray-100 bg-gray-50/50 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Calendar className="w-5 h-5 text-primary-500" />
                <h3 className="text-[16px] font-bold text-gray-900">Today's Schedule</h3>
              </div>
              <Link to="/student/schedule" className="text-xs text-primary-600 font-semibold hover:underline flex items-center gap-1">
                More about today's schedule
                <ChevronRight className="w-3.5 h-3.5" />
              </Link>
            </div>
            
            <div className="p-6">
              {scheduleLoading ? (
                <div className="space-y-3 animate-pulse">
                  {[1,2].map(i => <div key={i} className="h-16 bg-gray-100 rounded-xl" />)}
                </div>
              ) : todaysClasses.length > 0 ? (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Ongoing Class */}
                  <div className="space-y-3">
                    <h4 className="text-xs font-bold text-gray-400 tracking-wider uppercase">Ongoing Class</h4>
                    {ongoingClass ? (
                      <div className="bg-blue-50/40 border border-blue-100 shadow-sm p-4 rounded-xl relative overflow-hidden">
                        <div className="absolute top-0 right-0 px-2 py-0.5 bg-blue-500 text-[10px] font-black text-white rounded-bl-lg uppercase tracking-wider animate-pulse">
                          Active
                        </div>
                        <div className="flex items-center justify-between mb-1 pr-12">
                          <span className="font-bold text-gray-900 text-sm">{ongoingClass.course_name}</span>
                        </div>
                        <span className="text-xs font-semibold text-blue-600 bg-blue-50 px-2 py-0.5 rounded-full inline-block mb-2">
                          {formatTime(ongoingClass.start_time)} - {formatTime(ongoingClass.end_time)}
                        </span>
                        <p className="text-xs text-gray-500 font-medium">{ongoingClass.course_code}</p>
                        <div className="mt-3 flex items-center justify-between text-xs text-gray-500 pt-2 border-t border-blue-50/50">
                          <span className="flex items-center gap-1"><Users className="w-3 h-3"/> {ongoingClass.faculty_name}</span>
                          {ongoingClass.room_number && <span className="flex items-center gap-1"><MapPin className="w-3 h-3"/> {ongoingClass.room_number}</span>}
                        </div>
                      </div>
                    ) : (
                      <div className="bg-gray-50 border border-gray-100 p-4 rounded-xl text-center py-6 text-gray-500 text-xs font-medium">
                        No ongoing class at this time
                      </div>
                    )}
                  </div>

                  {/* Upcoming Class */}
                  <div className="space-y-3">
                    <h4 className="text-xs font-bold text-gray-400 tracking-wider uppercase">Upcoming Class</h4>
                    {upcomingClasses.length > 0 ? (
                      <div className="bg-white border border-gray-100 shadow-sm p-4 rounded-xl">
                        <div className="flex items-center justify-between mb-1">
                          <span className="font-bold text-gray-900 text-sm">{upcomingClasses[0].course_name}</span>
                          <span className="text-xs font-semibold text-primary-600 bg-primary-50 px-2 py-0.5 rounded-full">
                            {formatTime(upcomingClasses[0].start_time)}
                          </span>
                        </div>
                        <p className="text-xs text-gray-500 font-medium mb-2">{upcomingClasses[0].course_code}</p>
                        <div className="mt-3 flex items-center justify-between text-xs text-gray-500 pt-2 border-t border-gray-50">
                          <span className="flex items-center gap-1"><Users className="w-3 h-3"/> {upcomingClasses[0].faculty_name}</span>
                          {upcomingClasses[0].room_number && <span className="flex items-center gap-1"><MapPin className="w-3 h-3"/> {upcomingClasses[0].room_number}</span>}
                        </div>
                        {upcomingClasses.length > 1 && (
                          <div className="mt-3 text-right">
                            <Link to="/student/schedule" className="text-[11px] font-bold text-primary-500 hover:underline">
                              +{upcomingClasses.length - 1} more upcoming class{upcomingClasses.length - 1 > 1 ? 'es' : ''} today
                            </Link>
                          </div>
                        )}
                      </div>
                    ) : (
                      <div className="bg-gray-50 border border-gray-100 p-4 rounded-xl text-center py-6 text-gray-500 text-xs font-medium">
                        No upcoming classes remaining today
                      </div>
                    )}
                  </div>
                </div>
              ) : (
                <div className="text-center py-10">
                  <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-2">
                    <Calendar className="w-8 h-8 text-gray-300" />
                  </div>
                  <p className="text-sm text-gray-500 font-medium">No classes scheduled for today. Enjoy your day!</p>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Student Info Card */}
        <div className="bg-white rounded-[20px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6">
          <h3 className="text-[16px] font-bold text-gray-900 mb-4">Student Info</h3>
          {loading ? (
            <div className="space-y-3 animate-pulse">
              {[1,2,3,4].map(i => <div key={i} className="h-8 bg-gray-100 rounded-lg" />)}
            </div>
          ) : profile ? (
            <div className="space-y-3">
              {[
                { label: 'Register No.', value: profile.register_number },
                { label: 'Email', value: profile.college_email },
                { label: 'Department', value: profile.department?.name },
                { label: 'Section', value: profile.section || '—' },
              ].map(({ label, value }) => (
                <div key={label} className="flex items-start justify-between gap-2 py-2 border-b border-gray-50 last:border-0">
                  <span className="text-[12px] font-semibold text-gray-400 uppercase tracking-wide">{label}</span>
                  <span className="text-[13px] font-semibold text-gray-700 text-right truncate max-w-[60%]">{value || '—'}</span>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-[13px] text-gray-400">Unable to load profile data.</p>
          )}
        </div>
      </div>
    </div>
  );
};
