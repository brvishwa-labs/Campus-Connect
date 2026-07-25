import React, { useState, useEffect, useRef } from 'react';
import { Outlet, Navigate, Link, useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { 
  LayoutDashboard, Users, BookOpen, GraduationCap, Settings, LogOut, Bell, Search, Moon, Sun, Home, Calendar, ShieldAlert, Clock, Menu, X, ChevronDown, ChevronRight, ClipboardList, BarChart2, TrendingUp, Info, User, Shield, Award, MessageSquare, Upload, AlertTriangle, CreditCard, Eye, MapPin
} from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import MessagingFloatingWidget from '../components/MessagingFloatingWidget';

const ROLE_NAV_LINKS = {
  admin: [
    { name: 'Dashboard', path: '/admin', icon: LayoutDashboard },
    { name: 'Departments', path: '/admin/departments', icon: Settings },
    { name: 'Faculty', path: '/admin/faculty', icon: Users },
    { name: 'Students', path: '/admin/students', icon: GraduationCap },
    { name: 'Alumni', path: '/admin/alumni', icon: Award },
    { name: 'Authorities', path: '/admin/authorities', icon: Home },
    { name: 'Courses', path: '/admin/courses', icon: BookOpen },
    { name: 'Discipline', path: '/admin/discipline', icon: ShieldAlert },
    { name: 'Late Tracker', path: '/admin/latetracker', icon: Clock },
    { name: 'Announcements', path: '/admin/announcements', icon: Bell },
    { name: 'Password Resets', path: '/admin/password-resets', icon: ShieldAlert },
    { name: 'Fees & Accounts', path: '/admin/fees', icon: TrendingUp },
  ],
  hod: [
    { name: 'Dashboard', path: '/hod', icon: LayoutDashboard },
    { name: 'Faculty', path: '/hod/faculty', icon: Users },
    { name: 'Students', path: '/hod/students', icon: GraduationCap },
    { name: 'Sections', path: '/hod/sections', icon: Settings },
    { name: 'My Courses', path: '/faculty/courses', icon: BookOpen },
    { name: 'Timetable', path: '/hod/timetable', icon: Calendar },
    { name: 'Open Electives', path: '/hod/open-electives', icon: Users },
    { name: 'Course Assignment', path: '/hod/assignments', icon: BookOpen },
    { name: 'Mentor Assignment', path: '/hod/mentors', icon: Users },
    { name: 'Attendance', path: '/hod/attendance', icon: ClipboardList },
    { name: 'Results', path: '/hod/results', icon: BarChart2 },
    { name: 'Announcements', path: '/hod/announcements', icon: Bell },
    { name: 'My Leave', path: '/hod/my-leave', icon: Calendar },
    { name: 'Leave Approvals', path: '/hod/leave', icon: Calendar },
    { name: 'Peer Approvals', path: '/faculty/leave/substitutes', icon: Users },
    { name: 'Discipline', path: '/hod/discipline', icon: ShieldAlert },
    { name: 'Late Tracker', path: '/hod/latetracker', icon: Clock },
    { name: 'Gate Pass Approvals', path: '/hod/gatepass', icon: Clock },
    { name: 'Faculty Gate Pass Approvals', path: '/hod/faculty-gatepass', icon: Clock },
  ],
  faculty: [
    { name: 'Dashboard', path: '/faculty', icon: LayoutDashboard },
    { name: 'My Attendance', path: '/faculty/my-attendance', icon: ClipboardList },
    { name: 'My Courses', path: '/faculty/courses', icon: BookOpen },
    { name: 'Leave Requests', path: '/faculty/leave', icon: Calendar },
    { name: 'Peer Approvals', path: '/faculty/leave/substitutes', icon: Users },
    { name: 'Mentorship', path: '/faculty/mentorship', icon: GraduationCap },
    { name: 'Report Incident', path: '/faculty/discipline', icon: ShieldAlert },
    { name: 'Late Entry Notifications', path: '/faculty/late-entry', icon: Bell },
    { name: 'Altered Class Advisor', path: '/faculty/altered-class-advisor', icon: Users },
    { name: 'Announcements', path: '/faculty/announcements', icon: Bell },
  ],
  student: [
    { name: 'Dashboard', path: '/student', icon: LayoutDashboard },
    { name: 'My Class', path: '/student/class', icon: Users },
    { name: 'My Courses', path: '/student/courses', icon: BookOpen },
    { name: "Today's Schedule", path: '/student/schedule', icon: Calendar },
    { name: 'My Marks', path: '/student/marks', icon: Award },
    { name: 'Leave Tracker', path: '/student/leave', icon: Calendar },
    { name: 'Gate Pass', path: '/student/gatepass', icon: Clock },
    { name: 'Late Entry Notification', path: '/student/late-entry', icon: Bell },
    { name: 'Announcements', path: '/student/announcements', icon: Bell },
    { name: 'Message Dean', path: '/student/messaging', icon: MessageSquare },
    { name: 'My Fees', path: '/student/fees', icon: TrendingUp },
  ],
  authority: [
    { name: 'Dashboard', path: '/authority', icon: LayoutDashboard },
    { name: 'Faculty Directory', path: '/authority/faculty', icon: Users },
    { name: 'Analytics', path: '/authority/analytics', icon: BookOpen },
    { name: 'Discipline', path: '/authority/discipline', icon: ShieldAlert },
    { name: 'Late Tracker', path: '/authority/latetracker', icon: Clock },
    { name: 'Leave Approvals', path: '/authority/leave', icon: Calendar },
    { name: 'Peer Approvals', path: '/authority/leave/substitutes', icon: Users },
    { name: 'Gate Pass Approvals', path: '/authority/gatepass', icon: Clock },
    { name: 'Faculty Gate Pass Approvals', path: '/authority/faculty-gatepass', icon: Clock },
    { name: 'Announcements', path: '/authority/announcements', icon: Bell },
  ],
  accountant: [
    { name: 'Upload Center', path: '/accountant', icon: Upload },
    { name: 'Unmapped Queue', path: '/accountant', icon: AlertTriangle },
    { name: 'Manual Payment', path: '/accountant', icon: CreditCard },
    { name: 'Fee Structure', path: '/accountant', icon: BookOpen },
    { name: 'Student Ledger', path: '/accountant', icon: Eye },
    { name: 'Reports', path: '/accountant', icon: BarChart2 },
    { name: 'Ledger Mappings', path: '/accountant', icon: MapPin },
  ]
};

export default function DashboardLayout() {
  const { user, logout } = useAuth();
  const { isDarkMode, toggleTheme } = useTheme();
  const location = useLocation();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isCAOpen, setIsCAOpen] = useState(location.pathname.startsWith('/faculty/class-advisor'));
  const [isHRLeavesOpen, setIsHRLeavesOpen] = useState(location.pathname.startsWith('/hr/leaves'));
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);
  const [userMenuVisible, setUserMenuVisible] = useState(false);
  const userMenuRef = useRef(null);

  useEffect(() => {
    const handleClickOutside = (e) => {
      if (userMenuRef.current && !userMenuRef.current.contains(e.target)) {
        setIsUserMenuOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Sync visibility with open state for animation
  useEffect(() => {
    if (isUserMenuOpen) {
      setUserMenuVisible(true);
    } else {
      const t = setTimeout(() => setUserMenuVisible(false), 150);
      return () => clearTimeout(t);
    }
  }, [isUserMenuOpen]);

  const [badgeCounts, setBadgeCounts] = useState({});

  const [delegationStatus, setDelegationStatus] = useState({
    has_delegation: false,
    has_pending: false,
    is_active_today: false,
    active_leave: null
  });

  const fetchDelegationStatus = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;
      const res = await axios.get('/api/leave/delegation-status', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setDelegationStatus(res.data);
    } catch (err) {
      console.error('Failed to fetch delegation status', err);
    }
  };

  const fetchBadgeCounts = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;
      const res = await axios.get('/api/notifications/badge-counts', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setBadgeCounts(res.data);
    } catch (err) {
      console.error('Failed to fetch badge counts', err);
    }
  };

  useEffect(() => {
    if (user) {
      fetchBadgeCounts();
      fetchNotifications();
      if (user.role === 'faculty' || user.role === 'hod') {
        fetchDelegationStatus();
      }
      const interval = setInterval(() => {
        fetchBadgeCounts();
        fetchNotifications();
        if (user.role === 'faculty' || user.role === 'hod') {
          fetchDelegationStatus();
        }
      }, 10000); // poll every 10s for near real-time
      return () => clearInterval(interval);
    }
  }, [user]);

  useEffect(() => {
    window.addEventListener('refetch-badges', fetchBadgeCounts);
    // Refresh badges instantly when user switches back to the tab
    const handleVisibility = () => {
      if (document.visibilityState === 'visible') fetchBadgeCounts();
    };
    // Refresh badges when the browser window regains focus
    const handleFocus = () => fetchBadgeCounts();
    document.addEventListener('visibilitychange', handleVisibility);
    window.addEventListener('focus', handleFocus);
    return () => {
      window.removeEventListener('refetch-badges', fetchBadgeCounts);
      document.removeEventListener('visibilitychange', handleVisibility);
      window.removeEventListener('focus', handleFocus);
    };
  }, []);

  useEffect(() => {
    const markAsViewed = async () => {
      const pathToSector = {
        // Faculty
        '/faculty/leave':               'faculty-leave',
        '/faculty/leave/substitutes':   'faculty-peer-substitutes',
        '/faculty/hod-duty':            'faculty-hod-duty',
        '/faculty/mentorship':          'faculty-mentorship',
        '/faculty/gatepass':            'faculty-gatepass',
        '/faculty/faculty-gatepass':    'faculty-gatepass-own',
        '/faculty/late-entry':          'late-entry',
        '/faculty/announcements':       'faculty-announcements',
        '/faculty/class-advisor/leave': 'faculty-ca-leave',
        // HOD
        '/hod/leave':                   'hod-leave',
        '/hod/gatepass':                'hod-gatepass',
        '/hod/faculty-gatepass':        'hod-faculty-gatepass',
        '/hod/discipline':              'hod-discipline',
        '/hod/latetracker':             'hod-latetracker',
        '/hod/announcements':           'hod-announcements',
        // Authority / Dean / OM / Principal
        '/authority/leave':             'authority-leave',
        '/authority/gatepass':          'authority-gatepass',
        '/authority/faculty-gatepass':  'authority-faculty-gatepass',
        '/authority/announcements':     'authority-announcements',
        // Student
        '/student/leave':               'student-leave',
        '/student/gatepass':            'student-gatepass',
        '/student/late-entry':          'student-late-entry',
        '/student/announcements':       'student-announcements',
        // Admin
        '/admin/discipline':            'admin-discipline',
        '/admin/latetracker':           'admin-latetracker',
        '/admin/announcements':         'admin-announcements',
      };

      const sector = pathToSector[location.pathname];

      if (sector) {
        try {
          const token = localStorage.getItem('token');
          await axios.put(`/api/notifications/mark-viewed?sector=${sector}`, {}, {
            headers: { Authorization: `Bearer ${token}` }
          });
          fetchBadgeCounts();
        } catch (err) {
          console.error('Failed to mark sector as viewed', err);
        }
      }
    };

    if (user) {
      markAsViewed();
    }
  }, [location.pathname, user]);

  const [isNotificationsOpen, setIsNotificationsOpen] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [hasUnread, setHasUnread] = useState(false);
  const navigate = useNavigate();
  const dropdownRef = useRef(null);

  const fetchNotifications = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return;
      const res = await axios.get('/api/notifications/center', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setNotifications(res.data);
      const hasUnreadItems = Array.isArray(res.data) && res.data.some(n => !n.is_read);
      setHasUnread(hasUnreadItems);
    } catch (err) {
      console.error('Failed to fetch notifications center', err);
    }
  };

  useEffect(() => {
    function handleClickOutside(event) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsNotificationsOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleBellClick = () => {
    setIsUserMenuOpen(false); // close profile menu first
    setIsNotificationsOpen(prev => !prev);
  };

  if (!user) return <Navigate to="/login" replace />;

  let navLinks = ROLE_NAV_LINKS[user.role] || [];
  
  if (user.role === 'faculty') {
    navLinks = navLinks.filter(link => link.name !== 'Mentorship' || user.is_mentor);
  }
  
  if (user.role === 'authority') {
    const title = user.title ? user.title.toLowerCase().trim() : '';
    
    // Filter Faculty menu - only for Dean, Principal, and OM
    if (title !== 'dean' && title !== 'principal' && title !== 'office manager') {
      navLinks = navLinks.filter(link => link.name !== 'Faculty Directory');
    }
    
    if (title !== 'office manager') {
      navLinks = navLinks.filter(link => link.name !== 'Gate Pass Approvals');
    } else {
      // If Office Manager, update Analytics path
      navLinks = navLinks.map(link => 
        link.name === 'Analytics' ? { ...link, path: '/authority/om-analytics' } : link
      );
    }
    if (title !== 'dean' && title !== 'office manager' && title !== 'hr') {
      navLinks = navLinks.filter(link => link.name !== 'Faculty Gate Pass Approvals');
    }
    if (title === 'hr') {
      navLinks = navLinks.filter(link => 
        ['Dashboard'].includes(link.name)
      );
      navLinks.push({
        name: 'Faculty Leaves',
        path: '/hr/leaves',
        icon: Calendar
      });
      navLinks.push({
        name: 'Restricted Holidays',
        path: '/hr/restricted-holidays',
        icon: Calendar
      });
      navLinks.push({
        name: 'Gatepass Tracking',
        path: '/hr/gatepass',
        icon: Clock
      });
      navLinks.push({
        name: 'Faculty Directory',
        path: '/hr/faculty',
        icon: Users
      });
    }
    if (title === 'dean') {
      // Add Messages to Dean Authority
      navLinks = [
        ...navLinks,
        { name: 'Student Messages', path: '/dean/messaging', icon: MessageSquare }
      ];
    }
  }
  const currentLink = navLinks.find(link => link.path === location.pathname);

  // For Class Advisor sub-pages, find a label
  const CA_SUB_LABELS = {
    '/faculty/class-advisor': 'Class Advisor',
    '/faculty/class-advisor/students': 'Student List',
    '/faculty/class-advisor/attendance': 'Daily Attendance',
    '/faculty/class-advisor/attendance-summary': 'Attendance Summary',
    '/faculty/class-advisor/timetable': 'Class Timetable',
    '/faculty/class-advisor/subjects': 'Class Subjects',
    '/faculty/class-advisor/progress': 'Course Progress',
    '/faculty/class-advisor/info': 'Class Information',
    '/faculty/class-advisor/leave': 'Leave Requests',
  };
  const caLabel = CA_SUB_LABELS[location.pathname];
  const pageName = currentLink ? currentLink.name : (caLabel || 'Dashboard');

  const CA_SUB_LINKS = [
    { name: 'Dashboard',          path: '/faculty/class-advisor',                    icon: LayoutDashboard },
    { name: 'Student List',       path: '/faculty/class-advisor/students',            icon: GraduationCap },
    { name: 'Daily Attendance',   path: '/faculty/class-advisor/attendance',          icon: ClipboardList },
    { name: 'Attendance Summary', path: '/faculty/class-advisor/attendance-summary',  icon: BarChart2 },
    { name: 'Class Timetable',    path: '/faculty/class-advisor/timetable',           icon: Calendar },
    { name: 'Class Subjects',     path: '/faculty/class-advisor/subjects',            icon: BookOpen },
    { name: 'Course Progress',    path: '/faculty/class-advisor/progress',            icon: TrendingUp },
    { name: 'Class Information',  path: '/faculty/class-advisor/info',                icon: Info },
    { name: 'Leave Requests',     path: '/faculty/class-advisor/leave',               icon: Calendar },
  ];

  const totalBadgeCount = Object.values(badgeCounts).reduce((acc, count) => acc + (count || 0), 0);

  return (
    <div className="flex h-screen bg-gray-50 overflow-hidden font-sans w-full relative">
      
      {/* Elegant Dark Theme Ambient Glow (White Shade) */}
      <div className="absolute top-0 left-0 right-0 h-[800px] opacity-0 dark:opacity-100 bg-[radial-gradient(ellipse_at_top,rgba(255,255,255,0.05),transparent_70%)] pointer-events-none z-0"></div>
      {/* Mobile Backdrop */}
      {isMobileMenuOpen && (
        <div 
          className="fixed inset-0 bg-gray-900/50 z-[104] lg:hidden transition-opacity backdrop-blur-sm"
          onClick={() => setIsMobileMenuOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside 
        className={`fixed inset-y-0 left-0 w-[280px] bg-white border-r border-gray-200 flex flex-col z-[105] transform transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-auto lg:flex-shrink-0 ${
          isMobileMenuOpen ? 'translate-x-0 shadow-2xl' : '-translate-x-full'
        }`}
      >
        <div className="h-20 flex flex-col justify-center px-6 border-b border-gray-100 relative">
          <div className="text-primary-600 font-extrabold text-2xl tracking-tight flex items-center">
            <img src="/logo2.png" alt="Logo" className="h-8 w-auto mr-2 object-contain" onError={(e) => { e.target.style.display = 'none'; }} />
            <span className="bg-clip-text text-transparent bg-gradient-to-r from-primary-600 to-indigo-600">
              CampusConnect
            </span>
          </div>
          <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1 ml-1.5">
            {user.role} Portal
          </p>
        </div>
        
        <nav className="flex-1 px-4 py-6 space-y-1.5 overflow-y-auto">
          {navLinks.map((link) => {
            const Icon = link.icon;
            const isActive = location.pathname === link.path;
            const renderLink = (
              <Link
                key={link.name}
                to={link.path}
                onClick={() => setIsMobileMenuOpen(false)}
                className={`flex items-center justify-between px-4 py-3 rounded-xl transition-all ${
                  isActive 
                    ? 'bg-primary-50 dark:bg-gray-100 text-primary-600 dark:text-gray-900 font-bold' 
                    : 'text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-100/50 hover:text-gray-900 dark:hover:text-gray-100 font-medium'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <Icon className={`w-5 h-5 ${isActive ? 'text-primary-600 dark:text-gray-900' : 'text-gray-400 dark:text-gray-500'}`} />
                  <span className="text-[15px]">{link.name}</span>
                </div>
                {badgeCounts[link.path] > 0 && (
                  <span className="bg-red-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full min-w-[20px] text-center shadow-sm">
                    {badgeCounts[link.path]}
                  </span>
                )}
              </Link>
            );

            if (link.name === 'Dashboard' && user.role === 'faculty' && user.is_class_advisor) {
              const caTotalBadge = CA_SUB_LINKS.reduce((acc, sublink) => acc + (badgeCounts[sublink.path] || 0), 0);
              return (
                <React.Fragment key={link.name}>
                  {renderLink}
                  <div>
                    <button
                      onClick={() => setIsCAOpen(prev => !prev)}
                      className={`w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all font-medium ${
                        location.pathname.startsWith('/faculty/class-advisor')
                          ? 'bg-indigo-50 dark:bg-gray-100 text-indigo-700 dark:text-gray-900 font-bold'
                          : 'text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-100/50 hover:text-gray-900 dark:hover:text-gray-100'
                      }`}
                    >
                      <div className="flex items-center space-x-3">
                        <GraduationCap className={`w-5 h-5 ${location.pathname.startsWith('/faculty/class-advisor') ? 'text-indigo-600 dark:text-gray-900' : 'text-gray-400 dark:text-gray-500'}`} />
                        <span className="text-[15px]">Class Advisor</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        {caTotalBadge > 0 && !isCAOpen && (
                          <span className="bg-indigo-500 text-white text-[11px] font-bold px-2 py-0.5 rounded-full min-w-[20px] text-center shadow-sm">
                            {caTotalBadge}
                          </span>
                        )}
                        {isCAOpen
                          ? <ChevronDown className="w-4 h-4 text-gray-400" />
                          : <ChevronRight className="w-4 h-4 text-gray-400" />
                        }
                      </div>
                    </button>

                    {isCAOpen && (
                      <div className="ml-4 mt-1 space-y-0.5 border-l-2 border-indigo-100 dark:border-indigo-500/50 pl-3">
                        {CA_SUB_LINKS.map(sublink => {
                          const SubIcon = sublink.icon;
                          const isSubActive = location.pathname === sublink.path;
                          return (
                            <Link
                              key={sublink.path}
                              to={sublink.path}
                              onClick={() => setIsMobileMenuOpen(false)}
                              className={`flex items-center justify-between px-3 py-2.5 rounded-xl transition-all text-[14px] ${
                                isSubActive
                                  ? 'bg-indigo-50 dark:bg-gray-100 text-indigo-700 dark:text-gray-900 font-bold'
                                  : 'text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-100/50 hover:text-gray-800 dark:hover:text-gray-100 font-medium'
                              }`}
                            >
                              <div className="flex items-center space-x-2.5">
                                <SubIcon className={`w-4 h-4 ${isSubActive ? 'text-indigo-600 dark:text-gray-900' : 'text-gray-400 dark:text-gray-500'}`} />
                                <span>{sublink.name}</span>
                              </div>
                              {badgeCounts[sublink.path] > 0 && (
                                <span className="bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full min-w-[18px] text-center shadow-sm">
                                  {badgeCounts[sublink.path]}
                                </span>
                              )}
                            </Link>
                          );
                        })}
                      </div>
                    )}
                  </div>
                </React.Fragment>
              );
            }

            if (link.name === 'Faculty Leaves' && user.role === 'authority') {
              const HR_LEAVES_SUB_LINKS = [
                { name: 'Leave Tracking', path: '/hr/leaves', icon: Calendar },
                { name: 'Set Limits', path: '/hr/leaves/set-limits', icon: Settings },
              ];
              return (
                <React.Fragment key={link.name}>
                  <div>
                    <button
                      onClick={() => setIsHRLeavesOpen(prev => !prev)}
                      className={`w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all font-medium ${
                        location.pathname.startsWith('/hr/leaves')
                          ? 'bg-indigo-50 dark:bg-gray-100 text-indigo-700 dark:text-gray-900 font-bold'
                          : 'text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-100/50 hover:text-gray-900 dark:hover:text-gray-100'
                      }`}
                    >
                      <div className="flex items-center space-x-3">
                        <Calendar className={`w-5 h-5 ${location.pathname.startsWith('/hr/leaves') ? 'text-indigo-600 dark:text-gray-900' : 'text-gray-400 dark:text-gray-500'}`} />
                        <span className="text-[15px]">Faculty Leaves</span>
                      </div>
                      <div className="flex items-center space-x-2">
                        {isHRLeavesOpen
                          ? <ChevronDown className="w-4 h-4 text-gray-400" />
                          : <ChevronRight className="w-4 h-4 text-gray-400" />
                        }
                      </div>
                    </button>

                    {isHRLeavesOpen && (
                      <div className="ml-4 mt-1 space-y-0.5 border-l-2 border-indigo-100 dark:border-indigo-500/50 pl-3">
                        {HR_LEAVES_SUB_LINKS.map(sublink => {
                          const SubIcon = sublink.icon;
                          const isSubActive = location.pathname === sublink.path;
                          return (
                            <Link
                              key={sublink.path}
                              to={sublink.path}
                              onClick={() => setIsMobileMenuOpen(false)}
                              className={`flex items-center justify-between px-3 py-2.5 rounded-xl transition-all text-[14px] ${
                                isSubActive
                                  ? 'bg-indigo-50 dark:bg-gray-100 text-indigo-700 dark:text-gray-900 font-bold'
                                  : 'text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-100/50 hover:text-gray-800 dark:hover:text-gray-100 font-medium'
                              }`}
                            >
                              <div className="flex items-center space-x-2.5">
                                <SubIcon className={`w-4 h-4 ${isSubActive ? 'text-indigo-600 dark:text-gray-900' : 'text-gray-400 dark:text-gray-500'}`} />
                                <span>{sublink.name}</span>
                              </div>
                            </Link>
                          );
                        })}
                      </div>
                    )}
                  </div>
                </React.Fragment>
              );
            }

            return renderLink;
          })}

          {/* Dedicated Temporary HOD Responsibilities Section */}
          {user.role === 'faculty' && (delegationStatus.has_delegation || delegationStatus.is_active_today) && (
            <div className="mt-4 pt-3 border-t-2 border-amber-300 dark:border-amber-500/40 bg-gradient-to-b from-amber-50/80 to-orange-50/40 dark:from-amber-950/30 dark:to-amber-900/10 rounded-xl p-2.5 border border-amber-200/80 dark:border-amber-800/40 shadow-sm">
              <div className="flex items-center space-x-2 px-2 py-1.5 mb-1.5">
                <Shield className="w-4 h-4 text-amber-600 dark:text-amber-400 flex-shrink-0" />
                <span className="text-[11px] font-extrabold text-amber-900 dark:text-amber-300 uppercase tracking-wider">
                  HOD Responsibilities (Temporary)
                </span>
              </div>

              <div className="space-y-1">
                {/* HOD Duty Requests - visible when faculty has pending/active delegation */}
                {delegationStatus.has_delegation && (
                  <Link
                    to="/faculty/hod-duty"
                    onClick={() => setIsMobileMenuOpen(false)}
                    className={`flex items-center justify-between px-3 py-2 rounded-lg transition-all text-xs font-semibold ${
                      location.pathname === '/faculty/hod-duty'
                        ? 'bg-amber-600 text-white font-bold shadow-sm'
                        : 'text-amber-950 dark:text-amber-200 hover:bg-amber-100/80 dark:hover:bg-amber-900/40 font-medium'
                    }`}
                  >
                    <div className="flex items-center space-x-2.5">
                      <Users className={`w-4 h-4 ${location.pathname === '/faculty/hod-duty' ? 'text-white' : 'text-amber-600 dark:text-amber-400'}`} />
                      <span>HOD Duty Requests</span>
                    </div>
                    {badgeCounts['/faculty/hod-duty'] > 0 && (
                      <span className="bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full min-w-[18px] text-center shadow-sm">
                        {badgeCounts['/faculty/hod-duty']}
                      </span>
                    )}
                  </Link>
                )}

                {/* Temporary Approval Modules - visible ONLY when leave is approved and today is within leave dates */}
                {delegationStatus.is_active_today && (
                  <>
                    <Link
                      to="/hod/leave"
                      onClick={() => setIsMobileMenuOpen(false)}
                      className={`flex items-center justify-between px-3 py-2 rounded-lg transition-all text-xs font-semibold ${
                        location.pathname === '/hod/leave'
                          ? 'bg-amber-600 text-white font-bold shadow-sm'
                          : 'text-amber-950 dark:text-amber-200 hover:bg-amber-100/80 dark:hover:bg-amber-900/40 font-medium'
                      }`}
                    >
                      <div className="flex items-center space-x-2.5">
                        <Calendar className={`w-4 h-4 ${location.pathname === '/hod/leave' ? 'text-white' : 'text-amber-600 dark:text-amber-400'}`} />
                        <span>Faculty & Student Leave Approvals</span>
                      </div>
                      {badgeCounts['/hod/leave'] > 0 && (
                        <span className="bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full min-w-[18px] text-center shadow-sm">
                          {badgeCounts['/hod/leave']}
                        </span>
                      )}
                    </Link>

                    <Link
                      to="/hod/gatepass"
                      onClick={() => setIsMobileMenuOpen(false)}
                      className={`flex items-center justify-between px-3 py-2 rounded-lg transition-all text-xs font-semibold ${
                        location.pathname === '/hod/gatepass'
                          ? 'bg-amber-600 text-white font-bold shadow-sm'
                          : 'text-amber-950 dark:text-amber-200 hover:bg-amber-100/80 dark:hover:bg-amber-900/40 font-medium'
                      }`}
                    >
                      <div className="flex items-center space-x-2.5">
                        <Clock className={`w-4 h-4 ${location.pathname === '/hod/gatepass' ? 'text-white' : 'text-amber-600 dark:text-amber-400'}`} />
                        <span>Student Gate Pass Approvals</span>
                      </div>
                      {badgeCounts['/hod/gatepass'] > 0 && (
                        <span className="bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full min-w-[18px] text-center shadow-sm">
                          {badgeCounts['/hod/gatepass']}
                        </span>
                      )}
                    </Link>

                    <Link
                      to="/hod/faculty-gatepass"
                      onClick={() => setIsMobileMenuOpen(false)}
                      className={`flex items-center justify-between px-3 py-2 rounded-lg transition-all text-xs font-semibold ${
                        location.pathname === '/hod/faculty-gatepass'
                          ? 'bg-amber-600 text-white font-bold shadow-sm'
                          : 'text-amber-950 dark:text-amber-200 hover:bg-amber-100/80 dark:hover:bg-amber-900/40 font-medium'
                      }`}
                    >
                      <div className="flex items-center space-x-2.5">
                        <Clock className={`w-4 h-4 ${location.pathname === '/hod/faculty-gatepass' ? 'text-white' : 'text-amber-600 dark:text-amber-400'}`} />
                        <span>Faculty Gate Pass Approvals</span>
                      </div>
                      {badgeCounts['/hod/faculty-gatepass'] > 0 && (
                        <span className="bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full min-w-[18px] text-center shadow-sm">
                          {badgeCounts['/hod/faculty-gatepass']}
                        </span>
                      )}
                    </Link>
                  </>
                )}
              </div>
            </div>
          )}
        </nav>
        
        <div className="p-4 mt-auto border-t border-gray-100">
          <button
            onClick={() => { setIsMobileMenuOpen(false); navigate(`/${user.role}/profile`); }}
            className="flex items-center space-x-3 w-full px-4 py-3 rounded-xl text-gray-600 hover:bg-gray-50 font-semibold transition-colors mb-1"
          >
            <User className="w-5 h-5 text-gray-400" />
            <span className="text-[15px]">Profile</span>
          </button>
          <button 
            onClick={logout}
            className="flex items-center space-x-3 w-full px-4 py-3 rounded-xl text-red-600 hover:bg-red-50 font-bold transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span className="text-[15px]">Logout</span>
          </button>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 h-screen overflow-hidden">
        
        {/* Top Header */}
        <header className="h-[72px] bg-white border-b border-gray-200 flex items-center justify-between px-4 sm:px-8 z-[100] flex-shrink-0 relative">
          <div className="flex items-center space-x-3">
            <button 
              className="lg:hidden p-2 rounded-xl text-gray-500 hover:bg-gray-100 transition-colors relative"
              onClick={() => setIsMobileMenuOpen(true)}
            >
              <Menu className="w-6 h-6" />
              {totalBadgeCount > 0 && (
                <span className="absolute top-1.5 right-1.5 bg-red-500 text-white text-[9px] font-bold h-4 w-4 rounded-full flex items-center justify-center border border-white">
                  {totalBadgeCount}
                </span>
              )}
            </button>
            <div className="hidden sm:flex items-center text-gray-700 font-bold text-[14px] bg-gray-50 px-4 py-2 rounded-xl border border-gray-200 shadow-sm">
              <Home className="w-4 h-4 mr-2 text-gray-400" />
              {pageName}
            </div>
          </div>
          
          <div className="flex items-center space-x-6">
            <button 
              onClick={toggleTheme}
              className="text-gray-400 hover:text-gray-600 transition-colors p-2 rounded-xl hover:bg-gray-50 focus:outline-none"
            >
              {isDarkMode ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
            </button>
            <div className="relative" ref={dropdownRef}>
              <button 
                onClick={handleBellClick}
                className="relative text-gray-400 hover:text-gray-600 transition-colors p-1.5 rounded-xl hover:bg-gray-50 focus:outline-none"
              >
                <Bell className="w-5 h-5" />
                {hasUnread && (
                  <span className="absolute top-1 right-1 block h-2.5 w-2.5 rounded-full bg-red-500 ring-2 ring-white animate-pulse"></span>
                )}
              </button>
              
              {isNotificationsOpen && (
                <>
                  {/* Mobile backdrop */}
                  <div
                    className="fixed inset-0 z-[98] sm:hidden"
                    onClick={() => setIsNotificationsOpen(false)}
                  />
                  <div className="fixed left-2 right-2 top-[72px] sm:absolute sm:left-auto sm:right-0 sm:top-14 sm:w-80 bg-white rounded-[20px] shadow-[0_4px_20px_rgb(0,0,0,0.15)] border border-gray-100 z-[99] overflow-hidden sm:origin-top-right">
                  <div className="px-3 sm:px-5 py-2.5 sm:py-3 border-b border-gray-50 bg-gray-50/50 flex justify-between items-center gap-1">
                    <h3 className="text-xs sm:text-sm font-bold text-gray-900 truncate">Notifications</h3>
                    <span className="text-[8px] sm:text-[9px] bg-primary-50 text-primary-600 px-1.5 sm:px-2 py-0.5 rounded-full font-bold uppercase tracking-wide whitespace-nowrap flex-shrink-0">
                      Alerts
                    </span>
                  </div>
                  
                  <div className="max-h-[45vh] sm:max-h-[350px] overflow-y-auto">
                    {notifications.length === 0 ? (
                      <div className="p-4 sm:p-6 text-center text-gray-400">
                        <Bell className="w-5 h-5 sm:w-6 sm:h-6 mx-auto mb-2 text-gray-300" />
                        <p className="text-[10px] sm:text-xs font-semibold">No notifications</p>
                      </div>
                    ) : (
                      notifications.map((notif) => {
                        const statusColors = {
                          approved: "bg-emerald-50 text-emerald-700 border-emerald-200",
                          accepted: "bg-emerald-50 text-emerald-700 border-emerald-200",
                          rejected: "bg-rose-50 text-rose-700 border-rose-200",
                          declined: "bg-rose-50 text-rose-700 border-rose-200",
                          pending: "bg-amber-50 text-amber-700 border-amber-200",
                          published: "bg-blue-50 text-blue-700 border-blue-200"
                        };
                        const statusLower = (notif.status || '').toLowerCase();
                        const badgeStyle = Object.keys(statusColors).find(k => statusLower.includes(k)) 
                          ? statusColors[Object.keys(statusColors).find(k => statusLower.includes(k))]
                          : "bg-gray-50 text-gray-700 border-gray-200";
                        
                        return (
                          <div 
                            key={notif.id}
                            onClick={() => {
                              setIsNotificationsOpen(false);
                              if (notif.link) {
                                navigate(notif.link);
                              }
                            }}
                            className={`px-3 sm:px-4 py-2.5 sm:py-3 hover:bg-gray-50 cursor-pointer transition-colors text-left border-b border-gray-50 last:border-b-0 ${!notif.is_read ? 'bg-blue-50/30' : ''}`}
                          >
                            <div className="flex justify-between items-start gap-1 mb-0.5">
                              <span className="font-semibold text-gray-900 text-[10px] sm:text-xs line-clamp-2 flex-1">
                                {!notif.is_read && <span className="inline-block w-2 h-2 rounded-full bg-blue-600 mr-1.5 align-middle"></span>}
                                {notif.title}
                              </span>
                              {notif.status && (
                                <span className={`text-[7px] sm:text-[8px] font-bold uppercase px-1 sm:px-1.5 py-0.5 rounded border ${badgeStyle} shrink-0 whitespace-nowrap`}>
                                  {notif.status}
                                </span>
                              )}
                            </div>
                            <div className="flex justify-between items-center text-[8px] sm:text-[9px] text-gray-400 font-medium gap-1 mt-1">
                              <span className="truncate text-gray-500 font-medium">By: {notif.requester || "System"}</span>
                              <span className="whitespace-nowrap flex-shrink-0 text-gray-400">{notif.date ? new Date(notif.date).toLocaleDateString([], { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }) : ''}</span>
                            </div>
                          </div>
                        );
                      })
                    )}
                  </div>
                </div>
                </>
              )}
            </div>
            
            <div className="relative flex items-center pl-6 border-l border-gray-200" ref={userMenuRef}>
              <button
                onClick={() => setIsUserMenuOpen(prev => {
                  if (!prev) setIsNotificationsOpen(false); // close notifications when opening profile
                  return !prev;
                })}
                className="flex items-center gap-3 cursor-pointer group focus:outline-none"
              >
                <div className="w-10 h-10 rounded-full bg-primary-600 flex items-center justify-center text-white font-bold text-sm shadow-md group-hover:scale-105 transition-transform">
                  {user.email.charAt(0).toUpperCase()}
                </div>
                <div className="hidden sm:block text-left">
                  <p className="text-[14px] font-bold text-gray-900 leading-tight">
                    {user.name || user.email.split('@')[0]}
                  </p>
                  <p className="text-[12px] text-gray-500 font-medium capitalize">{user.role}</p>
                </div>
                <ChevronDown className={`w-4 h-4 text-gray-400 hidden sm:block transition-transform ${isUserMenuOpen ? 'rotate-180' : ''}`} />
              </button>

              {/* Dropdown */}
              {userMenuVisible && (
                <>
                  {/* Mobile backdrop - closes menu when tapping outside */}
                  <div
                    className="fixed inset-0 z-[98] sm:hidden"
                    onClick={() => setIsUserMenuOpen(false)}
                  />
                  <div
                    className={`fixed right-2 top-[72px] w-52 sm:absolute sm:right-0 sm:top-full sm:mt-2 bg-white dark:bg-[#1c1c1e]/90 dark:backdrop-blur-xl rounded-2xl shadow-2xl border border-gray-100 py-2 z-[99] transition-all duration-150 origin-top-right ${
                      isUserMenuOpen ? 'opacity-100 scale-100 translate-y-0' : 'opacity-0 scale-95 -translate-y-1 pointer-events-none'
                    }`}
                  >
                    <div className="px-4 py-2 border-b border-gray-100 mb-1">
                      <p className="text-xs font-bold text-gray-900 truncate">{user.email}</p>
                      <p className="text-xs text-gray-400 capitalize">{user.role}</p>
                    </div>
                    <button
                      onClick={() => { setIsUserMenuOpen(false); navigate(`/${user.role}/profile`); }}
                      className="w-full flex items-center gap-3 px-4 py-2.5 text-sm font-semibold text-gray-700 dark:text-gray-900 hover:bg-gray-50 dark:hover:bg-gray-100/50 transition-colors rounded-xl"
                    >
                      <User className="w-4 h-4 text-gray-400 dark:text-gray-500" /> Profile
                    </button>
                    <button
                      onClick={() => { setIsUserMenuOpen(false); logout(); }}
                      className="w-full flex items-center gap-3 px-4 py-2.5 text-sm font-semibold text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-500/10 transition-colors rounded-xl"
                    >
                      <LogOut className="w-4 h-4" /> Logout
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        </header>

        {/* Scrollable Page Content */}
        <main className={`flex-1 overflow-y-auto p-4 sm:p-8 relative ${isUserMenuOpen ? 'pointer-events-none sm:pointer-events-auto' : ''}`}>
          <div className="max-w-[1200px] mx-auto pb-12">
            <Outlet />
          </div>
        </main>
      </div>

      {/* Floating Messages Widget (desktop only, student + Dean) */}
      <MessagingFloatingWidget user={user} badgeCounts={badgeCounts} />
    </div>
  );
}
