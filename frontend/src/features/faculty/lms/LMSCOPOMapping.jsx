import React, { useState, useEffect, useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import axios from 'axios';
import {
  ArrowLeft, Save, CheckCircle2, AlertTriangle, Grid3x3, Info, BookOpen
} from 'lucide-react';

// ── CO-PO/PSO Mapping Helpers ────────────────────────────────────────
const BADGE_STYLES = {
  N: 'bg-gray-100 text-gray-600 border-gray-200',
  L: 'bg-blue-100 text-blue-700 border-blue-200',
  M: 'bg-amber-100 text-amber-700 border-amber-200',
  H: 'bg-green-100 text-green-700 border-green-200',
};

const getConfig = (courseType) => ({
  coCount: courseType === 'lab' ? 2 : 5,
  psoCount: 2,
});

const parseMappingJSON = (raw) => {
  if (!raw) return {};
  if (typeof raw === 'object') return raw;
  try { return JSON.parse(raw); } catch { return {}; }
};

/** Sticky-header editable mapping table */
const getUnitAndKLevel = (i, courseType, coCount, kLevels) => {
  let unitNo;
  if (courseType === 'lab') {
    unitNo = i + 1;
  } else {
    if (coCount <= 5) {
      unitNo = i + 1;
    } else {
      unitNo = Math.floor(i / 2) + 1;
    }
  }
  const unitKey = `Unit-${unitNo}`;
  const val = kLevels?.[unitKey];
  let kDisplay = '—';
  if (val) {
    if (Array.isArray(val)) {
      kDisplay = val.join(', ');
    } else if (typeof val === 'object') {
      kDisplay = JSON.stringify(val);
    } else {
      kDisplay = val;
    }
  }
  return { unitNo, kDisplay };
};

/** Sticky-header editable mapping table */
const CoPOEditTable = ({ mapping, courseType, onChange, kLevels }) => {
  const { coCount, psoCount } = getConfig(courseType);
  const coRows    = Array.from({ length: coCount },  (_, i) => `CO-${i + 1}`);
  const poColumns = Array.from({ length: 12 },       (_, i) => `PO-${i + 1}`);
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
    const base =
      'w-full text-center text-[11px] font-bold rounded border-0 ' +
      'focus:outline-none focus:ring-1 focus:ring-indigo-400 ' +
      'cursor-pointer appearance-none py-0.5 transition-colors';
    if (!val) return `${base} bg-transparent text-gray-400`;
    const map = {
      N: `${base} bg-gray-100 text-gray-700`,
      L: `${base} bg-blue-100 text-blue-700`,
      M: `${base} bg-amber-100 text-amber-700`,
      H: `${base} bg-green-100 text-green-700`,
    };
    return map[val] || `${base} bg-transparent`;
  };

  return (
    <div className="overflow-x-auto rounded-xl border border-indigo-200 shadow-sm">
      <table className="text-[11px] border-collapse" style={{ minWidth: '780px' }}>
        <thead className="sticky top-0 z-20">
          <tr>
            <th className="sticky left-0 z-30 bg-indigo-50 border border-indigo-200 px-3 py-2 text-center font-bold text-indigo-900" rowSpan={2}>CO</th>
            <th className="bg-indigo-50 border border-indigo-200 px-3 py-2 text-center font-bold text-indigo-900" rowSpan={2}>Unit</th>
            <th className="bg-indigo-50 border border-indigo-200 px-3 py-2 text-center font-bold text-indigo-900" rowSpan={2}>K-Level</th>
            <th
              colSpan={12}
              className="bg-indigo-100 text-indigo-900 font-bold px-3 py-2 border border-indigo-200 text-center"
            >
              Programme Outcomes (POs)
            </th>
            <th
              colSpan={psoCount}
              className="bg-purple-100 text-purple-900 font-bold px-3 py-2 border border-indigo-200 text-center"
            >
              Programme Specific Outcomes (PSOs)
            </th>
          </tr>
          <tr>
            {poColumns.map((po) => (
              <th
                key={po}
                className="bg-indigo-50 text-indigo-700 font-semibold px-1.5 py-1.5 border border-indigo-200 text-center whitespace-nowrap"
                style={{ minWidth: '46px' }}
              >
                {po}
              </th>
            ))}
            {psoColumns.map((pso) => (
              <th
                key={pso}
                className="bg-purple-50 text-purple-700 font-semibold px-1.5 py-1.5 border border-indigo-200 text-center whitespace-nowrap"
                style={{ minWidth: '56px' }}
              >
                {pso}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {coRows.map((co, idx) => {
            const { unitNo, kDisplay } = getUnitAndKLevel(idx, courseType, coCount, kLevels);
            return (
              <tr key={co} className={idx % 2 === 0 ? 'bg-white hover:bg-indigo-50/20' : 'bg-indigo-50/20 hover:bg-indigo-50/30'}>
                <td className="sticky left-0 z-10 bg-white border border-indigo-200 px-3 py-1.5 font-bold text-indigo-800 whitespace-nowrap text-center">
                  {co}
                </td>
                <td className="border border-indigo-100 px-3 py-1.5 text-gray-600 whitespace-nowrap text-center">
                  Unit {unitNo}
                </td>
                <td className="border border-indigo-100 px-3 py-1.5 font-semibold text-gray-700 whitespace-nowrap text-center">
                  {kDisplay}
                </td>
                {allCols.map((col) => {
                  const val = mapping?.[co]?.[col] || '';
                  return (
                    <td key={col} className="border border-indigo-100 px-0.5 py-0.5">
                      <select
                        value={val}
                        onChange={(e) => handleCell(co, col, e.target.value)}
                        className={selectCls(val)}
                        style={{ minWidth: '38px' }}
                        title={`${co} × ${col}`}
                      >
                        <option value="">–</option>
                        <option value="N">N</option>
                        <option value="L">L</option>
                        <option value="M">M</option>
                        <option value="H">H</option>
                      </select>
                    </td>
                  );
                })}
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

/** Read-only view of the mapping table */
const CoPOViewTable = ({ mapping, courseType, kLevels }) => {
  const { coCount, psoCount } = getConfig(courseType);
  const coRows    = Array.from({ length: coCount },  (_, i) => `CO-${i + 1}`);
  const poColumns = Array.from({ length: 12 },       (_, i) => `PO-${i + 1}`);
  const psoColumns = Array.from({ length: psoCount }, (_, i) => `PSO-${i + 1}`);
  const allCols = [...poColumns, ...psoColumns];

  return (
    <div className="overflow-x-auto rounded-xl border border-gray-200 shadow-sm">
      <table className="text-[11px] border-collapse" style={{ minWidth: '780px' }}>
        <thead>
          <tr>
            <th className="sticky left-0 z-20 bg-gray-50 border border-gray-200 px-3 py-2 text-center font-bold text-gray-700" rowSpan={2}>CO</th>
            <th className="bg-gray-50 border border-gray-200 px-3 py-2 text-center font-bold text-gray-700" rowSpan={2}>Unit</th>
            <th className="bg-gray-50 border border-gray-200 px-3 py-2 text-center font-bold text-gray-700" rowSpan={2}>K-Level</th>
            <th
              colSpan={12}
              className="bg-indigo-50 text-indigo-800 font-bold px-3 py-2 border border-gray-200 text-center"
            >
              Programme Outcomes (POs)
            </th>
            <th
              colSpan={psoCount}
              className="bg-purple-50 text-purple-800 font-bold px-3 py-2 border border-gray-200 text-center"
            >
              Programme Specific Outcomes (PSOs)
            </th>
          </tr>
          <tr>
            {poColumns.map((po) => (
              <th
                key={po}
                className="bg-indigo-50/60 text-indigo-700 font-semibold px-1.5 py-1.5 border border-gray-200 text-center whitespace-nowrap"
                style={{ minWidth: '42px' }}
              >
                {po}
              </th>
            ))}
            {psoColumns.map((pso) => (
              <th
                key={pso}
                className="bg-purple-50/60 text-purple-700 font-semibold px-1.5 py-1.5 border border-gray-200 text-center whitespace-nowrap"
                style={{ minWidth: '52px' }}
              >
                {pso}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {coRows.map((co, idx) => {
            const { unitNo, kDisplay } = getUnitAndKLevel(idx, courseType, coCount, kLevels);
            return (
              <tr key={co} className={idx % 2 === 0 ? 'bg-white hover:bg-gray-50/30' : 'bg-gray-50/40 hover:bg-gray-50/50'}>
                <td className="sticky left-0 z-10 bg-white border border-gray-200 px-3 py-1.5 font-bold text-gray-700 whitespace-nowrap text-center">
                  {co}
                </td>
                <td className="border border-gray-200 px-3 py-1.5 text-gray-600 whitespace-nowrap text-center">
                  Unit {unitNo}
                </td>
                <td className="border border-gray-200 px-3 py-1.5 font-semibold text-gray-700 whitespace-nowrap text-center">
                  {kDisplay}
                </td>
                {allCols.map((col) => {
                  const val = mapping?.[co]?.[col] || '';
                  return (
                    <td key={col} className="border border-gray-200 px-1 py-1 text-center">
                      {val ? (
                        <span
                          className={`inline-flex items-center justify-center w-6 h-5 rounded text-[11px] font-bold border ${BADGE_STYLES[val] || ''}`}
                        >
                          {val}
                        </span>
                      ) : (
                        <span className="text-gray-200">–</span>
                      )}
                    </td>
                  );
                })}
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};
// ── End helpers ───────────────────────────────────────────────────────

const LEGEND = [
  { code: 'H', label: 'High Contribution',   cls: 'bg-green-100 text-green-700 border-green-200' },
  { code: 'M', label: 'Medium Contribution', cls: 'bg-amber-100 text-amber-700 border-amber-200' },
  { code: 'L', label: 'Low Contribution',    cls: 'bg-blue-100  text-blue-700  border-blue-200'  },
  { code: 'N', label: 'No Contribution',     cls: 'bg-gray-100  text-gray-600  border-gray-200'  },
];

export const LMSCOPOMapping = () => {
  const { assignmentId } = useParams();

  const [course, setCourse]       = useState(null);
  const [mapping, setMapping]     = useState({});
  const [kLevels, setKLevels]     = useState({});
  const [loading, setLoading]     = useState(true);
  const [saving, setSaving]       = useState(false);
  const [dirty, setDirty]         = useState(false);
  const [success, setSuccess]     = useState(null);
  const [error, setError]         = useState(null);

  // ── Fetch course details ─────────────────────────────────────────
  const fetchCourse = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await axios.get('/api/faculty/me/courses');
      const found = res.data.find((c) => c.id.toString() === assignmentId);
      if (found) {
        setCourse(found);
        setMapping(parseMappingJSON(found.course?.co_po_mapping));
        setKLevels(parseMappingJSON(found.course?.co_k_levels));
      } else {
        setError('Course assignment not found.');
      }
    } catch (err) {
      console.error('Failed to fetch course details:', err);
      setError('Failed to load course data. Please try again.');
    } finally {
      setLoading(false);
    }
  }, [assignmentId]);

  useEffect(() => {
    fetchCourse();
  }, [fetchCourse]);

  // Auto-clear success/error banners
  useEffect(() => {
    if (success) { const t = setTimeout(() => setSuccess(null), 4000); return () => clearTimeout(t); }
  }, [success]);
  useEffect(() => {
    if (error)   { const t = setTimeout(() => setError(null),   6000); return () => clearTimeout(t); }
  }, [error]);

  // ── Handle cell change ───────────────────────────────────────────
  const handleChange = (updated) => {
    setMapping(updated);
    setDirty(true);
  };

  const handleKLevelChange = (unit, level) => {
    setKLevels(prev => ({ ...prev, [unit]: level }));
    setDirty(true);
  };

  // ── Save mapping ─────────────────────────────────────────────────
  const handleSave = async () => {
    if (!course) return;
    setSaving(true);
    setError(null);
    setSuccess(null);
    try {
      const courseId = course.course.id;
      await axios.put(`/api/courses/${courseId}`, {
        co_po_mapping: JSON.stringify(mapping),
        co_k_levels: JSON.stringify(kLevels),
      });
      // Persist locally so cancel doesn't revert
      setCourse((prev) => ({
        ...prev,
        course: { 
          ...prev.course, 
          co_po_mapping: JSON.stringify(mapping),
          co_k_levels: JSON.stringify(kLevels) 
        },
      }));
      setDirty(false);
      setSuccess('CO–PO/PSO Mapping saved successfully!');
    } catch (err) {
      console.error('Failed to save mapping:', err);
      setError(
        err.response?.data?.detail || 'Failed to save mapping. Please try again.'
      );
    } finally {
      setSaving(false);
    }
  };

  // ── Discard changes ──────────────────────────────────────────────
  const handleCancel = () => {
    setMapping(parseMappingJSON(course?.course?.co_po_mapping));
    setKLevels(parseMappingJSON(course?.course?.co_k_levels));
    setDirty(false);
    setError(null);
  };

  // ── Derived values ───────────────────────────────────────────────
  const courseData    = course?.course;
  const courseType    = courseData?.course_type;
  const isLab         = courseType === 'lab';
  const { coCount, psoCount } = getConfig(courseType);

  // Count filled cells for the progress bar
  const totalCells = coCount * (12 + psoCount);
  const filledCells = Object.values(mapping).reduce(
    (sum, row) => sum + Object.values(row).filter(Boolean).length,
    0
  );
  const fillPct = totalCells > 0 ? Math.round((filledCells / totalCells) * 100) : 0;

  // Parse outcomes into an array of 5 units
  const outcomesText = course?.course?.outcomes || '';
  const outcomesList = outcomesText.split('\n').map(line => line.trim()).filter(line => line.length > 0);
  const unitRows = Array.from({ length: 5 }, (_, i) => {
    const unitNo = i + 1;
    const outcomeText = outcomesList[i] || `Unit ${unitNo} Outcome (Not defined)`;
    return { unitNo, outcomeText, key: `Unit-${unitNo}` };
  });

  // ── Loading state ────────────────────────────────────────────────
  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600" />
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto space-y-6 p-4 md:p-6 lg:p-8">

      {/* ── Breadcrumb / back nav ── */}
      <div className="flex items-center gap-2 text-sm font-medium text-gray-500">
        <Link
          to={`/faculty/courses/${assignmentId}/lms`}
          className="flex items-center gap-1 hover:text-indigo-600 transition-colors"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to Course Dashboard
        </Link>
        <span className="text-gray-300">/</span>
        <span className="text-gray-800 font-bold">CO–PO/PSO Mapping</span>
      </div>

      {/* ── Page header ── */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 bg-indigo-50 border border-indigo-100 rounded-xl flex items-center justify-center flex-shrink-0">
              <Grid3x3 className="w-6 h-6 text-indigo-600" />
            </div>
            <div>
              <div className="flex items-center gap-2 mb-0.5">
                <span className="text-xs font-bold px-2.5 py-0.5 bg-indigo-50 text-indigo-700 rounded-md uppercase tracking-wide">
                  {courseData?.code}
                </span>
                <span className="text-xs font-semibold px-2 py-0.5 rounded-md bg-gray-100 text-gray-600 capitalize">
                  {isLab ? 'Practical / Lab' : 'Theory'}
                </span>
              </div>
              <h1 className="text-xl font-extrabold text-gray-900 tracking-tight">
                CO–PO/PSO Mapping
              </h1>
              <p className="text-sm text-gray-500 mt-0.5">
                {courseData?.name} — {isLab ? `CO-1 to CO-6` : `CO-1 to CO-10`}, PO-1 to PO-12,{' '}
                PSO-1 to PSO-{psoCount}
              </p>
            </div>
          </div>

          {/* Save / Discard buttons */}
          <div className="flex items-center gap-3">
            {dirty && (
              <button
                onClick={handleCancel}
                className="px-4 py-2 text-sm font-bold text-gray-600 hover:bg-gray-100 rounded-xl transition-colors border border-gray-200"
              >
                Discard Changes
              </button>
            )}
            <button
              onClick={handleSave}
              disabled={saving || !dirty}
              className="flex items-center gap-2 px-5 py-2 rounded-xl text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 disabled:bg-indigo-300 transition-colors shadow-sm"
            >
              <Save className="w-4 h-4" />
              {saving ? 'Saving…' : 'Save Mapping'}
            </button>
          </div>
        </div>

        {/* Fill progress */}
        <div className="mt-4 pt-4 border-t border-gray-100">
          <div className="flex items-center justify-between mb-1.5">
            <span className="text-xs font-semibold text-gray-500">
              Mapping Completion
            </span>
            <span className="text-xs font-bold text-indigo-700">
              {filledCells} / {totalCells} cells filled ({fillPct}%)
            </span>
          </div>
          <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-indigo-500 to-purple-500 rounded-full transition-all duration-500"
              style={{ width: `${fillPct}%` }}
            />
          </div>
        </div>
      </div>

      {/* ── Status banners ── */}
      {success && (
        <div className="flex items-center gap-2 p-3 bg-green-50 text-green-700 text-sm font-bold rounded-xl border border-green-200">
          <CheckCircle2 className="w-4 h-4 flex-shrink-0" />
          {success}
        </div>
      )}
      {error && (
        <div className="flex items-center gap-2 p-3 bg-red-50 text-red-700 text-sm font-bold rounded-xl border border-red-200">
          <AlertTriangle className="w-4 h-4 flex-shrink-0" />
          {error}
        </div>
      )}

      {/* ── Main mapping card ── */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 space-y-4">
        {/* Legend + info */}
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div className="flex flex-wrap gap-2">
            {LEGEND.map(({ code, label, cls }) => (
              <span
                key={code}
                className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full border text-[11px] font-bold ${cls}`}
              >
                <span className="font-extrabold">{code}</span>
                <span className="font-medium opacity-80">{label}</span>
              </span>
            ))}
          </div>
          <div className="flex items-center gap-1.5 text-[11px] text-indigo-500 font-semibold bg-indigo-50 px-3 py-1.5 rounded-lg border border-indigo-100">
            <Info className="w-3.5 h-3.5" />
            Select a value in each cell. Leave blank (–) for no mapping.
          </div>
        </div>

        {/* Course Outcomes K-Level Table */}
        <div className="bg-white border border-gray-200 rounded-2xl shadow-sm p-5 sm:p-6 mt-8">
          <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-4 flex items-center gap-2">
            <BookOpen className="w-4 h-4 text-primary-500" />
            Course Outcomes
          </h3>
          
          <div className="overflow-x-auto border border-gray-200 rounded-xl mb-6">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-200">
                  <th className="px-4 py-3 text-left font-bold text-gray-700 w-24">Unit</th>
                  <th className="px-4 py-3 text-left font-bold text-gray-700">Course Outcome</th>
                  <th className="px-4 py-3 text-center font-bold text-gray-700 w-48">Bloom's Taxonomy Level</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {unitRows.map((row) => (
                  <tr key={row.key} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-medium text-gray-800 text-center">{row.unitNo}</td>
                    <td className="px-4 py-3 text-gray-600">{row.outcomeText}</td>
                    <td className="px-4 py-3 text-center">
                      <select
                        className="w-full bg-white border border-gray-300 text-gray-700 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block p-2"
                        value={kLevels[row.key] || ''}
                        onChange={(e) => handleKLevelChange(row.key, e.target.value)}
                      >
                        <option value="">Select Level</option>
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

          <h3 className="text-sm font-bold text-gray-800 uppercase tracking-wider mb-4 flex items-center gap-2 mt-8">
            <Grid3x3 className="w-4 h-4 text-primary-500" />
            Interactive Editor
          </h3>
          <p className="text-xs text-gray-500 mb-6 max-w-3xl">
            Use the dropdowns below to set the contribution level for each Course Outcome against Programme Outcomes (POs) and Programme Specific Outcomes (PSOs).
          </p>
          <CoPOEditTable
            mapping={mapping}
            onChange={handleChange}
            courseType={courseType}
            kLevels={kLevels}
          />
        </div>
      </div>

      {/* ── Read-only preview card ── */}
      {filledCells > 0 && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 space-y-3">
          <h2 className="text-sm font-bold text-gray-700 uppercase tracking-wider flex items-center gap-2">
            <Grid3x3 className="w-4 h-4 text-gray-400" />
            Preview (Read-only)
          </h2>
          <CoPOViewTable mapping={mapping} courseType={courseType} kLevels={kLevels} />
        </div>
      )}
    </div>
  );
};
