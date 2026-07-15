import React, { useState, useEffect, useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import { Printer, ArrowLeft, Loader2, AlertTriangle, Save, CheckCircle, Download } from 'lucide-react';

// ── Helpers ────────────────────────────────────────────────────────────────────
const parseJSON = (raw) => {
  if (!raw) return {};
  if (typeof raw === 'object') return raw;
  try { return JSON.parse(raw); } catch { return {}; }
};

// Parse rubric from remarks JSON
const parseRubric = (remarksStr) => {
  try {
    const parsed = JSON.parse(remarksStr || '{}');
    if (parsed.__rubric) return parsed.__rubric;
  } catch { /* */ }
  return null;
};

// Assignment rubric criteria (same as LMSAssignments)
const ASSIGNMENT_RUBRIC = [
  { key: 'content_quality',   label: 'Content Quality',          max: 4 },
  { key: 'structure_org',     label: 'Structure & Organization', max: 2 },
  { key: 'presentation',      label: 'Presentation',             max: 1 },
  { key: 'timely_submission', label: 'Timely Submission',        max: 1 },
  { key: 'creativity',        label: 'Creativity',               max: 2 },
];

// Seminar rubric criteria (same as LMSSeminars)
const SEMINAR_RUBRIC = [
  { key: 'rubric_content_relevance',   label: 'Content Relevance'  },
  { key: 'rubric_presentation_skills', label: 'Presentation Skills' },
  { key: 'rubric_resources_used',      label: 'Resources Used'      },
  { key: 'rubric_time_management',     label: 'Time Management'     },
  { key: 'rubric_question_handling',   label: 'Q&A Handling (2)'   },
  { key: 'rubric_team_coordination',   label: 'Team Coord. (1)'    },
];

// PO descriptions for the mapping table
const PO_DESCRIPTIONS = {
  'PO1':  'Engineering Knowledge',
  'PO2':  'Problem Analysis',
  'PO3':  'Design/Development of Solutions',
  'PO4':  'Conduct Investigations of Complex Problems',
  'PO5':  'Modern Tool Usage',
  'PO6':  'The Engineer and Society',
  'PO7':  'Environment and Sustainability',
  'PO8':  'Ethics',
  'PO9':  'Individual and Team Work',
  'PO10': 'Communication',
  'PO11': 'Project Management and Finance',
  'PO12': 'Life-long Learning',
};

// K-Level labels
const K_LABELS = {
  K1: 'Remember', K2: 'Understand', K3: 'Apply',
  K4: 'Analyze', K5: 'Evaluate', K6: 'Create',
};

// ── Section header component ──────────────────────────────────────────────────
const SectionHeader = ({ title }) => (
  <div style={{ borderBottom: '2px solid #1e293b', paddingBottom: '6px', marginBottom: '14px', marginTop: '28px', pageBreakInside: 'avoid' }}>
    <h2 style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', color: '#1e293b', textTransform: 'uppercase', letterSpacing: '0.06em', margin: 0 }}>
      {title}
    </h2>
  </div>
);

// ── Report styles (injected once) ─────────────────────────────────────────────
const REPORT_STYLES = `
  @import url('https://fonts.googleapis.com/css2?family=Times+New+Roman');
  @media print {
    .print-hidden { display: none !important; }
    .print-only { display: block !important; }
    .print-page { margin: 0 !important; padding: 0 !important; box-shadow: none !important; max-width: 100% !important; width: 100% !important; }
    @page { size: A4; margin: 15mm; }
    .page-break { page-break-before: always; break-before: page; }
  }
  .print-only { display: none !important; }
  .print-hidden { display: block; }
  .report-body { font-family: 'Times New Roman', Times, serif; font-size: 12pt; color: #1e293b; line-height: 1.6; }
  .report-body table { border-collapse: collapse; width: 100%; }
  .report-body th, .report-body td { border: 1px solid #94a3b8; padding: 5px 8px; }
  .report-body thead th { background: #f1f5f9; font-weight: bold; }
  .highlight-label { font-weight: bold; }
`;

const highlightReportText = (text) => {
  if (!text) return <span style={{ color: '#94a3b8', fontStyle: 'italic' }}>No data available</span>;
  
  // Escape HTML tags to prevent XSS/rendering issues
  let html = text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
    
  // Highlight M1, M2... PEO1, PEO2... PO1, PO2... PSO1, PSO2...
  html = html.replace(/\b(M\d+|PEO\d+|PEO[!@]|PO\d+|PSO\d+)\b/g, '<strong style="color: #1e3a8a; font-weight: bold;">$1</strong>');
  
  // Highlight UNIT 1, UNIT I, Unit-1, etc.
  html = html.replace(/\b(UNIT\s*[-–—:]?\s*(?:[IVXLCDM]+|\d+))\b/gi, '<strong style="color: #1e3a8a; font-weight: 800; text-transform: uppercase;">$1</strong>');
  
  // Highlight unit names/lesson titles (uppercase phrase of 3+ words preceding a colon)
  html = html.replace(/\b([A-Z][A-Z\s]{3,}[A-Z])\b(?=\s*:)/g, '<span style="font-weight: bold; color: #0f172a;">$1</span>');

  return <div dangerouslySetInnerHTML={{ __html: html }} style={{ whiteSpace: 'pre-wrap', textAlign: 'justify' }} />;
};

// ── Main Component ────────────────────────────────────────────────────────────
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
  const [assignmentMeta, setAssignmentMeta] = useState([]);
  const [assignmentGrades, setAssignmentGrades] = useState({});
  const [assignmentRosters, setAssignmentRosters] = useState({}); // resource_id -> roster
  
  // Gradebook states
  const [gradebook, setGradebook] = useState([]);
  const [gradebookDates, setGradebookDates] = useState({}); // grade_type -> test_date
  const [editableKLevels, setEditableKLevels] = useState({});
  const [logoUrl, setLogoUrl] = useState("/logo.png");
  const [isBanner, setIsBanner] = useState(true);

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const coursesRes = await axios.get(`/api/faculty/me/courses?t=${Date.now()}`);
      const foundCourse = coursesRes.data.find(c => c.id.toString() === assignmentId);
      if (!foundCourse) throw new Error("Course Assignment not found.");
      setCourseAssignment(foundCourse);
      
      const deptId = foundCourse.course?.department_id;

      const [deptRes, planRes, attRes, semRes, resRes, poRes] = await Promise.all([
        axios.get(`/api/departments/?t=${Date.now()}`),
        axios.get(`/api/course-plan/${assignmentId}?t=${Date.now()}`).catch(() => ({ data: { topics: [] } })),
        axios.get(`/api/faculty/courses/${assignmentId}/attendance-history?t=${Date.now()}`).catch(() => ({ data: { history: [] } })),
        axios.get(`/api/faculty/courses/${assignmentId}/seminars?t=${Date.now()}`).catch(() => ({ data: { roster: [] } })),
        axios.get(`/api/faculty/courses/${assignmentId}/resources?t=${Date.now()}`).catch(() => ({ data: [] })),
        axios.get(`/api/departments/program-outcomes?t=${Date.now()}`).catch(() => ({ data: null }))
      ]);

      const deptObj = deptRes.data.find(d => d.id === deptId) || null;
      setDepartment(deptObj);
      setCoursePlan(planRes.data?.topics || []);
      setAttendance(attRes.data?.history || []);
      setSeminars(semRes.data?.roster || []);
      setProgramOutcomes(poRes.data || null);
      setEditableKLevels(parseJSON(foundCourse.course?.co_k_levels) || {});

      // Process Assignments (max 5)
      const allResources = resRes.data || [];
      const assignments = allResources.filter(r => r.resource_type === 'assignment').slice(0, 5);
      setAssignmentMeta(assignments);
      
      const assignmentGradesMap = {};
      const rostersMap = {};

      if (assignments.length > 0) {
        const gradePromises = assignments.map(a =>
          axios.get(`/api/faculty/courses/${assignmentId}/assignments/${a.id}/grades?t=${Date.now()}`).catch(() => ({ data: { roster: [] } }))
        );
        const gradesResults = await Promise.all(gradePromises);
        
        assignments.forEach((a, index) => {
          const roster = gradesResults[index].data?.roster || [];
          rostersMap[a.id] = roster;
          roster.forEach(g => {
            if (!assignmentGradesMap[g.student_id]) assignmentGradesMap[g.student_id] = {};
            assignmentGradesMap[g.student_id][a.id] = {
              marks: g.marks_obtained,
              remarks: g.remarks,
              rubric: parseRubric(g.remarks),
            };
          });
        });
      }
      setAssignmentGrades(assignmentGradesMap);
      setAssignmentRosters(rostersMap);

      // Process Gradebook (CIA-1, CIA-2, Model Exam + Retests)
      const assessmentTypes = ['internal_1', 'internal_2', 'model_exam'];
      const gbPromises = assessmentTypes.map(type =>
        axios.get(`/api/faculty/courses/${assignmentId}/gradebook`, { params: { grade_type: type, t: Date.now() } }).catch(() => ({ data: { roster: [], test_date: null } }))
      );
      const retestPromises = assessmentTypes.map(type =>
        axios.get(`/api/retest/courses/${assignmentId}/eligible`, { params: { grade_type: type, t: Date.now() } }).catch(() => ({ data: { eligible_students: [] } }))
      );
      
      const [gbResults, rtResults] = await Promise.all([
        Promise.all(gbPromises),
        Promise.all(retestPromises)
      ]);

      // Extract test dates
      const datesMap = {};
      assessmentTypes.forEach((type, i) => {
        if (gbResults[i].data?.test_date) {
          datesMap[type] = gbResults[i].data.test_date;
        }
      });
      setGradebookDates(datesMap);

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
          const keyMap = { 'internal_1': 'cia_1', 'internal_2': 'cia_2', 'model_exam': 'model_exam' };
          const mappedKey = keyMap[type] || type;
          studentsMap[r.student_id][mappedKey] = r.is_absent ? 'AAA' : r.marks_obtained;
        });

        retestList.forEach(rt => {
          if (studentsMap[rt.student_id]) {
            const keyMap = { 'internal_1': 'cia_1_retest', 'internal_2': 'cia_2_retest', 'model_exam': 'model_exam_retest' };
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

  useEffect(() => { fetchData(); }, [fetchData]);

  // K-level multi-select handler (max 3)
  const handleKLevelChange = (key, level) => {
    setEditableKLevels(prev => {
      const current = Array.isArray(prev[key]) ? prev[key] : (prev[key] ? [prev[key]] : []);
      let updated;
      if (current.includes(level)) {
        updated = current.filter(l => l !== level);
      } else if (current.length < 3) {
        updated = [...current, level].sort();
      } else {
        return prev; // max 3 reached
      }
      return { ...prev, [key]: updated };
    });
  };

  const getKLevelArray = (key) => {
    const val = editableKLevels[key];
    if (!val) return [];
    if (Array.isArray(val)) return val;
    return [val]; // legacy single string
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
      setCourseAssignment(prev => {
        if (!prev) return prev;
        return { ...prev, course: { ...prev.course, co_k_levels: JSON.stringify(editableKLevels) } };
      });
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || 'Failed to save K-Levels');
    } finally {
      setSavingKLevels(false);
    }
  };

  const getStudentAttendanceSummary = (studentId) => {
    let conducted = 0, attended = 0;
    attendance.forEach(session => {
      const record = session.records?.find(r => r.student_id === studentId);
      if (record) {
        conducted++;
        if (['present', 'on_duty', 'late'].includes(record.status)) attended++;
      }
    });
    const percentage = conducted > 0 ? ((attended / conducted) * 100).toFixed(1) + '%' : '—';
    return { conducted, attended, percentage };
  };

  const printReport = () => window.print();

  // ── Loading / Error states ─────────────────────────────────────────────────
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

  // ── Data preparation ───────────────────────────────────────────────────────
  const course = courseAssignment.course || {};
  const coPoMapping = parseJSON(course.co_po_mapping);

  // Always 2 PSOs for theory (as per requirements)
  const psoCount = 2;
  const coRows     = ['CO1', 'CO2', 'CO3', 'CO4', 'CO5'];
  const poColumns  = ['PO1','PO2','PO3','PO4','PO5','PO6','PO7','PO8','PO9','PO10','PO11','PO12'];
  const psoColumns = ['PSO1', 'PSO2'];
  const allCols    = [...poColumns, ...psoColumns];

  // Map legacy key format (CO-1, PO-1) to new format (CO1, PO1) for mapping lookup
  const getMappingValue = (co, col) => {
    // Try new format first
    let val = coPoMapping?.[co]?.[col];
    if (val !== undefined) return val;
    // Try legacy format CO-1, PO-1
    const legacyCo  = co.replace('CO', 'CO-');
    const legacyCol = col.replace(/^(PO|PSO)(\d+)$/, '$1-$2');
    val = coPoMapping?.[legacyCo]?.[legacyCol];
    return val;
  };

  // Course Outcomes (COs)
  const outcomesText = course.outcomes || '';
  const outcomesList = outcomesText.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  const coUnitRows = coRows.map((co, i) => {
    const unitKey = `Unit-${i + 1}`;
    const legacyKey = `Unit-${i + 1}`;
    return {
      co,
      unitNo: i + 1,
      unitKey: legacyKey,
      outcomeText: outcomesList[i] || `Course Outcome ${i + 1} (Not defined)`,
      kLevels: getKLevelArray(legacyKey),
    };
  });

  const thStyle = { fontFamily: 'Times New Roman, serif', fontSize: '10pt', fontWeight: 'bold', textAlign: 'center', padding: '5px 6px', backgroundColor: '#f1f5f9', border: '1px solid #94a3b8' };
  const tdStyle = { fontFamily: 'Times New Roman, serif', fontSize: '10pt', padding: '4px 6px', border: '1px solid #94a3b8', textAlign: 'center' };
  const tdLeftStyle = { ...tdStyle, textAlign: 'left' };

  const facultyName = courseAssignment.faculty
    ? `${courseAssignment.faculty.first_name} ${courseAssignment.faculty.last_name}`
    : 'N/A';

  return (
    <div style={{ minHeight: '100vh', background: '#f8fafc' }}>
      <style>{REPORT_STYLES}</style>

      {/* ── Top Bar (Hidden on Print) ── */}
      <div className="print-hidden bg-white border-b border-gray-200 sticky top-0 z-50">
        <div style={{ maxWidth: '210mm', margin: '0 auto', padding: '14px 16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <Link
            to={`/faculty/courses/${assignmentId}/lms`}
            className="flex items-center gap-2 text-gray-500 hover:text-primary-600 font-medium transition-colors text-sm"
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
              onClick={printReport}
              className="flex items-center gap-2 px-4 py-2 bg-slate-800 text-white font-bold rounded-xl hover:bg-slate-900 shadow-sm transition-colors text-xs"
            >
              <Printer className="w-4 h-4" /> Print Report
            </button>
          </div>
        </div>
      </div>

      {/* ── A4 Report Container ── */}
      <div
        className="print-page report-body"
        style={{
          maxWidth: '210mm',
          margin: '24px auto',
          background: '#fff',
          padding: '20mm 18mm',
          boxShadow: '0 4px 24px rgba(0,0,0,0.08)',
          fontFamily: 'Times New Roman, Times, serif',
          fontSize: '12pt',
          color: '#1e293b',
          lineHeight: '1.6',
        }}
      >
        {/* ══ COVER / HEADER ══════════════════════════════════════════════════ */}
        <div style={{ textAlign: 'center', marginBottom: '28px', borderBottom: '3px solid #1e293b', paddingBottom: '20px' }}>
          {/* College logo */}
          <div style={{ marginBottom: '12px', display: 'flex', justifyContent: 'center' }}>
            <img
              src={logoUrl}
              alt="College Logo"
              style={isBanner ? { width: '100%', height: 'auto', display: 'block' } : { height: '80px', width: 'auto', display: 'inline-block' }}
              onError={() => {
                if (logoUrl !== "/logo2.png") {
                  setLogoUrl("/logo2.png");
                  setIsBanner(false);
                }
              }}
            />
          </div>
          <h1 style={{ fontFamily: 'Times New Roman, serif', fontSize: '18pt', fontWeight: '900', textTransform: 'uppercase', letterSpacing: '0.12em', margin: '0 0 6px 0', color: '#0f172a' }}>
            Course Logbook Report
          </h1>
          <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '14pt', fontWeight: 'bold', color: '#334155', margin: '0 0 12px 0' }}>
            {course.code} – {course.name}
          </p>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(3, 1fr)',
            gap: '12px 24px',
            fontSize: '11pt',
            fontWeight: '600',
            color: '#334155',
            marginTop: '20px',
            padding: '16px',
            backgroundColor: '#f8fafc',
            borderRadius: '8px',
            border: '1px solid #e2e8f0',
            textAlign: 'left'
          }}>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Academic Year:</span> {courseAssignment.academic_year}</div>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Semester:</span> {courseAssignment.semester}</div>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Section:</span> {courseAssignment.section ? `${courseAssignment.section.year} Yr ${courseAssignment.section.name}` : 'N/A'}</div>
            <div style={{ gridColumn: 'span 2' }}><span style={{ color: '#64748b', fontWeight: 'bold' }}>Faculty:</span> {facultyName} {courseAssignment.faculty?.designation ? `(${courseAssignment.faculty.designation})` : ''}</div>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Department:</span> {department ? `${department.name} (${department.code})` : 'N/A'}</div>
          </div>
        </div>

        {/* ══ 1. DEPARTMENT VISION ═══════════════════════════════════════════ */}
        <SectionHeader title="1. Department Vision" />
        <div style={{ marginBottom: '18px', textAlign: 'justify', whiteSpace: 'pre-wrap' }}>
          {department?.vision || 'No data available'}
        </div>

        {/* ══ 2. DEPARTMENT MISSION ══════════════════════════════════════════ */}
        <SectionHeader title="2. Department Mission" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(department?.mission)}
        </div>

        {/* ══ 3. PROGRAMME EDUCATIONAL OBJECTIVES ═══════════════════════════ */}
        <SectionHeader title="3. Programme Educational Objectives (PEOs)" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(department?.peos)}
        </div>

        {/* ══ 4. PROGRAMME OUTCOMES ══════════════════════════════════════════ */}
        <SectionHeader title="4. Programme Outcomes (POs)" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(programOutcomes?.outcomes)}
        </div>

        {/* ══ 5. PROGRAMME SPECIFIC OUTCOMES ════════════════════════════════ */}
        <SectionHeader title="5. Programme Specific Outcomes (PSOs)" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(department?.psos)}
        </div>

        {/* ══ 6. COURSE OBJECTIVES ═══════════════════════════════════════════ */}
        <SectionHeader title="6. Course Objectives" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(course.objectives)}
        </div>

        {/* Page break before CO sections */}
        <div className="page-break" />

        {/* ══ 7. COURSE OUTCOMES ═════════════════════════════════════════════ */}
        <SectionHeader title="7. Course Outcomes" />
        <div style={{ marginBottom: '18px' }}>
          <table>
            <thead>
              <tr>
                <th style={{ ...thStyle, width: '50px', textAlign: 'center' }}>CO</th>
                <th style={{ ...thStyle, textAlign: 'left' }}>Course Outcome Description</th>
                <th style={{ ...thStyle, width: '180px' }}>Bloom's Taxonomy Level(s)</th>
              </tr>
            </thead>
            <tbody>
              {coUnitRows.map((row) => (
                <tr key={row.co}>
                  <td style={{ ...tdStyle, fontWeight: 'bold' }}>
                    <span className="highlight-label">{row.co}</span>
                  </td>
                  <td style={tdLeftStyle}>{row.outcomeText}</td>
                  <td style={tdStyle}>
                    {/* Screen: checkboxes for multi-select */}
                    <div className="print-hidden" style={{ display: 'flex', flexWrap: 'wrap', gap: '4px', justifyContent: 'center' }}>
                      {Object.entries(K_LABELS).map(([kLevel, kDesc]) => {
                        const selected = row.kLevels.includes(kLevel);
                        const atMax = row.kLevels.length >= 3 && !selected;
                        return (
                          <label
                            key={kLevel}
                            style={{
                              display: 'flex', alignItems: 'center', gap: '3px',
                              cursor: atMax ? 'not-allowed' : 'pointer',
                              opacity: atMax ? 0.4 : 1,
                              fontSize: '10pt', fontFamily: 'Times New Roman, serif',
                              padding: '2px 5px',
                              borderRadius: '4px',
                              background: selected ? '#312e81' : '#f1f5f9',
                              color: selected ? '#fff' : '#475569',
                              fontWeight: selected ? 'bold' : 'normal',
                              transition: 'all 0.15s',
                              userSelect: 'none',
                            }}
                          >
                            <input
                              type="checkbox"
                              checked={selected}
                              disabled={atMax}
                              onChange={() => handleKLevelChange(row.unitKey, kLevel)}
                              style={{ display: 'none' }}
                            />
                            {kLevel}
                          </label>
                        );
                      })}
                    </div>
                    {/* Print: show only selected levels */}
                    <div className="print-only" style={{ fontWeight: 'bold', textAlign: 'center' }}>
                      {row.kLevels.length > 0
                        ? row.kLevels.map(k => `${k} – ${K_LABELS[k]}`).join(', ')
                        : '—'}
                    </div>
                    {/* Screen preview of selected */}
                    {row.kLevels.length > 0 && (
                      <div className="print-hidden" style={{ marginTop: '4px', fontSize: '9pt', color: '#6366f1', fontWeight: 'bold', textAlign: 'center' }}>
                        Selected: {row.kLevels.join(', ')} {row.kLevels.length >= 3 && '(max)'}
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* ══ 8. PO–CO MAPPING ═══════════════════════════════════════════════ */}
        <SectionHeader title="8. PO–CO Mapping" />
        <div style={{ marginBottom: '18px', overflowX: 'auto' }}>
          <table style={{ fontSize: '9pt', width: '100%' }}>
            <thead>
              <tr>
                <th style={{ ...thStyle, fontSize: '9pt', width: '48px', verticalAlign: 'middle' }} rowSpan={2}>CO</th>
                <th style={{ ...thStyle, fontSize: '9pt', width: '52px', verticalAlign: 'middle' }} rowSpan={2}>Unit</th>
                <th style={{ ...thStyle, fontSize: '9pt', width: '60px', verticalAlign: 'middle' }} rowSpan={2}>K-Level</th>
                <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'center' }} colSpan={12}>
                  Programme Outcomes (POs)
                </th>
                <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'center' }} colSpan={2}>
                  PSOs
                </th>
              </tr>
              <tr>
                {poColumns.map(po => (
                  <th key={po} style={{ ...thStyle, fontSize: '8pt', width: '28px', padding: '3px 2px' }}>
                    <span className="highlight-label">{po}</span>
                  </th>
                ))}
                {psoColumns.map(pso => (
                  <th key={pso} style={{ ...thStyle, fontSize: '8pt', width: '28px', padding: '3px 2px' }}>
                    <span className="highlight-label">{pso}</span>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {coUnitRows.map((row) => {
                const kDisplay = row.kLevels.length > 0 ? row.kLevels.join(', ') : '—';
                return (
                  <tr key={row.co}>
                    <td style={{ ...tdStyle, fontWeight: 'bold', backgroundColor: '#f8fafc' }}>
                      <span className="highlight-label">{row.co}</span>
                    </td>
                    <td style={{ ...tdStyle, backgroundColor: '#f8fafc' }}>Unit {row.unitNo}</td>
                    <td style={{ ...tdStyle, fontWeight: 'bold', backgroundColor: '#f8fafc', fontSize: '9pt' }}>{kDisplay}</td>
                    {allCols.map(col => {
                      const val = getMappingValue(row.co, col);
                      return (
                        <td key={col} style={{ ...tdStyle, fontSize: '9pt', fontWeight: val ? 'bold' : 'normal' }}>
                          {val || '-'}
                        </td>
                      );
                    })}
                  </tr>
                );
              })}
            </tbody>
          </table>
          {/* PO descriptions key */}
          <div style={{ marginTop: '10px', fontSize: '9pt', color: '#475569' }}>
            <strong>PO Key: </strong>
            {Object.entries(PO_DESCRIPTIONS).map(([k, v]) => (
              <span key={k} style={{ marginRight: '10px' }}>
                <strong>{k}</strong> – {v};
              </span>
            ))}
          </div>
        </div>

        {/* ══ 9. SYLLABUS ════════════════════════════════════════════════════ */}
        <SectionHeader title="9. Syllabus" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(course.syllabus)}
        </div>

        {/* ══ 10. TEXTBOOKS ══════════════════════════════════════════════════ */}
        <SectionHeader title="10. Textbooks" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(course.textbooks)}
        </div>

        {/* ══ 11. REFERENCES ═════════════════════════════════════════════════ */}
        <SectionHeader title="11. References" />
        <div style={{ marginBottom: '18px' }}>
          {highlightReportText(course.references)}
        </div>

        {/* Page break */}
        <div className="page-break" />

        {/* ══ 12. COURSE PLAN ════════════════════════════════════════════════ */}
        <SectionHeader title="12. Course Plan / Lesson Plan Coverage" />
        <div style={{ marginBottom: '18px' }}>
          {coursePlan.length === 0 ? (
            <p style={{ fontStyle: 'italic', color: '#64748b' }}>No lesson plan coverage data available.</p>
          ) : (
            <table style={{ fontSize: '9pt' }}>
              <thead>
                <tr>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Seq</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Unit</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Topic</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Hrs</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Proposed Date</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Actual Date</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Cog. Level</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Mode</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Status</th>
                </tr>
              </thead>
              <tbody>
                {coursePlan.map(tp => (
                  <tr key={tp.id}>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.sequence_no}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.unit}</td>
                    <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{tp.topic}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.hours}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.proposed_date ? formatDate(tp.proposed_date) : '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.actual_date ? formatDate(tp.actual_date) : '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.cognitive_level || '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.mode_of_delivery || '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>
                      {tp.is_signed ? 'Signed' : tp.actual_date ? 'Done' : 'Pending'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>

        {/* Page break */}
        <div className="page-break" />

        {/* ══ 13. STUDENT ATTENDANCE SUMMARY ════════════════════════════════ */}
        <SectionHeader title="13. Student Attendance Summary" />
        <div style={{ marginBottom: '18px' }}>
          {gradebook.length === 0 ? (
            <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student records available.</p>
          ) : (
            <table style={{ fontSize: '10pt' }}>
              <thead>
                <tr>
                  <th style={{ ...thStyle, textAlign: 'left', width: '110px' }}>Reg No.</th>
                  <th style={{ ...thStyle, textAlign: 'left' }}>Student Name</th>
                  <th style={{ ...thStyle, width: '90px' }}>Conducted</th>
                  <th style={{ ...thStyle, width: '90px' }}>Attended</th>
                  <th style={{ ...thStyle, width: '110px' }}>Percentage</th>
                </tr>
              </thead>
              <tbody>
                {gradebook.map(stu => {
                  const { conducted, attended, percentage } = getStudentAttendanceSummary(stu.student_id);
                  return (
                    <tr key={stu.student_id}>
                      <td style={tdLeftStyle}>{stu.register_number}</td>
                      <td style={tdLeftStyle}>{stu.name}</td>
                      <td style={tdStyle}>{conducted}</td>
                      <td style={tdStyle}>{attended}</td>
                      <td style={{ ...tdStyle, fontWeight: 'bold' }}>{percentage}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          )}
        </div>

        {/* Page break */}
        <div className="page-break" />

        {/* ══ 14. STUDENT SEMINAR REPORT ════════════════════════════════════ */}
        <SectionHeader title="14. Student Seminar Report" />
        <div style={{ marginBottom: '18px' }}>
          {seminars.length === 0 ? (
            <p style={{ fontStyle: 'italic', color: '#64748b' }}>No seminar records available.</p>
          ) : (
            <table style={{ fontSize: '9pt' }}>
              <thead>
                <tr>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '140px' }}>Student Name</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Seminar Topic</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '75px' }}>Date</th>
                  {SEMINAR_RUBRIC.map(c => (
                    <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}</th>
                  ))}
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Total</th>
                </tr>
              </thead>
              <tbody>
                {seminars.map(s => (
                  <tr key={s.student_id}>
                    <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.register_number}</td>
                    <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{`${s.first_name} ${s.last_name}`}</td>
                    <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.seminar_topic || 'Not Assigned'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt' }}>{s.seminar_date ? formatDate(s.seminar_date) : '—'}</td>
                    {SEMINAR_RUBRIC.map(c => (
                      <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>
                        {s[c.key] != null ? s[c.key] : '—'}
                      </td>
                    ))}
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>
                      {s.marks_obtained != null ? s.marks_obtained : '—'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>

        {/* ══ 15. ASSIGNMENTS MARKS REPORT ══════════════════════════════════ */}
        <SectionHeader title="15. Assignments Marks Report" />
        <div style={{ marginBottom: '18px' }}>
          {assignmentMeta.length === 0 ? (
            <p style={{ fontStyle: 'italic', color: '#64748b' }}>No assignment records available.</p>
          ) : (
            assignmentMeta.map((asgn, aIdx) => {
              const roster = assignmentRosters[asgn.id] || [];
              // Check if this assignment uses rubric
              const firstWithRubric = roster.find(r => parseRubric(r.remarks));
              const hasRubric = !!firstWithRubric;

              return (
                <div key={asgn.id} style={{ marginBottom: '20px' }}>
                  <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', marginBottom: '8px', color: '#1e293b' }}>
                    Assignment {aIdx + 1}: {asgn.title}
                  </p>
                  {roster.length === 0 ? (
                    <p style={{ fontStyle: 'italic', color: '#64748b', fontSize: '10pt' }}>No student data available for this assignment.</p>
                  ) : (
                    <table style={{ fontSize: '9pt' }}>
                      <thead>
                        <tr>
                          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                          <th style={{ ...thStyle, fontSize: '9pt', width: '65px' }}>Total</th>
                          {ASSIGNMENT_RUBRIC.map(c => (
                            <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>
                              {c.label}<br /><span style={{ fontWeight: 'normal', fontSize: '7pt' }}>/{c.max}</span>
                            </th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {roster.map(g => {
                          const rubric = parseRubric(g.remarks);
                          return (
                            <tr key={g.student_id}>
                              <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.register_number}</td>
                              <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.first_name} {g.last_name}</td>
                              <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>
                                {g.marks_obtained != null ? g.marks_obtained : '—'}
                              </td>
                              {ASSIGNMENT_RUBRIC.map(c => (
                                <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>
                                  {rubric ? (rubric[c.key] != null ? rubric[c.key] : '—') : '—'}
                                </td>
                              ))}
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  )}
                </div>
              );
            })
          )}
        </div>

        {/* Page break */}
        <div className="page-break" />

        {/* ══ 16. INTERNAL ASSESSMENTS GRADE BOOK ═══════════════════════════ */}
        <SectionHeader title="16. Internal Assessments Grade Book" />
        <div style={{ marginBottom: '18px' }}>
          {gradebook.length === 0 ? (
            <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student roster records available.</p>
          ) : (
            <table style={{ fontSize: '9pt' }}>
              <thead>
                <tr>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                    <span className="highlight-label">CIA-1</span>
                    {gradebookDates['internal_1'] && (
                      <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>
                        {formatDate(gradebookDates['internal_1'])}
                      </div>
                    )}
                  </th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 1</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                    <span className="highlight-label">CIA-2</span>
                    {gradebookDates['internal_2'] && (
                      <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>
                        {formatDate(gradebookDates['internal_2'])}
                      </div>
                    )}
                  </th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 2</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                    <span className="highlight-label">Model</span>
                    {gradebookDates['model_exam'] && (
                      <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>
                        {formatDate(gradebookDates['model_exam'])}
                      </div>
                    )}
                  </th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest Model</th>
                </tr>
              </thead>
              <tbody>
                {gradebook.map(stu => (
                  <tr key={stu.student_id}>
                    <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.register_number}</td>
                    <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.name}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.cia_1 ?? '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.cia_1_retest ?? '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.cia_2 ?? '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.cia_2_retest ?? '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.model_exam ?? '—'}</td>
                    <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.model_exam_retest ?? '—'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>

        {/* ══ FOOTER / SIGNATURES ════════════════════════════════════════════ */}
        <div style={{ marginTop: '48px', paddingTop: '24px', borderTop: '1px solid #94a3b8', display: 'flex', justifyContent: 'space-between' }}>
          {['Faculty Signature', 'HOD Signature', 'Principal Signature'].map(label => (
            <div key={label} style={{ textAlign: 'center' }}>
              <div style={{ width: '140px', borderBottom: '1px solid #64748b', marginBottom: '6px', height: '40px' }} />
              <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '11pt', fontWeight: 'bold', color: '#334155', margin: 0 }}>{label}</p>
            </div>
          ))}
        </div>

      </div>{/* end A4 container */}
    </div>
  );
};
