import React, { useState, useEffect, useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import { Printer, ArrowLeft, Loader2, AlertTriangle, BookOpen, Save, CheckCircle } from 'lucide-react';

const parseJSON = (raw) => {
  if (!raw) return {};
  if (typeof raw === 'object') return raw;
  try { return JSON.parse(raw); } catch { return {}; }
};

const SectionHeader = ({ title }) => (
  <div className="border-b-2 border-slate-800 pb-2 mb-4 mt-8 break-inside-avoid print:mt-6">
    <h2 className="text-sm font-bold text-slate-800 uppercase tracking-wider">{title}</h2>
  </div>
);

export const LMSLogbookReport = () => {
  const { assignmentId } = useParams();
  
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [savingKLevels, setSavingKLevels] = useState(false);
  const [saveSuccess, setSaveSuccess] = useState(false);

  // Data states
  const [courseAssignment, setCourseAssignment] = useState(null);
  const [department, setDepartment] = useState(null);
  const [programOutcomes, setProgramOutcomes] = useState(null);
  const [coursePlan, setCoursePlan] = useState([]);
  const [attendance, setAttendance] = useState([]);
  const [seminars, setSeminars] = useState([]);
  
  // Assignment states
  const [assignmentMeta, setAssignmentMeta] = useState([]); // List of assignments
  const [assignmentGrades, setAssignmentGrades] = useState({}); // student_id -> { assignment_id -> grade }
  
  // Gradebook states
  const [gradebook, setGradebook] = useState([]); // Array of students with cia1, cia2, model, and retests
  const [editableKLevels, setEditableKLevels] = useState({});

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      // 1. Fetch assignment course
      const coursesRes = await axios.get('/api/faculty/me/courses');
      const foundCourse = coursesRes.data.find(c => c.id.toString() === assignmentId);
      if (!foundCourse) throw new Error("Course Assignment not found.");
      setCourseAssignment(foundCourse);
      
      const deptId = foundCourse.course?.department_id;

      // 2. Fetch parallel base data
      const [deptRes, planRes, attRes, semRes, resRes, poRes] = await Promise.all([
        axios.get('/api/departments/'),
        axios.get(`/api/course-plan/${assignmentId}`).catch(() => ({ data: { topics: [] } })),
        axios.get(`/api/faculty/courses/${assignmentId}/attendance-history`).catch(() => ({ data: { history: [] } })),
        axios.get(`/api/faculty/courses/${assignmentId}/seminars`).catch(() => ({ data: { roster: [] } })),
        axios.get(`/api/faculty/courses/${assignmentId}/resources`).catch(() => ({ data: [] })),
        axios.get('/api/departments/program-outcomes').catch(() => ({ data: null }))
      ]);

      const deptObj = deptRes.data.find(d => d.id === deptId) || null;
      setDepartment(deptObj);
      setCoursePlan(planRes.data?.topics || []);
      setAttendance(attRes.data?.history || []);
      setSeminars(semRes.data?.roster || []);
      setProgramOutcomes(poRes.data || null);
      setEditableKLevels(parseJSON(foundCourse.course?.co_k_levels) || {});

      // 3. Process Assignments
      const allResources = resRes.data || [];
      const assignments = allResources.filter(r => r.resource_type === 'assignment').slice(0, 5); // Max 5 assignments
      setAssignmentMeta(assignments);
      
      const assignmentGradesMap = {}; // student_id -> { resource_id: grade }
      if (assignments.length > 0) {
        const gradePromises = assignments.map(a => 
          axios.get(`/api/faculty/courses/${assignmentId}/assignments/${a.id}/grades`).catch(() => ({ data: { roster: [] } }))
        );
        const gradesResults = await Promise.all(gradePromises);
        
        assignments.forEach((a, index) => {
          const roster = gradesResults[index].data?.roster || [];
          roster.forEach(g => {
            if (!assignmentGradesMap[g.student_id]) assignmentGradesMap[g.student_id] = {};
            assignmentGradesMap[g.student_id][a.id] = g.marks_obtained;
          });
        });
      }
      setAssignmentGrades(assignmentGradesMap);

      // 4. Process Gradebook (CIA-1, CIA-2, Model Exam + Retests)
      const assessmentTypes = ['internal_1', 'internal_2', 'model_exam'];
      const gbPromises = assessmentTypes.map(type => 
        axios.get(`/api/faculty/courses/${assignmentId}/gradebook`, { params: { grade_type: type } }).catch(() => ({ data: { roster: [] } }))
      );
      const retestPromises = assessmentTypes.map(type => 
        axios.get(`/api/retest/courses/${assignmentId}/eligible`, { params: { grade_type: type } }).catch(() => ({ data: { eligible_students: [] } }))
      );
      
      const [gbResults, rtResults] = await Promise.all([
        Promise.all(gbPromises),
        Promise.all(retestPromises)
      ]);

      const studentsMap = {};
      
      assessmentTypes.forEach((type, index) => {
        const roster = gbResults[index].data?.roster || [];
        const retestList = rtResults[index].data?.eligible_students || [];
        
        roster.forEach(r => {
          if (!studentsMap[r.student_id]) {
            studentsMap[r.student_id] = { 
              student_id: r.student_id, 
              register_number: r.register_number, 
              name: `${r.first_name} ${r.last_name}` 
            };
          }
          const keyMap = {
            'internal_1': 'cia_1',
            'internal_2': 'cia_2',
            'model_exam': 'model_exam'
          };
          const mappedKey = keyMap[type] || type;
          studentsMap[r.student_id][mappedKey] = r.is_absent ? 'AAA' : r.marks_obtained;
        });

        retestList.forEach(rt => {
          if (studentsMap[rt.student_id]) {
            const keyMap = {
              'internal_1': 'cia_1_retest',
              'internal_2': 'cia_2_retest',
              'model_exam': 'model_exam_retest'
            };
            const mappedKey = keyMap[type] || `${type}_retest`;
            studentsMap[rt.student_id][mappedKey] = rt.retest_marks;
          }
        });
      });
      
      const gbArray = Object.values(studentsMap).sort((a, b) => (a.register_number || '').localeCompare(b.register_number || ''));
      setGradebook(gbArray);

    } catch (err) {
      console.error(err);
      setError(err.message || 'Failed to load report data.');
    } finally {
      setLoading(false);
    }
  }, [assignmentId]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleKLevelChange = (key, val) => {
    setEditableKLevels(prev => ({
      ...prev,
      [key]: val
    }));
  };

  const handleSaveKLevels = async () => {
    if (!courseAssignment?.course?.id) return;
    setSavingKLevels(true);
    setSaveSuccess(false);
    try {
      await axios.put(`/api/courses/${courseAssignment.course.id}`, {
        co_k_levels: JSON.stringify(editableKLevels)
      });
      setSaveSuccess(true);
      setTimeout(() => setSaveSuccess(false), 3000);
      
      // Update locally
      setCourseAssignment(prev => {
        if (!prev) return prev;
        return {
          ...prev,
          course: {
            ...prev.course,
            co_k_levels: JSON.stringify(editableKLevels)
          }
        };
      });
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || 'Failed to save K-Levels');
    } finally {
      setSavingKLevels(false);
    }
  };

  const getStudentAttendanceSummary = (studentId) => {
    let conducted = 0;
    let attended = 0;
    
    attendance.forEach(session => {
      const record = session.records?.find(r => r.student_id === studentId);
      if (record) {
        conducted++;
        if (['present', 'on_duty', 'late'].includes(record.status)) {
          attended++;
        }
      }
    });
    
    const percentage = conducted > 0 ? ((attended / conducted) * 100).toFixed(1) + '%' : '—';
    return { conducted, attended, percentage };
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh]">
        <Loader2 className="w-10 h-10 text-primary-600 animate-spin mb-4" />
        <p className="text-gray-500 font-medium animate-pulse">Compiling Logbook Report Data...</p>
        <p className="text-xs text-gray-400 mt-2">This may take a few seconds as it fetches all records.</p>
      </div>
    );
  }

  if (error || !courseAssignment) {
    return (
      <div className="p-8 text-center max-w-lg mx-auto mt-10 bg-white rounded-2xl shadow-sm border border-red-100">
        <AlertTriangle className="w-12 h-12 text-red-500 mx-auto mb-4" />
        <h2 className="text-xl font-bold text-gray-800 mb-2">Error Generating Report</h2>
        <p className="text-gray-600 mb-6">{error}</p>
        <Link to={`/faculty/courses/${assignmentId}/lms`} className="px-5 py-2.5 bg-gray-100 text-gray-700 font-bold rounded-xl hover:bg-gray-200 transition-colors">
          Go Back
        </Link>
      </div>
    );
  }

  const course = courseAssignment.course || {};
  const coPoMapping = parseJSON(course.co_po_mapping);
  
  const courseType = course.course_type;
  const psoCount = courseType === 'lab' ? 2 : 3;
  const coRows  = Array.from({ length: 5 },  (_, i) => `CO-${i + 1}`);
  const poColumns  = Array.from({ length: 12 }, (_, i) => `PO-${i + 1}`);
  const psoColumns = Array.from({ length: psoCount }, (_, i) => `PSO-${i + 1}`);
  const allCols = [...poColumns, ...psoColumns];

  // Parsing Course Outcomes for Unit table
  const outcomesText = course.outcomes || '';
  const outcomesList = outcomesText.split('\n').map(line => line.trim()).filter(line => line.length > 0);
  const unitRows = Array.from({ length: 5 }, (_, i) => {
    const unitNo = i + 1;
    const outcomeText = outcomesList[i] || `Course Outcome for Unit ${unitNo} (Not defined)`;
    return { unitNo, outcomeText, key: `Unit-${unitNo}` };
  });

  const facultyName = courseAssignment.faculty 
    ? `${courseAssignment.faculty.first_name} ${courseAssignment.faculty.last_name}` 
    : 'N/A';

  return (
    <div className="min-h-screen bg-gray-50 pb-20 print:bg-white print:pb-0">
      {/* ── Top Bar (Hidden on Print) ── */}
      <div className="bg-white border-b border-gray-200 sticky top-0 z-50 print:hidden">
        <div className="max-w-[210mm] mx-auto px-4 py-4 flex items-center justify-between">
          <Link 
            to={`/faculty/courses/${assignmentId}/lms`}
            className="flex items-center gap-2 text-gray-500 hover:text-primary-600 font-medium transition-colors"
          >
            <ArrowLeft className="w-5 h-5" /> Back to Dashboard
          </Link>
          <div className="flex items-center gap-3">
            {saveSuccess && (
              <span className="text-emerald-600 text-xs font-bold flex items-center gap-1">
                <CheckCircle className="w-4 h-4" /> K-Levels Saved!
              </span>
            )}
            <button 
              onClick={handleSaveKLevels}
              disabled={savingKLevels}
              className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-sm transition-colors text-xs disabled:opacity-50"
            >
              <Save className="w-4 h-4" /> {savingKLevels ? 'Saving...' : 'Save K-Levels'}
            </button>
            <button 
              onClick={() => window.print()}
              className="flex items-center gap-2 px-4 py-2 bg-slate-800 text-white font-bold rounded-xl hover:bg-slate-900 shadow-sm transition-colors text-xs"
            >
              <Printer className="w-4 h-4" /> Print Report
            </button>
          </div>
        </div>
      </div>

      {/* ── A4 Page Container ── */}
      <div className="max-w-[210mm] mx-auto bg-white p-8 md:p-12 mt-8 mb-8 shadow-md print:shadow-none print:m-0 print:p-0 print:max-w-none text-[12px] leading-relaxed text-slate-800 font-serif">
        
        {/* Cover / Header */}
        <div className="text-center mb-10 border-b-4 border-slate-800 pb-6">
          <h1 className="text-3xl font-black uppercase tracking-widest text-slate-900 mb-2">Course Logbook Report</h1>
          <p className="text-lg font-bold text-slate-700">{course.code} - {course.name}</p>
          <div className="mt-4 flex justify-center gap-8 text-sm font-semibold text-slate-600">
            <span>Semester: {courseAssignment.semester}</span>
            <span>Academic Year: {courseAssignment.academic_year}</span>
            <span>Section: {courseAssignment.section ? `${courseAssignment.section.year} Yr ${courseAssignment.section.name}` : 'N/A'}</span>
          </div>
          <div className="mt-2 text-sm font-semibold text-slate-600">
            Faculty Assigned: {facultyName}
          </div>
        </div>

        {/* 1. Department Vision */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="1. Department Vision" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{department?.vision || 'No data available'}</div>
        </div>

        {/* 2. Department Mission */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="2. Department Mission" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{department?.mission || 'No data available'}</div>
        </div>
        
        {/* 3. Programme Educational Objectives (PEOs) */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="3. Programme Educational Objectives (PEOs)" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{department?.peos || 'No data available'}</div>
        </div>

        {/* 4. Programme Outcomes (POs) */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="4. Programme Outcomes (POs)" />
          <div className="mb-6 text-justify whitespace-pre-wrap">
            {programOutcomes?.outcomes || 'No data available'}
          </div>
        </div>

        {/* 5. Programme Specific Outcomes (PSOs) */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="5. Programme Specific Outcomes (PSOs)" />
          <div className="mb-6 text-justify whitespace-pre-wrap">
            {department?.psos || 'No data available'}
          </div>
        </div>

        {/* 6. Course Objectives */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="6. Course Objectives" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{course.objectives || 'No data available'}</div>
        </div>

        <div className="print:break-before-page"></div>

        {/* 7. Course Outcomes (COs) & K-Levels */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="7. Course Outcomes (COs) & K-Levels" />
          <div className="mb-6">
            <table className="w-full border-collapse border border-slate-300">
              <thead className="bg-slate-50">
                <tr>
                  <th className="border border-slate-300 p-2 text-left w-20">Unit</th>
                  <th className="border border-slate-300 p-2 text-left">Course Outcome</th>
                  <th className="border border-slate-300 p-2 text-center w-36">Bloom's Taxonomy Knowledge Level</th>
                </tr>
              </thead>
              <tbody>
                {unitRows.map((row) => (
                  <tr key={row.key}>
                    <td className="border border-slate-300 p-2 text-center font-bold">Unit {row.unitNo}</td>
                    <td className="border border-slate-300 p-2">{row.outcomeText}</td>
                    <td className="border border-slate-300 p-2 text-center">
                      <select
                        value={editableKLevels[row.key] || ''}
                        onChange={(e) => handleKLevelChange(row.key, e.target.value)}
                        className="border border-slate-300 rounded px-2 py-1 text-xs font-bold text-slate-800 bg-white focus:outline-none focus:ring-1 focus:ring-slate-500 w-28 print:border-none print:appearance-none print:bg-transparent print:w-auto print:text-center"
                      >
                        <option value="">- Select -</option>
                        <option value="K1">K1 - Remember</option>
                        <option value="K2">K2 - Understand</option>
                        <option value="K3">K3 - Apply</option>
                        <option value="K4">K4 - Analyze</option>
                        <option value="K5">K5 - Evaluate</option>
                        <option value="K6">K6 - Create</option>
                      </select>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* 8. PO–CO Mapping */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="8. PO–CO Mapping" />
          <div className="mb-6 overflow-x-auto">
            <table className="w-full border-collapse border border-slate-300 text-[10px]">
              <thead>
                <tr>
                  <th className="border border-slate-300 bg-slate-50 p-1 w-12" rowSpan={2}>CO</th>
                  <th className="border border-slate-300 bg-slate-50 p-1 w-16" rowSpan={2}>Unit</th>
                  <th className="border border-slate-300 bg-slate-50 p-1 w-16" rowSpan={2}>K-Level</th>
                  <th className="border border-slate-300 bg-slate-100 p-1 text-center" colSpan={12}>Programme Outcomes (POs)</th>
                  <th className="border border-slate-300 bg-slate-100 p-1 text-center" colSpan={psoCount}>PSOs</th>
                </tr>
                <tr>
                  {poColumns.map(po => (
                    <th key={po} className="border border-slate-300 bg-slate-50 p-1 w-8">{po.replace('PO-', '')}</th>
                  ))}
                  {psoColumns.map(pso => (
                    <th key={pso} className="border border-slate-300 bg-slate-50 p-1 w-8">{pso.replace('PSO-', '')}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {coRows.map((co, index) => {
                  const unitNo = index + 1;
                  const unitKey = `Unit-${unitNo}`;
                  const kLevel = editableKLevels[unitKey] || '-';
                  return (
                    <tr key={co}>
                      <td className="border border-slate-300 bg-slate-50 p-1 font-bold text-center">{co}</td>
                      <td className="border border-slate-300 bg-slate-50 p-1 font-bold text-center">Unit {unitNo}</td>
                      <td className="border border-slate-300 bg-slate-50 p-1 font-bold text-center">{kLevel}</td>
                      {allCols.map(col => {
                        const val = coPoMapping?.[co]?.[col] || '';
                        return (
                          <td key={col} className="border border-slate-300 p-1 text-center font-bold">
                            {val || '-'}
                          </td>
                        );
                      })}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>

        {/* 9. Syllabus */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="9. Syllabus" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{course.syllabus || 'No data available'}</div>
        </div>

        <div className="print:break-before-page"></div>

        {/* 10. Textbooks */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="10. Textbooks" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{course.textbooks || 'No data available'}</div>
        </div>

        {/* 11. References */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="11. References" />
          <div className="mb-6 text-justify whitespace-pre-wrap">{course.references || 'No data available'}</div>
        </div>

        {/* 12. Course Plan / Lesson Plan Coverage */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="12. Course Plan / Lesson Plan Coverage" />
          <div className="mb-6">
            {coursePlan.length === 0 ? (
              <p className="italic text-gray-500">No lesson plan coverage data available.</p>
            ) : (
              <table className="w-full border-collapse border border-slate-300 text-[10px]">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="border border-slate-300 p-2 text-center w-12">Seq No.</th>
                    <th className="border border-slate-300 p-2 text-center w-12">Unit</th>
                    <th className="border border-slate-300 p-2 text-left">Topic</th>
                    <th className="border border-slate-300 p-2 text-center w-12">Hours</th>
                    <th className="border border-slate-300 p-2 text-center w-20">Proposed Date</th>
                    <th className="border border-slate-300 p-2 text-center w-20">Actual Date</th>
                    <th className="border border-slate-300 p-2 text-center w-16">Cognitive Level</th>
                    <th className="border border-slate-300 p-2 text-center w-16">Delivery Mode</th>
                    <th className="border border-slate-300 p-2 text-center w-16">Status</th>
                  </tr>
                </thead>
                <tbody>
                  {coursePlan.map(tp => (
                    <tr key={tp.id}>
                      <td className="border border-slate-300 p-2 text-center font-bold">{tp.sequence_no}</td>
                      <td className="border border-slate-300 p-2 text-center">{tp.unit}</td>
                      <td className="border border-slate-300 p-2">{tp.topic}</td>
                      <td className="border border-slate-300 p-2 text-center">{tp.hours}</td>
                      <td className="border border-slate-300 p-2 text-center">{tp.proposed_date ? new Date(tp.proposed_date).toLocaleDateString() : '-'}</td>
                      <td className="border border-slate-300 p-2 text-center">{tp.actual_date ? new Date(tp.actual_date).toLocaleDateString() : '-'}</td>
                      <td className="border border-slate-300 p-2 text-center">{tp.cognitive_level || '-'}</td>
                      <td className="border border-slate-300 p-2 text-center">{tp.mode_of_delivery || '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold">
                        {tp.is_signed ? 'Signed' : tp.actual_date ? 'Completed' : 'Pending'}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>

        <div className="print:break-before-page"></div>

        {/* 13. Student Attendance Summary */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="13. Student Attendance Summary" />
          <div className="mb-6">
            {gradebook.length === 0 ? (
              <p className="italic text-gray-500 font-medium">No student records available.</p>
            ) : (
              <table className="w-full border-collapse border border-slate-300 text-[10px]">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="border border-slate-300 p-2 text-left w-28">Reg No.</th>
                    <th className="border border-slate-300 p-2 text-left">Student Name</th>
                    <th className="border border-slate-300 p-2 text-center w-28">Conducted</th>
                    <th className="border border-slate-300 p-2 text-center w-28">Attended</th>
                    <th className="border border-slate-300 p-2 text-center w-28">Attendance Percentage</th>
                  </tr>
                </thead>
                <tbody>
                  {gradebook.map(stu => {
                    const { conducted, attended, percentage } = getStudentAttendanceSummary(stu.student_id);
                    return (
                      <tr key={stu.student_id}>
                        <td className="border border-slate-300 p-2">{stu.register_number}</td>
                        <td className="border border-slate-300 p-2">{stu.name}</td>
                        <td className="border border-slate-300 p-2 text-center">{conducted}</td>
                        <td className="border border-slate-300 p-2 text-center">{attended}</td>
                        <td className="border border-slate-300 p-2 text-center font-bold">{percentage}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            )}
          </div>
        </div>

        <div className="print:break-before-page"></div>

        {/* 14. Student Seminar Report */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="14. Student Seminar Report" />
          <div className="mb-6">
            {seminars.length === 0 ? (
              <p className="italic text-gray-500">No seminar records available.</p>
            ) : (
              <table className="w-full border-collapse border border-slate-300 text-[10px]">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="border border-slate-300 p-2 text-left w-28">Reg No.</th>
                    <th className="border border-slate-300 p-2 text-left">Student Name</th>
                    <th className="border border-slate-300 p-2 text-left">Seminar Topic</th>
                    <th className="border border-slate-300 p-2 text-center w-28">Date</th>
                    <th className="border border-slate-300 p-2 text-center w-20">Marks Obtained</th>
                  </tr>
                </thead>
                <tbody>
                  {seminars.map(s => (
                    <tr key={s.student_id}>
                      <td className="border border-slate-300 p-2">{s.register_number}</td>
                      <td className="border border-slate-300 p-2">{`${s.first_name} ${s.last_name}`}</td>
                      <td className="border border-slate-300 p-2">{s.seminar_topic || 'Not Assigned'}</td>
                      <td className="border border-slate-300 p-2 text-center">{s.seminar_date ? new Date(s.seminar_date).toLocaleDateString() : '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold">
                        {s.marks_obtained !== null ? s.marks_obtained : '-'} / {s.max_marks}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>

        {/* 15. Assignments Marks Report */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="15. Assignments Marks Report" />
          <div className="mb-6">
            {gradebook.length === 0 ? (
              <p className="italic text-gray-500 font-medium">No student records available.</p>
            ) : (
              <table className="w-full border-collapse border border-slate-300 text-[10px]">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="border border-slate-300 p-2 text-left w-28">Reg No.</th>
                    <th className="border border-slate-300 p-2 text-left">Student Name</th>
                    {Array.from({length: 5}).map((_, i) => (
                      <th key={i} className="border border-slate-300 p-2 text-center w-20">Assignment {i + 1}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {gradebook.map(stu => (
                    <tr key={stu.student_id}>
                      <td className="border border-slate-300 p-2">{stu.register_number}</td>
                      <td className="border border-slate-300 p-2">{stu.name}</td>
                      {Array.from({length: 5}).map((_, i) => {
                        const assignRes = assignmentMeta[i];
                        const marks = assignRes ? (assignmentGrades[stu.student_id]?.[assignRes.id] ?? '-') : '-';
                        return (
                          <td key={i} className="border border-slate-300 p-2 text-center font-bold">{marks}</td>
                        );
                      })}
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>

        <div className="print:break-before-page"></div>

        {/* 16. Internal Assessments Grade Book */}
        <div className="page-break-inside-avoid">
          <SectionHeader title="16. Internal Assessments Grade Book" />
          <div className="mb-6">
            {gradebook.length === 0 ? (
              <p className="italic text-gray-500">No student roster records available.</p>
            ) : (
              <table className="w-full border-collapse border border-slate-300 text-[10px]">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="border border-slate-300 p-2 text-left w-28">Reg No.</th>
                    <th className="border border-slate-300 p-2 text-left">Student Name</th>
                    <th className="border border-slate-300 p-2 text-center w-20">CIA-1</th>
                    <th className="border border-slate-300 p-2 text-center text-red-700 w-20">Retest 1</th>
                    <th className="border border-slate-300 p-2 text-center w-20">CIA-2</th>
                    <th className="border border-slate-300 p-2 text-center text-red-700 w-20">Retest 2</th>
                    <th className="border border-slate-300 p-2 text-center w-20">Model Exam</th>
                    <th className="border border-slate-300 p-2 text-center text-red-700 w-20">Retest Model</th>
                  </tr>
                </thead>
                <tbody>
                  {gradebook.map(stu => (
                    <tr key={stu.student_id}>
                      <td className="border border-slate-300 p-2">{stu.register_number}</td>
                      <td className="border border-slate-300 p-2">{stu.name}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold">{stu.cia_1 ?? '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold text-red-800">{stu.cia_1_retest ?? '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold">{stu.cia_2 ?? '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold text-red-800">{stu.cia_2_retest ?? '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold">{stu.model_exam ?? '-'}</td>
                      <td className="border border-slate-300 p-2 text-center font-bold text-red-800">{stu.model_exam_retest ?? '-'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>

        {/* Footer */}
        <div className="mt-16 pt-8 border-t border-slate-300 flex justify-between text-sm font-bold text-slate-700">
          <div className="text-center">
            <div className="w-40 border-b border-slate-400 mb-2"></div>
            Faculty Signature
          </div>
          <div className="text-center">
            <div className="w-40 border-b border-slate-400 mb-2"></div>
            HOD Signature
          </div>
          <div className="text-center">
            <div className="w-40 border-b border-slate-400 mb-2"></div>
            Principal Signature
          </div>
        </div>

      </div>
    </div>
  );
};
