import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import { Calendar, Users, ArrowRight, Loader2, Info } from 'lucide-react';

export const AlteredClassAdvisor = () => {
  const [duties, setDuties] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDuties();
  }, []);

  const fetchDuties = async () => {
    try {
      setLoading(true);
      const res = await axios.get('/api/leave/altered-class-advisor-duties');
      setDuties(res.data);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900 tracking-tight">Altered Class Advisor Duties</h1>
        <p className="text-sm text-gray-500 mt-1">Manage temporary class advisor responsibilities assigned to you today.</p>
      </div>

      {loading ? (
        <div className="flex justify-center p-12">
          <Loader2 className="w-8 h-8 animate-spin text-primary-600" />
        </div>
      ) : duties.length === 0 ? (
        <div className="text-center py-16 bg-white rounded-2xl border border-gray-200">
          <Calendar className="w-10 h-10 text-gray-300 mx-auto mb-3" />
          <p className="text-gray-500 font-medium">No temporary class advisor duties for today.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {duties.map(duty => (
            <div key={duty.arrangement_id} className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 hover:shadow-md transition-shadow group flex flex-col">
              <div className="flex items-start justify-between mb-4">
                <div className="w-10 h-10 rounded-lg bg-purple-50 flex items-center justify-center border border-purple-100">
                  <Users className="w-5 h-5 text-purple-600" />
                </div>
                <span className="bg-purple-100 text-purple-700 px-2.5 py-0.5 rounded-full text-xs font-bold uppercase tracking-wider">
                  Substitute
                </span>
              </div>
              
              <h3 className="font-bold text-gray-900 mb-1">{duty.class_section}</h3>
              <p className="text-xs text-gray-500 mb-6 flex-grow">
                Acting as Class Advisor for today.
              </p>
              
              <Link 
                to={`/faculty/class-advisor/attendance?section_id=${duty.section_id}`}
                className="flex items-center justify-between pt-4 border-t border-gray-100 text-sm font-semibold text-primary-600 group-hover:text-primary-700 transition-colors"
              >
                <span>Take Attendance</span>
                <ArrowRight className="w-4 h-4 transform group-hover:translate-x-1 transition-transform" />
              </Link>
            </div>
          ))}
        </div>
      )}

      <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 flex items-start gap-3 mt-8">
        <Info className="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" />
        <div className="text-sm text-blue-800">
          <p className="font-bold mb-1">How this works</p>
          <p>You have been assigned as a substitute class advisor due to the absence of the primary advisor. This access is granted only for the duration of their approved leave. You can mark attendance for their section during this period.</p>
        </div>
      </div>
    </div>
  );
};
