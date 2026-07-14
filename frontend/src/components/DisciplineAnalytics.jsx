import React from 'react';
import { 
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, 
  PieChart, Pie, Cell, LineChart, Line 
} from 'recharts';
import { ShieldAlert, TrendingUp, AlertTriangle } from 'lucide-react';

const COLORS = ['#ef4444', '#f59e0b', '#3b82f6', '#10b981', '#8b5cf6'];

export const DisciplineAnalytics = ({ data }) => {
  if (!data) return null;

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
          <div className="bg-white p-6 rounded-[24px] shadow-sm border border-gray-100 lg:col-span-1">
            <h3 className="text-lg font-bold text-gray-900 mb-6">Incidents by Mentor</h3>
            <div className="h-64 overflow-y-auto pr-2 custom-scrollbar">
              <div className="space-y-3">
                {data.mentor_distribution.map((item, idx) => (
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
    </div>
  );
};
