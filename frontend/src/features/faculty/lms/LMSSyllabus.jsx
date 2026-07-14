import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import { 
  ArrowLeft, Save, Plus, Trash2, ClipboardList, CheckCircle2, 
  AlertTriangle, Calendar, BookOpen, Clock, FileText, Settings, Users,
  ChevronDown, Edit2, Grid3x3
} from 'lucide-react';

const COLOR_THEMES = {
  orange: {
    borderFocus: "border-orange-500 ring-2 ring-orange-100/50",
    tag: "bg-orange-50 text-orange-700 border-orange-200/50",
    chevronActive: "text-orange-500",
    optionSelected: "bg-orange-50/60 text-orange-900",
    checkboxOn: "bg-orange-600 border-orange-600",
  },
  blue: {
    borderFocus: "border-blue-500 ring-2 ring-blue-100/50",
    tag: "bg-blue-50 text-blue-700 border-blue-200/50",
    chevronActive: "text-blue-500",
    optionSelected: "bg-blue-50/60 text-blue-900",
    checkboxOn: "bg-blue-600 border-blue-600",
  },
  emerald: {
    borderFocus: "border-emerald-500 ring-2 ring-emerald-100/50",
    tag: "bg-emerald-50 text-emerald-700 border-emerald-200/50",
    chevronActive: "text-emerald-500",
    optionSelected: "bg-emerald-50/60 text-emerald-900",
    checkboxOn: "bg-emerald-600 border-emerald-600",
  },
  violet: {
    borderFocus: "border-violet-500 ring-2 ring-violet-100/50",
    tag: "bg-violet-50 text-violet-700 border-violet-200/50",
    chevronActive: "text-violet-500",
    optionSelected: "bg-violet-50/60 text-violet-900",
    checkboxOn: "bg-violet-600 border-violet-600",
  },
};

const DropdownSelectInput = ({ value, onChange, options, isMulti = false, placeholder = "Select...", onBlur, color = "orange" }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [inputValue, setInputValue] = useState(value || "");
  const containerRef = React.useRef(null);
  const inputRef = React.useRef(null);
  const theme = COLOR_THEMES[color] || COLOR_THEMES.orange;

  // Sync state with parent value
  useEffect(() => {
    setInputValue(value || "");
  }, [value]);

  // Focus input when opened
  useEffect(() => {
    if (isOpen && inputRef.current) {
      inputRef.current.focus();
    }
  }, [isOpen]);

  // Handle outside click to close dropdown and fire onBlur
  useEffect(() => {
    const handleOutsideClick = (e) => {
      if (containerRef.current && !containerRef.current.contains(e.target)) {
        if (isOpen) {
          setIsOpen(false);
          if (onBlur) {
            onBlur();
          }
        }
      }
    };
    document.addEventListener("mousedown", handleOutsideClick);
    return () => document.removeEventListener("mousedown", handleOutsideClick);
  }, [isOpen, onBlur]);

  const handleInputChange = (e) => {
    const val = e.target.value;
    setInputValue(val);
    onChange(val);
  };

  const handleOptionToggle = (option) => {
    if (isMulti) {
      let currentValues = inputValue
        .split(",")
        .map(v => v.trim())
        .filter(v => v !== "");
      
      if (currentValues.includes(option)) {
        currentValues = currentValues.filter(v => v !== option);
      } else {
        currentValues.push(option);
      }
      
      const newVal = currentValues.join(", ");
      setInputValue(newVal);
      onChange(newVal);
    } else {
      setInputValue(option);
      onChange(option);
      setIsOpen(false);
      if (onBlur) {
        setTimeout(() => onBlur(), 0);
      }
    }
  };

  const activeValues = inputValue.split(",").map(v => v.trim()).filter(Boolean);

  return (
    <div ref={containerRef} className="relative w-full text-left">
      <div 
        onClick={() => setIsOpen(true)}
        className={`flex items-center min-h-[34px] w-full border rounded-xl bg-white shadow-sm transition-all duration-200 cursor-pointer ${
          isOpen 
            ? theme.borderFocus
            : "border-gray-200 hover:border-gray-300"
        }`}
      >
        <div className="flex-1 flex flex-wrap gap-1 p-1.5 overflow-hidden">
          {(!isOpen && activeValues.length > 0) ? (
            activeValues.map((val) => (
              <span 
                key={val}
                className={`inline-flex items-center px-2 py-0.5 rounded-md text-[10px] font-bold border ${theme.tag}`}
              >
                {val}
              </span>
            ))
          ) : (
            <input
              ref={inputRef}
              type="text"
              value={inputValue}
              onChange={handleInputChange}
              placeholder={placeholder}
              className="w-full bg-transparent border-0 p-0 px-1 text-xs font-semibold text-gray-800 placeholder-gray-400 focus:ring-0 focus:outline-none"
            />
          )}
        </div>
        <div className="flex items-center pr-2 pl-1">
          <ChevronDown 
            className={`w-3.5 h-3.5 text-gray-400 transition-transform duration-200 ${
              isOpen ? `transform rotate-180 ${theme.chevronActive}` : ""
            }`} 
          />
        </div>
      </div>
      
      {isOpen && (
        <div className="absolute left-0 z-50 mt-1 min-w-[140px] bg-white/95 backdrop-blur-sm border border-gray-200/80 rounded-xl shadow-xl max-h-48 overflow-y-auto py-1">
          {options.map((opt) => {
            const isSelected = isMulti 
              ? activeValues.includes(opt)
              : inputValue.trim() === opt;
            
            return (
              <div
                key={opt}
                onClick={() => handleOptionToggle(opt)}
                className={`flex items-center justify-between px-3 py-1.5 text-xs font-semibold cursor-pointer select-none transition-colors duration-150 ${
                  isSelected 
                    ? `${theme.optionSelected} font-bold` 
                    : "text-gray-700 hover:bg-slate-50"
                }`}
              >
                <div className="flex items-center gap-2">
                  <div className={`w-3.5 h-3.5 rounded flex items-center justify-center border transition-all duration-150 ${
                    isSelected 
                      ? `${theme.checkboxOn} text-white` 
                      : "border-gray-300 bg-white"
                  }`}>
                    {isSelected && (
                      <svg className="w-2 h-2 fill-current" viewBox="0 0 20 20">
                        <path d="M0 11l2-2 5 5L18 3l2 2L7 18z" />
                      </svg>
                    )}
                  </div>
                  <span>{opt}</span>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};


// ── CO-PO/PSO Mapping Helpers (Faculty LMS) ────────────────────────
const CO_PO_BADGE_STYLES = {
  'N': 'bg-gray-100 text-gray-600 border border-gray-200',
  'L': 'bg-blue-100 text-blue-700 border border-blue-200',
  'M': 'bg-amber-100 text-amber-700 border border-amber-200',
  'H': 'bg-green-100 text-green-700 border border-green-200',
};

const getLMSCoPOConfig = (courseType) => ({
  coCount: courseType === 'lab' ? 6 : 10,
  psoCount: courseType === 'lab' ? 2 : 3,
});

const parseLMSMappingJSON = (raw) => {
  if (!raw) return {};
  if (typeof raw === 'object') return raw;
  try { return JSON.parse(raw); } catch { return {}; }
};

/** Read-only view of CO-PO table (for faculty view mode). */
const LMSCoPOViewTable = ({ mapping, courseType }) => {
  const { coCount, psoCount } = getLMSCoPOConfig(courseType);
  const coRows    = Array.from({ length: coCount },  (_, i) => `CO-${i + 1}`);
  const poColumns = Array.from({ length: 12 },      (_, i) => `PO-${i + 1}`);
  const psoColumns = Array.from({ length: psoCount }, (_, i) => `PSO-${i + 1}`);
  const allCols = [...poColumns, ...psoColumns];

  return (
    <div className="overflow-x-auto border border-gray-200 rounded-xl">
      <table className="text-[11px] border-collapse" style={{ minWidth: '680px' }}>
        <thead>
          <tr>
            <th className="sticky left-0 z-20 bg-gray-50 border border-gray-200 px-3 py-2" rowSpan={2} />
            <th colSpan={12} className="bg-indigo-50 text-indigo-800 font-bold px-3 py-2 border border-gray-200 text-center">
              Programme Outcomes (POs)
            </th>
            <th colSpan={psoCount} className="bg-purple-50 text-purple-800 font-bold px-3 py-2 border border-gray-200 text-center">
              Programme Specific Outcomes (PSOs)
            </th>
          </tr>
          <tr>
            {poColumns.map(po => (
              <th key={po} className="bg-indigo-50/60 text-indigo-700 font-semibold px-1.5 py-1.5 border border-gray-200 text-center whitespace-nowrap" style={{ minWidth: '42px' }}>{po}</th>
            ))}
            {psoColumns.map(pso => (
              <th key={pso} className="bg-purple-50/60 text-purple-700 font-semibold px-1.5 py-1.5 border border-gray-200 text-center whitespace-nowrap" style={{ minWidth: '52px' }}>{pso}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {coRows.map(co => (
            <tr key={co} className="hover:bg-gray-50/50">
              <td className="sticky left-0 z-10 bg-white border border-gray-200 px-3 py-1.5 font-bold text-gray-700 whitespace-nowrap">{co}</td>
              {allCols.map(col => {
                const val = mapping?.[co]?.[col] || '';
                return (
                  <td key={col} className="border border-gray-200 px-1 py-1 text-center">
                    {val ? (
                      <span className={`inline-flex items-center justify-center w-6 h-5 rounded text-[11px] font-bold ${CO_PO_BADGE_STYLES[val] || ''}`}>{val}</span>
                    ) : (
                      <span className="text-gray-200">–</span>
                    )}
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
/** Editable CO-PO table with dropdowns (for faculty edit mode). */
const LMSCoPOEditTable = ({ mapping, courseType, onChange }) => {
  const { coCount, psoCount } = getLMSCoPOConfig(courseType);
  const coRows    = Array.from({ length: coCount },  (_, i) => `CO-${i + 1}`);
  const poColumns = Array.from({ length: 12 },      (_, i) => `PO-${i + 1}`);
  const psoColumns = Array.from({ length: psoCount }, (_, i) => `PSO-${i + 1}`);
  const allCols = [...poColumns, ...psoColumns];

  const handleCell = (co, col, value) => {
    const updated = { ...mapping };
    if (!updated[co]) updated[co] = {};
    if (value === '') {
      delete updated[co][col];
      if (Object.keys(updated[co]).length === 0) delete updated[co];
    } else {
      updated[co][col] = value;
    }
    onChange(updated);
  };

  const selectCls = (val) => {
    const base = 'w-full text-center text-[11px] font-bold rounded border-0 focus:outline-none focus:ring-1 focus:ring-primary-400 cursor-pointer appearance-none py-0.5';
    if (!val) return `${base} bg-transparent text-gray-400`;
    const cls = {
      'N': `${base} bg-gray-100 text-gray-700`,
      'L': `${base} bg-blue-100 text-blue-700`,
      'M': `${base} bg-amber-100 text-amber-700`,
      'H': `${base} bg-green-100 text-green-700`,
    };
    return cls[val] || `${base} bg-transparent`;
  };

  return (
    <div className="overflow-x-auto border border-indigo-200 rounded-xl">
      <table className="text-[11px] border-collapse" style={{ minWidth: '680px' }}>
        <thead>
          <tr>
            <th className="sticky left-0 z-20 bg-indigo-50 border border-indigo-200 px-3 py-2" rowSpan={2} />
            <th colSpan={12} className="bg-indigo-100 text-indigo-900 font-bold px-3 py-2 border border-indigo-200 text-center">
              Programme Outcomes (POs)
            </th>
            <th colSpan={psoCount} className="bg-purple-100 text-purple-900 font-bold px-3 py-2 border border-indigo-200 text-center">
              Programme Specific Outcomes (PSOs)
            </th>
          </tr>
          <tr>
            {poColumns.map(po => (
              <th key={po} className="bg-indigo-50 text-indigo-700 font-semibold px-1.5 py-1.5 border border-indigo-200 text-center whitespace-nowrap" style={{ minWidth: '46px' }}>{po}</th>
            ))}
            {psoColumns.map(pso => (
              <th key={pso} className="bg-purple-50 text-purple-700 font-semibold px-1.5 py-1.5 border border-indigo-200 text-center whitespace-nowrap" style={{ minWidth: '54px' }}>{pso}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {coRows.map(co => (
            <tr key={co} className="hover:bg-indigo-50/30">
              <td className="sticky left-0 z-10 bg-white border border-indigo-200 px-3 py-1 font-bold text-gray-700 whitespace-nowrap">{co}</td>
              {allCols.map(col => {
                const val = mapping?.[co]?.[col] || '';
                return (
                  <td key={col} className="border border-indigo-200 px-0.5 py-0.5">
                    <select
                      value={val}
                      onChange={(e) => handleCell(co, col, e.target.value)}
                      className={selectCls(val)}
                      style={{ minWidth: '38px' }}
                    >
                      <option value="">-</option>
                      <option value="N">N</option>
                      <option value="L">L</option>
                      <option value="M">M</option>
                      <option value="H">H</option>
                    </select>
                  </td>
                );
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
// ── End CO-PO helpers ─────────────────────────────────

export const LMSSyllabus = () => {
  const { assignmentId } = useParams();
  
  const [topics, setTopics] = useState([]);
  const [courseDetails, setCourseDetails] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState(null);

  // View state: "selection" (landing), "write" (planning sheet), "record" (coverage sheet), or "details" (syllabus & details)
  const [viewMode, setViewMode] = useState("selection");

  const [isEditingDetails, setIsEditingDetails] = useState(false);
  const [detailsForm, setDetailsForm] = useState({
    syllabus: '',
    objectives: '',
    outcomes: '',
    textbooks: '',
    references: '',
    prerequisites: '',
    co_po_mapping: {}
  });


  useEffect(() => {
    fetchPlan();
    fetchCourseDetails();
  }, [assignmentId]);

  const fetchPlan = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await axios.get(`/api/course-plan/${assignmentId}`);
      const fetchedTopics = response.data.topics || [];
      setTopics(fetchedTopics);
    } catch (err) {
      console.error("Failed to fetch course plan:", err);
      setError("Failed to load course plan. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  const fetchCourseDetails = async () => {
    try {
      const response = await axios.get('/api/faculty/me/courses');
      const currentCourse = response.data.find(c => c.id.toString() === assignmentId);
      if (currentCourse) {
        setCourseDetails(currentCourse);
        setDetailsForm({
          syllabus: currentCourse.course?.syllabus || '',
          objectives: currentCourse.course?.objectives || '',
          outcomes: currentCourse.course?.outcomes || '',
          textbooks: currentCourse.course?.textbooks || '',
          references: currentCourse.course?.references || '',
          prerequisites: currentCourse.course?.prerequisites || '',
          co_po_mapping: parseLMSMappingJSON(currentCourse.course?.co_po_mapping)
        });
      }
    } catch (err) {
      console.error("Failed to fetch course details:", err);
    }
  };

  const handleSaveDetails = async (e) => {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setSuccessMessage(null);
    try {
      const courseId = courseDetails.course.id;
      const payload = {
        ...detailsForm,
        co_po_mapping: JSON.stringify(detailsForm.co_po_mapping || {})
      };
      const response = await axios.put(`/api/courses/${courseId}`, payload);
      // Update local state
      setCourseDetails(prev => ({
        ...prev,
        course: {
          ...prev.course,
          ...response.data
        }
      }));
      setSuccessMessage("Course details updated successfully!");
      setIsEditingDetails(false);
    } catch (err) {
      console.error("Failed to save course details:", err);
      setError(err.response?.data?.detail || "Failed to save course details.");
    } finally {
      setSaving(false);
    }
  };

  const handleCancelDetails = () => {
    setDetailsForm({
      syllabus: courseDetails.course?.syllabus || '',
      objectives: courseDetails.course?.objectives || '',
      outcomes: courseDetails.course?.outcomes || '',
      textbooks: courseDetails.course?.textbooks || '',
      references: courseDetails.course?.references || '',
      prerequisites: courseDetails.course?.prerequisites || '',
      co_po_mapping: parseLMSMappingJSON(courseDetails.course?.co_po_mapping)
    });
    setIsEditingDetails(false);
    setError(null);
    setSuccessMessage(null);
  };

  // Save changes to backend
  const savePlanToBackend = async (updatedTopics = topics) => {
    setSaving(true);
    setSuccessMessage(null);
    setError(null);

    // Validation: proposed date vs actual date deviation reason
    const errors = updatedTopics.filter(t => {
      if (t.actual_date && t.proposed_date) {
        const actualStr = t.actual_date.split('T')[0];
        const proposedStr = t.proposed_date.split('T')[0];
        if (actualStr !== proposedStr) {
          return !t.reason_for_deviation || t.reason_for_deviation.trim() === "";
        }
      }
      return false;
    });

    if (errors.length > 0) {
      alert(`Cannot save! There are ${errors.length} topic(s) where Actual Date differs from Proposed Date but no Reason for Deviation is provided.`);
      setSaving(false);
      return false;
    }

    try {
      const payloadTopics = updatedTopics.map(t => {
        // Automatically clear reason if dates match
        let finalReason = t.reason_for_deviation || "";
        if (t.actual_date && t.proposed_date) {
          const actualStr = t.actual_date.split('T')[0];
          const proposedStr = t.proposed_date.split('T')[0];
          if (actualStr === proposedStr) {
            finalReason = "";
          }
        }
        return {
          ...t,
          reason_for_deviation: finalReason,
          is_signed: !!t.actual_date
        };
      });

      const response = await axios.post(`/api/course-plan/${assignmentId}`, { topics: payloadTopics });
      setTopics(response.data.topics || []);
      setSuccessMessage("Changes saved successfully!");
      return true;
    } catch (err) {
      console.error("Failed to save plan:", err);
      setError(err.response?.data?.detail || "Failed to save the plan. Please check validations.");
      return false;
    } finally {
      setSaving(false);
    }
  };

  // Add new topic row (Write Mode)
  const addRow = () => {
    setSuccessMessage(null);
    const newSeq = topics.length + 1;
    const lastRow = topics[topics.length - 1];
    
    let proposedDateStr = new Date().toISOString().split('T')[0];
    if (lastRow && lastRow.proposed_date) {
      const lastDate = new Date(lastRow.proposed_date);
      lastDate.setDate(lastDate.getDate() + 2);
      proposedDateStr = lastDate.toISOString().split('T')[0];
    }

    setTopics(prev => [
      ...prev,
      {
        sequence_no: newSeq,
        proposed_date: proposedDateStr,
        hours: 1,
        unit: lastRow ? lastRow.unit : "1",
        topic: "",
        cognitive_level: "K1",
        co: "CO1",
        po: "PO1",
        mode_of_delivery: "BB",
        actual_date: null,
        reason_for_deviation: "",
        is_signed: false
      }
    ]);
  };

  // Delete topic row (Write Mode)
  const removeRow = (index) => {
    setSuccessMessage(null);
    setTopics(prev => {
      const filtered = prev.filter((_, idx) => idx !== index);
      return filtered.map((t, idx) => ({ ...t, sequence_no: idx + 1 }));
    });
  };

  // Edit fields inline in tables by sequence number
  const handleRowChange = (sequenceNo, field, value) => {
    setSuccessMessage(null);
    setTopics(prev => prev.map(t => {
      if (t.sequence_no !== sequenceNo) return t;
      const updated = { ...t, [field]: value };
      
      if (field === 'actual_date' && !value) {
        updated.is_signed = false;
        updated.reason_for_deviation = "";
      }
      
      // Clear deviation reason if actual date matches proposed date
      if (field === 'actual_date' && value && t.proposed_date) {
        const actualStr = value.split('T')[0];
        const proposedStr = t.proposed_date.split('T')[0];
        if (actualStr === proposedStr) {
          updated.reason_for_deviation = "";
        }
      }

      return updated;
    }));
  };

  // Filter topics for Record table (Only show covered ones)
  const coveredTopics = topics.filter(t => t.actual_date !== null && t.actual_date !== "");

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  const courseCode = courseDetails?.course?.code || "N/A";
  const courseTitle = courseDetails?.course?.name || "N/A";

  // 1. LANDING DASHBOARD CARD VIEW
  if (viewMode === "selection") {
    return (
      <div className="max-w-7xl mx-auto space-y-8 p-4 md:p-6 lg:p-8">
        
        {/* Breadcrumb Header */}
        <div>
          <div className="flex items-center gap-3 mb-2">
            <Link 
              to={`/faculty/courses/${assignmentId}/lms`} 
              className="text-gray-500 hover:text-primary-600 transition-colors flex items-center gap-1 text-sm font-medium"
            >
              <ArrowLeft className="w-4 h-4" /> Back to My Courses
            </Link>
          </div>
          <h1 className="text-3xl font-extrabold text-gray-900 tracking-tight">Lesson Plan</h1>
          <p className="text-sm text-gray-500 mt-1 font-medium">Manage lesson planning and coverage records</p>
        </div>

        {/* Selection Cards (mockup styling matching Course Dashboard) */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-6xl pt-4">
          
          {/* Card 1: Write Lesson Plan */}
          <div
            onClick={() => setViewMode("write")}
            className="group flex flex-col bg-white border-2 border-gray-100 rounded-2xl p-6 transition-all duration-300 ease-out hover:-translate-y-1 hover:shadow-lg hover:border-orange-300 hover:shadow-orange-100 cursor-pointer relative overflow-hidden"
          >
            {/* Background blob */}
            <div className="absolute -right-6 -top-6 w-24 h-24 rounded-full opacity-20 bg-orange-50 blur-2xl group-hover:scale-150 transition-transform duration-500"></div>
            
            <div className="w-14 h-14 rounded-xl bg-orange-50 border border-orange-100 flex items-center justify-center mb-5 relative z-10 transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3">
              <Settings className="w-8 h-8 text-orange-600" />
            </div>
            
            <h3 className="text-xl font-bold text-gray-900 mb-2 relative z-10">
              Write Lesson Plan
            </h3>
            
            <p className="text-gray-500 text-sm font-medium leading-relaxed relative z-10">
              Plan topics, record proposed dates, and schedule Units to make them available in the daily attendance page.
            </p>
            
            <div className="mt-auto pt-6 flex items-center text-sm font-bold text-gray-400 group-hover:text-gray-950 transition-colors relative z-10">
              Manage Write Lesson Plan <ArrowLeft className="w-4 h-4 ml-1 rotate-180 transition-transform group-hover:translate-x-1" />
            </div>
          </div>

          {/* Card 2: Coverage Record */}
          <div
            onClick={() => setViewMode("record")}
            className="group flex flex-col bg-white border-2 border-gray-100 rounded-2xl p-6 transition-all duration-300 ease-out hover:-translate-y-1 hover:shadow-lg hover:border-green-300 hover:shadow-green-100 cursor-pointer relative overflow-hidden"
          >
            {/* Background blob */}
            <div className="absolute -right-6 -top-6 w-24 h-24 rounded-full opacity-20 bg-green-50 blur-2xl group-hover:scale-150 transition-transform duration-500"></div>
            
            <div className="w-14 h-14 rounded-xl bg-green-50 border border-green-100 flex items-center justify-center mb-5 relative z-10 transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3">
              <Users className="w-8 h-8 text-green-600" />
            </div>
            
            <h3 className="text-xl font-bold text-gray-900 mb-2 relative z-10">
              Coverage Record
            </h3>
            
            <p className="text-gray-500 text-sm font-medium leading-relaxed relative z-10">
              View work done progress. The covered dates log automatically from Daily Attendance, allowing manual entry of deviation reasons.
            </p>
            
            <div className="mt-auto pt-6 flex items-center text-sm font-bold text-gray-400 group-hover:text-gray-950 transition-colors relative z-10">
              Manage Coverage Records <ArrowLeft className="w-4 h-4 ml-1 rotate-180 transition-transform group-hover:translate-x-1" />
            </div>
          </div>

          {/* Card 3: Course Details */}
          <div
            onClick={() => setViewMode("details")}
            className="group flex flex-col bg-white border-2 border-gray-100 rounded-2xl p-6 transition-all duration-300 ease-out hover:-translate-y-1 hover:shadow-lg hover:border-blue-300 hover:shadow-blue-100 cursor-pointer relative overflow-hidden"
          >
            {/* Background blob */}
            <div className="absolute -right-6 -top-6 w-24 h-24 rounded-full opacity-20 bg-blue-50 blur-2xl group-hover:scale-150 transition-transform duration-500"></div>
            
            <div className="w-14 h-14 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center mb-5 relative z-10 transition-transform duration-300 group-hover:scale-110 group-hover:rotate-3">
              <BookOpen className="w-8 h-8 text-blue-600" />
            </div>
            
            <h3 className="text-xl font-bold text-gray-900 mb-2 relative z-10">
              Syllabus & Course Details
            </h3>
            
            <p className="text-gray-500 text-sm font-medium leading-relaxed relative z-10">
              View and edit course syllabus, objectives, outcomes, prerequisites, textbooks, and references.
            </p>
            
            <div className="mt-auto pt-6 flex items-center text-sm font-bold text-gray-400 group-hover:text-gray-950 transition-colors relative z-10">
              Manage Syllabus & Details <ArrowLeft className="w-4 h-4 ml-1 rotate-180 transition-transform group-hover:translate-x-1" />
            </div>
          </div>

        </div>

      </div>
    );
  }

  // ── DETAILS MODE ──
  if (viewMode === "details") {
    const course = courseDetails?.course;
    const isLab = course?.course_type === 'lab';
    return (
      <div className="max-w-7xl mx-auto space-y-6 p-4 md:p-6 lg:p-8 bg-white rounded-2xl shadow-sm border border-gray-200">
        {/* Breadcrumb Header */}
        <div className="flex items-center justify-between border-b border-gray-200 pb-4">
          <button 
            onClick={() => { setViewMode("selection"); setSuccessMessage(null); setError(null); setIsEditingDetails(false); }}
            className="text-gray-600 hover:text-primary-600 flex items-center gap-1 text-sm font-bold transition-colors focus:outline-none"
          >
            <ArrowLeft className="w-4 h-4" /> Back to Selection Mode
          </button>
          <span className="text-xs font-bold text-gray-400">Course Syllabus & Details</span>
        </div>

        <div>
          <h1 className="text-2xl font-extrabold text-gray-905 tracking-tight">Syllabus & Course Details</h1>
          <p className="text-xs font-semibold text-gray-500 mt-1">
            Course: <span className="font-mono text-gray-800">{courseCode}</span> &nbsp;·&nbsp; <span className="uppercase text-gray-800">{courseTitle}</span>
          </p>
        </div>

        {/* Messages */}
        {successMessage && (
          <div className="p-3 bg-green-50 text-green-700 text-xs font-bold rounded-lg border border-green-200 flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 text-green-600" /> {successMessage}
          </div>
        )}
        {error && (
          <div className="p-3 bg-red-50 text-red-700 text-xs font-bold rounded-lg border border-red-200 flex items-center gap-2">
            <AlertTriangle className="w-4 h-4 text-red-600" /> {error}
          </div>
        )}

        {!isEditingDetails ? (
          /* View Mode */
          <div className="space-y-6">
            <div className="flex justify-end">
              <button
                onClick={() => setIsEditingDetails(true)}
                className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-xs font-bold text-white bg-primary-600 hover:bg-primary-700 transition-colors"
              >
                <Edit2 className="w-4 h-4" /> Edit Details
              </button>
            </div>

            <div className="grid grid-cols-1 gap-6">
              {isLab && (
                <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                  <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-2">Course Prerequisites</h3>
                  <div className="text-sm text-gray-600 whitespace-pre-wrap leading-relaxed">
                    {course?.prerequisites || <span className="text-gray-400 italic">No prerequisites defined.</span>}
                  </div>
                </div>
              )}

              <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-2">Course Objectives</h3>
                <div className="text-sm text-gray-600 whitespace-pre-wrap leading-relaxed">
                  {course?.objectives || <span className="text-gray-400 italic">No objectives defined.</span>}
                </div>
              </div>

              <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-2">Course Outcomes (COs)</h3>
                <div className="text-sm text-gray-600 whitespace-pre-wrap leading-relaxed">
                  {course?.outcomes || <span className="text-gray-400 italic">No course outcomes defined.</span>}
                </div>
              </div>

              <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-2">Syllabus</h3>
                <div className="text-sm text-gray-600 whitespace-pre-wrap leading-relaxed">
                  {course?.syllabus || <span className="text-gray-400 italic">No syllabus defined.</span>}
                </div>
              </div>

              <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-2">Textbooks</h3>
                <div className="text-sm text-gray-600 whitespace-pre-wrap leading-relaxed">
                  {course?.textbooks || <span className="text-gray-400 italic">No textbooks defined.</span>}
                </div>
              </div>

              <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-2">References</h3>
                <div className="text-sm text-gray-600 whitespace-pre-wrap leading-relaxed">
                  {course?.references || <span className="text-gray-400 italic">No references defined.</span>}
                </div>
              </div>

              {/* CO–PO/PSO Mapping – view mode */}
              <div className="bg-gray-50 p-5 rounded-xl border border-gray-200">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-7 h-7 bg-indigo-50 rounded-lg flex items-center justify-center">
                    <Grid3x3 className="w-4 h-4 text-indigo-600" />
                  </div>
                  <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider">CO–PO/PSO Mapping</h3>
                </div>
                <div className="flex flex-wrap gap-2 text-[10px] font-bold mb-3">
                  {[['H', 'High', 'bg-green-50 text-green-700 border-green-200'],
                    ['M', 'Medium', 'bg-amber-50 text-amber-700 border-amber-200'],
                    ['L', 'Low', 'bg-blue-50 text-blue-700 border-blue-200'],
                    ['N', 'No Contribution', 'bg-gray-50 text-gray-600 border-gray-200']].map(([code, label, cls]) => (
                    <span key={code} className={`px-2 py-0.5 rounded-full border ${cls}`}>{code} – {label}</span>
                  ))}
                </div>
                <LMSCoPOViewTable
                  mapping={parseLMSMappingJSON(course?.co_po_mapping)}
                  courseType={course?.course_type}
                />
              </div>
            </div>
          </div>
        ) : (
          /* Edit Mode */
          <form onSubmit={handleSaveDetails} className="space-y-6">
            {isLab && (
              <div>
                <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Prerequisites</label>
                <textarea
                  rows={4}
                  value={detailsForm.prerequisites}
                  onChange={(e) => setDetailsForm({ ...detailsForm, prerequisites: e.target.value })}
                  placeholder="Enter course prerequisites..."
                  className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[100px]"
                />
              </div>
            )}

            <div>
              <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Objectives</label>
              <textarea
                rows={4}
                value={detailsForm.objectives}
                onChange={(e) => setDetailsForm({ ...detailsForm, objectives: e.target.value })}
                placeholder="Enter course objectives..."
                className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[100px]"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Course Outcomes (COs)</label>
              <textarea
                rows={4}
                value={detailsForm.outcomes}
                onChange={(e) => setDetailsForm({ ...detailsForm, outcomes: e.target.value })}
                placeholder="Enter course outcomes..."
                className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[100px]"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Syllabus</label>
              <textarea
                rows={6}
                value={detailsForm.syllabus}
                onChange={(e) => setDetailsForm({ ...detailsForm, syllabus: e.target.value })}
                placeholder="Enter syllabus details..."
                className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[120px]"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Textbooks</label>
              <textarea
                rows={4}
                value={detailsForm.textbooks}
                onChange={(e) => setDetailsForm({ ...detailsForm, textbooks: e.target.value })}
                placeholder="Enter textbooks..."
                className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[100px]"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">References</label>
              <textarea
                rows={4}
                value={detailsForm.references}
                onChange={(e) => setDetailsForm({ ...detailsForm, references: e.target.value })}
                placeholder="Enter reference books..."
                className="w-full px-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-y min-h-[100px]"
              />
            </div>

            {/* CO–PO/PSO Mapping – edit mode */}
            <div className="border border-indigo-100 rounded-2xl p-5 bg-indigo-50/30">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-7 h-7 bg-indigo-100 rounded-lg flex items-center justify-center">
                  <Grid3x3 className="w-4 h-4 text-indigo-600" />
                </div>
                <span className="text-xs font-bold text-indigo-800 uppercase tracking-wider">CO–PO/PSO Mapping</span>
                <span className="text-[10px] bg-indigo-600 text-white font-bold px-2 py-0.5 rounded-full tracking-wide">Editable</span>
              </div>
              <p className="text-xs text-indigo-600/70 mb-3 ml-10">
                Select the contribution level for each CO–PO/PSO pair. Leave blank if no mapping.
              </p>
              <div className="flex flex-wrap gap-2 text-[10px] font-bold mb-3 ml-10">
                {[['H', 'High', 'bg-green-100 text-green-700 border-green-200'],
                  ['M', 'Medium', 'bg-amber-100 text-amber-700 border-amber-200'],
                  ['L', 'Low', 'bg-blue-100 text-blue-700 border-blue-200'],
                  ['N', 'No Contribution', 'bg-gray-100 text-gray-600 border-gray-200']].map(([code, label, cls]) => (
                  <span key={code} className={`px-2 py-0.5 rounded-full border ${cls}`}>{code} – {label}</span>
                ))}
              </div>
              <LMSCoPOEditTable
                mapping={detailsForm.co_po_mapping}
                courseType={course?.course_type}
                onChange={(updated) => setDetailsForm({ ...detailsForm, co_po_mapping: updated })}
              />
            </div>

            <div className="flex justify-end gap-3 pt-4 border-t border-gray-100">
              <button
                type="button"
                onClick={handleCancelDetails}
                className="px-5 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-100 rounded-xl transition-colors"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={saving}
                className="flex items-center gap-1.5 px-6 py-2.5 rounded-xl text-xs font-bold text-white bg-primary-600 hover:bg-primary-700 transition-colors disabled:bg-primary-400"
              >
                <Save className="w-4 h-4" /> {saving ? "Saving..." : "Save Details"}
              </button>
            </div>
          </form>
        )}
      </div>
    );
  }

  // 2. WORKSHEET ACTIVE VIEWS (WRITE & RECORD TABLES)
  return (
    <div className="max-w-7xl mx-auto space-y-6 p-4 md:p-6 lg:p-8 bg-white rounded-2xl shadow-sm border border-gray-200">
      
      {/* Small Back to Selection breadcrumb */}
      <div className="flex items-center justify-between border-b border-gray-200 pb-4">
        <button 
          onClick={() => { setViewMode("selection"); setSuccessMessage(null); setError(null); }}
          className="text-gray-600 hover:text-primary-600 flex items-center gap-1 text-sm font-bold transition-colors focus:outline-none"
        >
          <ArrowLeft className="w-4 h-4" /> Back to Selection Mode
        </button>
        <span className="text-xs font-bold text-gray-400">Course Plan</span>
      </div>

      {/* Simplified Header Title and Metadata */}
      <div>
        <h1 className="text-2xl font-extrabold text-gray-955 tracking-tight flex items-center gap-2">
          {viewMode === "write" ? "Write Lesson Plan" : "Coverage Record (Work Done)"}
        </h1>
        <p className="text-xs font-semibold text-gray-500 mt-1">
          Course: <span className="font-mono text-gray-800">{courseCode}</span> &nbsp;·&nbsp; <span className="uppercase text-gray-800">{courseTitle}</span>
        </p>
      </div>

      {/* Messages */}
      {successMessage && (
        <div className="p-3 bg-green-50 text-green-700 text-xs font-bold rounded-lg border border-green-200 flex items-center gap-2">
          <CheckCircle2 className="w-4 h-4 text-green-600" /> {successMessage}
        </div>
      )}
      {error && (
        <div className="p-3 bg-red-50 text-red-700 text-xs font-bold rounded-lg border border-red-200 flex items-center gap-2">
          <AlertTriangle className="w-4 h-4 text-red-600" /> {error}
        </div>
      )}

      {/* ── WRITE TABLE ── */}
      {viewMode === "write" && (
        <div className="space-y-4">
          
          <div className="flex items-center justify-between pb-1">
            <span className="text-xs font-extrabold text-gray-500 uppercase tracking-wider">Lesson Plan Sheet</span>
            <span className="text-xs text-gray-400 font-medium">* Fill out proposed dates, period, units and topics below</span>
          </div>

          {/* Desktop Table View */}
          <div className="hidden md:block overflow-x-auto border border-gray-300 rounded-xl">
            <table className="w-full text-left border-collapse min-w-[800px]">
              <thead>
                <tr className="bg-gray-100 border-b border-gray-300 text-xs font-bold text-gray-700 uppercase">
                  <th className="py-2.5 px-3 w-16 text-center border-r border-gray-300">S.No.</th>
                  <th className="py-2.5 px-3 w-36 border-r border-gray-300">Proposed Date</th>
                  <th className="py-2.5 px-3 w-28 border-r border-gray-300">Hour/Period</th>
                  <th className="py-2.5 px-3 w-20 border-r border-gray-300">Unit</th>
                  <th className="py-2.5 px-4 border-r border-gray-300">Topic(s)</th>
                  <th className="py-2.5 px-3 w-32 border-r border-gray-300">Blooms Level</th>
                  <th className="py-2.5 px-3 w-32 border-r border-gray-300">COs</th>
                  <th className="py-2.5 px-3 w-36 border-r border-gray-300">PO</th>
                  <th className="py-2.5 px-3 w-36 border-r border-gray-300">Mode of Delivery</th>
                  <th className="py-2.5 px-2 w-12 text-center"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 text-xs">
                {topics.map((t, idx) => (
                  <tr key={idx} className="hover:bg-gray-50">
                    
                    {/* S.No */}
                    <td className="py-2 px-3 text-center font-bold text-gray-500 border-r border-gray-200 bg-gray-50/50">
                      {t.sequence_no}
                    </td>

                    {/* Proposed Date */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <input
                        type="date"
                        value={t.proposed_date ? t.proposed_date.split('T')[0] : ""}
                        onChange={(e) => handleRowChange(t.sequence_no, 'proposed_date', e.target.value || null)}
                        className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none"
                      />
                    </td>

                    {/* Hour / Period Dropdown */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <select
                        value={t.hours}
                        onChange={(e) => handleRowChange(t.sequence_no, 'hours', parseInt(e.target.value) || 1)}
                        className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none bg-white text-gray-800"
                      >
                        <option value={1}>1st Hour</option>
                        <option value={2}>2nd Hour</option>
                        <option value={3}>3rd Hour</option>
                        <option value={4}>4th Hour</option>
                        <option value={5}>5th Hour</option>
                        <option value={6}>6th Hour</option>
                        <option value={7}>7th Hour</option>
                        <option value={8}>8th Hour</option>
                      </select>
                    </td>

                    {/* Unit */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <input
                        type="text"
                        value={t.unit}
                        onChange={(e) => handleRowChange(t.sequence_no, 'unit', e.target.value)}
                        placeholder="e.g. 1"
                        className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none"
                      />
                    </td>

                    {/* Topic */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <input
                        type="text"
                        value={t.topic}
                        onChange={(e) => handleRowChange(t.sequence_no, 'topic', e.target.value)}
                        placeholder="Enter topic details..."
                        className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none"
                      />
                    </td>

                    {/* Blooms Level (cognitive_level) */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <DropdownSelectInput
                        value={t.cognitive_level}
                        onChange={(val) => handleRowChange(t.sequence_no, 'cognitive_level', val)}
                        options={["K1", "K2", "K3", "K4", "K5", "K6"]}
                        isMulti={true}
                        placeholder="Blooms Level"
                        color="blue"
                      />
                    </td>

                    {/* COs */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <DropdownSelectInput
                        value={t.co}
                        onChange={(val) => handleRowChange(t.sequence_no, 'co', val)}
                        options={["CO1", "CO2", "CO3", "CO4", "CO5"]}
                        isMulti={true}
                        placeholder="COs"
                        color="emerald"
                      />
                    </td>

                    {/* PO */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <DropdownSelectInput
                        value={t.po}
                        onChange={(val) => handleRowChange(t.sequence_no, 'po', val)}
                        options={["PO1", "PO2", "PO3", "PO4", "PO5", "PO6"]}
                        isMulti={true}
                        placeholder="POs"
                        color="violet"
                      />
                    </td>

                    {/* Mode of Delivery */}
                    <td className="py-2 px-3 border-r border-gray-200">
                      <select
                        value={t.mode_of_delivery}
                        onChange={(e) => handleRowChange(t.sequence_no, 'mode_of_delivery', e.target.value)}
                        className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none bg-white"
                      >
                        <option value="BB">Blackboard (BB)</option>
                        <option value="PPT">PPT Presentation</option>
                        <option value="F2F">Face-to-Face (F2F)</option>
                        <option value="LAB">Laboratory (LAB)</option>
                        <option value="LMS">LMS</option>
                        <option value="SEM">Seminar (SEM)</option>
                        <option value="WS">Workshop (WS)</option>
                        <option value="PBL">Project-Based Learning (PBL)</option>
                        <option value="TUT">Tutorial (TUT)</option>
                        <option value="CS">Case Study (CS)</option>
                      </select>
                    </td>

                    {/* Delete button */}
                    <td className="py-2 px-2 text-center">
                      <button
                        type="button"
                        onClick={() => removeRow(idx)}
                        className="text-gray-400 hover:text-red-600 transition-colors p-1"
                        title="Delete Row"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </td>

                  </tr>
                ))}

                {topics.length === 0 && (
                  <tr>
                    <td colSpan="8" className="py-8 text-center text-gray-500 font-semibold">
                      No topics added yet. Click "+ Add Topic Row" below to plan a syllabus item.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* Mobile Card-Based View */}
          <div className="block md:hidden space-y-4">
            {topics.map((t, idx) => (
              <div key={idx} className="bg-white border border-gray-200 rounded-xl p-4 shadow-sm space-y-3">
                <div className="flex items-center justify-between border-b border-gray-100 pb-2">
                  <span className="text-xs font-bold text-gray-700">Topic #{t.sequence_no}</span>
                  <button
                    type="button"
                    onClick={() => removeRow(idx)}
                    className="text-red-500 hover:text-red-700 transition-colors p-1"
                    title="Delete Row"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
                
                <div className="grid grid-cols-2 gap-3 text-xs">
                  <div>
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Proposed Date</label>
                    <input
                      type="date"
                      value={t.proposed_date ? t.proposed_date.split('T')[0] : ""}
                      onChange={(e) => handleRowChange(t.sequence_no, 'proposed_date', e.target.value || null)}
                      className="w-full px-2 py-1.5 border border-gray-300 rounded-lg font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Hour / Period</label>
                    <select
                      value={t.hours}
                      onChange={(e) => handleRowChange(t.sequence_no, 'hours', parseInt(e.target.value) || 1)}
                      className="w-full px-2 py-1.5 border border-gray-300 rounded-lg font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none bg-white text-gray-800"
                    >
                      <option value={1}>1st Hour</option>
                      <option value={2}>2nd Hour</option>
                      <option value={3}>3rd Hour</option>
                      <option value={4}>4th Hour</option>
                      <option value={5}>5th Hour</option>
                      <option value={6}>6th Hour</option>
                      <option value={7}>7th Hour</option>
                      <option value={8}>8th Hour</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Unit</label>
                    <input
                      type="text"
                      value={t.unit}
                      onChange={(e) => handleRowChange(t.sequence_no, 'unit', e.target.value)}
                      placeholder="e.g. 1"
                      className="w-full px-2 py-1.5 border border-gray-300 rounded-lg font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Blooms Level</label>
                    <DropdownSelectInput
                      value={t.cognitive_level}
                      onChange={(val) => handleRowChange(t.sequence_no, 'cognitive_level', val)}
                      options={["K1", "K2", "K3", "K4", "K5", "K6"]}
                      isMulti={true}
                      placeholder="Blooms Level"
                      color="blue"
                    />
                  </div>
                  <div>
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">COs</label>
                    <DropdownSelectInput
                      value={t.co}
                      onChange={(val) => handleRowChange(t.sequence_no, 'co', val)}
                      options={["CO1", "CO2", "CO3", "CO4", "CO5"]}
                      isMulti={true}
                      placeholder="COs"
                      color="emerald"
                    />
                  </div>
                  <div className="col-span-2">
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">PO</label>
                    <DropdownSelectInput
                      value={t.po}
                      onChange={(val) => handleRowChange(t.sequence_no, 'po', val)}
                      options={["PO1", "PO2", "PO3", "PO4", "PO5", "PO6"]}
                      isMulti={true}
                      placeholder="POs"
                      color="violet"
                    />
                  </div>
                  <div className="col-span-2">
                    <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Mode of Delivery</label>
                    <select
                      value={t.mode_of_delivery}
                      onChange={(e) => handleRowChange(t.sequence_no, 'mode_of_delivery', e.target.value)}
                      className="w-full px-2 py-1.5 border border-gray-300 rounded-lg font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none bg-white"
                    >
                      <option value="BB">Blackboard (BB)</option>
                      <option value="PPT">PPT Presentation</option>
                      <option value="F2F">Face-to-Face (F2F)</option>
                      <option value="LAB">Laboratory (LAB)</option>
                      <option value="LMS">LMS</option>
                      <option value="SEM">Seminar (SEM)</option>
                      <option value="WS">Workshop (WS)</option>
                      <option value="PBL">Project-Based Learning (PBL)</option>
                      <option value="TUT">Tutorial (TUT)</option>
                      <option value="CS">Case Study (CS)</option>
                    </select>
                  </div>
                </div>
                
                <div>
                  <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Topic(s)</label>
                  <textarea
                    value={t.topic}
                    onChange={(e) => handleRowChange(t.sequence_no, 'topic', e.target.value)}
                    placeholder="Enter topic details..."
                    rows={2}
                    className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-orange-500 focus:outline-none bg-white text-gray-800"
                  />
                </div>
              </div>
            ))}
            
            {topics.length === 0 && (
              <div className="bg-white border border-gray-200 border-dashed rounded-xl p-8 text-center text-gray-500 text-xs font-semibold">
                No topics added yet. Click "+ Add Topic Row" below to plan a syllabus item.
              </div>
            )}
          </div>

          <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-2">
            <button
              onClick={addRow}
              className="flex items-center gap-1 px-4 py-2 border border-gray-300 rounded-xl text-xs font-bold text-gray-700 bg-white hover:bg-gray-50 transition-colors w-full sm:w-auto justify-center"
            >
              <Plus className="w-4 h-4 text-orange-600" /> Add Topic Row
            </button>
            
            <button
              onClick={() => savePlanToBackend(topics)}
              disabled={saving}
              className="flex items-center gap-1.5 px-6 py-2 rounded-xl text-xs font-bold text-white bg-orange-600 hover:bg-orange-700 transition-colors disabled:bg-orange-400 w-full sm:w-auto justify-center"
            >
              <Save className="w-4 h-4" /> {saving ? "Saving..." : "Save Lesson Plan"}
            </button>
          </div>

        </div>
      )}

      {/* ── RECORD TABLE ── */}
      {viewMode === "record" && (
        <div className="space-y-6">
          
          <div className="flex items-center justify-between pb-1">
            <span className="text-xs font-extrabold text-gray-500 uppercase tracking-wider">Coverage Log Sheet</span>
            <span className="text-xs text-gray-400 font-semibold">* Deviation reason auto-saves on leaving the input field</span>
          </div>

          {/* Desktop Table View */}
          <div className="hidden md:block overflow-x-auto border border-gray-300 rounded-xl">
            <table className="w-full text-left border-collapse min-w-[950px]">
              <thead>
                <tr className="bg-gray-100 border-b border-gray-300 text-xs font-bold text-gray-700 uppercase">
                  <th className="py-2.5 px-3 w-16 text-center border-r border-gray-300">S.No.</th>
                  <th className="py-2.5 px-3 w-28 border-r border-gray-300">Proposed Date</th>
                  <th className="py-2.5 px-3 w-28 text-center border-r border-gray-300">Hour / Period</th>
                  <th className="py-2.5 px-2 w-16 border-r border-gray-300">Unit</th>
                  <th className="py-2.5 px-4 border-r border-gray-300">Topic(s)</th>
                  <th className="py-2.5 px-3 w-32 border-r border-gray-300">Blooms Level</th>
                  <th className="py-2.5 px-3 w-32 border-r border-gray-300">COs</th>
                  <th className="py-2.5 px-3 w-36 border-r border-gray-300">PO</th>
                  <th className="py-2.5 px-3 w-36 border-r border-gray-300">Mode of Delivery</th>
                  <th className="py-2.5 px-3 w-32 border-r border-gray-300">Actual Date Covered</th>
                  <th className="py-2.5 px-4">Reason for Deviation (if any)</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 text-xs">
                {coveredTopics.map((t, idx) => {
                  const isDeviated = t.proposed_date && t.actual_date && t.actual_date.split('T')[0] !== t.proposed_date.split('T')[0];
                  
                  return (
                    <tr key={idx} className="hover:bg-gray-50/50 bg-green-50/10">
                      
                      {/* S.No */}
                      <td className="py-2.5 px-3 text-center font-bold text-gray-500 border-r border-gray-200 bg-gray-50/50">
                        {t.sequence_no}
                      </td>

                      {/* Proposed Date */}
                      <td className="py-2.5 px-3 border-r border-gray-200 font-semibold text-gray-700">
                        {t.proposed_date ? new Date(t.proposed_date).toLocaleDateString(undefined, {month: 'short', day: 'numeric', year: 'numeric'}) : 'N/A'}
                      </td>

                      {/* Hour / Period */}
                      <td className="py-2.5 px-3 text-center border-r border-gray-200 font-semibold text-gray-700">
                        {t.hours === 1 ? "1st Hour" :
                         t.hours === 2 ? "2nd Hour" :
                         t.hours === 3 ? "3rd Hour" :
                         t.hours === 4 ? "4th Hour" :
                         t.hours === 5 ? "5th Hour" :
                         t.hours === 6 ? "6th Hour" :
                         t.hours === 7 ? "7th Hour" :
                         t.hours === 8 ? "8th Hour" : `${t.hours} Hour`}
                      </td>

                      {/* Unit */}
                      <td className="py-2.5 px-2 text-center border-r border-gray-200 font-semibold text-gray-700">
                        {t.unit}
                      </td>

                      {/* Topic */}
                      <td className="py-2.5 px-4 border-r border-gray-200 text-gray-700 font-medium">
                        {t.topic}
                      </td>

                      {/* Blooms Level (cognitive_level) */}
                      <td className="py-2 px-3 border-r border-gray-200">
                        <DropdownSelectInput
                          value={t.cognitive_level}
                          onChange={(val) => handleRowChange(t.sequence_no, 'cognitive_level', val)}
                          onBlur={() => savePlanToBackend(topics)}
                          options={["K1", "K2", "K3", "K4", "K5", "K6"]}
                          isMulti={true}
                          placeholder="Blooms Level"
                          color="blue"
                        />
                      </td>

                      {/* COs */}
                      <td className="py-2 px-3 border-r border-gray-200">
                        <DropdownSelectInput
                          value={t.co}
                          onChange={(val) => handleRowChange(t.sequence_no, 'co', val)}
                          onBlur={() => savePlanToBackend(topics)}
                          options={["CO1", "CO2", "CO3", "CO4", "CO5"]}
                          isMulti={true}
                          placeholder="COs"
                          color="emerald"
                        />
                      </td>

                      {/* PO */}
                      <td className="py-2 px-3 border-r border-gray-200">
                        <DropdownSelectInput
                          value={t.po}
                          onChange={(val) => handleRowChange(t.sequence_no, 'po', val)}
                          onBlur={() => savePlanToBackend(topics)}
                          options={["PO1", "PO2", "PO3", "PO4", "PO5", "PO6"]}
                          isMulti={true}
                          placeholder="POs"
                          color="violet"
                        />
                      </td>

                      {/* Mode of Delivery */}
                      <td className="py-2.5 px-3 border-r border-gray-200 font-semibold text-gray-600">
                        {t.mode_of_delivery === "BB" ? "Blackboard (BB)" :
                         t.mode_of_delivery === "PPT" ? "PPT Presentation" :
                         t.mode_of_delivery === "F2F" ? "Face-to-Face (F2F)" :
                         t.mode_of_delivery === "LAB" ? "Laboratory (LAB)" :
                         t.mode_of_delivery === "LMS" ? "LMS" :
                         t.mode_of_delivery === "SEM" ? "Seminar (SEM)" :
                         t.mode_of_delivery === "WS" ? "Workshop (WS)" :
                         t.mode_of_delivery === "PBL" ? "Project-Based Learning (PBL)" :
                         t.mode_of_delivery === "TUT" ? "Tutorial (TUT)" :
                         t.mode_of_delivery === "CS" ? "Case Study (CS)" : t.mode_of_delivery}
                      </td>

                      {/* Actual Date Covered */}
                      <td className="py-2 px-3 border-r border-gray-200">
                        <input
                          type="date"
                          value={t.actual_date ? t.actual_date.split('T')[0] : ""}
                          onChange={(e) => handleRowChange(t.sequence_no, 'actual_date', e.target.value || null)}
                          onBlur={() => savePlanToBackend(topics)}
                          className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-green-500 focus:outline-none"
                        />
                      </td>

                      {/* Reason for Deviation (Editable) */}
                      <td className="py-2 px-3">
                        <input
                          type="text"
                          value={t.reason_for_deviation || ""}
                          onChange={(e) => handleRowChange(t.sequence_no, 'reason_for_deviation', e.target.value)}
                          onBlur={() => savePlanToBackend(topics)}
                          placeholder={isDeviated ? "Mandatory deviation reason..." : "No deviation"}
                          className={`w-full px-2 py-1.5 border rounded-lg text-xs font-semibold focus:outline-none focus:ring-1 ${
                            isDeviated && (!t.reason_for_deviation || t.reason_for_deviation.trim() === "")
                              ? "border-red-400 bg-red-50/30 focus:ring-red-500 focus:border-red-500"
                              : isDeviated
                                ? "border-amber-300 bg-amber-50/20 focus:ring-amber-500 focus:border-amber-500"
                                : "border-gray-200 bg-gray-50/50 cursor-not-allowed text-gray-400"
                          }`}
                          disabled={!isDeviated}
                        />
                      </td>

                    </tr>
                  );
                })}

                {coveredTopics.length === 0 && (
                  <tr>
                    <td colSpan="9" className="py-12 text-center text-gray-500 font-semibold bg-gray-50/30 border-dashed border border-gray-200 rounded-lg">
                      <div className="max-w-md mx-auto space-y-1">
                        <p className="text-sm font-bold text-gray-700">No Covered Topics Recorded Yet</p>
                        <p className="text-xs text-gray-400 leading-relaxed font-normal">
                          Topics planned in Write Mode will populate here automatically once student attendance is marked for them.
                        </p>
                      </div>
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* Mobile Card-Based View */}
          <div className="block md:hidden space-y-4">
            {coveredTopics.map((t, idx) => {
              const isDeviated = t.proposed_date && t.actual_date && t.actual_date.split('T')[0] !== t.proposed_date.split('T')[0];
              
              return (
                <div key={idx} className="bg-white border border-gray-200 rounded-xl p-4 shadow-sm space-y-3 bg-green-50/5">
                  <div className="flex items-center justify-between border-b border-gray-100 pb-2">
                    <span className="text-xs font-bold text-gray-700">Topic #{t.sequence_no} · Unit {t.unit}</span>
                    <span className="text-[10px] bg-green-100 text-green-700 px-2 py-0.5 rounded-full font-bold">Covered</span>
                  </div>

                  <div className="text-xs space-y-1 bg-gray-50 p-3 rounded-lg border border-gray-100">
                    <p className="font-semibold text-gray-800">{t.topic}</p>
                    <div className="grid grid-cols-2 gap-2 pt-2 text-[10px] text-gray-500 font-medium">
                      <p>Proposed: {t.proposed_date ? new Date(t.proposed_date).toLocaleDateString() : 'N/A'}</p>
                      <p>Hour/Period: {t.hours === 1 ? "1st Hour" : t.hours === 2 ? "2nd Hour" : t.hours === 3 ? "3rd Hour" : t.hours === 4 ? "4th Hour" : t.hours === 5 ? "5th Hour" : t.hours === 6 ? "6th Hour" : t.hours === 7 ? "7th Hour" : t.hours === 8 ? "8th Hour" : `${t.hours} Hour`}</p>
                      <p>Blooms: {t.cognitive_level || 'N/A'}</p>
                      <p>COs: {t.co || 'N/A'}</p>
                      <p>PO: {t.po || 'N/A'}</p>
                      <p>Mode: {t.mode_of_delivery}</p>
                    </div>
                  </div>

                  <div className="space-y-2.5">
                    <div>
                      <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Blooms Level</label>
                      <DropdownSelectInput
                        value={t.cognitive_level}
                        onChange={(val) => handleRowChange(t.sequence_no, 'cognitive_level', val)}
                        onBlur={() => savePlanToBackend(topics)}
                        options={["K1", "K2", "K3", "K4", "K5", "K6"]}
                        isMulti={true}
                        placeholder="Blooms Level"
                        color="blue"
                      />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">COs</label>
                      <DropdownSelectInput
                        value={t.co}
                        onChange={(val) => handleRowChange(t.sequence_no, 'co', val)}
                        onBlur={() => savePlanToBackend(topics)}
                        options={["CO1", "CO2", "CO3", "CO4", "CO5"]}
                        isMulti={true}
                        placeholder="COs"
                        color="emerald"
                      />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">PO</label>
                      <DropdownSelectInput
                        value={t.po}
                        onChange={(val) => handleRowChange(t.sequence_no, 'po', val)}
                        onBlur={() => savePlanToBackend(topics)}
                        options={["PO1", "PO2", "PO3", "PO4", "PO5", "PO6"]}
                        isMulti={true}
                        placeholder="POs"
                        color="violet"
                      />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">Actual Date Covered</label>
                      <input
                        type="date"
                        value={t.actual_date ? t.actual_date.split('T')[0] : ""}
                        onChange={(e) => handleRowChange(t.sequence_no, 'actual_date', e.target.value || null)}
                        onBlur={() => savePlanToBackend(topics)}
                        className="w-full px-2 py-1.5 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-1 focus:ring-green-500 focus:outline-none bg-white text-gray-800"
                      />
                    </div>

                    <div>
                      <label className="block text-[10px] font-bold text-gray-400 uppercase mb-1">
                        Reason for Deviation {isDeviated && <span className="text-red-500">*</span>}
                      </label>
                      <input
                        type="text"
                        value={t.reason_for_deviation || ""}
                        onChange={(e) => handleRowChange(t.sequence_no, 'reason_for_deviation', e.target.value)}
                        onBlur={() => savePlanToBackend(topics)}
                        placeholder={isDeviated ? "Mandatory deviation reason..." : "No deviation"}
                        className={`w-full px-2 py-1.5 border rounded-lg text-xs font-semibold focus:outline-none focus:ring-1 ${
                          isDeviated && (!t.reason_for_deviation || t.reason_for_deviation.trim() === "")
                            ? "border-red-400 bg-red-50/30 focus:ring-red-500 focus:border-red-500"
                            : isDeviated
                              ? "border-amber-300 bg-amber-50/20 focus:ring-amber-500 focus:border-amber-500"
                              : "border-gray-200 bg-gray-50/50 cursor-not-allowed text-gray-400"
                        }`}
                        disabled={!isDeviated}
                      />
                    </div>
                  </div>
                </div>
              );
            })}

            {coveredTopics.length === 0 && (
              <div className="bg-gray-50/30 border border-gray-200 border-dashed rounded-xl p-8 text-center text-gray-500 text-xs font-semibold">
                <p className="font-bold text-gray-700">No Covered Topics Recorded Yet</p>
                <p className="text-[10px] text-gray-400 mt-1 leading-relaxed">
                  Topics planned in Write Mode will populate here automatically once student attendance is marked for them.
                </p>
              </div>
            )}
          </div>

          <div className="flex justify-end gap-2 pt-2">
            <button
              onClick={() => savePlanToBackend(topics)}
              disabled={saving}
              className="flex items-center gap-1.5 px-6 py-2.5 rounded-xl text-xs font-bold text-white bg-green-600 hover:bg-green-700 transition-colors disabled:bg-green-400"
            >
              <Save className="w-4 h-4" /> {saving ? "Saving..." : "Save Deviation Reasons"}
            </button>
          </div>

        </div>
      )}

    </div>
  );
};
