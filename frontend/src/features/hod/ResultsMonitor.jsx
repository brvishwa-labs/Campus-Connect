import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Target, TrendingUp, ChevronRight, ArrowLeft, Users, Trophy, AlertTriangle, BookOpen } from 'lucide-react';
import {
  PieChart, Pie, Cell, Tooltip as RechartsTooltip, ResponsiveContainer,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Legend
} from 'recharts';

export const ResultsMonitor = () => {
  const [data, setData] = useState({});
  const [loading, setLoading] = useState(true);
  const [selectedYear, setSelectedYear] = useState(null);
  const [selectedSubject, setSelectedSubject] = useState(null);
  const [detailedResults, setDetailedResults] = useState(null);
  const [selectedExamKey, setSelectedExamKey] = useState(null);
  const [loadingDetails, setLoadingDetails] = useState(false);

  useEffect(() => {
    const fetchResults = async () => {
      try {
        const res = await axios.get('/api/hod/results-summary');
        setData(res.data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchResults();
  }, []);

  useEffect(() => {
    if (selectedSubject) {
      const fetchDetailedResults = async () => {
        setLoadingDetails(true);
        try {
          const res = await axios.get(`/api/hod/course-results/${selectedSubject.course_id}`);
          setDetailedResults(res.data);
          if (res.data.exams && res.data.exams.length > 0) {
            // Default to the last exam in the array (usually the latest)
            setSelectedExamKey(res.data.exams[res.data.exams.length - 1].exam_key);
          }
        } catch (err) {
          console.error(err);
        } finally {
          setLoadingDetails(false);
        }
      };
      fetchDetailedResults();
    } else {
      setDetailedResults(null);
      setSelectedExamKey(null);
    }
  }, [selectedSubject]);

  const years = Object.keys(data);
  const COLORS = ['#10b981', '#f43f5e', '#64748b']; // Pass, Fail, Absent

  if (loading) {
    return <div className="text-center text-gray-500 p-8">Loading...</div>;
  }

  // --- View 3: Advanced Subject Dashboard ---
  if (selectedSubject) {
    if (loadingDetails || !detailedResults) {
      return <div className="text-center text-gray-500 p-8">Loading detailed analytics...</div>;
    }

    const currentExam = detailedResults.exams.find(e => e.exam_key === selectedExamKey) || detailedResults.exams[0];

    if (!currentExam) {
      return (
        <div className="text-center py-12 bg-gray-50/50 rounded-[20px] border border-gray-100 border-dashed max-w-6xl mx-auto mt-10">
          <button 
            onClick={() => setSelectedSubject(null)}
            className="flex items-center text-gray-500 hover:text-gray-900 transition-colors bg-white px-4 py-2 rounded-xl border border-gray-100 shadow-sm mx-auto mb-6"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Back to {selectedYear} Subjects
          </button>
          <AlertTriangle className="w-8 h-8 text-amber-400 mx-auto mb-3" />
          <h3 className="text-lg font-bold text-gray-900">No Exams Found</h3>
          <p className="text-sm text-gray-500 mt-1">No exam grades have been recorded for this subject yet.</p>
        </div>
      );
    }

    const analytics = currentExam.analytics;

    const passFailData = [
      { name: 'Passed', value: analytics.passed || 0 },
      { name: 'Failed', value: analytics.failed || 0 },
      { name: 'Absent', value: analytics.absent || 0 }
    ];

    return (
      <div className="space-y-6 max-w-6xl mx-auto pb-10 animate-in fade-in zoom-in-95 duration-300">
        <button 
          onClick={() => setSelectedSubject(null)}
          className="flex items-center text-gray-500 hover:text-gray-900 transition-colors bg-white px-4 py-2 rounded-xl border border-gray-100 shadow-sm"
        >
          <ArrowLeft className="w-4 h-4 mr-2" />
          Back to {selectedYear} Subjects
        </button>

        <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8">
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
            <div>
              <div className="inline-flex items-center space-x-2 bg-indigo-50 text-indigo-700 px-3 py-1 rounded-full text-xs font-bold mb-3">
                <BookOpen className="w-3.5 h-3.5" />
                <span>{detailedResults.course_code}</span>
              </div>
              <h2 className="text-3xl font-black text-gray-900 tracking-tight">{detailedResults.course_name}</h2>
              <p className="text-gray-500 font-medium mt-1">Subject Performance Analytics</p>
            </div>
            
            {/* Exam Dropdown Filter */}
            <div className="flex items-center space-x-3 bg-gray-50 p-2 rounded-xl border border-gray-200">
              <span className="text-sm font-bold text-gray-600 pl-2">Select Exam:</span>
              <select 
                value={selectedExamKey}
                onChange={(e) => setSelectedExamKey(e.target.value)}
                className="bg-white border border-gray-200 text-gray-900 text-sm rounded-lg focus:ring-indigo-500 focus:border-indigo-500 block w-40 p-2.5 font-bold shadow-sm"
              >
                {detailedResults.exams.map(exam => (
                  <option key={exam.exam_key} value={exam.exam_key}>
                    {exam.exam_name}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
            <div className="bg-emerald-50/50 border border-emerald-100 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center text-emerald-600">
                  <TrendingUp className="w-5 h-5" />
                </div>
                <span className="text-3xl font-black text-emerald-600">{analytics.pass_percentage}%</span>
              </div>
              <p className="text-sm font-bold text-gray-900">Pass Percentage</p>
              <p className="text-xs text-gray-500 mt-1">{analytics.passed} out of {analytics.total_students} passed</p>
            </div>

            <div className="bg-blue-50/50 border border-blue-100 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center text-blue-600">
                  <Trophy className="w-5 h-5" />
                </div>
                <span className="text-3xl font-black text-blue-600">{analytics.highest_score}</span>
              </div>
              <p className="text-sm font-bold text-gray-900">Highest Score</p>
              <p className="text-xs text-gray-500 mt-1">Average score is {analytics.average_score}</p>
            </div>

            <div className="bg-amber-50/50 border border-amber-100 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="w-10 h-10 bg-amber-100 rounded-xl flex items-center justify-center text-amber-600">
                  <Users className="w-5 h-5" />
                </div>
                <span className="text-3xl font-black text-amber-600">{analytics.total_students}</span>
              </div>
              <p className="text-sm font-bold text-gray-900">Total Graded</p>
              <p className="text-xs text-gray-500 mt-1">{analytics.absent} students absent</p>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-10">
            <div className="lg:col-span-1 border border-gray-100 rounded-2xl p-6 bg-gray-50/30">
              <h3 className="text-sm font-bold text-gray-900 mb-6">Outcome Breakdown</h3>
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={passFailData}
                      cx="50%"
                      cy="50%"
                      innerRadius={60}
                      outerRadius={80}
                      paddingAngle={5}
                      dataKey="value"
                    >
                      {passFailData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                      ))}
                    </Pie>
                    <RechartsTooltip />
                    <Legend verticalAlign="bottom" height={36}/>
                  </PieChart>
                </ResponsiveContainer>
              </div>
            </div>

            <div className="lg:col-span-2 border border-gray-100 rounded-2xl p-6 bg-gray-50/30">
              <h3 className="text-sm font-bold text-gray-900 mb-6">Grade Distribution</h3>
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={analytics.distribution || []}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0"/>
                    <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fontSize: 12, fill: '#64748b'}} />
                    <YAxis axisLine={false} tickLine={false} tick={{fontSize: 12, fill: '#64748b'}} />
                    <RechartsTooltip 
                      cursor={{fill: '#f1f5f9'}}
                      contentStyle={{borderRadius: '12px', border: 'none', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)'}}
                    />
                    <Bar dataKey="count" fill="#6366f1" radius={[4, 4, 0, 0]} maxBarSize={50}>
                      {
                        (analytics.distribution || []).map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.name === '<50% (Fail)' ? '#f43f5e' : '#6366f1'} />
                        ))
                      }
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>
          </div>
          
          {/* Detailed Student Marks List */}
          <div className="mt-8">
            <h3 className="text-xl font-bold text-gray-900 mb-6 border-b border-gray-100 pb-4">Detailed Student Marks</h3>
            <div className="overflow-x-auto rounded-xl border border-gray-200">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                      S.No
                    </th>
                    <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                      Student Name
                    </th>
                    <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                      Reg. Number
                    </th>
                    <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                      Marks Obtained
                    </th>
                    <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {currentExam.students.map((student, idx) => (
                    <tr key={student.id} className="hover:bg-gray-50/50 transition-colors">
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {idx + 1}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-bold text-gray-900">{student.name}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-medium">
                        {student.register_number}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-black text-gray-900">
                          {student.marks_obtained !== null ? (
                            <span>{student.marks_obtained} <span className="text-gray-400 font-medium">/ {student.max_marks}</span></span>
                          ) : (
                            <span className="text-gray-400 font-medium">N/A</span>
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        {student.status === 'Pass' && (
                          <span className="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-emerald-100 text-emerald-800">
                            Pass
                          </span>
                        )}
                        {student.status === 'Fail' && (
                          <span className="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-rose-100 text-rose-800">
                            Fail
                          </span>
                        )}
                        {student.status === 'Absent' && (
                          <span className="px-3 py-1 inline-flex text-xs leading-5 font-bold rounded-full bg-gray-100 text-gray-600">
                            Absent
                          </span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
          
        </div>
      </div>
    );
  }

  // --- View 2: Subjects for a Year ---
  if (selectedYear) {
    const subjects = data[selectedYear] || [];
    return (
      <div className="space-y-6 max-w-5xl mx-auto pb-10 animate-in fade-in zoom-in-95 duration-300">
        <div className="flex items-center justify-between">
          <button 
            onClick={() => setSelectedYear(null)}
            className="flex items-center text-gray-500 hover:text-gray-900 transition-colors bg-white px-4 py-2 rounded-xl border border-gray-100 shadow-sm"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Back to Years
          </button>
        </div>
        
        <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-8">
          <div className="mb-8">
            <h2 className="text-2xl font-black text-gray-900">{selectedYear} Subjects</h2>
            <p className="text-sm text-gray-500 font-medium mt-1">Select a subject to view detailed analytics</p>
          </div>

          {subjects.length > 0 ? (
            <div className="space-y-10">
              {/* Theory Section */}
              {subjects.filter(s => s.course_type === 'theory' || s.course_type === 'elective').length > 0 && (
                <div>
                  <h3 className="text-lg font-bold text-gray-900 mb-4 border-b border-gray-100 pb-2">Theory Subjects</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {subjects.filter(s => s.course_type === 'theory' || s.course_type === 'elective').map((item, idx) => (
                      <div 
                        key={idx} 
                        onClick={() => setSelectedSubject(item)}
                        className="p-5 rounded-[20px] border border-gray-100 bg-gray-50/50 hover:bg-white hover:shadow-lg hover:border-indigo-100 transition-all duration-300 cursor-pointer group flex flex-col justify-between"
                      >
                        <div className="mb-4">
                          <span className="text-xs font-bold text-indigo-600 bg-indigo-50 px-2.5 py-1 rounded-md mb-2 inline-block">
                            {item.course_code}
                          </span>
                          <h4 className="font-bold text-gray-900 group-hover:text-indigo-600 transition-colors line-clamp-2">
                            {item.course_name}
                          </h4>
                        </div>
                        
                        <div className="flex items-center justify-between pt-4 border-t border-gray-100/80">
                          <div>
                            <p className="text-[10px] uppercase font-bold text-gray-400 tracking-wider">Pass Rate</p>
                            <p className="text-lg font-black text-emerald-600">{item.pass_percentage}%</p>
                          </div>
                          <div className="w-8 h-8 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <ChevronRight className="w-4 h-4" />
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Lab Section */}
              {subjects.filter(s => s.course_type === 'lab' || s.course_type === 'project').length > 0 && (
                <div>
                  <h3 className="text-lg font-bold text-gray-900 mb-4 border-b border-gray-100 pb-2">Practical / Lab Subjects</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {subjects.filter(s => s.course_type === 'lab' || s.course_type === 'project').map((item, idx) => (
                      <div 
                        key={idx} 
                        onClick={() => setSelectedSubject(item)}
                        className="p-5 rounded-[20px] border border-gray-100 bg-gray-50/50 hover:bg-white hover:shadow-lg hover:border-fuchsia-100 transition-all duration-300 cursor-pointer group flex flex-col justify-between"
                      >
                        <div className="mb-4">
                          <span className="text-xs font-bold text-fuchsia-600 bg-fuchsia-50 px-2.5 py-1 rounded-md mb-2 inline-block">
                            {item.course_code}
                          </span>
                          <h4 className="font-bold text-gray-900 group-hover:text-fuchsia-600 transition-colors line-clamp-2">
                            {item.course_name}
                          </h4>
                        </div>
                        
                        <div className="flex items-center justify-between pt-4 border-t border-gray-100/80">
                          <div>
                            <p className="text-[10px] uppercase font-bold text-gray-400 tracking-wider">Pass Rate</p>
                            <p className="text-lg font-black text-emerald-600">{item.pass_percentage}%</p>
                          </div>
                          <div className="w-8 h-8 rounded-full bg-fuchsia-50 text-fuchsia-600 flex items-center justify-center group-hover:scale-110 transition-transform">
                            <ChevronRight className="w-4 h-4" />
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          ) : (
            <div className="text-center py-12 bg-gray-50/50 rounded-[20px] border border-gray-100 border-dashed">
              <AlertTriangle className="w-8 h-8 text-amber-400 mx-auto mb-3" />
              <h3 className="text-lg font-bold text-gray-900">No Subjects Found</h3>
              <p className="text-sm text-gray-500 mt-1">There are no active subjects graded for {selectedYear}.</p>
            </div>
          )}
        </div>
      </div>
    );
  }

  // --- View 1: Year Selection ---
  return (
    <div className="space-y-6 max-w-5xl mx-auto pb-10">
      <div className="flex items-center space-x-4 bg-white p-6 rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100">
        <div className="w-14 h-14 bg-gradient-to-br from-indigo-500 to-fuchsia-500 rounded-2xl flex items-center justify-center shadow-lg shadow-indigo-200">
          <Target className="w-7 h-7 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-black text-gray-900 tracking-tight">Results Monitoring</h1>
          <p className="text-sm text-gray-500 font-medium">Select an academic year to analyze performance</p>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
        {years.map((year, idx) => {
          const courseCount = (data[year] || []).length;
          return (
            <div 
              key={idx}
              onClick={() => setSelectedYear(year)}
              className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 p-6 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 cursor-pointer group"
            >
              <div className="flex items-start justify-between mb-6">
                <div className="w-12 h-12 rounded-2xl bg-slate-50 border border-slate-100 flex items-center justify-center group-hover:bg-indigo-50 group-hover:border-indigo-100 transition-colors">
                  <span className="text-lg font-black text-slate-400 group-hover:text-indigo-600">
                    {year.split(' ')[0]}
                  </span>
                </div>
                <div className="w-8 h-8 rounded-full bg-slate-50 flex items-center justify-center text-slate-400 group-hover:bg-indigo-600 group-hover:text-white transition-all">
                  <ChevronRight className="w-4 h-4" />
                </div>
              </div>
              
              <h2 className="text-2xl font-black text-gray-900 mb-1">{year}</h2>
              <p className="text-sm font-medium text-gray-500">
                {courseCount} active {courseCount === 1 ? 'subject' : 'subjects'}
              </p>
            </div>
          )
        })}
      </div>
    </div>
  );
};
