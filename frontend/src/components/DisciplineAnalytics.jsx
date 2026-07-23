import React, { useState } from 'react';
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, 
  PieChart, Pie, Cell, LineChart, Line 
} from 'recharts';
import { ShieldAlert, TrendingUp, AlertTriangle, X } from 'lucide-react';

const COLORS = ['#ef4444', '#f59e0b', '#3b82f6', '#10b981', '#8b5cf6'];

export const DisciplineAnalytics = ({ data }) => {
  const [isReporterModalOpen, setIsReporterModalOpen] = useState(false);
  const [selectedDepartment, setSelectedDepartment] = useState('All');
  const [isMentorModalOpen, setIsMentorModalOpen] = useState(false);
  const [selectedMentorDepartment, setSelectedMentorDepartment] = useState('All');

  if (!data) return null;

  const departments = data.reporter_distribution 
    ? ['All', ...new Set(data.reporter_distribution.map(item => item.department_name))]
    : ['All'];

  const filteredReporters = data.reporter_distribution
    ? data.reporter_distribution.filter(item => selectedDepartment === 'All' || item.department_name === selectedDepartment)
    : [];

  const mentorDepartments = data.mentor_distribution
    ? ['All', ...new Set(data.mentor_distribution.map(item => item.department_name))]
    : ['All'];

  const filteredMentors = data.mentor_distribution
    ? data.mentor_distribution.filter(item => selectedMentorDepartment === 'All' || item.department_name === selectedMentorDepartment)
    : [];

  return (
    <div className="space-y-6">
      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 flex items-center space-x-4">
          <div className="w-12 h-12 bg-red-50 text-red-600 rounded-2xl flex items-center justify-center">
            <ShieldAlert className="w-6 h-6" />
          </div>
          <div>
            <p className="text-sm font-medium text-gray-500">Total Incidents</p>
            <h3 className="text-2xl font-bold text-gray-900">{data.total_incidents}</h3>
          </div>
        </div>
        
        <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 flex items-center space-x-4">
          <div className="w-12 h-12 bg-amber-50 text-amber-600 rounded-2xl flex items-center justify-center">
            <AlertTriangle className="w-6 h-6" />
          </div>
          <div>
            <p className="text-sm font-medium text-gray-500">Top Violation</p>
            <h3 className="text-lg font-bold text-gray-900 truncate max-w-[150px]" title={data.category_distribution.sort((a,b)=>b.count - a.count)[0]?.category || 'N/A'}>
              {data.category_distribution.sort((a,b)=>b.count - a.count)[0]?.category || 'N/A'}
            </h3>
          </div>
        </div>

        <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 flex items-center space-x-4">
          <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center">
            <TrendingUp className="w-6 h-6" />
          </div>
          <div>
            <p className="text-sm font-medium text-gray-500">Recent Trend (7d)</p>
            <h3 className="text-2xl font-bold text-gray-900">
              {data.recent_trend.reduce((sum, item) => sum + item.count, 0)}
            </h3>
          </div>
        </div>
      </div>

      {/* Charts Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* Department Distribution (Bar) - Only Authority/Admin */}
        {data.department_distribution && (
          <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1">
            <h3 className="text-lg font-bold text-gray-900 mb-6">Department Distribution</h3>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={data.department_distribution} margin={{ top: 5, right: 10, bottom: 5, left: -20 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                  <XAxis dataKey="department" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} />
                  <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} allowDecimals={false} />
                  <Tooltip 
                    cursor={{ fill: '#f9fafb' }}
                    contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                  />
                  <Bar dataKey="count" name="Incidents" fill="#8b5cf6" radius={[4, 4, 0, 0]} barSize={40} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>
        )}

        {/* Student Distribution (List) */}
        {data.student_distribution && (
          <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1">
            <h3 className="text-lg font-bold text-gray-900 mb-6">Top Students by Incidents</h3>
            <div className="h-64 overflow-y-auto pr-2 custom-scrollbar">
              <div className="space-y-3">
                {data.student_distribution.map((item, idx) => (
                  <div key={idx} className="flex items-center justify-between p-3 rounded-xl bg-gray-50/50 border border-gray-100 hover:bg-gray-50 transition-colors">
                    <div className="flex items-center space-x-3">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                        idx === 0 ? 'bg-red-100 text-red-600' : 
                        idx === 1 ? 'bg-orange-100 text-orange-600' : 
                        idx === 2 ? 'bg-amber-100 text-amber-600' : 
                        'bg-gray-100 text-gray-500'
                      }`}>
                        #{idx + 1}
                      </div>
                      <div>
                        <div className="font-semibold text-gray-800 text-sm">{item.student_name}</div>
                        <div className="text-xs text-gray-500">{item.register_number} • {item.mentor}</div>
                      </div>
                    </div>
                    <div className="flex items-baseline space-x-1">
                      <span className="text-lg font-bold text-gray-900">{item.count}</span>
                    </div>
                  </div>
                ))}
                {data.student_distribution.length === 0 && (
                  <div className="text-center text-gray-500 text-sm mt-10">
                    No incidents recorded.
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Mentor Distribution (List) */}
        {data.mentor_distribution && (
          <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1 flex flex-col h-full">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-lg font-bold text-gray-900">Incidents by Mentor</h3>
              {data.mentor_distribution.length > 5 && (
                <button 
                  onClick={() => setIsMentorModalOpen(true)}
                  className="text-sm text-blue-600 font-medium hover:text-blue-700 hover:underline"
                >
                  View All
                </button>
              )}
            </div>
            <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
              <div className="space-y-3">
                {data.mentor_distribution.slice(0, 5).map((item, idx) => (
                  <div key={idx} className="flex items-center justify-between p-3 rounded-xl bg-gray-50/50 border border-gray-100 hover:bg-gray-50 transition-colors">
                    <div className="flex items-center space-x-3">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                        idx === 0 ? 'bg-red-100 text-red-600' : 
                        idx === 1 ? 'bg-orange-100 text-orange-600' : 
                        idx === 2 ? 'bg-amber-100 text-amber-600' : 
                        'bg-gray-100 text-gray-500'
                      }`}>
                        #{idx + 1}
                      </div>
                      <span className="font-semibold text-gray-800 text-sm">{item.mentor}</span>
                    </div>
                    <div className="flex items-baseline space-x-1">
                      <span className="text-lg font-bold text-gray-900">{item.count}</span>
                      <span className="text-[10px] text-gray-500 font-medium uppercase tracking-wider">incidents</span>
                    </div>
                  </div>
                ))}
                {data.mentor_distribution.length === 0 && (
                  <div className="text-center text-gray-500 text-sm mt-10">
                    No incidents recorded.
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Reporter Distribution (List) */}
        {data.reporter_distribution && (
          <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1 flex flex-col h-full">
            <div className="flex justify-between items-center mb-6">
              <h3 className="text-lg font-bold text-gray-900">Incidents by Reporting Staff</h3>
              {data.reporter_distribution.length > 5 && (
                <button 
                  onClick={() => setIsReporterModalOpen(true)}
                  className="text-sm text-blue-600 font-medium hover:text-blue-700 hover:underline"
                >
                  View All
                </button>
              )}
            </div>
            <div className="flex-1 overflow-y-auto pr-2 custom-scrollbar">
              <div className="space-y-3">
                {data.reporter_distribution.slice(0, 5).map((item, idx) => (
                  <div key={idx} className="flex items-center justify-between p-3 rounded-xl bg-gray-50/50 border border-gray-100 hover:bg-gray-50 transition-colors">
                    <div className="flex items-center space-x-3">
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                        idx === 0 ? 'bg-red-100 text-red-600' : 
                        idx === 1 ? 'bg-orange-100 text-orange-600' : 
                        idx === 2 ? 'bg-amber-100 text-amber-600' : 
                        'bg-gray-100 text-gray-500'
                      }`}>
                        #{idx + 1}
                      </div>
                      <span className="font-semibold text-gray-800 text-sm">{item.reporter_name}</span>
                    </div>
                    <div className="flex items-baseline space-x-1">
                      <span className="text-lg font-bold text-gray-900">{item.count}</span>
                      <span className="text-[10px] text-gray-500 font-medium uppercase tracking-wider">reports</span>
                    </div>
                  </div>
                ))}
                {data.reporter_distribution.length === 0 && (
                  <div className="text-center text-gray-500 text-sm mt-10">
                    No reports recorded.
                  </div>
                )}
              </div>
            </div>
          </div>
        )}



        {/* Category Distribution (Pie) */}
        <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Incident Distribution</h3>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={data.category_distribution}
                  cx="50%"
                  cy="50%"
                  innerRadius={60}
                  outerRadius={90}
                  paddingAngle={5}
                  dataKey="count"
                  nameKey="category"
                >
                  {data.category_distribution.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip 
                  contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Recent Trends (Line) */}
        <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1">
          <h3 className="text-lg font-bold text-gray-900 mb-6">Recent Trends (Last 7 Days)</h3>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <LineChart data={data.recent_trend} margin={{ top: 5, right: 20, bottom: 5, left: -20 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f3f4f6" />
                <XAxis dataKey="period" axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} />
                <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: '#6b7280' }} allowDecimals={false} />
                <Tooltip 
                  contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                />
                <Line type="monotone" dataKey="count" name="Incidents" stroke="#ef4444" strokeWidth={3} dot={{ r: 4, fill: '#ef4444', strokeWidth: 2, stroke: '#fff' }} activeDot={{ r: 6 }} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>

      {/* Full Mentor List Modal */}
      {isMentorModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-gray-900/50 backdrop-blur-sm p-4">
          <div className="bg-white rounded-[24px] w-full max-w-4xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
              <div className="flex items-center space-x-4">
                <h2 className="text-xl font-bold text-gray-900">All Mentor Usage</h2>
                <select
                  value={selectedMentorDepartment}
                  onChange={(e) => setSelectedMentorDepartment(e.target.value)}
                  className="bg-white border border-gray-200 text-gray-700 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2 outline-none cursor-pointer"
                >
                  {mentorDepartments.map((dept) => (
                    <option key={dept} value={dept}>{dept}</option>
                  ))}
                </select>
              </div>
              <button 
                onClick={() => setIsMentorModalOpen(false)}
                className="p-2 hover:bg-gray-200 rounded-full transition-colors text-gray-500 hover:text-gray-900"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <div className="p-0 overflow-hidden flex flex-col flex-1 bg-white">
              <div className="overflow-x-auto overflow-y-auto custom-scrollbar h-full max-h-[60vh]">
                <table className="w-full text-left border-collapse min-w-max">
                  <thead className="bg-gray-50/80 sticky top-0 z-10 backdrop-blur-sm border-b border-gray-100">
                    <tr>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Rank</th>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Staff Name</th>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Department</th>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider text-center">Mentee Incidents</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {filteredMentors.map((item, idx) => (
                      <tr key={idx} className={`hover:bg-gray-50 transition-colors ${item.count === 0 ? 'bg-gray-50/30' : 'bg-white'}`}>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                            idx === 0 ? 'bg-red-100 text-red-600' : 
                            idx === 1 ? 'bg-orange-100 text-orange-600' : 
                            idx === 2 ? 'bg-amber-100 text-amber-600' : 
                            item.count === 0 ? 'bg-gray-100 text-gray-400' :
                            'bg-blue-50 text-blue-600'
                          }`}>
                            #{idx + 1}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`font-semibold text-sm ${item.count === 0 ? 'text-gray-500' : 'text-gray-900'}`}>
                            {item.mentor}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                            {item.department_name}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-center">
                          <span className={`text-lg font-bold ${item.count === 0 ? 'text-gray-400' : 'text-gray-900'}`}>
                            {item.count}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
            
            <div className="px-6 py-4 border-t border-gray-100 bg-gray-50/50 flex justify-end">
              <button
                onClick={() => setIsMentorModalOpen(false)}
                className="px-6 py-2 bg-white border border-gray-200 text-gray-700 font-medium rounded-xl hover:bg-gray-50 transition-colors shadow-sm"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Full Reporter List Modal */}
      {isReporterModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-gray-900/50 backdrop-blur-sm p-4">
          <div className="bg-white rounded-[24px] w-full max-w-4xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
              <div className="flex items-center space-x-4">
                <h2 className="text-xl font-bold text-gray-900">All Reporting Staff Usage</h2>
                <select
                  value={selectedDepartment}
                  onChange={(e) => setSelectedDepartment(e.target.value)}
                  className="bg-white border border-gray-200 text-gray-700 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2 outline-none cursor-pointer"
                >
                  {departments.map((dept) => (
                    <option key={dept} value={dept}>{dept}</option>
                  ))}
                </select>
              </div>
              <button 
                onClick={() => setIsReporterModalOpen(false)}
                className="p-2 hover:bg-gray-200 rounded-full transition-colors text-gray-500 hover:text-gray-900"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <div className="p-0 overflow-hidden flex flex-col flex-1 bg-white">
              <div className="overflow-x-auto overflow-y-auto custom-scrollbar h-full max-h-[60vh]">
                <table className="w-full text-left border-collapse min-w-max">
                  <thead className="bg-gray-50/80 sticky top-0 z-10 backdrop-blur-sm border-b border-gray-100">
                    <tr>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Rank</th>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Staff Name</th>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Department</th>
                      <th className="px-6 py-4 text-xs font-semibold text-gray-500 uppercase tracking-wider text-center">Total Reports</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {filteredReporters.map((item, idx) => (
                      <tr key={idx} className={`hover:bg-gray-50 transition-colors ${item.count === 0 ? 'bg-gray-50/30' : 'bg-white'}`}>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                            idx === 0 ? 'bg-red-100 text-red-600' : 
                            idx === 1 ? 'bg-orange-100 text-orange-600' : 
                            idx === 2 ? 'bg-amber-100 text-amber-600' : 
                            item.count === 0 ? 'bg-gray-100 text-gray-400' :
                            'bg-blue-50 text-blue-600'
                          }`}>
                            #{idx + 1}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`font-semibold text-sm ${item.count === 0 ? 'text-gray-500' : 'text-gray-900'}`}>
                            {item.reporter_name}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                            {item.department_name}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-center">
                          <span className={`text-lg font-bold ${item.count === 0 ? 'text-gray-400' : 'text-gray-900'}`}>
                            {item.count}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
            
            <div className="px-6 py-4 border-t border-gray-100 bg-gray-50/50 flex justify-end">
              <button
                onClick={() => setIsReporterModalOpen(false)}
                className="px-6 py-2 bg-white border border-gray-200 text-gray-700 font-medium rounded-xl hover:bg-gray-50 transition-colors shadow-sm"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
