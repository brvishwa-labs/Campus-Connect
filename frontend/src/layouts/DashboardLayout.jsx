import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import { useAuth } from '../context/AuthContext';
import { Search, Bell, Moon } from 'lucide-react';

export default function DashboardLayout() {
  const { user } = useAuth();

  return (
    <div className="min-h-screen bg-slate-50">
      <Sidebar />
      
      <div className="ml-64 flex flex-col min-h-screen">
        <header className="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 sticky top-0 z-10">
          <div className="flex items-center gap-4 flex-1">
            <div className="relative w-96">
              <Search className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
              <input 
                type="text" 
                placeholder="Search pages, courses..." 
                className="w-full pl-10 pr-4 py-2.5 bg-slate-100 border-transparent rounded-lg text-sm focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
              />
            </div>
          </div>
          
          <div className="flex items-center gap-6">
            <button className="text-slate-500 hover:text-slate-700 transition-colors">
              <Moon className="w-5 h-5" />
            </button>
            <div className="relative">
              <button className="text-slate-500 hover:text-slate-700 transition-colors">
                <Bell className="w-5 h-5" />
              </button>
              <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full"></span>
            </div>
            
            <div className="flex items-center gap-3 border-l border-slate-200 pl-6">
              <div className="w-10 h-10 rounded-lg bg-indigo-600 text-white flex items-center justify-center font-bold">
                {user?.full_name?.charAt(0) || 'A'}
              </div>
              <div className="flex flex-col">
                <span className="text-sm font-semibold text-slate-900">{user?.full_name || 'Admin User'}</span>
                <span className="text-xs text-slate-500 capitalize">{user?.role}</span>
              </div>
            </div>
          </div>
        </header>

        <main className="flex-1 p-8">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
