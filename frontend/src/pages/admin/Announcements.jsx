import { useState, useEffect } from 'react';
import api from '../../api/axios';
import { format } from 'date-fns';
import { cn } from '../../utils/cn';

export default function Announcements() {
  const [announcements, setAnnouncements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [categoryFilter, setCategoryFilter] = useState('All');

  useEffect(() => {
    const fetchAnnouncements = async () => {
      try {
        const res = await api.get('/admin/announcements/');
        setAnnouncements(res.data);
      } catch (err) {
        console.warn("Backend unavailable, using mock announcements");
        setAnnouncements([
          { id: 1, title: 'CR meeting', content: 'In 201', category: 'urgent', target_audience: 'student', created_at: new Date().toISOString(), created_by_name: 'Dr. John Smith' },
          { id: 2, title: 'Mid-Semester Exams Schedule', content: 'Mid-semester exams will be held from next week. Check your timetable.', category: 'urgent', target_audience: 'student', created_at: new Date().toISOString(), created_by_name: 'Admin User' },
          { id: 3, title: 'Library Extended Hours', content: 'Library will remain open until 10 PM during exam season.', category: 'general', target_audience: 'all', created_at: new Date().toISOString(), created_by_name: 'Admin User' },
          { id: 4, title: 'Scholarship Announcement', content: 'Merit-based scholarships are available. Apply by the deadline.', category: 'academic', target_audience: 'student', created_at: new Date().toISOString(), created_by_name: 'Admin User' },
          { id: 5, title: 'New Lab Equipment', content: 'New lab equipment has been installed in Lab 3.', category: 'event', target_audience: 'all', created_at: new Date().toISOString(), created_by_name: 'Admin User' },
          { id: 6, title: 'Semester Registration Open', content: 'Registration for next semester is now open. Register before the deadline.', category: 'academic', target_audience: 'all', created_at: new Date().toISOString(), created_by_name: 'Admin User' },
        ]);
      } finally {
        setLoading(false);
      }
    };
    fetchAnnouncements();
  }, []);

  const getCategoryStyle = (category) => {
    switch(category.toLowerCase()) {
      case 'urgent': return 'tag-urgent';
      case 'general': return 'tag-general';
      case 'academic': return 'tag-academic';
      default: return 'bg-slate-100 text-slate-600';
    }
  };

  const filteredAnnouncements = categoryFilter === 'All' 
    ? announcements 
    : announcements.filter(a => a.category.toLowerCase() === categoryFilter.toLowerCase());

  const urgentCount = announcements.filter(a => a.category.toLowerCase() === 'urgent').length;

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex flex-col gap-1">
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Announcements</h1>
        <p className="text-sm font-medium text-slate-500">
          {announcements.length} posts • {urgentCount} urgent
        </p>
      </div>

      <div className="flex items-center gap-3">
        <span className="text-sm font-bold text-slate-900">Category</span>
        <select 
          className="border border-slate-200 rounded-lg px-3 py-1.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500"
          value={categoryFilter}
          onChange={(e) => setCategoryFilter(e.target.value)}
        >
          <option value="All">All</option>
          <option value="general">General</option>
          <option value="urgent">Urgent</option>
          <option value="academic">Academic</option>
          <option value="event">Event</option>
        </select>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 animate-pulse">
          {[1,2,3,4,5,6].map(i => (
            <div key={i} className="glass-card rounded-xl p-6 h-48"></div>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredAnnouncements.map((post) => (
            <div key={post.id} className="glass-card rounded-xl p-6 hover:-translate-y-1 transition-transform cursor-pointer flex flex-col h-full">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-2">
                  <span className={cn("text-[10px] font-bold uppercase tracking-wider px-2 py-1 rounded-full", getCategoryStyle(post.category))}>
                    {post.category}
                  </span>
                  <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-1 rounded-full bg-slate-100 text-slate-600">
                    {post.target_audience}
                  </span>
                </div>
                <span className="text-xs font-medium text-slate-400">
                  {format(new Date(post.created_at), 'dd/MM/yyyy, HH:mm:ss')}
                </span>
              </div>
              
              <h3 className="text-lg font-bold text-slate-900 mb-2 leading-tight">{post.title}</h3>
              <p className="text-sm text-slate-600 line-clamp-3 mb-6 flex-1">
                {post.content}
              </p>
              
              <div className="text-xs font-medium text-slate-500 pt-4 border-t border-slate-100 mt-auto">
                Posted by: {post.created_by_name}
              </div>
            </div>
          ))}
          
          {filteredAnnouncements.length === 0 && (
             <div className="col-span-full py-12 text-center text-slate-500">
               No announcements found for this category.
             </div>
          )}
        </div>
      )}
    </div>
  );
}
