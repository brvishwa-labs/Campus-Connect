import { NavLink } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { 
  LayoutDashboard, 
  Megaphone, 
  BookOpen, 
  Users, 
  GraduationCap, 
  Building2, 
  ShieldCheck, 
  ClipboardList, 
  LogOut,
  UserCheck
} from 'lucide-react';
import { cn } from '../utils/cn';

const adminLinks = [
  { name: 'Dashboard', path: '/admin/dashboard', icon: LayoutDashboard },
  { name: 'Announcements', path: '/admin/announcements', icon: Megaphone },
  { name: 'Departments', path: '/admin/departments', icon: Building2 },
  { name: 'Faculty', path: '/admin/faculty', icon: Users },
  { name: 'Students', path: '/admin/students', icon: GraduationCap },
  { name: 'Courses', path: '/admin/courses', icon: BookOpen },
  { name: 'HODs', path: '/admin/hods', icon: UserCheck },
  { name: 'High Authorities', path: '/admin/authorities', icon: ShieldCheck },
  { name: 'Roles', path: '/admin/roles', icon: ShieldCheck },
  { name: 'Discipline', path: '/admin/discipline', icon: ClipboardList },
  { name: 'Audit Logs', path: '/admin/audit', icon: ClipboardList },
];

export default function Sidebar() {
  const { user, logout } = useAuth();
  
  // We determine links based on user role. For Phase 1, we focus on admin.
  const links = user?.role === 'admin' ? adminLinks : [];

  return (
    <aside className="w-64 bg-white border-r border-slate-200 h-screen flex flex-col fixed left-0 top-0">
      <div className="p-6">
        <div className="flex items-center gap-2 mb-1">
          <div className="w-8 h-8 rounded bg-indigo-600 flex items-center justify-center text-white font-bold text-xl">
            C
          </div>
          <span className="text-2xl font-bold text-slate-900 tracking-tight">Campus Connect</span>
        </div>
        <div className="text-xs font-semibold text-slate-500 uppercase tracking-wider pl-10 mt-1">
          {user?.role === 'admin' ? 'ADMIN PORTAL' : 'PORTAL'}
        </div>
      </div>

      <div className="flex-1 overflow-y-auto py-4 px-3 space-y-1">
        {links.map((link) => (
          <NavLink
            key={link.name}
            to={link.path}
            className={({ isActive }) =>
              cn(
                "flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-all relative overflow-hidden",
                isActive 
                  ? "bg-blue-50 text-blue-600" 
                  : "text-slate-600 hover:bg-slate-50 hover:text-slate-900"
              )
            }
          >
            {({ isActive }) => (
              <>
                {isActive && (
                  <div className="absolute left-0 top-0 bottom-0 w-1 bg-blue-600 rounded-r-md"></div>
                )}
                <link.icon className={cn("w-5 h-5", isActive ? "text-blue-600" : "text-slate-400")} />
                {link.name}
              </>
            )}
          </NavLink>
        ))}
      </div>

      <div className="p-4 border-t border-slate-200">
        <button
          onClick={logout}
          className="flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium text-red-600 hover:bg-red-50 w-full transition-all"
        >
          <LogOut className="w-5 h-5" />
          Logout
        </button>
      </div>
    </aside>
  );
}
