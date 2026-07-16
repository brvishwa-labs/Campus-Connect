import React, { useState, useEffect, useCallback, useRef } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import {
  Printer, ArrowLeft, Loader2, AlertTriangle, Save, CheckCircle,
  Layout, Eye, EyeOff, GripVertical, PlusSquare, RotateCcw,
  FileText, Sliders, Download,
} from 'lucide-react';
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd';
import { jsPDF } from 'jspdf';
import html2canvas from 'html2canvas';

// ── Helpers ────────────────────────────────────────────────────────────────────
const parseJSON = (raw) => {
  if (!raw) return {};
  if (typeof raw === 'object') return raw;
  try { return JSON.parse(raw); } catch { return {}; }
};

const formatDate = (dateStr) => {
  if (!dateStr) return '—';
  const d = new Date(dateStr);
  return d.toLocaleDateString('en-GB');
};

const parseRubric = (remarksStr) => {
  try {
    const parsed = JSON.parse(remarksStr || '{}');
    if (parsed.__rubric) return parsed.__rubric;
  } catch { /* */ }
  return null;
};

const ASSIGNMENT_RUBRIC = [
  { key: 'content_quality',   label: 'Content Quality',          max: 4 },
  { key: 'structure_org',     label: 'Structure & Organization', max: 2 },
  { key: 'presentation',      label: 'Presentation',             max: 1 },
  { key: 'timely_submission', label: 'Timely Submission',        max: 1 },
  { key: 'creativity',        label: 'Creativity',               max: 2 },
];

const SEMINAR_RUBRIC = [
  { key: 'rubric_content_relevance',   label: 'Content Relevance'  },
  { key: 'rubric_presentation_skills', label: 'Presentation Skills' },
  { key: 'rubric_resources_used',      label: 'Resources Used'      },
  { key: 'rubric_time_management',     label: 'Time Management'     },
  { key: 'rubric_question_handling',   label: 'Q&A Handling (2)'   },
  { key: 'rubric_team_coordination',   label: 'Team Coord. (1)'    },
];

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

// ── Report styles ─────────────────────────────────────────────────────────────
const REPORT_STYLES = `
  @import url('https://fonts.googleapis.com/css2?family=Times+New+Roman');

  /* ── Screen utility classes ── */
  .print-only  { display: none !important; }
  .print-hidden { display: block; }
  .report-body { font-family: 'Times New Roman', Times, serif; font-size: 12pt; color: #1e293b; line-height: 1.6; }
  .report-body table { border-collapse: collapse; width: 100%; }
  .report-body th, .report-body td { border: 1px solid #94a3b8; padding: 5px 8px; }
  .report-body thead th { background: #f1f5f9; font-weight: bold; }
  .highlight-label { font-weight: bold; }

  /* ── Layout editor sidebar scrollbar ── */
  .layout-sidebar::-webkit-scrollbar { width: 5px; }
  .layout-sidebar::-webkit-scrollbar-track { background: transparent; }
  .layout-sidebar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.15); border-radius: 4px; }

  /* ── PRINT: show only .lms-print-output, hide everything else ── */
  @media print {
    * { -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }

    /* Hide everything in body first */
    body > * { display: none !important; }
    #root { display: block !important; }

    /* Hide all UI chrome — order matters: specific overrides after general */
    .print-ui-hide { display: none !important; }
    .layout-sidebar { display: none !important; }
    .layout-scroll-panel { display: none !important; }

    /* The dedicated print output container — always in DOM, always visible on print */
    .lms-print-output {
      display: block !important;
      position: static !important;
      left: auto !important;
      top: auto !important;
      width: auto !important;
      height: auto !important;
      overflow: visible !important;
      background: white !important;
    }

    .lms-print-output .a4-print-page {
      display: block !important;
      width: 210mm !important;
      min-height: 297mm !important;
      padding: 15mm !important;
      margin: 0 !important;
      box-shadow: none !important;
      border: none !important;
      page-break-after: always !important;
      break-after: page !important;
      box-sizing: border-box !important;
      background: white !important;
      overflow: hidden !important;
      position: relative !important;
    }

    .lms-print-output .a4-print-page:last-child {
      page-break-after: auto !important;
      break-after: auto !important;
    }
    
    .lms-print-output .a4-page-number {
      display: block !important;
    }

    /* Hide screen-only decorators inside print pages */
    .lms-print-output .print-ui-hide { display: none !important; }

    @page { size: A4; margin: 0; }
  }
`;

// ── highlightReportText ───────────────────────────────────────────────────────
const highlightReportText = (text) => {
  if (!text) return <span style={{ color: '#94a3b8', fontStyle: 'italic' }}>No data available</span>;
  const normalizedText = text.replace(/\n\s*\n\s*\n/g, '\n\n');
  const lines = normalizedText.split('\n');
  return (
    <div style={{ textAlign: 'justify' }} className="prose-container">
      {lines.map((line, idx) => {
        if (!line.trim()) return <div key={idx} className="prose-line" style={{ height: '12px' }} />;
        let html = line
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;');
        html = html.replace(/\b(M\d+|PEO\d+|PEO[!@]|PO\d+|PSO\d+)\b/g, '<strong style="color: #1e3a8a; font-weight: bold;">$1</strong>');
        html = html.replace(/\b(UNIT\s*[-\u2013\u2014:]?\s*(?:[IVXLCDM]+|\d+))\b/gi, '<strong style="color: #1e3a8a; font-weight: 800; text-transform: uppercase;">$1</strong>');
        html = html.replace(/\b([A-Z][A-Z\s]{3,}[A-Z])\b(?=\s*:)/g, '<span style="font-weight: bold; color: #0f172a;">$1</span>');
        const isListItem  = /^(?:[a-zA-Z0-9]{1,5}[.:\)]|[-*\u2022])\s/.test(line.trim());
        const isUnitHeader = /^\s*UNIT\s*[-\u2013\u2014:]?\s*(?:[IVXLCDM]+|\d+)/i.test(line);
        const lineStyle = (isListItem && !isUnitHeader) ? { paddingLeft: '32px', textIndent: '-32px' } : {};
        return (
          <div key={idx} className="prose-line" dangerouslySetInnerHTML={{ __html: html }}
            style={{ ...lineStyle, lineHeight: '1.6', marginBottom: '6px', marginTop: isUnitHeader && idx > 0 ? '16px' : '0' }}
          />
        );
      })}
    </div>
  );
};

// ── Section registry ──────────────────────────────────────────────────────────
const DEFAULT_SECTION_IDS = [
  'cover', 'dept-vision', 'dept-mission', 'peos', 'pos', 'psos',
  'course-objectives', 'course-outcomes', 'po-co-mapping',
  'syllabus', 'textbooks', 'references',
  'course-plan', 'attendance', 'seminars', 'assignments', 'gradebook', 'footer',
];

const LAB_SECTION_IDS = [
  'cover', 'course-objectives', 'course-outcomes',
  'list-of-experiments', 'po-co-mapping',
  'practical-schedule', 'attendance', 'lab-marks', 'footer',
];

const DEFAULT_LAYOUT = (isLab = false) => {
  const ids = isLab ? LAB_SECTION_IDS : DEFAULT_SECTION_IDS;
  return ids.reduce((acc, id) => {
    acc[id] = { pageBreakBefore: false, visible: true, spacingTop: 0 };
    return acc;
  }, {});
};

// Sections with default page breaks
const DEFAULT_PAGE_BREAKS = new Set(['course-outcomes', 'course-plan', 'attendance', 'seminars', 'gradebook', 'practical-schedule', 'lab-marks']);

const SECTION_LABELS = {
  'cover':             'Cover / Header',
  'dept-vision':       '1. Department Vision',
  'dept-mission':      '2. Department Mission',
  'peos':              '3. Programme Educational Objectives',
  'pos':               '4. Programme Outcomes (POs)',
  'psos':              '5. Programme Specific Outcomes (PSOs)',
  'course-objectives': '6. Course Objectives',
  'course-outcomes':   '7. Course Outcomes',
  'po-co-mapping':     '8. PO\u2013CO Mapping',
  'syllabus':          '9. Syllabus',
  'textbooks':         '10. Textbooks',
  'references':        '11. References',
  'course-plan':       '12. Course Plan / Lesson Plan',
  'attendance':        '13. Student Attendance Summary',
  'seminars':          '14. Student Seminar Report',
  'assignments':       '15. Assignments Marks Report',
  'gradebook':         '16. Internal Assessments Grade Book',
  'footer':            'Signatures Footer',
};

const LAB_SECTION_LABELS = {
  'cover':              'Cover / Header',
  'course-objectives':  '1. Course Objectives',
  'course-outcomes':    '2. Course Outcomes',
  'list-of-experiments':'3. List of Experiments',
  'po-co-mapping':      '4. PO-CO Mapping',
  'practical-schedule': '5. Practical Schedule',
  'attendance':         '5. Student Attendance Summary',
  'lab-marks':          '6. Lab Mark Entry',
  'footer':             'Signatures Footer',
};

// ── MAIN COMPONENT ────────────────────────────────────────────────────────────
export const LMSLogbookReport = () => {
  const { assignmentId } = useParams();
  const [mode, setMode] = useState('view');

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [savingKLevels, setSavingKLevels] = useState(false);
  const [saveSuccess, setSaveSuccess] = useState(false);

  const [courseAssignment, setCourseAssignment] = useState(null);
  const [department, setDepartment] = useState(null);
  const [programOutcomes, setProgramOutcomes] = useState(null);
  const [coursePlan, setCoursePlan] = useState([]);
  const [attendance, setAttendance] = useState([]);
  const [seminars, setSeminars] = useState([]);
  const [assignmentMeta, setAssignmentMeta] = useState([]);
  const [assignmentGrades, setAssignmentGrades] = useState({});
  const [assignmentRosters, setAssignmentRosters] = useState({});
  const [gradebook, setGradebook] = useState([]);
  const [gradebookDates, setGradebookDates] = useState({});
  const [editableKLevels, setEditableKLevels] = useState({});
  const [logoUrl, setLogoUrl] = useState('/logo.png');
  const [isBanner, setIsBanner] = useState(true);

  const [isLab, setIsLab] = useState(false);
  const [labMarks, setLabMarks] = useState([]);

  const [sectionOrder, setSectionOrder] = useState(() => {
    try {
      const saved = localStorage.getItem('logbook_layout_' + assignmentId);
      if (saved) {
        const { order } = JSON.parse(saved);
        if (Array.isArray(order)) return order;
      }
    } catch (e) { console.error(e); }
    return [];
  });
  const [layoutMap, setLayoutMap] = useState(() => {
    try {
      const saved = localStorage.getItem('logbook_layout_' + assignmentId);
      if (saved) {
        const { map } = JSON.parse(saved);
        if (map) return map;
      }
    } catch (e) { console.error(e); }
    return {};
  });
  const [generatingPDF, setGeneratingPDF] = useState(false);
  const [saveLayoutSuccess, setSaveLayoutSuccess] = useState(false);

  const fetchData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const coursesRes = await axios.get('/api/faculty/me/courses?t=' + Date.now());
      const foundCourse = coursesRes.data.find(c => c.id.toString() === assignmentId);
      if (!foundCourse) throw new Error('Course Assignment not found.');
      setCourseAssignment(foundCourse);
      const deptId = foundCourse.course?.department_id;
      const isLabCourse = foundCourse.course?.course_type === 'lab';
      setIsLab(isLabCourse);

      if (!localStorage.getItem('logbook_layout_' + assignmentId)) {
        setSectionOrder(isLabCourse ? [...LAB_SECTION_IDS] : [...DEFAULT_SECTION_IDS]);
        setLayoutMap(DEFAULT_LAYOUT(isLabCourse));
      }

      const promises = [
        axios.get('/api/departments/?t=' + Date.now()),
        axios.get('/api/course-plan/' + assignmentId + '?t=' + Date.now()).catch(() => ({ data: { topics: [] } })),
        axios.get('/api/faculty/courses/' + assignmentId + '/attendance-history?t=' + Date.now()).catch(() => ({ data: { history: [] } })),
        axios.get('/api/faculty/courses/' + assignmentId + '/seminars?t=' + Date.now()).catch(() => ({ data: { roster: [] } })),
        axios.get('/api/faculty/courses/' + assignmentId + '/resources?t=' + Date.now()).catch(() => ({ data: [] })),
        axios.get('/api/departments/program-outcomes?t=' + Date.now()).catch(() => ({ data: null })),
      ];

      if (isLabCourse) {
        promises.push(axios.get('/api/faculty/courses/' + assignmentId + '/lab-marks?t=' + Date.now()).catch(() => ({ data: { roster: [] } })));
      }

      const results = await Promise.all(promises);
      const [deptRes, planRes, attRes, semRes, resRes, poRes, labMarksRes] = results;

      setDepartment(deptRes.data.find(d => d.id === deptId) || null);
      setCoursePlan(planRes.data?.topics || []);
      setAttendance(attRes.data?.history || []);
      setSeminars(semRes.data?.roster || []);
      setProgramOutcomes(poRes.data || null);
      if (isLabCourse && labMarksRes) {
        setLabMarks(labMarksRes.data?.roster || []);
      }
      setEditableKLevels(parseJSON(foundCourse.course?.co_k_levels) || {});

      const allResources = resRes.data || [];
      const assignments = allResources.filter(r => r.resource_type === 'assignment').slice(0, 5);
      setAssignmentMeta(assignments);

      const assignmentGradesMap = {};
      const rostersMap = {};
      if (assignments.length > 0) {
        const gradesResults = await Promise.all(
          assignments.map(a => axios.get('/api/faculty/courses/' + assignmentId + '/assignments/' + a.id + '/grades?t=' + Date.now()).catch(() => ({ data: { roster: [] } })))
        );
        assignments.forEach((a, index) => {
          const roster = gradesResults[index].data?.roster || [];
          rostersMap[a.id] = roster;
          roster.forEach(g => {
            if (!assignmentGradesMap[g.student_id]) assignmentGradesMap[g.student_id] = {};
            assignmentGradesMap[g.student_id][a.id] = { marks: g.marks_obtained, remarks: g.remarks, rubric: parseRubric(g.remarks) };
          });
        });
      }
      setAssignmentGrades(assignmentGradesMap);
      setAssignmentRosters(rostersMap);

      const assessmentTypes = ['internal_1', 'internal_2', 'model_exam'];
      const [gbResults, rtResults] = await Promise.all([
        Promise.all(assessmentTypes.map(type => axios.get('/api/faculty/courses/' + assignmentId + '/gradebook', { params: { grade_type: type, t: Date.now() } }).catch(() => ({ data: { roster: [], test_date: null } })))),
        Promise.all(assessmentTypes.map(type => axios.get('/api/retest/courses/' + assignmentId + '/eligible', { params: { grade_type: type, t: Date.now() } }).catch(() => ({ data: { eligible_students: [] } })))),
      ]);

      const datesMap = {};
      assessmentTypes.forEach((type, i) => { if (gbResults[i].data?.test_date) datesMap[type] = gbResults[i].data.test_date; });
      setGradebookDates(datesMap);

      const studentsMap = {};
      assessmentTypes.forEach((type, index) => {
        const keyMap = { internal_1: 'cia_1', internal_2: 'cia_2', model_exam: 'model_exam' };
        const rkeyMap = { internal_1: 'cia_1_retest', internal_2: 'cia_2_retest', model_exam: 'model_exam_retest' };
        (gbResults[index].data?.roster || []).forEach(r => {
          if (!studentsMap[r.student_id]) studentsMap[r.student_id] = { student_id: r.student_id, register_number: r.register_number, name: r.first_name + ' ' + r.last_name };
          studentsMap[r.student_id][keyMap[type] || type] = r.is_absent ? 'AAA' : r.marks_obtained;
        });
        (rtResults[index].data?.eligible_students || []).forEach(rt => {
          if (studentsMap[rt.student_id]) studentsMap[rt.student_id][rkeyMap[type] || (type + '_retest')] = rt.retest_marks;
        });
      });
      setGradebook(Object.values(studentsMap).sort((a, b) => (a.register_number || '').localeCompare(b.register_number || '')));
    } catch (err) {
      console.error(err);
      setError(err.message || 'Failed to load report data.');
    } finally {
      setLoading(false);
    }
  }, [assignmentId]);

  useEffect(() => { fetchData(); }, [fetchData]);

  const handleKLevelChange = (key, level) => {
    setEditableKLevels(prev => {
      const current = Array.isArray(prev[key]) ? prev[key] : (prev[key] ? [prev[key]] : []);
      if (current.includes(level)) return { ...prev, [key]: current.filter(l => l !== level) };
      if (current.length >= 3) return prev;
      return { ...prev, [key]: [...current, level].sort() };
    });
  };

  const getKLevelArray = (key) => {
    const val = editableKLevels[key];
    if (!val) return [];
    return Array.isArray(val) ? val : [val];
  };

  const handleSaveKLevels = async () => {
    if (!courseAssignment?.course?.id) return;
    setSavingKLevels(true); setSaveSuccess(false);
    try {
      await axios.put('/api/courses/' + courseAssignment.course.id, { co_k_levels: JSON.stringify(editableKLevels) });
      setSaveSuccess(true);
      setTimeout(() => setSaveSuccess(false), 3000);
      setCourseAssignment(prev => prev ? { ...prev, course: { ...prev.course, co_k_levels: JSON.stringify(editableKLevels) } } : prev);
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || 'Failed to save K-Levels');
    } finally { setSavingKLevels(false); }
  };

  const getStudentAttendanceSummary = (studentId) => {
    let conducted = 0, attended = 0;
    attendance.forEach(session => {
      const record = session.records?.find(r => r.student_id === studentId);
      if (record) { conducted++; if (['present', 'on_duty', 'late'].includes(record.status)) attended++; }
    });
    return { conducted, attended, percentage: conducted > 0 ? ((attended / conducted) * 100).toFixed(1) + '%' : '\u2014' };
  };

  const printReport = () => window.print();

  const togglePageBreak = (id) => setLayoutMap(prev => ({ ...prev, [id]: { ...prev[id], pageBreakBefore: !prev[id].pageBreakBefore } }));
  const toggleVisibility = (id) => setLayoutMap(prev => ({ ...prev, [id]: { ...prev[id], visible: !prev[id].visible } }));
  const setSpacing = (id, val) => setLayoutMap(prev => ({ ...prev, [id]: { ...prev[id], spacingTop: Number(val) } }));
  const handleDragEnd = (result) => {
    if (!result.destination) return;
    const o = [...sectionOrder];
    const [m] = o.splice(result.source.index, 1);
    o.splice(result.destination.index, 0, m);
    setSectionOrder(o);
  };
  const handleSaveLayout = () => {
    try {
      localStorage.setItem('logbook_layout_' + assignmentId, JSON.stringify({ order: sectionOrder, map: layoutMap }));
      setSaveLayoutSuccess(true);
      setTimeout(() => setSaveLayoutSuccess(false), 3000);
    } catch (e) {
      console.error(e);
      alert('Failed to save layout.');
    }
  };

  const handleDiscardLayout = () => {
    try {
      const saved = localStorage.getItem('logbook_layout_' + assignmentId);
      if (saved) {
        const { order, map } = JSON.parse(saved);
        if (order) setSectionOrder(order);
        if (map) setLayoutMap(map);
      } else {
        setSectionOrder([...DEFAULT_SECTION_IDS]);
        setLayoutMap(DEFAULT_LAYOUT());
      }
    } catch (e) {
      console.error(e);
    }
  };

  const resetLayout = () => {
    setSectionOrder([...DEFAULT_SECTION_IDS]);
    setLayoutMap(DEFAULT_LAYOUT());
    localStorage.removeItem('logbook_layout_' + assignmentId);
  };

  // ── Data prep ────────────────────────────────────────────────────────────────
  const course      = courseAssignment?.course || {};
  const coPoMapping = parseJSON(course.co_po_mapping);
  const coRows      = isLab ? ['CO1', 'CO2'] : ['CO1','CO2','CO3','CO4','CO5'];
  const poColumns   = ['PO1','PO2','PO3','PO4','PO5','PO6','PO7','PO8','PO9','PO10','PO11','PO12'];
  const psoColumns  = ['PSO1','PSO2'];
  const allCols     = [...poColumns, ...psoColumns];

  const getMappingValue = (co, col) => {
    let val = coPoMapping?.[co]?.[col];
    if (val !== undefined) return val;
    return coPoMapping?.[co.replace('CO','CO-')]?.[col.replace(/^(PO|PSO)(\d+)$/,'$1-$2')];
  };

  const outcomesList = (course.outcomes || '').split('\n').map(l => l.trim()).filter(Boolean);
  const coUnitRows = coRows.map((co, i) => {
    const unitKey = 'Unit-' + (i + 1);
    return { co, unitNo: i + 1, unitKey, outcomeText: outcomesList[i] || ('Course Outcome ' + (i+1) + ' (Not defined)'), kLevels: getKLevelArray(unitKey) };
  });

  const thStyle     = { fontFamily: 'Times New Roman, serif', fontSize: '10pt', fontWeight: 'bold', textAlign: 'center', padding: '5px 6px', backgroundColor: '#f1f5f9', border: '1px solid #94a3b8' };
  const tdStyle     = { fontFamily: 'Times New Roman, serif', fontSize: '10pt', padding: '4px 6px', border: '1px solid #94a3b8', textAlign: 'center' };
  const tdLeftStyle = { ...tdStyle, textAlign: 'left' };
  const facultyName = courseAssignment?.faculty ? (courseAssignment.faculty.first_name + ' ' + courseAssignment.faculty.last_name) : 'N/A';

  // ── Section renderers ────────────────────────────────────────────────────────
  const renderSection = (id) => {
    const sectionTitle = isLab ? (LAB_SECTION_LABELS[id] || SECTION_LABELS[id] || id) : (SECTION_LABELS[id] || id);
    switch (id) {
      case 'cover': return (
        <div style={{ textAlign: 'center', marginBottom: '28px', borderBottom: '3px solid #1e293b', paddingBottom: '20px' }}>
          <div style={{ marginBottom: '12px', display: 'flex', justifyContent: 'center' }}>
            <img src={logoUrl} alt="College Logo" crossOrigin="anonymous"
              style={isBanner ? { width: '100%', height: 'auto', display: 'block' } : { height: '80px', width: 'auto', display: 'inline-block' }}
              onError={() => { if (logoUrl !== '/logo2.png') { setLogoUrl('/logo2.png'); setIsBanner(false); } }}
            />
          </div>
          <h1 style={{ fontFamily: 'Times New Roman, serif', fontSize: '18pt', fontWeight: '900', textTransform: 'uppercase', letterSpacing: '0.12em', margin: '0 0 6px 0', color: '#0f172a' }}>Course Logbook Report</h1>
          <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '14pt', fontWeight: 'bold', color: '#334155', margin: '0 0 12px 0' }}>{course.code} \u2013 {course.name}</p>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '12px 24px', fontSize: '11pt', fontWeight: '600', color: '#334155', marginTop: '20px', padding: '16px', backgroundColor: '#f8fafc', borderRadius: '8px', border: '1px solid #e2e8f0', textAlign: 'left' }}>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Academic Year:</span> {courseAssignment.academic_year}</div>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Semester:</span> {courseAssignment.semester}</div>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Section:</span> {courseAssignment.section ? (courseAssignment.section.year + ' Yr ' + courseAssignment.section.name) : 'N/A'}</div>
            <div style={{ gridColumn: 'span 2' }}><span style={{ color: '#64748b', fontWeight: 'bold' }}>Faculty:</span> {facultyName} {courseAssignment.faculty?.designation ? ('(' + courseAssignment.faculty.designation + ')') : ''}</div>
            <div><span style={{ color: '#64748b', fontWeight: 'bold' }}>Department:</span> {department ? (department.name + ' (' + department.code + ')') : 'N/A'}</div>
          </div>
        </div>
      );

      case 'dept-vision': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(department?.vision)}</div></>);
      case 'dept-mission': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(department?.mission)}</div></>);
      case 'peos': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(department?.peos)}</div></>);
      case 'pos': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(programOutcomes?.outcomes)}</div></>);
      case 'psos': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(department?.psos)}</div></>);
      case 'course-objectives': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(course.objectives)}</div></>);

      case 'course-outcomes': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            <table className="report-table"><thead><tr>
              <th style={{ ...thStyle, width: '50px', textAlign: 'center' }}>CO</th>
              <th style={{ ...thStyle, textAlign: 'left' }}>Course Outcome Description</th>
              <th style={{ ...thStyle, width: '180px' }}>Bloom's Taxonomy Level(s)</th>
            </tr></thead>
            <tbody>
              {coUnitRows.map((row) => (
                <tr key={row.co} className="report-table-row">
                  <td style={{ ...tdStyle, fontWeight: 'bold' }}><span className="highlight-label">{row.co}</span></td>
                  <td style={tdLeftStyle}>{row.outcomeText}</td>
                  <td style={tdStyle}>
                    {mode === 'view' ? (
                      <>
                        <div className="print-hidden" style={{ display: 'flex', flexWrap: 'wrap', gap: '4px', justifyContent: 'center' }}>
                          {Object.entries(K_LABELS).map(([kLevel]) => {
                            const selected = row.kLevels.includes(kLevel);
                            const atMax = row.kLevels.length >= 3 && !selected;
                            return (
                              <label key={kLevel} style={{ display: 'flex', alignItems: 'center', gap: '3px', cursor: atMax ? 'not-allowed' : 'pointer', opacity: atMax ? 0.4 : 1, fontSize: '10pt', fontFamily: 'Times New Roman, serif', padding: '2px 5px', borderRadius: '4px', background: selected ? '#312e81' : '#f1f5f9', color: selected ? '#fff' : '#475569', fontWeight: selected ? 'bold' : 'normal', transition: 'all 0.15s', userSelect: 'none' }}>
                                <input type="checkbox" checked={selected} disabled={atMax} onChange={() => handleKLevelChange(row.unitKey, kLevel)} style={{ display: 'none' }} />
                                {kLevel}
                              </label>
                            );
                          })}
                        </div>
                        {row.kLevels.length > 0 && (
                          <div className="print-hidden" style={{ marginTop: '4px', fontSize: '9pt', color: '#6366f1', fontWeight: 'bold', textAlign: 'center' }}>
                            Selected: {row.kLevels.join(', ')} {row.kLevels.length >= 3 && '(max)'}
                          </div>
                        )}
                      </>
                    ) : null}
                    <div className={mode === 'view' ? "print-only" : ""} style={{ fontWeight: 'bold', textAlign: 'center' }}>
                      {row.kLevels.length > 0 ? row.kLevels.map(k => k + ' \u2013 ' + K_LABELS[k]).join(', ') : '\u2014'}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody></table>
          </div>
        </>
      );

      case 'po-co-mapping': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px', overflowX: 'auto' }}>
            <table className="report-table" style={{ fontSize: '9pt', width: '100%' }}>
              <thead>
                <tr>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '48px', verticalAlign: 'middle' }} rowSpan={2}>CO</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '52px', verticalAlign: 'middle' }} rowSpan={2}>Unit</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px', verticalAlign: 'middle' }} rowSpan={2}>K-Level</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'center' }} colSpan={12}>Programme Outcomes (POs)</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'center' }} colSpan={2}>PSOs</th>
                </tr>
                <tr>
                  {poColumns.map(po => <th key={po} style={{ ...thStyle, fontSize: '8pt', width: '28px', padding: '3px 2px' }}><span className="highlight-label">{po}</span></th>)}
                  {psoColumns.map(pso => <th key={pso} style={{ ...thStyle, fontSize: '8pt', width: '28px', padding: '3px 2px' }}><span className="highlight-label">{pso}</span></th>)}
                </tr>
              </thead>
              <tbody>
                {coUnitRows.map((row) => {
                  const kDisplay = row.kLevels.length > 0 ? row.kLevels.join(', ') : '\u2014';
                  return (
                    <tr key={row.co} className="report-table-row">
                      <td style={{ ...tdStyle, fontWeight: 'bold', backgroundColor: '#f8fafc' }}><span className="highlight-label">{row.co}</span></td>
                      <td style={{ ...tdStyle, backgroundColor: '#f8fafc' }}>Unit {row.unitNo}</td>
                      <td style={{ ...tdStyle, fontWeight: 'bold', backgroundColor: '#f8fafc', fontSize: '9pt' }}>{kDisplay}</td>
                      {allCols.map(col => { const val = getMappingValue(row.co, col); return <td key={col} style={{ ...tdStyle, fontSize: '9pt', fontWeight: val ? 'bold' : 'normal' }}>{val || '-'}</td>; })}
                    </tr>
                  );
                })}
              </tbody>
            </table>
            <div style={{ marginTop: '10px', fontSize: '9pt', color: '#475569' }}>
              <strong>PO Key: </strong>
              {Object.entries(PO_DESCRIPTIONS).map(([k, v]) => <span key={k} style={{ marginRight: '10px' }}><strong>{k}</strong> \u2013 {v};</span>)}
            </div>
          </div>
        </>
      );

      case 'syllabus': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(course.syllabus)}</div></>);
      case 'textbooks': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(course.textbooks)}</div></>);
      case 'references': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(course.references)}</div></>);

      case 'list-of-experiments': return (<><SectionHeader title={sectionTitle} /><div style={{ marginBottom: '18px' }}>{highlightReportText(course.syllabus)}</div></>);

      case 'practical-schedule': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {coursePlan.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No schedule coverage data available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead><tr>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Seq</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Unit</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Experiment Topic</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Hrs</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Proposed Date</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Actual Date</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Cog. Level</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Mode</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Status</th>
                </tr></thead>
                <tbody>
                  {coursePlan.map(tp => (
                    <tr key={tp.id} className="report-table-row">
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.sequence_no}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.unit}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{tp.topic}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.hours}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.proposed_date ? formatDate(tp.proposed_date) : '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.actual_date ? formatDate(tp.actual_date) : '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.cognitive_level || '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.mode_of_delivery || '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.is_signed ? 'Signed' : tp.actual_date ? 'Done' : 'Pending'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </>
      );

      case 'lab-marks': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {labMarks.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student lab marks available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead><tr>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Record<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 30</span></th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>IA-1<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 15</span></th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>IA-2<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 15</span></th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Avg IA<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 15</span></th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Viva<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 5</span></th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Att %</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Att<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 10</span></th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Total<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 60</span></th>
                </tr></thead>
                <tbody>
                  {labMarks.map(stu => (
                    <tr key={stu.student_id} className="report-table-row">
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.register_number}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.first_name} {stu.last_name}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.record_marks ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.ia1_marks ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.ia2_marks ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.avg_ia ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.viva_marks ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.att_pct != null ? `${stu.att_pct}%` : '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.att_marks ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '10pt', fontWeight: 'bold' }}>{stu.total ?? '\u2014'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </>
      );

      case 'course-plan': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {coursePlan.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No lesson plan coverage data available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead><tr>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Seq</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Unit</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Topic</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Hrs</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Proposed Date</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Actual Date</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Cog. Level</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Mode</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Status</th>
                </tr></thead>
                <tbody>
                  {coursePlan.map(tp => (
                    <tr key={tp.id} className="report-table-row">
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.sequence_no}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.unit}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{tp.topic}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.hours}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.proposed_date ? formatDate(tp.proposed_date) : '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.actual_date ? formatDate(tp.actual_date) : '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.cognitive_level || '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.mode_of_delivery || '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.is_signed ? 'Signed' : tp.actual_date ? 'Done' : 'Pending'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </>
      );

      case 'attendance': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {gradebook.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student records available.</p> : (
              <table className="report-table" style={{ fontSize: '10pt' }}>
                <thead><tr>
                  <th style={{ ...thStyle, textAlign: 'left', width: '110px' }}>Reg No.</th>
                  <th style={{ ...thStyle, textAlign: 'left' }}>Student Name</th>
                  <th style={{ ...thStyle, width: '90px' }}>Conducted</th>
                  <th style={{ ...thStyle, width: '90px' }}>Attended</th>
                  <th style={{ ...thStyle, width: '110px' }}>Percentage</th>
                </tr></thead>
                <tbody>
                  {gradebook.map(stu => {
                    const { conducted, attended, percentage } = getStudentAttendanceSummary(stu.student_id);
                    return (
                      <tr key={stu.student_id} className="report-table-row">
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
        </>
      );

      case 'seminars': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {seminars.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No seminar records available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead><tr>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '140px' }}>Student Name</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Seminar Topic</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '75px' }}>Date</th>
                  {SEMINAR_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}</th>)}
                  <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Total</th>
                </tr></thead>
                <tbody>
                  {seminars.map(s => (
                    <tr key={s.student_id} className="report-table-row">
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.register_number}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.first_name + ' ' + s.last_name}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.seminar_topic || 'Not Assigned'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{s.seminar_date ? formatDate(s.seminar_date) : '\u2014'}</td>
                      {SEMINAR_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{s[c.key] != null ? s[c.key] : '\u2014'}</td>)}
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{s.marks_obtained != null ? s.marks_obtained : '\u2014'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </>
      );

      case 'assignments': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {assignmentMeta.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No assignment records available.</p> : (
              assignmentMeta.map((asgn, aIdx) => {
                const roster = assignmentRosters[asgn.id] || [];
                return (
                  <div key={asgn.id} className="assignment-block" style={{ marginBottom: '20px' }}>
                    <p className="assignment-title" style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', marginBottom: '8px', color: '#1e293b' }}>Assignment {aIdx + 1}: {asgn.title}</p>
                    {roster.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b', fontSize: '10pt' }}>No student data available.</p> : (
                      <table className="report-table" style={{ fontSize: '9pt' }}>
                        <thead><tr>
                          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                          <th style={{ ...thStyle, fontSize: '9pt', width: '65px' }}>Total</th>
                          {ASSIGNMENT_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}<br /><span style={{ fontWeight: 'normal', fontSize: '7pt' }}>/{c.max}</span></th>)}
                        </tr></thead>
                        <tbody>
                          {roster.map(g => {
                            const rubric = parseRubric(g.remarks);
                            return (
                              <tr key={g.student_id} className="report-table-row">
                                <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.register_number}</td>
                                <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.first_name} {g.last_name}</td>
                                <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{g.marks_obtained != null ? g.marks_obtained : '\u2014'}</td>
                                {ASSIGNMENT_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{rubric ? (rubric[c.key] != null ? rubric[c.key] : '\u2014') : '\u2014'}</td>)}
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
        </>
      );

      case 'gradebook': return (
        <>
          <SectionHeader title={sectionTitle} />
          <div style={{ marginBottom: '18px' }}>
            {gradebook.length === 0 ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student roster records available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead><tr>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                    <span className="highlight-label">CIA-1</span>
                    {gradebookDates['internal_1'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['internal_1'])}</div>}
                  </th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 1</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                    <span className="highlight-label">CIA-2</span>
                    {gradebookDates['internal_2'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['internal_2'])}</div>}
                  </th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 2</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                    <span className="highlight-label">Model</span>
                    {gradebookDates['model_exam'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['model_exam'])}</div>}
                  </th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest Model</th>
                </tr></thead>
                <tbody>
                  {gradebook.map(stu => (
                    <tr key={stu.student_id} className="report-table-row">
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.register_number}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.name}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.cia_1 ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.cia_1_retest ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.cia_2 ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.cia_2_retest ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.model_exam ?? '\u2014'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.model_exam_retest ?? '\u2014'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </>
      );

      case 'footer': return (
        <div style={{ marginTop: '48px', paddingTop: '24px', borderTop: '1px solid #94a3b8', display: 'flex', justifyContent: 'space-between' }}>
          {['Faculty Signature', 'HOD Signature', 'Principal Signature'].map(label => (
            <div key={label} style={{ textAlign: 'center' }}>
              <div style={{ width: '140px', borderBottom: '1px solid #64748b', marginBottom: '6px', height: '40px' }} />
              <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '11pt', fontWeight: 'bold', color: '#334155', margin: 0 }}>{label}</p>
            </div>
          ))}
        </div>
      );

      default: return null;
    }
  };

  const effectivePageBreaks = (id) => layoutMap[id]?.pageBreakBefore || DEFAULT_PAGE_BREAKS.has(id);
  const visibleSections = sectionOrder.filter(id => layoutMap[id]?.visible !== false);

  // ── Virtual sections chunking logic for tables ──────────────────────────────
  const renderSectionChunk = (type, data, idx1, idx2, total) => {
    switch (type) {
      case 'course-plan': {
        const isFirst = idx1 === 0;
        return (
          <>
            <SectionHeader title={isFirst ? "12. Course Plan / Lesson Plan Coverage" : "12. Course Plan / Lesson Plan Coverage (Continued)"} />
            <div style={{ marginBottom: '14px' }}>
              {!data ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No lesson plan coverage data available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
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
                  {data.map(tp => (
                    <tr key={tp.id} className="report-table-row">
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.sequence_no}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.unit}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{tp.topic}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.hours}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.proposed_date ? formatDate(tp.proposed_date) : '—'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.actual_date ? formatDate(tp.actual_date) : '—'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.cognitive_level || '—'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.mode_of_delivery || '—'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.is_signed ? 'Signed' : tp.actual_date ? 'Done' : 'Pending'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              )}
            </div>
          </>
        );
      }
      case 'attendance': {
        const isFirst = idx1 === 0;
        return (
          <>
            <SectionHeader title={isFirst ? "13. Student Attendance Summary" : "13. Student Attendance Summary (Continued)"} />
            <div style={{ marginBottom: '14px' }}>
              {!data ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student records available.</p> : (
              <table className="report-table" style={{ fontSize: '10pt' }}>
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
                  {data.map(stu => {
                    const { conducted, attended, percentage } = getStudentAttendanceSummary(stu.student_id);
                    return (
                      <tr key={stu.student_id} className="report-table-row">
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
          </>
        );
      }
      case 'seminars': {
        const isFirst = idx1 === 0;
        return (
          <>
            <SectionHeader title={isFirst ? "14. Student Seminar Report" : "14. Student Seminar Report (Continued)"} />
            <div style={{ marginBottom: '14px' }}>
              {!data ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No seminar records available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead>
                  <tr>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '140px' }}>Student Name</th>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Seminar Topic</th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '75px' }}>Date</th>
                    {SEMINAR_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}</th>)}
                    <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Total</th>
                  </tr>
                </thead>
                <tbody>
                  {data.map(s => (
                    <tr key={s.student_id} className="report-table-row">
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.register_number}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.first_name + ' ' + s.last_name}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.seminar_topic || 'Not Assigned'}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt' }}>{s.seminar_date ? formatDate(s.seminar_date) : '—'}</td>
                      {SEMINAR_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{s[c.key] != null ? s[c.key] : '—'}</td>)}
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{s.marks_obtained != null ? s.marks_obtained : '—'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              )}
            </div>
          </>
        );
      }
      case 'gradebook': {
        const isFirst = idx1 === 0;
        return (
          <>
            <SectionHeader title={isFirst ? "16. Internal Assessments Grade Book" : "16. Internal Assessments Grade Book (Continued)"} />
            <div style={{ marginBottom: '14px' }}>
              {!data ? <p style={{ fontStyle: 'italic', color: '#64748b' }}>No student roster records available.</p> : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead>
                  <tr>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                      <span className="highlight-label">CIA-1</span>
                      {gradebookDates['internal_1'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['internal_1'])}</div>}
                    </th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 1</th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                      <span className="highlight-label">CIA-2</span>
                      {gradebookDates['internal_2'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['internal_2'])}</div>}
                    </th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 2</th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
                      <span className="highlight-label">Model</span>
                      {gradebookDates['model_exam'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['model_exam'])}</div>}
                    </th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest Model</th>
                  </tr>
                </thead>
                <tbody>
                  {data.map(stu => (
                    <tr key={stu.student_id} className="report-table-row">
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
          </>
        );
      }
      case 'assignment-empty': {
        const isFirst = idx1 === 0;
        return (
          <>
            <SectionHeader title={isFirst ? "15. Assignments Marks Report" : "15. Assignments Marks Report (Continued)"} />
            <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', marginBottom: '8px', color: '#1e293b' }}>Assignment {idx1 + 1}: {data.title}</p>
            <p style={{ fontStyle: 'italic', color: '#64748b', fontSize: '10pt' }}>No student data available.</p>
          </>
         );
      }
      case 'assignment-chunk': {
        const { asgn, chunk } = data;
        const isFirstChunkForAsg = idx2 === 0;
        return (
          <>
            {isFirstChunkForAsg && <SectionHeader title={idx1 === 0 ? "15. Assignments Marks Report" : "15. Assignments Marks Report (Continued)"} />}
            {!isFirstChunkForAsg && <SectionHeader title={`15. Assignments Marks Report (Assignment {idx1 + 1} Continued)`} />}
            <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', marginBottom: '8px', color: '#1e293b' }}>
              Assignment {idx1 + 1}: {asgn.title} {!isFirstChunkForAsg && '(Continued)'}
            </p>
            <table className="report-table" style={{ fontSize: '9pt' }}>
              <thead>
                <tr>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                  <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                  <th style={{ ...thStyle, fontSize: '9pt', width: '65px' }}>Total</th>
                  {ASSIGNMENT_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}<br /><span style={{ fontWeight: 'normal', fontSize: '7pt' }}>/{c.max}</span></th>)}
                </tr>
              </thead>
              <tbody>
                {chunk.map(g => {
                  const rubric = parseRubric(g.remarks);
                  return (
                    <tr key={g.student_id} className="report-table-row">
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.register_number}</td>
                      <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.first_name} {g.last_name}</td>
                      <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{g.marks_obtained != null ? g.marks_obtained : '—'}</td>
                      {ASSIGNMENT_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{rubric ? (rubric[c.key] != null ? rubric[c.key] : '—') : '—'}</td>)}
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </>
        );
      }
      case 'assignments-empty': {
        return (
          <>
            <SectionHeader title="15. Assignments Marks Report" />
            <p style={{ fontStyle: 'italic', color: '#64748b' }}>No assignment records available.</p>
          </>
        );
      }
      default: return null;
    }
  };

  const renderTableHeader = (baseId) => {
    if (baseId === 'course-outcomes') {
      return (
        <tr>
          <th style={{ ...thStyle, width: '50px', textAlign: 'center' }}>CO</th>
          <th style={{ ...thStyle, textAlign: 'left' }}>Course Outcome Description</th>
          <th style={{ ...thStyle, width: '180px' }}>Bloom's Taxonomy Level(s)</th>
        </tr>
      );
    } else if (baseId === 'po-co-mapping') {
      return (
        <>
          <tr>
            <th style={{ ...thStyle, fontSize: '9pt', width: '48px', verticalAlign: 'middle' }} rowSpan={2}>CO</th>
            <th style={{ ...thStyle, fontSize: '9pt', width: '52px', verticalAlign: 'middle' }} rowSpan={2}>Unit</th>
            <th style={{ ...thStyle, fontSize: '9pt', width: '60px', verticalAlign: 'middle' }} rowSpan={2}>K-Level</th>
            <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'center' }} colSpan={12}>Programme Outcomes (POs)</th>
            <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'center' }} colSpan={2}>PSOs</th>
          </tr>
          <tr>
            {poColumns.map(po => <th key={po} style={{ ...thStyle, fontSize: '8pt', width: '28px', padding: '3px 2px' }}><span className="highlight-label">{po}</span></th>)}
            {psoColumns.map(pso => <th key={pso} style={{ ...thStyle, fontSize: '8pt', width: '28px', padding: '3px 2px' }}><span className="highlight-label">{pso}</span></th>)}
          </tr>
        </>
      );
    } else if (baseId === 'course-plan') {
      return (
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
      );
    } else if (baseId === 'practical-schedule') {
      return (
        <tr>
          <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Seq</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Unit</th>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Experiment Topic</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '40px' }}>Hrs</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Proposed Date</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '78px' }}>Actual Date</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Cog. Level</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Mode</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Status</th>
        </tr>
      );
    } else if (baseId === 'attendance') {
      return (
        <tr>
          <th style={{ ...thStyle, textAlign: 'left', width: '110px' }}>Reg No.</th>
          <th style={{ ...thStyle, textAlign: 'left' }}>Student Name</th>
          <th style={{ ...thStyle, width: '90px' }}>Conducted</th>
          <th style={{ ...thStyle, width: '90px' }}>Attended</th>
          <th style={{ ...thStyle, width: '110px' }}>Percentage</th>
        </tr>
      );
    } else if (baseId === 'seminars') {
      return (
        <tr>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '140px' }}>Student Name</th>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Seminar Topic</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '75px' }}>Date</th>
          {SEMINAR_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}</th>)}
          <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Total</th>
        </tr>
      );
    } else if (baseId === 'gradebook') {
      return (
        <tr>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
            <span className="highlight-label">CIA-1</span>
            {gradebookDates['internal_1'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['internal_1'])}</div>}
          </th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 1</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
            <span className="highlight-label">CIA-2</span>
            {gradebookDates['internal_2'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['internal_2'])}</div>}
          </th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest 2</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '70px' }}>
            <span className="highlight-label">Model</span>
            {gradebookDates['model_exam'] && <div style={{ fontSize: '7.5pt', fontWeight: 'normal', color: '#475569' }}>{formatDate(gradebookDates['model_exam'])}</div>}
          </th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '70px', color: '#b91c1c' }}>Retest Model</th>
        </tr>
      );
    } else if (baseId === 'lab-marks') {
      return (
        <tr>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Record<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 30</span></th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>IA-1<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 15</span></th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>IA-2<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 15</span></th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Avg IA<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 15</span></th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Viva<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 5</span></th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Att %</th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '55px' }}>Att<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 10</span></th>
          <th style={{ ...thStyle, fontSize: '9pt', width: '60px' }}>Total<br/><span style={{fontWeight:'normal',fontSize:'7.5pt'}}>Out of 60</span></th>
        </tr>
      );
    }
    return null;
  };

  const renderTableRow = (baseId, rowData, rIdx) => {
    if (baseId === 'course-outcomes') {
      const row = rowData;
      return (
        <tr key={row.co} className="report-table-row">
          <td style={{ ...tdStyle, fontWeight: 'bold' }}><span className="highlight-label">{row.co}</span></td>
          <td style={tdLeftStyle}>{row.outcomeText}</td>
          <td style={tdStyle}>
            <div style={{ fontWeight: 'bold', textAlign: 'center' }}>
              {row.kLevels.length > 0 ? row.kLevels.map(k => k + ' \u2013 ' + K_LABELS[k]).join(', ') : '\u2014'}
            </div>
          </td>
        </tr>
      );
    } else if (baseId === 'po-co-mapping') {
      const row = rowData;
      const kDisplay = row.kLevels.length > 0 ? row.kLevels.join(', ') : '\u2014';
      return (
        <tr key={row.co} className="report-table-row">
          <td style={{ ...tdStyle, fontWeight: 'bold', backgroundColor: '#f8fafc' }}><span className="highlight-label">{row.co}</span></td>
          <td style={{ ...tdStyle, backgroundColor: '#f8fafc' }}>Unit {row.unitNo}</td>
          <td style={{ ...tdStyle, fontWeight: 'bold', backgroundColor: '#f8fafc', fontSize: '9pt' }}>{kDisplay}</td>
          {allCols.map(col => { const val = getMappingValue(row.co, col); return <td key={col} style={{ ...tdStyle, fontSize: '9pt', fontWeight: val ? 'bold' : 'normal' }}>{val || '-'}</td>; })}
        </tr>
      );
    } else if (baseId === 'course-plan' || baseId === 'practical-schedule') {
      const tp = rowData;
      return (
        <tr key={tp.id} className="report-table-row">
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.sequence_no}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.unit}</td>
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{tp.topic}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.hours}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.proposed_date ? formatDate(tp.proposed_date) : '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.actual_date ? formatDate(tp.actual_date) : '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.cognitive_level || '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{tp.mode_of_delivery || '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{tp.is_signed ? 'Signed' : tp.actual_date ? 'Done' : 'Pending'}</td>
        </tr>
      );
    } else if (baseId === 'attendance') {
      const stu = rowData;
      const { conducted, attended, percentage } = getStudentAttendanceSummary(stu.student_id);
      return (
        <tr key={stu.student_id} className="report-table-row">
          <td style={tdLeftStyle}>{stu.register_number}</td>
          <td style={tdLeftStyle}>{stu.name}</td>
          <td style={tdStyle}>{conducted}</td>
          <td style={tdStyle}>{attended}</td>
          <td style={{ ...tdStyle, fontWeight: 'bold' }}>{percentage}</td>
        </tr>
      );
    } else if (baseId === 'seminars') {
      const s = rowData;
      return (
        <tr key={s.student_id} className="report-table-row">
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.register_number}</td>
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.first_name + ' ' + s.last_name}</td>
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{s.seminar_topic || 'Not Assigned'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt' }}>{s.seminar_date ? formatDate(s.seminar_date) : '—'}</td>
          {SEMINAR_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{s[c.key] != null ? s[c.key] : '—'}</td>)}
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{s.marks_obtained != null ? s.marks_obtained : '—'}</td>
        </tr>
      );
    } else if (baseId === 'gradebook') {
      const stu = rowData;
      return (
        <tr key={stu.student_id} className="report-table-row">
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.register_number}</td>
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.name}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.cia_1 ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.cia_1_retest ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.cia_2 ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.cia_2_retest ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.model_exam ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{stu.model_exam_retest ?? '—'}</td>
        </tr>
      );
    } else if (baseId === 'lab-marks') {
      const stu = rowData;
      return (
        <tr key={stu.student_id} className="report-table-row">
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.register_number}</td>
          <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{stu.first_name} {stu.last_name}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.record_marks ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.ia1_marks ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.ia2_marks ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.avg_ia ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.viva_marks ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.att_pct != null ? `${stu.att_pct}%` : '—'}</td>
          <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{stu.att_marks ?? '—'}</td>
          <td style={{ ...tdStyle, fontSize: '10pt', fontWeight: 'bold' }}>{stu.total ?? '—'}</td>
        </tr>
      );
    }
    return null;
  };

  const renderPageElements = (elements) => {
    const rendered = [];
    let i = 0;
    while (i < elements.length) {
      const current = elements[i];
      if (current.type === 'full') {
        rendered.push(
          <div key={current.id} style={{ marginTop: (layoutMap[current.baseId]?.spacingTop || 0) + 'px' }}>
            {current.render()}
          </div>
        );
        i++;
      } else if (current.type === 'prose-header' || current.type === 'prose-line') {
        const baseId = current.baseId;
        const isFirst = current.isFirst !== false;
        const group = [];
        let spacingTop = 0;
        if (isFirst) {
          spacingTop = layoutMap[baseId]?.spacingTop || 0;
        }
        while (i < elements.length && (elements[i].type === 'prose-header' || elements[i].type === 'prose-line') && elements[i].baseId === baseId) {
          if (elements[i].type === 'prose-line') {
            group.push(elements[i]);
          }
          i++;
        }
        rendered.push(
          <div key={`${baseId}-prose-group`} style={{ marginTop: spacingTop + 'px' }}>
            <SectionHeader title={isFirst ? SECTION_LABELS[baseId] || LAB_SECTION_LABELS[baseId] : `${SECTION_LABELS[baseId] || LAB_SECTION_LABELS[baseId]} (Continued)`} />
            <div style={{ marginBottom: '18px' }}>
              <div style={{ textAlign: 'justify' }} className="prose-container">
                {group.map((item, idx) => (
                  <div key={idx} dangerouslySetInnerHTML={{ __html: item.html }} />
                ))}
              </div>
            </div>
          </div>
        );
      } else if (current.type === 'table-header' || current.type === 'table-row') {
        const baseId = current.baseId;
        const isFirst = current.isFirst !== false;
        const group = [];
        let spacingTop = 0;
        if (isFirst) {
          spacingTop = layoutMap[baseId]?.spacingTop || 0;
        }
        while (i < elements.length && (elements[i].type === 'table-header' || elements[i].type === 'table-row') && elements[i].baseId === baseId) {
          if (elements[i].type === 'table-row') {
            group.push(elements[i].data);
          }
          i++;
        }
        rendered.push(
          <div key={`${baseId}-table-group-${group.length > 0 ? group[0].id || group[0].student_id || i : i}`} style={{ marginTop: spacingTop + 'px' }}>
            <SectionHeader title={isFirst ? SECTION_LABELS[baseId] || LAB_SECTION_LABELS[baseId] : `${SECTION_LABELS[baseId] || LAB_SECTION_LABELS[baseId]} (Continued)`} />
            <div style={{ marginBottom: '18px' }}>
              {group.length === 0 && isFirst ? (
                <p style={{ fontStyle: 'italic', color: '#64748b' }}>No records available.</p>
              ) : (
                <table className="report-table" style={{ fontSize: baseId === 'attendance' ? '10pt' : '9pt' }}>
                  <thead>
                    {renderTableHeader(baseId)}
                  </thead>
                  <tbody>
                    {group.map((rowData, rIdx) => renderTableRow(baseId, rowData, rIdx))}
                  </tbody>
                </table>
              )}
            </div>
          </div>
        );
      } else if (current.type === 'assignment-title' || current.type === 'assignment-row') {
        const baseId = current.baseId;
        const asgnIdx = current.asgnIdx;
        const asgn = assignmentMeta[asgnIdx];
        const isFirst = current.type === 'assignment-title';
        const group = [];
        let spacingTop = 0;
        if (isFirst && asgnIdx === 0) {
          spacingTop = layoutMap[baseId]?.spacingTop || 0;
        }
        while (i < elements.length && (elements[i].type === 'assignment-title' || elements[i].type === 'assignment-row') && elements[i].baseId === baseId && elements[i].asgnIdx === asgnIdx) {
          if (elements[i].type === 'assignment-row') {
            group.push(elements[i].data);
          }
          i++;
        }
        rendered.push(
          <div key={`${baseId}-asgn-${asgnIdx}-group`} style={{ marginTop: spacingTop + 'px' }}>
            {isFirst && asgnIdx === 0 && <SectionHeader title="15. Assignments Marks Report" />}
            {isFirst && asgnIdx > 0 && <SectionHeader title="15. Assignments Marks Report (Continued)" />}
            {!isFirst && <SectionHeader title={`15. Assignments Marks Report (Assignment ${asgnIdx + 1} Continued)`} />}
            <p style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', marginBottom: '8px', color: '#1e293b' }}>
              Assignment {asgnIdx + 1}: {asgn.title} {!isFirst && '(Continued)'}
            </p>
            {group.length === 0 && isFirst ? (
              <p style={{ fontStyle: 'italic', color: '#64748b', fontSize: '10pt' }}>No student data available.</p>
            ) : (
              <table className="report-table" style={{ fontSize: '9pt' }}>
                <thead>
                  <tr>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                    <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                    <th style={{ ...thStyle, fontSize: '9pt', width: '65px' }}>Total</th>
                    {ASSIGNMENT_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}<br /><span style={{ fontWeight: 'normal', fontSize: '7pt' }}>/{c.max}</span></th>)}
                  </tr>
                </thead>
                <tbody>
                  {group.map((g, rIdx) => {
                    const rubric = parseRubric(g.remarks);
                    return (
                      <tr key={g.student_id} className="report-table-row">
                        <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.register_number}</td>
                        <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.first_name} {g.last_name}</td>
                        <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{g.marks_obtained != null ? g.marks_obtained : '—'}</td>
                        {ASSIGNMENT_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{rubric ? (rubric[c.key] != null ? rubric[c.key] : '—') : '—'}</td>)}
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            )}
          </div>
        );
      } else {
        i++;
      }
    }
    return rendered;
  };

  const estimateHeight = (id) => {
    if (id === 'cover') return 350;
    if (id === 'dept-vision' || id === 'dept-mission' || id === 'peos' || id === 'pos' || id === 'psos') return 150;
    if (id === 'course-objectives' || id === 'course-outcomes') return 200;
    if (id === 'po-co-mapping') return 250;
    if (id === 'syllabus' || id === 'textbooks' || id === 'references') return 250;
    if (id === 'course-plan') return 400;
    if (id === 'attendance') return 300;
    if (id === 'seminars') return 300;
    if (id === 'assignments') return 350;
    if (id === 'gradebook') return 300;
    if (id === 'footer') return 150;
    return 150;
  };

  const paginateSections = useCallback((useDOM = false) => {
    const pagesList = [];
    let currentPage = [];
    let accumulatedHeight = 0;
    const maxHeight = 860; // content height limits within A4 297mm page in pixels (reduced to prevent bottom overflow)

    if (!useDOM) {
      sectionOrder.forEach((id) => {
        const isVisible = layoutMap[id]?.visible !== false;
        if (!isVisible) return;
        
        let estHeight = estimateHeight(id);
        if (accumulatedHeight + estHeight > maxHeight || DEFAULT_PAGE_BREAKS.has(id)) {
          if (currentPage.length > 0) {
            pagesList.push([...currentPage]);
            currentPage = [];
            accumulatedHeight = 0;
          }
        }
        currentPage.push({ id, baseId: id, type: 'full', render: () => renderSection(id) });
        accumulatedHeight += estHeight;
      });
      if (currentPage.length > 0) {
        pagesList.push([...currentPage]);
      }
      return pagesList;
    }

    sectionOrder.forEach((id) => {
      const isVisible = layoutMap[id]?.visible !== false;
      if (!isVisible) return;

      const spacingTop = layoutMap[id]?.spacingTop || 0;
      const isForcedBreak = layoutMap[id]?.pageBreakBefore || DEFAULT_PAGE_BREAKS.has(id);

      if (isForcedBreak && currentPage.length > 0) {
        pagesList.push([...currentPage]);
        currentPage = [];
        accumulatedHeight = 0;
      }

      const measureEl = document.getElementById(`measure-${id}`);
      if (!measureEl) {
        const estHeight = estimateHeight(id) + spacingTop;
        if (accumulatedHeight + estHeight > maxHeight && currentPage.length > 0) {
          pagesList.push([...currentPage]);
          currentPage = [];
          accumulatedHeight = 0;
        }
        currentPage.push({ id, baseId: id, type: 'full', render: () => renderSection(id) });
        accumulatedHeight += estHeight;
        return;
      }

      if (['dept-vision', 'dept-mission', 'peos', 'pos', 'psos', 'course-objectives', 'syllabus', 'textbooks', 'references', 'list-of-experiments'].includes(id)) {
        const headerEl = measureEl.querySelector('.section-header');
        const headerHeight = (headerEl?.offsetHeight || 40) + spacingTop;
        const lines = Array.from(measureEl.querySelectorAll('.prose-line'));
        
        if (lines.length === 0) {
          const estHeight = headerHeight + 20;
          if (accumulatedHeight + estHeight > maxHeight && currentPage.length > 0) {
            pagesList.push([...currentPage]);
            currentPage = [];
            accumulatedHeight = 0;
          }
          currentPage.push({ id: `${id}-empty`, baseId: id, type: 'prose-header', text: '', isFirst: true });
          accumulatedHeight += estHeight;
        } else {
          let currentLineIdx = 0;
          while (currentLineIdx < lines.length) {
            const isFirstSegment = currentLineIdx === 0;
            const segmentHeaderHeight = isFirstSegment ? headerHeight : 40;
            const lineH = lines[currentLineIdx].offsetHeight || 19;
            const requiredH = segmentHeaderHeight + lineH;

            if (accumulatedHeight + requiredH > maxHeight && currentPage.length > 0) {
              pagesList.push([...currentPage]);
              currentPage = [];
              accumulatedHeight = 0;
            }

            const segmentIsFirst = currentLineIdx === 0;
            currentPage.push({
              id: `${id}-chunk-header-${currentLineIdx}`,
              baseId: id,
              type: 'prose-header',
              isFirst: segmentIsFirst
            });
            currentPage.push({
              id: `${id}-chunk-${currentLineIdx}`,
              baseId: id,
              type: 'prose-line',
              html: lines[currentLineIdx].outerHTML,
              lineIdx: currentLineIdx
            });
            accumulatedHeight += segmentIsFirst ? headerHeight + lineH : lineH;
            currentLineIdx++;

            while (currentLineIdx < lines.length) {
              const nextLineH = lines[currentLineIdx].offsetHeight || 19;
              if (accumulatedHeight + nextLineH > maxHeight) {
                break;
              }
              currentPage.push({
                id: `${id}-chunk-${currentLineIdx}`,
                baseId: id,
                type: 'prose-line',
                html: lines[currentLineIdx].outerHTML,
                lineIdx: currentLineIdx
              });
              accumulatedHeight += nextLineH;
              currentLineIdx++;
            }
          }
        }
      } else if (['course-outcomes', 'po-co-mapping', 'course-plan', 'attendance', 'seminars', 'gradebook', 'practical-schedule', 'lab-marks'].includes(id)) {
        const headerEl = measureEl.querySelector('.section-header');
        const headerHeight = (headerEl?.offsetHeight || 40) + spacingTop;
        const tableHeaderEl = measureEl.querySelector('thead');
        const tableHeaderHeight = tableHeaderEl?.offsetHeight || 35;
        const rows = Array.from(measureEl.querySelectorAll('.report-table-row'));
        const rowDataArray = (id === 'course-outcomes' || id === 'po-co-mapping' ? coUnitRows :
                              id === 'course-plan' || id === 'practical-schedule' ? coursePlan :
                              id === 'attendance' ? gradebook :
                              id === 'seminars' ? seminars :
                              id === 'lab-marks' ? labMarks :
                              gradebook);

        if (rows.length === 0 || rowDataArray.length === 0) {
          const estHeight = headerHeight + tableHeaderHeight + 30;
          if (accumulatedHeight + estHeight > maxHeight && currentPage.length > 0) {
            pagesList.push([...currentPage]);
            currentPage = [];
            accumulatedHeight = 0;
          }
          currentPage.push({ id: `${id}-header-only`, baseId: id, type: 'table-header', isFirst: true });
          accumulatedHeight += estHeight;
        } else {
          let currentRowIdx = 0;
          while (currentRowIdx < rows.length) {
            const isFirstSegment = currentRowIdx === 0;
            const segmentHeaderHeight = isFirstSegment ? (headerHeight + tableHeaderHeight) : (40 + tableHeaderHeight);
            const rowH = rows[currentRowIdx].offsetHeight || 30;
            const requiredH = segmentHeaderHeight + rowH;

            if (accumulatedHeight + requiredH > maxHeight && currentPage.length > 0) {
              pagesList.push([...currentPage]);
              currentPage = [];
              accumulatedHeight = 0;
            }

            const segmentIsFirst = currentRowIdx === 0;
            currentPage.push({
              id: `${id}-header-${currentRowIdx}`,
              baseId: id,
              type: 'table-header',
              isFirst: segmentIsFirst
            });
            currentPage.push({
              id: `${id}-row-${currentRowIdx}`,
              baseId: id,
              type: 'table-row',
              data: rowDataArray[currentRowIdx],
              rowIdx: currentRowIdx
            });

            accumulatedHeight += segmentIsFirst ? (headerHeight + tableHeaderHeight + rowH) : (40 + tableHeaderHeight + rowH);
            currentRowIdx++;

            while (currentRowIdx < rows.length) {
              const nextRowH = rows[currentRowIdx].offsetHeight || 30;
              if (accumulatedHeight + nextRowH > maxHeight) {
                break;
              }
              currentPage.push({
                id: `${id}-row-${currentRowIdx}`,
                baseId: id,
                type: 'table-row',
                data: rowDataArray[currentRowIdx],
                rowIdx: currentRowIdx
              });
              accumulatedHeight += nextRowH;
              currentRowIdx++;
            }
          }
        }
      } else if (id === 'assignments') {
        const headerEl = measureEl.querySelector('.section-header');
        const headerHeight = (headerEl?.offsetHeight || 40) + spacingTop;
        const blocks = Array.from(measureEl.querySelectorAll('.assignment-block'));

        if (blocks.length === 0 || assignmentMeta.length === 0) {
          const estHeight = headerHeight + 30;
          if (accumulatedHeight + estHeight > maxHeight && currentPage.length > 0) {
            pagesList.push([...currentPage]);
            currentPage = [];
            accumulatedHeight = 0;
          }
          currentPage.push({ id: 'assignments-empty', baseId: id, type: 'full', render: () => renderSection('assignments') });
          accumulatedHeight += estHeight;
        } else {
          let asgnIdx = 0;
          let isSectionStart = true;

          while (asgnIdx < blocks.length) {
            const blockEl = blocks[asgnIdx];
            const titleEl = blockEl.querySelector('.assignment-title');
            const titleHeight = titleEl?.offsetHeight || 25;
            const tableHeaderEl = blockEl.querySelector('thead');
            const tableHeaderHeight = tableHeaderEl?.offsetHeight || 35;
            const rows = Array.from(blockEl.querySelectorAll('.report-table-row'));
            const roster = assignmentRosters[assignmentMeta[asgnIdx].id] || [];

            const initialHeaderHeight = isSectionStart ? (headerHeight + titleHeight + tableHeaderHeight) : (titleHeight + tableHeaderHeight);

            if (rows.length === 0 || roster.length === 0) {
              const requiredH = initialHeaderHeight + 30;
              if (accumulatedHeight + requiredH > maxHeight && currentPage.length > 0) {
                pagesList.push([...currentPage]);
                currentPage = [];
                accumulatedHeight = 0;
              }
              currentPage.push({
                id: `assignment-title-${asgnIdx}`,
                baseId: id,
                type: 'assignment-title',
                asgnIdx,
                isFirst: true
              });
              accumulatedHeight += requiredH;
              asgnIdx++;
              isSectionStart = false;
            } else {
              let rowIdx = 0;
              while (rowIdx < rows.length) {
                const isFirstRow = rowIdx === 0;
                const segmentHeaderH = isFirstRow ? initialHeaderHeight : (25 + tableHeaderHeight);
                const rowH = rows[rowIdx].offsetHeight || 30;
                const requiredH = segmentHeaderH + rowH;

                if (accumulatedHeight + requiredH > maxHeight && currentPage.length > 0) {
                  pagesList.push([...currentPage]);
                  currentPage = [];
                  accumulatedHeight = 0;
                }

                currentPage.push({
                  id: `assignment-title-${asgnIdx}-${rowIdx}`,
                  baseId: id,
                  type: 'assignment-title',
                  asgnIdx,
                  isFirst: isFirstRow
                });
                currentPage.push({
                  id: `assignment-row-${asgnIdx}-${rowIdx}`,
                  baseId: id,
                  type: 'assignment-row',
                  asgnIdx,
                  rowIdx,
                  data: roster[rowIdx]
                });

                accumulatedHeight += isFirstRow ? (initialHeaderHeight + rowH) : (25 + tableHeaderHeight + rowH);
                rowIdx++;

                while (rowIdx < rows.length) {
                  const nextRowH = rows[rowIdx].offsetHeight || 30;
                  if (accumulatedHeight + nextRowH > maxHeight) {
                    break;
                  }
                  currentPage.push({
                    id: `assignment-row-${asgnIdx}-${rowIdx}`,
                    baseId: id,
                    type: 'assignment-row',
                    asgnIdx,
                    rowIdx,
                    data: roster[rowIdx]
                  });
                  accumulatedHeight += nextRowH;
                  rowIdx++;
                }
              }
              asgnIdx++;
              isSectionStart = false;
            }
          }
        }
      } else {
        const height = (measureEl.offsetHeight || estimateHeight(id)) + spacingTop;
        if (accumulatedHeight + height > maxHeight && currentPage.length > 0) {
          pagesList.push([...currentPage]);
          currentPage = [];
          accumulatedHeight = 0;
        }
        currentPage.push({ id, baseId: id, type: 'full', render: () => renderSection(id) });
        accumulatedHeight += height;
      }
    });

    if (currentPage.length > 0) {
      pagesList.push([...currentPage]);
    }

    return pagesList;
  }, [sectionOrder, layoutMap, coursePlan, gradebook, seminars, assignmentMeta, assignmentRosters, course]);

  const [computedPages, setComputedPages] = useState([]);

  useEffect(() => {
    if (loading || !courseAssignment) return;
    
    const recalculate = () => {
      const pagesList = paginateSections(true);
      
      const getKeys = (pList) => pList.map(p => p.map(v => v.id).join(',')).join('|');
      const keysBefore = getKeys(computedPages);
      const keysAfter = getKeys(pagesList);
      
      if (keysBefore !== keysAfter) {
        setComputedPages(pagesList);
      }
    };

    const handle = requestAnimationFrame(recalculate);
    return () => cancelAnimationFrame(handle);
  }, [sectionOrder, layoutMap, loading, coursePlan, gradebook, seminars, assignmentMeta, computedPages, paginateSections, courseAssignment]);

  const pages = computedPages.length > 0 ? computedPages : paginateSections(false);

  const getSectionPageNumbers = () => {
    const sectionPages = {};
    pages.forEach((pageItems, pageIdx) => {
      pageItems.forEach(v => {
        const baseId = v.baseId;
        if (!sectionPages[baseId]) {
          sectionPages[baseId] = [];
        }
        if (!sectionPages[baseId].includes(pageIdx + 1)) {
          sectionPages[baseId].push(pageIdx + 1);
        }
      });
    });
    return sectionPages;
  };

  const downloadPDF = async () => {
    setGeneratingPDF(true);
    // Create a temporary container positioned off-screen so html2canvas
    // can measure and render it correctly regardless of scroll position.
    const tempContainer = document.createElement('div');
    tempContainer.style.cssText = [
      'position:fixed',
      'top:0',
      'left:0',
      'width:210mm',
      'background:#ffffff',
      'z-index:-9999',
      'pointer-events:none',
      'overflow:visible',
      'font-family:Times New Roman,Times,serif',
      'font-size:12pt',
      'color:#1e293b',
      'line-height:1.6',
    ].join(';');
    document.body.appendChild(tempContainer);

    try {
      if (!pages.length) {
        alert('No pages found to export. Please switch to Print Layout Editor mode first.');
        return;
      }

      const pdf = new jsPDF('p', 'mm', 'a4');
      const pdfWidth = 210;
      const pdfHeight = 297;

      // Inject the same report styles so fonts/borders render correctly
      const styleEl = document.createElement('style');
      styleEl.textContent = `
        .pdf-page { box-sizing:border-box; width:210mm; min-height:297mm;
          padding:15mm; background:#fff; position:relative;
          font-family:'Times New Roman',Times,serif; font-size:12pt;
          color:#1e293b; line-height:1.6; overflow:hidden; }
        .pdf-page table { border-collapse:collapse; width:100%; }
        .pdf-page th, .pdf-page td { border:1px solid #94a3b8; padding:5px 8px; }
        .pdf-page thead th { background:#f1f5f9; font-weight:bold; }
        .pdf-page .a4-page-number { position:absolute; bottom:8mm; left:0; right:0;
          text-align:center; font-size:9pt; color:#94a3b8;
          font-family:'Times New Roman',serif; }
        .pdf-page .print-ui-hide { display:none !important; }
      `;
      tempContainer.appendChild(styleEl);

      for (let i = 0; i < pages.length; i++) {
        // Clear previous page content
        while (tempContainer.children.length > 1) {
          tempContainer.removeChild(tempContainer.lastChild);
        }

        // Create a fresh page div
        const pageDiv = document.createElement('div');
        pageDiv.className = 'pdf-page';
        tempContainer.appendChild(pageDiv);

        // We need a React root to render JSX into this div
        // Use a hidden iframe-like approach: clone the actual DOM page from lms-print-output
        const printPages = document.querySelectorAll('.lms-print-output .a4-print-page');
        if (printPages.length > 0 && printPages[i]) {
          // Clone the already-rendered DOM node
          const clone = printPages[i].cloneNode(true);
          // Strip the screen-only decorators
          clone.querySelectorAll('.print-ui-hide').forEach(el => el.remove());
          // Remove inline dimensions that fight with our fixed capture size
          clone.style.width = '210mm';
          clone.style.height = 'auto';
          clone.style.minHeight = '297mm';
          clone.style.padding = '15mm';
          clone.style.margin = '0';
          clone.style.boxShadow = 'none';
          clone.style.border = 'none';
          clone.style.boxSizing = 'border-box';
          clone.style.background = '#ffffff';
          clone.style.overflow = 'hidden';
          clone.style.position = 'relative';
          clone.style.fontFamily = 'Times New Roman,Times,serif';
          clone.style.fontSize = '12pt';
          clone.style.color = '#1e293b';
          clone.style.lineHeight = '1.6';
          // Fix cross-origin images
          clone.querySelectorAll('img').forEach(img => {
            img.crossOrigin = 'anonymous';
          });
          tempContainer.appendChild(clone);
          tempContainer.removeChild(pageDiv);

          // Allow browser to layout
          await new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)));

          const canvas = await html2canvas(clone, {
            scale: 2,
            useCORS: true,
            allowTaint: true,
            logging: false,
            backgroundColor: '#ffffff',
            width: clone.offsetWidth,
            height: clone.offsetHeight,
            windowWidth: clone.offsetWidth,
            onclone: (clonedDoc) => {
              // Strip stylesheets containing oklch color functions to prevent html2canvas crash
              clonedDoc.querySelectorAll('style').forEach(el => {
                if (el.textContent && el.textContent.includes('oklch')) {
                  el.remove();
                }
              });
              clonedDoc.querySelectorAll('link[rel="stylesheet"]').forEach(el => {
                if (el.href && !el.href.includes('fonts.googleapis.com')) {
                  el.remove();
                }
              });
            }
          });

          const imgData = canvas.toDataURL('image/jpeg', 0.95);
          if (i > 0) pdf.addPage();
          pdf.addImage(imgData, 'JPEG', 0, 0, pdfWidth, pdfHeight);

          tempContainer.removeChild(clone);
        } else {
          console.warn(`Page ${i + 1} not found in print output DOM.`);
        }
      }

      const courseCode = course?.code || 'logbook';
      pdf.save(`Logbook_Report_${courseCode}.pdf`);
    } catch (err) {
      console.error('Error generating PDF:', err);
      alert('Failed to generate PDF: ' + (err.message || 'Unknown error'));
    } finally {
      if (document.body.contains(tempContainer)) {
        document.body.removeChild(tempContainer);
      }
      setGeneratingPDF(false);
    }
  };

  // ── Print all pages ───────────────────────────────────────────────────────────
  const printAllPages = () => window.print();


  // ── VIEW MODE ────────────────────────────────────────────────────────────────
  // Simple continuous scroll. K-level editing lives here.
  const renderViewMode = () => (
    <div
      className="print-page report-body print-ui-hide"
      style={{ maxWidth: '210mm', margin: '24px auto', background: '#fff', padding: '20mm 18mm', boxShadow: '0 4px 24px rgba(0,0,0,0.08)', fontFamily: 'Times New Roman, Times, serif', fontSize: '12pt', color: '#1e293b', lineHeight: '1.6' }}
    >
      {visibleSections.map((id, i) => (
        <div key={id}>
          {i > 0 && effectivePageBreaks(id) && <div className="page-break" />}
          <div style={{ marginTop: (layoutMap[id]?.spacingTop || 0) + 'px' }}>{renderSection(id)}</div>
        </div>
      ))}
    </div>
  );

  // ── PRINT LAYOUT EDITOR ───────────────────────────────────────────────────────
  // The editor IS the print preview — what you see is exactly what prints.
  // Sidebar is sticky/fixed with its own scrollbar. Right panel scrolls independently.
  // NOTE: The outer div does NOT carry print-ui-hide — the lms-print-output div
  //       at the bottom of the tree is what actually prints.
  const renderLayoutMode = () => (
    <div
      className="print-ui-hide"
      style={{ display: 'flex', height: 'calc(100vh - 57px)', background: '#374151', overflow: 'hidden' }}
    >
      {/* ── Fixed sidebar ─────────────────────────────────────────────────── */}
      <div
        className="layout-sidebar"
        style={{
          width: '288px',
          flexShrink: 0,
          background: '#1e293b',
          color: '#f1f5f9',
          overflowY: 'auto',
          overflowX: 'hidden',
          display: 'flex',
          flexDirection: 'column',
          borderRight: '1px solid #0f172a',
          position: 'sticky',
          top: 0,
          height: '100%',
        }}
      >
        {/* Sidebar header — never scrolls away */}
        <div style={{ padding: '14px 16px', borderBottom: '1px solid rgba(255,255,255,0.08)', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
          <div>
            <div style={{ fontWeight: 'bold', fontSize: '13px', display: 'flex', alignItems: 'center', gap: '6px' }}>
              <Layout size={15} style={{ color: '#818cf8' }} /> Print Layout Editor
            </div>
            <div style={{ fontSize: '10px', color: '#64748b', marginTop: '2px' }}>Drag · Reorder · Page Breaks · Spacing</div>
          </div>
          <button
            onClick={resetLayout}
            title="Reset to defaults"
            style={{ background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', borderRadius: '7px', padding: '5px 9px', cursor: 'pointer', color: '#94a3b8', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '11px' }}
          >
            <RotateCcw size={12} /> Reset
          </button>
        </div>

        {/* Page stats */}
        <div style={{ padding: '7px 16px', borderBottom: '1px solid rgba(255,255,255,0.06)', fontSize: '10px', color: '#64748b', flexShrink: 0 }}>
          <span style={{ color: '#60a5fa', fontWeight: 'bold' }}>{pages.length} pages</span>
          <span style={{ margin: '0 6px', color: '#334155' }}>·</span>
          {visibleSections.length} sections visible
        </div>

        {/* Drag-and-drop list — scrollable */}
        <DragDropContext onDragEnd={handleDragEnd}>
          <Droppable droppableId="sections">
            {(provided) => (
              <div
                ref={provided.innerRef}
                {...provided.droppableProps}
                style={{ flex: 1, padding: '8px 0', minHeight: 0 }}
              >
                {sectionOrder.map((id, index) => {
                  const lm = layoutMap[id] || {};
                  const isVisible = lm.visible !== false;
                  const hasBreak = lm.pageBreakBefore || DEFAULT_PAGE_BREAKS.has(id);
                  const sectionPages = getSectionPageNumbers();
                  const pagesForSection = sectionPages[id] || [];
                  const pageLabel = pagesForSection.length > 1
                    ? `p.${pagesForSection[0]}\u2013${pagesForSection[pagesForSection.length - 1]}`
                    : pagesForSection.length === 1
                      ? `p.${pagesForSection[0]}`
                      : 'hidden';
                  return (
                    <Draggable key={id} draggableId={id} index={index}>
                      {(provided, snapshot) => (
                        <div
                          ref={provided.innerRef}
                          {...provided.draggableProps}
                          style={{
                            ...provided.draggableProps.style,
                            margin: '2px 10px',
                            borderRadius: '9px',
                            background: snapshot.isDragging
                              ? 'rgba(99,102,241,0.35)'
                              : isVisible ? 'rgba(255,255,255,0.05)' : 'rgba(255,255,255,0.02)',
                            border: '1px solid ' + (isVisible ? 'rgba(255,255,255,0.09)' : 'rgba(255,255,255,0.04)'),
                            opacity: isVisible ? 1 : 0.4,
                            transition: 'background 0.15s',
                          }}
                        >
                          {hasBreak && index > 0 && (
                            <div style={{ margin: '0 10px', borderTop: '2px dashed rgba(99,102,241,0.55)' }} />
                          )}
                          <div style={{ padding: '9px 11px' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '7px' }}>
                              <div {...provided.dragHandleProps} style={{ color: '#475569', cursor: 'grab', flexShrink: 0, display: 'flex' }}>
                                <GripVertical size={15} />
                              </div>
                              <div style={{ flex: 1, fontSize: '11px', fontWeight: '600', color: isVisible ? '#f1f5f9' : '#64748b', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                                {isLab ? (LAB_SECTION_LABELS[id] || id) : (SECTION_LABELS[id] || id)}
                              </div>
                              <span style={{ flexShrink: 0, fontSize: '9px', background: 'rgba(99,102,241,0.25)', color: '#a5b4fc', borderRadius: '4px', padding: '1px 5px', fontWeight: 'bold' }}>
                                {pageLabel}
                              </span>
                              <button
                                onClick={() => toggleVisibility(id)}
                                title={isVisible ? 'Hide from print' : 'Show in print'}
                                style={{ background: 'none', border: 'none', cursor: 'pointer', color: isVisible ? '#94a3b8' : '#475569', padding: '2px', display: 'flex', flexShrink: 0 }}
                              >
                                {isVisible ? <Eye size={13} /> : <EyeOff size={13} />}
                              </button>
                            </div>
                            {isVisible && (
                              <div style={{ marginTop: '7px', display: 'flex', alignItems: 'center', gap: '7px' }}>
                                <button
                                  onClick={() => togglePageBreak(id)}
                                  style={{ display: 'flex', alignItems: 'center', gap: '3px', fontSize: '10px', padding: '3px 7px', borderRadius: '5px', border: '1px solid ' + (hasBreak ? '#6366f1' : 'rgba(255,255,255,0.1)'), background: hasBreak ? 'rgba(99,102,241,0.18)' : 'transparent', color: hasBreak ? '#a5b4fc' : '#64748b', cursor: 'pointer', fontWeight: hasBreak ? 'bold' : 'normal', flexShrink: 0 }}
                                >
                                  <PlusSquare size={10} /> {hasBreak ? 'Break ✓' : 'Add Break'}
                                </button>
                                <Sliders size={10} style={{ color: '#475569', flexShrink: 0 }} />
                                <input
                                  type="range" min="0" max="60" step="4"
                                  value={lm.spacingTop || 0}
                                  onChange={e => setSpacing(id, e.target.value)}
                                  style={{ flex: 1, accentColor: '#6366f1', height: '3px' }}
                                />
                                <span style={{ fontSize: '9px', color: '#64748b', minWidth: '22px', textAlign: 'right' }}>{lm.spacingTop || 0}px</span>
                              </div>
                            )}
                          </div>
                        </div>
                      )}
                    </Draggable>
                  );
                })}
                {provided.placeholder}
              </div>
            )}
          </Droppable>
        </DragDropContext>

        {/* Legend — pinned to sidebar bottom */}
        <div style={{ padding: '10px 16px', borderTop: '1px solid rgba(255,255,255,0.07)', fontSize: '10px', color: '#475569', lineHeight: '1.9', flexShrink: 0 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><GripVertical size={10} /> Drag to reorder</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><PlusSquare size={10} /> Toggle page break</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><Eye size={10} /> Show / hide from print</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}><Sliders size={10} /> Extra top spacing</div>
        </div>
      </div>

      {/* ── Right: scrollable A4 page canvas ──────────────────────────────── */}
      <div className="layout-scroll-panel" style={{ flex: 1, overflowY: 'auto', background: '#4b5563', padding: '28px 20px 60px' }}>

        {/* Info bar */}
        <div style={{ textAlign: 'center', marginBottom: '18px', color: '#9ca3af', fontSize: '11px', fontFamily: 'sans-serif', letterSpacing: '0.03em' }}>
          Print Layout Editor — What you see is exactly what prints &nbsp;·&nbsp; {pages.length} pages total
        </div>

        {/* Screen-only preview pages (NOT what prints — lms-print-output below is the print target) */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
          {pages.map((pageItems, pageIdx) => (
            <div key={pageIdx}>
              {/* A4 sheet — screen preview only */}
              <div
                style={{
                  width: '210mm',
                  height: '297mm',
                  background: '#fff',
                  boxShadow: '0 6px 28px rgba(0,0,0,0.38)',
                  border: '1px solid #374151',
                  position: 'relative',
                  boxSizing: 'border-box',
                  margin: '0 auto',
                  padding: '15mm',
                  fontFamily: 'Times New Roman, Times, serif',
                  fontSize: '12pt',
                  color: '#1e293b',
                  lineHeight: '1.6',
                  overflow: 'hidden',
                }}
              >
                {/* Dashed margin guide */}
                <div
                  style={{ position: 'absolute', top: '15mm', left: '15mm', right: '15mm', bottom: '15mm', border: '1px dashed rgba(99,102,241,0.18)', pointerEvents: 'none', borderRadius: '2px' }}
                />
                {/* Report content */}
                <div className="report-body">
                  {renderPageElements(pageItems)}
                </div>
                {/* Page number */}
                <div
                  style={{ position: 'absolute', bottom: '8mm', left: 0, right: 0, textAlign: 'center', fontSize: '9pt', color: '#94a3b8', fontFamily: 'Times New Roman, serif' }}
                >
                  Page {pageIdx + 1} of {pages.length}
                </div>
              </div>
              {/* Page gap indicator */}
              {pageIdx < pages.length - 1 && (
                <div
                  style={{ height: '24px', display: 'flex', alignItems: 'center', justifyContent: 'center', width: '210mm', margin: '0 auto' }}
                >
                  <div style={{ flex: 1, height: '1px', background: 'rgba(209,213,219,0.3)' }} />
                  <span style={{ color: '#9ca3af', fontSize: '10px', margin: '0 10px', fontFamily: 'sans-serif', letterSpacing: '0.04em' }}>— page break —</span>
                  <div style={{ flex: 1, height: '1px', background: 'rgba(209,213,219,0.3)' }} />
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  // ── Top bar button style ──────────────────────────────────────────────────────
  const tabBtn = (active, color = '#4f46e5') => ({
    display: 'flex', alignItems: 'center', gap: '5px',
    padding: '6px 13px', borderRadius: '9px', cursor: 'pointer',
    fontSize: '12px', fontWeight: 'bold', transition: 'all 0.15s', border: 'none',
    background: active ? (color + '18') : 'transparent',
    color: active ? color : '#64748b',
    outline: active ? ('1.5px solid ' + color) : '1.5px solid transparent',
  });

  // ── RENDER ───────────────────────────────────────────────────────────────────
  if (loading) return (
    <div className="flex flex-col items-center justify-center min-h-[60vh]">
      <Loader2 className="w-10 h-10 text-primary-600 animate-spin mb-4" />
      <p className="text-gray-500 font-medium animate-pulse">Compiling Logbook Report Data...</p>
      <p className="text-xs text-gray-400 mt-2">This may take a few seconds as it fetches all records.</p>
    </div>
  );

  if (error || !courseAssignment) return (
    <div className="p-8 text-center max-w-lg mx-auto mt-10 bg-white rounded-2xl shadow-sm border border-red-100">
      <AlertTriangle className="w-12 h-12 text-red-500 mx-auto mb-4" />
      <h2 className="text-xl font-bold text-gray-800 mb-2">Error Generating Report</h2>
      <p className="text-gray-600 mb-6">{error}</p>
      <Link to={'/faculty/courses/' + assignmentId + '/lms'} className="px-5 py-2.5 bg-gray-100 text-gray-700 font-bold rounded-xl hover:bg-gray-200 transition-colors">Go Back</Link>
    </div>
  );

  return (
    <div style={{ minHeight: '100vh', background: mode === 'view' ? '#f8fafc' : 'transparent' }}>
      <style>{REPORT_STYLES}</style>

      {/* ── Top bar (always hidden on print) ── */}
      <div
        className="print-ui-hide"
        style={{ background: '#fff', borderBottom: '1px solid #e2e8f0', position: 'sticky', top: 0, zIndex: 200 }}
      >
        <div style={{ maxWidth: mode === 'view' ? '210mm' : '100%', margin: '0 auto', padding: '9px 16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '10px' }}>

          {/* Back link */}
          <Link
            to={'/faculty/courses/' + assignmentId + '/lms'}
            style={{ display: 'flex', alignItems: 'center', gap: '5px', color: '#64748b', textDecoration: 'none', fontSize: '12px', fontWeight: '600', flexShrink: 0 }}
          >
            <ArrowLeft size={15} /> Back
          </Link>

          {/* Mode tabs: View | Print Layout Editor */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '3px', background: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: '11px', padding: '3px' }}>
            <button style={tabBtn(mode === 'view')} onClick={() => setMode('view')}>
              <FileText size={13} /> View
            </button>
            <button style={tabBtn(mode === 'layout', '#7c3aed')} onClick={() => setMode('layout')}>
              <Layout size={13} /> Print Layout Editor
            </button>
          </div>

          {/* Right action buttons — context-aware */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexShrink: 0 }}>
            {(saveSuccess || saveLayoutSuccess) && (
              <span style={{ color: '#059669', fontSize: '11px', fontWeight: 'bold', display: 'flex', alignItems: 'center', gap: '4px' }}>
                <CheckCircle size={13} /> Saved!
              </span>
            )}

            {/* Save K-Levels: only visible in View mode */}
            {mode === 'view' && (
              <button
                onClick={handleSaveKLevels}
                disabled={savingKLevels}
                style={{ display: 'flex', alignItems: 'center', gap: '5px', padding: '6px 13px', background: '#4f46e5', color: '#fff', border: 'none', borderRadius: '9px', cursor: 'pointer', fontSize: '12px', fontWeight: 'bold', opacity: savingKLevels ? 0.55 : 1 }}
              >
                <Save size={13} /> {savingKLevels ? 'Saving…' : 'Save K-Levels'}
              </button>
            )}

            {/* Download as PDF — only in Print Layout Editor */}
            {mode === 'layout' && (
              <>
                <button
                  onClick={handleSaveLayout}
                  style={{ display: 'flex', alignItems: 'center', gap: '5px', padding: '6px 13px', background: '#7c3aed', color: '#fff', border: 'none', borderRadius: '9px', cursor: 'pointer', fontSize: '12px', fontWeight: 'bold' }}
                >
                  <Save size={13} /> Save Layout
                </button>
                <button
                  onClick={handleDiscardLayout}
                  style={{ display: 'flex', alignItems: 'center', gap: '5px', padding: '6px 13px', background: '#dc2626', color: '#fff', border: 'none', borderRadius: '9px', cursor: 'pointer', fontSize: '12px', fontWeight: 'bold' }}
                >
                  <RotateCcw size={13} /> Discard
                </button>
                <button
                  onClick={downloadPDF}
                  disabled={generatingPDF}
                  style={{ display: 'flex', alignItems: 'center', gap: '5px', padding: '6px 13px', background: '#0f766e', color: '#fff', border: 'none', borderRadius: '9px', cursor: 'pointer', fontSize: '12px', fontWeight: 'bold', opacity: generatingPDF ? 0.55 : 1 }}
                >
                  {generatingPDF ? <Loader2 size={13} className="animate-spin" /> : <Download size={13} />}
                  {generatingPDF ? 'Generating...' : 'Download PDF'}
                </button>
              </>
            )}

            {/* Print — prints all pages of the current view */}
            <button
              onClick={printAllPages}
              disabled={generatingPDF}
              style={{ display: 'flex', alignItems: 'center', gap: '5px', padding: '6px 13px', background: '#1e293b', color: '#fff', border: 'none', borderRadius: '9px', cursor: 'pointer', fontSize: '12px', fontWeight: 'bold', opacity: generatingPDF ? 0.55 : 1 }}
            >
              <Printer size={13} /> Print
            </button>
          </div>
        </div>
      </div>

      {mode === 'view'   && renderViewMode()}
      {mode === 'layout' && renderLayoutMode()}

      {/*
        lms-print-output: ALWAYS in the DOM. Hidden on screen via CSS (display:none
        is not set inline — it is the @media print rules that make it visible).
        This is the single source of truth for both Print and PDF Export.
        It exists outside of any print-ui-hide container so @media print can
        display it correctly regardless of which mode the user is in.
      */}
      <div
        className="lms-print-output"
        aria-hidden="true"
        style={{
          // Hidden on screen — @media print overrides this to display:block
          display: 'none',
        }}
      >
        {pages.map((pageItems, pageIdx) => (
          <div
            key={pageIdx}
            className="a4-print-page"
            style={{
              width: '210mm',
              minHeight: '297mm',
              padding: '15mm',
              boxSizing: 'border-box',
              background: '#fff',
              position: 'relative',
              fontFamily: 'Times New Roman, Times, serif',
              fontSize: '12pt',
              color: '#1e293b',
              lineHeight: '1.6',
              overflow: 'hidden',
            }}
          >
            <div className="report-body">
              {renderPageElements(pageItems)}
            </div>
            <div
              className="a4-page-number"
              style={{ position: 'absolute', bottom: '8mm', left: 0, right: 0, textAlign: 'center', fontSize: '9pt', color: '#94a3b8', fontFamily: 'Times New Roman, serif' }}
            >
              Page {pageIdx + 1} of {pages.length}
            </div>
          </div>
        ))}
      </div>

      {/* Measure container: rendered offscreen so offsetHeight can be read accurately */}
      <div
        id="report-measure-container"
        className="print-ui-hide report-body"
        style={{
          position: 'absolute',
          left: '-9999px',
          top: '-9999px',
          width: '180mm', // content area width of A4 (210mm - 30mm margins)
          background: '#fff',
          fontFamily: 'Times New Roman, Times, serif',
          fontSize: '12pt',
          lineHeight: '1.6',
          display: 'block',
          pointerEvents: 'none',
        }}
      >
        {visibleSections.map(id => (
          <div key={id} id={`measure-${id}`} className="measure-section">
            {id === 'cover' && renderSection('cover')}
            {['dept-vision', 'dept-mission', 'peos', 'pos', 'psos', 'course-objectives', 'syllabus', 'textbooks', 'references'].includes(id) && (
              <div className="measure-prose">
                <div className="section-header">
                  <SectionHeader title={SECTION_LABELS[id]} />
                </div>
                {highlightReportText(
                  id === 'dept-vision' ? department?.vision :
                  id === 'dept-mission' ? department?.mission :
                  id === 'peos' ? department?.peos :
                  id === 'pos' ? programOutcomes?.outcomes :
                  id === 'psos' ? department?.psos :
                  id === 'course-objectives' ? course.objectives :
                  id === 'syllabus' ? course.syllabus :
                  id === 'textbooks' ? course.textbooks :
                  course.references
                )}
              </div>
            )}
            {id === 'course-outcomes' && renderSection('course-outcomes')}
            {id === 'po-co-mapping' && renderSection('po-co-mapping')}
            {['course-plan', 'attendance', 'seminars', 'gradebook'].includes(id) && (
              <div className="measure-table">
                <div className="section-header">
                  <SectionHeader title={SECTION_LABELS[id]} />
                </div>
                <table className="report-table">
                  <thead>{renderTableHeader(id)}</thead>
                  <tbody>
                    {(id === 'course-plan' ? coursePlan :
                      id === 'attendance' ? gradebook :
                      id === 'seminars' ? seminars :
                      gradebook
                    ).map((item, idx) => (
                      <tr key={idx} className="report-table-row">
                        {id === 'course-plan' && (
                          <>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{item.sequence_no}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.unit}</td>
                            <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{item.topic}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.hours}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.proposed_date ? formatDate(item.proposed_date) : '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.actual_date ? formatDate(item.actual_date) : '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.cognitive_level || '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.mode_of_delivery || '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{item.is_signed ? 'Signed' : item.actual_date ? 'Done' : 'Pending'}</td>
                          </>
                        )}
                        {id === 'attendance' && (
                          <>
                            <td style={tdLeftStyle}>{item.register_number}</td>
                            <td style={tdLeftStyle}>{item.name}</td>
                            <td style={tdStyle}>{getStudentAttendanceSummary(item.student_id).conducted}</td>
                            <td style={tdStyle}>{getStudentAttendanceSummary(item.student_id).attended}</td>
                            <td style={{ ...tdStyle, fontWeight: 'bold' }}>{getStudentAttendanceSummary(item.student_id).percentage}</td>
                          </>
                        )}
                        {id === 'seminars' && (
                          <>
                            <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{item.register_number}</td>
                            <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{item.first_name + ' ' + item.last_name}</td>
                            <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{item.seminar_topic || 'Not Assigned'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt' }}>{item.seminar_date ? formatDate(item.seminar_date) : '—'}</td>
                            {SEMINAR_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{item[c.key] != null ? item[c.key] : '—'}</td>)}
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{item.marks_obtained != null ? item.marks_obtained : '—'}</td>
                          </>
                        )}
                        {id === 'gradebook' && (
                          <>
                            <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{item.register_number}</td>
                            <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{item.name}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{item.cia_1 ?? '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{item.cia_1_retest ?? '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{item.cia_2 ?? '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{item.cia_2_retest ?? '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{item.model_exam ?? '—'}</td>
                            <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold', color: '#991b1b' }}>{item.model_exam_retest ?? '—'}</td>
                          </>
                        )}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
            {id === 'assignments' && (
              <div className="measure-assignments">
                <div className="section-header">
                  <SectionHeader title="15. Assignments Marks Report" />
                </div>
                {assignmentMeta.map((asgn, aIdx) => (
                  <div key={asgn.id} className="assignment-block">
                    <p className="assignment-title" style={{ fontFamily: 'Times New Roman, serif', fontSize: '13pt', fontWeight: 'bold', marginBottom: '8px', color: '#1e293b' }}>
                      Assignment {aIdx + 1}: {asgn.title}
                    </p>
                    <table className="report-table">
                      <thead>
                        <tr>
                          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left', width: '100px' }}>Reg No.</th>
                          <th style={{ ...thStyle, fontSize: '9pt', textAlign: 'left' }}>Student Name</th>
                          <th style={{ ...thStyle, fontSize: '9pt', width: '65px' }}>Total</th>
                          {ASSIGNMENT_RUBRIC.map(c => <th key={c.key} style={{ ...thStyle, fontSize: '8pt', width: '64px' }}>{c.label}<br /><span style={{ fontWeight: 'normal', fontSize: '7pt' }}>/{c.max}</span></th>)}
                        </tr>
                      </thead>
                      <tbody>
                        {(assignmentRosters[asgn.id] || []).map((g, rIdx) => {
                          const rubric = parseRubric(g.remarks);
                          return (
                            <tr key={g.student_id} className="report-table-row">
                              <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.register_number}</td>
                              <td style={{ ...tdLeftStyle, fontSize: '9pt' }}>{g.first_name} {g.last_name}</td>
                              <td style={{ ...tdStyle, fontSize: '9pt', fontWeight: 'bold' }}>{g.marks_obtained != null ? g.marks_obtained : '—'}</td>
                              {ASSIGNMENT_RUBRIC.map(c => <td key={c.key} style={{ ...tdStyle, fontSize: '9pt' }}>{rubric ? (rubric[c.key] != null ? rubric[c.key] : '—') : '—'}</td>)}
                            </tr>
                          );
                        })}
                      </tbody>
                    </table>
                  </div>
                ))}
              </div>
            )}
            {id === 'footer' && renderSection('footer')}
          </div>
        ))}
      </div>
    </div>
  );
};
