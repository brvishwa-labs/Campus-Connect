import React, { useState, useEffect, useCallback, useRef } from 'react';
import axios from 'axios';
import {
  Upload, FileText, AlertCircle, CheckCircle, XCircle, Search,
  Plus, Edit2, Trash2, RefreshCw, BarChart2, Users, DollarSign,
  CreditCard, MapPin, BookOpen, TrendingUp, Clock, AlertTriangle,
  ChevronDown, X, Check, Eye,
  FlaskConical, GraduationCap, ReceiptText, Layers
} from 'lucide-react';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell
} from 'recharts';

// ─── API helper ─────────────────────────────────────────────────────────────
const api = axios;

function fmt(amount) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency', currency: 'INR', maximumFractionDigits: 0
  }).format(amount || 0);
}

// Maps fee_type label to icon + color style
const FEE_TYPE_STYLES = {
  'Opening Balance': {
    icon: Layers,
    iconBg: 'bg-blue-100',
    iconColor: 'text-blue-600',
    badge: 'bg-blue-100 text-blue-700',
    rowBg: 'hover:bg-blue-50/40',
  },
  'Tuition Fee': {
    icon: GraduationCap,
    iconBg: 'bg-indigo-100',
    iconColor: 'text-indigo-600',
    badge: 'bg-indigo-100 text-indigo-700',
    rowBg: 'hover:bg-indigo-50/40',
  },
  'Exam Fee': {
    icon: ReceiptText,
    iconBg: 'bg-amber-100',
    iconColor: 'text-amber-600',
    badge: 'bg-amber-100 text-amber-700',
    rowBg: 'hover:bg-amber-50/40',
  },
  'Lab Fee': {
    icon: FlaskConical,
    iconBg: 'bg-emerald-100',
    iconColor: 'text-emerald-600',
    badge: 'bg-emerald-100 text-emerald-700',
    rowBg: 'hover:bg-emerald-50/40',
  },
};

function getFeeStyle(feeType) {
  return FEE_TYPE_STYLES[feeType] || {
    icon: DollarSign,
    iconBg: 'bg-gray-100',
    iconColor: 'text-gray-600',
    badge: 'bg-gray-100 text-gray-700',
    rowBg: 'hover:bg-gray-50/40',
  };
}

// ─── Shared UI primitives ────────────────────────────────────────────────────
const Card = ({ children, className = '' }) => (
  <div className={`bg-white rounded-2xl border border-gray-100 shadow-sm ${className}`}>
    {children}
  </div>
);

const Badge = ({ label, color = 'blue' }) => {
  const colors = {
    blue: 'bg-blue-100 text-blue-700',
    green: 'bg-emerald-100 text-emerald-700',
    red: 'bg-red-100 text-red-700',
    yellow: 'bg-amber-100 text-amber-700',
    gray: 'bg-gray-100 text-gray-600',
    purple: 'bg-purple-100 text-purple-700',
  };
  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded-full text-xs font-semibold ${colors[color] || colors.gray}`}>
      {label}
    </span>
  );
};

const SummaryCard = ({ icon: Icon, label, value, color = 'blue', sub }) => {
  const colors = {
    blue: 'from-blue-500 to-blue-600',
    green: 'from-emerald-500 to-emerald-600',
    red: 'from-red-500 to-rose-600',
    purple: 'from-purple-500 to-purple-600',
    amber: 'from-amber-500 to-orange-500',
  };
  return (
    <Card className="p-5 flex items-start gap-4">
      <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${colors[color]} flex items-center justify-center flex-shrink-0`}>
        <Icon className="w-6 h-6 text-white" />
      </div>
      <div>
        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">{label}</p>
        <p className="text-2xl font-bold text-gray-900 mt-0.5">{value}</p>
        {sub && <p className="text-xs text-gray-500 mt-0.5">{sub}</p>}
      </div>
    </Card>
  );
};

const Toast = ({ message, type = 'success', onClose }) => {
  useEffect(() => {
    const t = setTimeout(onClose, 4000);
    return () => clearTimeout(t);
  }, [onClose]);
  const styles = {
    success: 'bg-emerald-600',
    error: 'bg-red-600',
    info: 'bg-blue-600',
  };
  return (
    <div className={`fixed bottom-6 right-6 z-50 flex items-center gap-3 px-5 py-3.5 rounded-xl text-white text-sm font-medium shadow-xl ${styles[type]} animate-bounce-in`}>
      {type === 'success' ? <CheckCircle className="w-5 h-5" /> : <AlertCircle className="w-5 h-5" />}
      {message}
      <button onClick={onClose}><X className="w-4 h-4 opacity-70 hover:opacity-100" /></button>
    </div>
  );
};

const Spinner = ({ size = 'md' }) => {
  const s = size === 'sm' ? 'w-4 h-4' : 'w-6 h-6';
  return <div className={`${s} border-2 border-current border-t-transparent rounded-full animate-spin`} />;
};

// ─── Student Search Dropdown ─────────────────────────────────────────────────
function StudentSearch({ onSelect, placeholder = 'Search student by name or register number…', value }) {
  const [q, setQ] = useState(value || '');
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const ref = useRef(null);

  useEffect(() => {
    if (!q || q.length < 2) { setResults([]); return; }
    const t = setTimeout(async () => {
      setLoading(true);
      try {
        const res = await api.get(`/api/fees/students/search?q=${encodeURIComponent(q)}`);
        setResults(res.data);
        setOpen(true);
      } catch { setResults([]); }
      setLoading(false);
    }, 300);
    return () => clearTimeout(t);
  }, [q]);

  useEffect(() => {
    const handler = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  return (
    <div ref={ref} className="relative">
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input
          className="w-full pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400 bg-white"
          placeholder={placeholder}
          value={q}
          onChange={e => { setQ(e.target.value); if (!e.target.value) onSelect(null); }}
        />
        {loading && <div className="absolute right-3 top-1/2 -translate-y-1/2 text-blue-500"><Spinner size="sm" /></div>}
      </div>
      {open && results.length > 0 && (
        <div className="absolute top-full left-0 right-0 mt-1 bg-white rounded-xl shadow-xl border border-gray-100 z-50 max-h-60 overflow-y-auto">
          {results.map(s => (
            <button
              key={s.id}
              onClick={() => { onSelect(s); setQ(`${s.name} (${s.register_number})`); setOpen(false); }}
              className="w-full text-left px-4 py-2.5 hover:bg-blue-50 transition-colors border-b border-gray-50 last:border-0"
            >
              <p className="text-sm font-semibold text-gray-900">{s.name}</p>
              <p className="text-xs text-gray-500">{s.register_number} · Sem {s.current_semester}</p>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 1: Upload Center
// ═══════════════════════════════════════════════════════════════════════════════
function UploadCenter({ showToast }) {
  const [dragging, setDragging] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [result, setResult] = useState(null);
  const [history, setHistory] = useState([]);
  const fileRef = useRef(null);

  const fetchHistory = useCallback(async () => {
    try {
      const res = await api.get('/api/fees/uploads/history');
      setHistory(res.data || []);
    } catch { /* silently */ }
  }, []);

  useEffect(() => { fetchHistory(); }, [fetchHistory]);

  const handleFile = async (file) => {
    if (!file) return;
    const formData = new FormData();
    formData.append('file', file);
    setUploading(true);
    setResult(null);
    try {
      const res = await api.post('/api/fees/upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      setResult({ success: true, data: res.data });
      showToast(`Import complete: ${res.data.auto_matched} matched, ${res.data.unmapped_count} unmapped`, 'success');
      fetchHistory();
    } catch (err) {
      const msg = err.response?.data?.detail || 'Upload failed. Check file format.';
      setResult({ success: false, message: msg });
      showToast(msg, 'error');
    }
    setUploading(false);
  };

  const onDrop = (e) => {
    e.preventDefault(); setDragging(false);
    const file = e.dataTransfer.files[0];
    if (file) handleFile(file);
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-bold text-gray-900">Tally File Upload</h2>
        <p className="text-sm text-gray-500 mt-1">Upload a CSV or Excel export from Tally with columns: Particulars, Amount/Debit, Date, Voucher No.</p>
      </div>

      {/* Drop Zone */}
      <div
        onDragOver={e => { e.preventDefault(); setDragging(true); }}
        onDragLeave={() => setDragging(false)}
        onDrop={onDrop}
        onClick={() => fileRef.current?.click()}
        className={`border-2 border-dashed rounded-2xl p-12 flex flex-col items-center gap-4 cursor-pointer transition-all ${
          dragging ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-blue-300 hover:bg-gray-50'
        }`}
      >
        <div className={`w-16 h-16 rounded-2xl flex items-center justify-center ${dragging ? 'bg-blue-100' : 'bg-gray-100'}`}>
          {uploading ? <Spinner /> : <Upload className={`w-8 h-8 ${dragging ? 'text-blue-600' : 'text-gray-400'}`} />}
        </div>
        <div className="text-center">
          <p className="font-semibold text-gray-700">{uploading ? 'Uploading…' : 'Drop your Tally export here'}</p>
          <p className="text-sm text-gray-400 mt-1">or click to browse — CSV, XLSX supported</p>
        </div>
        <input ref={fileRef} type="file" accept=".csv,.xlsx,.xls" className="hidden"
          onChange={e => { if (e.target.files[0]) handleFile(e.target.files[0]); e.target.value = ''; }} />
      </div>

      {/* Result Summary */}
      {result && (
        <Card className={`p-5 border-l-4 ${result.success ? 'border-l-emerald-500' : 'border-l-red-500'}`}>
          {result.success ? (
            <div>
              <div className="flex items-center gap-2 mb-4">
                <CheckCircle className="w-5 h-5 text-emerald-600" />
                <h3 className="font-semibold text-emerald-700">Import Successful</h3>
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                {[
                  { label: 'Rows Processed', value: result.data.rows_processed, color: 'blue' },
                  { label: 'Auto Matched', value: result.data.auto_matched, color: 'green' },
                  { label: 'Unmapped', value: result.data.unmapped_count, color: 'yellow' },
                  { label: 'Duplicates Skipped', value: result.data.skipped_duplicate, color: 'gray' },
                ].map(item => (
                  <div key={item.label} className="bg-gray-50 rounded-xl p-3 text-center">
                    <p className="text-2xl font-bold text-gray-900">{item.value}</p>
                    <p className="text-xs text-gray-500 mt-0.5">{item.label}</p>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="flex items-start gap-3">
              <XCircle className="w-5 h-5 text-red-500 mt-0.5 flex-shrink-0" />
              <div>
                <p className="font-semibold text-red-700">Upload Failed</p>
                <p className="text-sm text-red-600 mt-1">{result.message}</p>
              </div>
            </div>
          )}
        </Card>
      )}

      {/* Upload History */}
      {history.length > 0 && (
        <Card className="overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-50 flex items-center justify-between">
            <h3 className="font-semibold text-gray-900">Upload History</h3>
            <button onClick={fetchHistory} className="text-gray-400 hover:text-gray-600"><RefreshCw className="w-4 h-4" /></button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50">
                <tr>
                  {['File', 'Uploaded At', 'Processed', 'Matched', 'Unmapped', 'Skipped'].map(h => (
                    <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {history.map((h, i) => (
                  <tr key={i} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-medium text-gray-900 flex items-center gap-2">
                      <FileText className="w-4 h-4 text-blue-400" />{h.filename || 'Unknown'}
                    </td>
                    <td className="px-4 py-3 text-gray-600">{new Date(h.uploaded_at).toLocaleString('en-IN')}</td>
                    <td className="px-4 py-3">{h.rows_processed}</td>
                    <td className="px-4 py-3"><Badge label={h.auto_matched} color="green" /></td>
                    <td className="px-4 py-3"><Badge label={h.unmapped_count} color={h.unmapped_count > 0 ? 'yellow' : 'gray'} /></td>
                    <td className="px-4 py-3">{h.skipped_duplicate || 0}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB: Fee Upload (Management File — any fee type)
// ═══════════════════════════════════════════════════════════════════════════════
const FEE_TYPE_OPTIONS = [
  'Opening Balance',
  'Exam Fee',
  'Tuition Fee',
  'Lab Fee',
  'Other',
];

function FeeUpload({ showToast }) {
  const [feeType, setFeeType] = useState('Opening Balance');
  const [customFeeType, setCustomFeeType] = useState('');
  const [dragging, setDragging] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [result, setResult] = useState(null);
  const [history, setHistory] = useState([]);
  const fileRef = useRef(null);

  const effectiveFeeType = feeType === 'Other' ? (customFeeType.trim() || 'Other') : feeType;

  const fetchHistory = useCallback(async () => {
    try {
      const res = await api.get('/api/fees/uploads/history');
      setHistory((res.data || []).filter(h => h.type === 'fee_upload'));
    } catch { /* silently */ }
  }, []);

  useEffect(() => { fetchHistory(); }, [fetchHistory]);

  const handleFile = async (file) => {
    if (!file) return;
    if (!effectiveFeeType) {
      showToast('Please enter a fee type label before uploading.', 'error');
      return;
    }
    const formData = new FormData();
    formData.append('file', file);
    formData.append('fee_type', effectiveFeeType);
    setUploading(true);
    setResult(null);
    try {
      const res = await api.post('/api/fees/fee-upload', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      setResult({ success: true, data: res.data });
      showToast(
        `✓ ${res.data.matched} students updated${res.data.failed > 0 ? `, ${res.data.failed} unmatched` : ''}`,
        res.data.failed > 0 ? 'info' : 'success'
      );
      fetchHistory();
    } catch (err) {
      const msg = err.response?.data?.detail || 'Upload failed. Check file format.';
      setResult({ success: false, message: msg });
      showToast(msg, 'error');
    }
    setUploading(false);
  };

  const onDrop = (e) => {
    e.preventDefault(); setDragging(false);
    const file = e.dataTransfer.files[0];
    if (file) handleFile(file);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl font-bold text-gray-900">Fee Upload</h2>
        <p className="text-sm text-gray-500 mt-1">
          Upload the Tally Group Summary report received from management to add fees to students.
          Select the fee type first, then upload the file. Each upload creates a separate fee record
          per student — it does <strong>not</strong> affect daily payment records.
        </p>
      </div>

      {/* Fee Type Selector */}
      <Card className="p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-8 h-8 rounded-lg bg-indigo-100 flex items-center justify-center">
            <BookOpen className="w-4 h-4 text-indigo-600" />
          </div>
          <h3 className="font-semibold text-gray-900">Step 1 — Select Fee Type</h3>
        </div>
        <div className="flex flex-wrap gap-2">
          {FEE_TYPE_OPTIONS.map(opt => (
            <button
              key={opt}
              onClick={() => { setFeeType(opt); if (opt !== 'Other') setCustomFeeType(''); }}
              className={`px-4 py-2 rounded-xl text-sm font-medium border transition-all ${
                feeType === opt
                  ? 'bg-indigo-600 text-white border-indigo-600 shadow-sm'
                  : 'bg-white text-gray-600 border-gray-200 hover:border-indigo-300 hover:text-indigo-600'
              }`}
            >
              {opt}
            </button>
          ))}
        </div>
        {feeType === 'Other' && (
          <input
            className="mt-3 w-full sm:w-72 px-3 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-400"
            placeholder="Enter custom fee type label…"
            value={customFeeType}
            onChange={e => setCustomFeeType(e.target.value)}
          />
        )}
        {effectiveFeeType && (
          <p className="mt-3 text-xs text-indigo-600 font-medium">
            ✓ Fee type label: <span className="font-bold">{effectiveFeeType}</span>
          </p>
        )}
      </Card>

      {/* Step 2: Upload */}
      <Card className="p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-8 h-8 rounded-lg bg-blue-100 flex items-center justify-center">
            <Upload className="w-4 h-4 text-blue-600" />
          </div>
          <h3 className="font-semibold text-gray-900">Step 2 — Upload Group Summary File</h3>
        </div>
        <div className="text-xs text-gray-500 bg-gray-50 rounded-xl px-4 py-3 mb-4 flex items-start gap-2">
          <AlertCircle className="w-3.5 h-3.5 text-amber-500 mt-0.5 flex-shrink-0" />
          <span>Expected format: Tally Group Summary export (Particulars / Closing Balance columns). Rows: <code>Student Name (Dept - GROUP/BATCH) | Amount</code></span>
        </div>
        <div
          onDragOver={e => { e.preventDefault(); setDragging(true); }}
          onDragLeave={() => setDragging(false)}
          onDrop={onDrop}
          onClick={() => fileRef.current?.click()}
          className={`border-2 border-dashed rounded-2xl p-10 flex flex-col items-center gap-3 cursor-pointer transition-all ${
            dragging ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-blue-300 hover:bg-gray-50'
          }`}
        >
          <div className={`w-14 h-14 rounded-2xl flex items-center justify-center ${
            dragging ? 'bg-blue-100' : uploading ? 'bg-indigo-50' : 'bg-gray-100'
          }`}>
            {uploading
              ? <Spinner />
              : <Upload className={`w-7 h-7 ${dragging ? 'text-blue-600' : 'text-gray-400'}`} />
            }
          </div>
          <div className="text-center">
            <p className="font-semibold text-gray-700">
              {uploading ? `Uploading “${effectiveFeeType}” file…` : 'Drop the Group Summary file here'}
            </p>
            <p className="text-sm text-gray-400 mt-1">or click to browse — CSV, XLSX supported</p>
          </div>
          <input
            ref={fileRef}
            type="file"
            accept=".csv,.xlsx,.xls"
            className="hidden"
            onChange={e => { if (e.target.files[0]) handleFile(e.target.files[0]); e.target.value = ''; }}
          />
        </div>
      </Card>

      {/* Result Summary */}
      {result && (
        <Card className={`p-5 border-l-4 ${result.success ? (result.data.failed > 0 ? 'border-l-amber-400' : 'border-l-emerald-500') : 'border-l-red-500'}`}>
          {result.success ? (
            <div className="space-y-4">
              <div className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-emerald-600" />
                <h3 className="font-semibold text-emerald-700">
                  Upload Complete — “{result.data.fee_type}”
                </h3>
              </div>
              <div className="grid grid-cols-3 gap-3">
                {[
                  { label: 'Rows Processed', value: result.data.rows_processed, color: 'blue' },
                  { label: 'Students Updated', value: result.data.matched, color: 'green' },
                  { label: 'Unmatched', value: result.data.failed, color: result.data.failed > 0 ? 'yellow' : 'gray' },
                ].map(item => (
                  <div key={item.label} className="bg-gray-50 rounded-xl p-3 text-center">
                    <p className="text-2xl font-bold text-gray-900">{item.value}</p>
                    <p className="text-xs text-gray-500 mt-0.5">{item.label}</p>
                  </div>
                ))}
              </div>

              {/* Failed rows table */}
              {result.data.failed_rows && result.data.failed_rows.length > 0 && (
                <div>
                  <h4 className="font-semibold text-amber-700 mb-2 flex items-center gap-2">
                    <AlertTriangle className="w-4 h-4" /> Unmatched Rows ({result.data.failed_rows.length})
                  </h4>
                  <div className="overflow-x-auto rounded-xl border border-amber-100">
                    <table className="w-full text-sm">
                      <thead className="bg-amber-50">
                        <tr>
                          {['Ledger Name (from file)', 'Amount', 'Reason'].map(h => (
                            <th key={h} className="px-3 py-2 text-left text-xs font-bold text-amber-700 uppercase tracking-wider">{h}</th>
                          ))}
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-amber-50">
                        {result.data.failed_rows.map((row, i) => (
                          <tr key={i} className="hover:bg-amber-50/50">
                            <td className="px-3 py-2 text-gray-800 font-mono text-xs">{row.ledger_name}</td>
                            <td className="px-3 py-2 text-gray-700">₹{row.amount?.toLocaleString('en-IN')}</td>
                            <td className="px-3 py-2 text-amber-700">{row.reason}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              )}
            </div>
          ) : (
            <div className="flex items-start gap-3">
              <XCircle className="w-5 h-5 text-red-500 mt-0.5 flex-shrink-0" />
              <div>
                <p className="font-semibold text-red-700">Upload Failed</p>
                <p className="text-sm text-red-600 mt-1">{result.message}</p>
              </div>
            </div>
          )}
        </Card>
      )}

      {/* Upload History */}
      {history.length > 0 && (
        <Card className="overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-50 flex items-center justify-between">
            <h3 className="font-semibold text-gray-900">Upload History</h3>
            <button onClick={fetchHistory} className="text-gray-400 hover:text-gray-600"><RefreshCw className="w-4 h-4" /></button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50">
                <tr>
                  {['File', 'Fee Type', 'Uploaded At', 'Processed', 'Matched', 'Failed'].map(h => (
                    <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {history.map((h, i) => (
                  <tr key={i} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-medium text-gray-900">
                      <div className="flex items-center gap-2">
                        <FileText className="w-4 h-4 text-blue-400 flex-shrink-0" />
                        <span className="truncate max-w-xs">{h.filename || 'Unknown'}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3"><Badge label={h.fee_type || '—'} color="purple" /></td>
                    <td className="px-4 py-3 text-gray-600">{new Date(h.uploaded_at).toLocaleString('en-IN')}</td>
                    <td className="px-4 py-3">{h.rows_processed}</td>
                    <td className="px-4 py-3"><Badge label={h.matched} color="green" /></td>
                    <td className="px-4 py-3"><Badge label={h.failed} color={h.failed > 0 ? 'yellow' : 'gray'} /></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 2: Unmapped Ledger Queue
// ═══════════════════════════════════════════════════════════════════════════════
function UnmappedQueue({ showToast }) {
  const [entries, setEntries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedStudents, setSelectedStudents] = useState({});
  const [actionLoading, setActionLoading] = useState({});

  const fetch = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/api/fees/unmapped');
      setEntries(res.data);
    } catch { showToast('Failed to load unmapped entries', 'error'); }
    setLoading(false);
  }, [showToast]);

  useEffect(() => { fetch(); }, [fetch]);

  const resolve = async (id, studentId) => {
    if (!studentId) { showToast('Please select a student first', 'error'); return; }
    setActionLoading(p => ({ ...p, [id]: 'resolve' }));
    try {
      await api.post(`/api/fees/unmapped/${id}/resolve`, { student_id: studentId });
      showToast('Entry resolved and payment recorded!', 'success');
      setEntries(prev => prev.filter(e => e.id !== id));
    } catch (err) {
      showToast(err.response?.data?.detail || 'Resolve failed', 'error');
    }
    setActionLoading(p => { const n = { ...p }; delete n[id]; return n; });
  };

  const skip = async (id) => {
    setActionLoading(p => ({ ...p, [id]: 'skip' }));
    try {
      await api.post(`/api/fees/unmapped/${id}/skip`);
      showToast('Entry skipped', 'info');
      setEntries(prev => prev.filter(e => e.id !== id));
    } catch (err) {
      showToast(err.response?.data?.detail || 'Skip failed', 'error');
    }
    setActionLoading(p => { const n = { ...p }; delete n[id]; return n; });
  };

  if (loading) return <div className="flex items-center justify-center py-24 text-gray-400"><Spinner /><span className="ml-3">Loading unmapped entries…</span></div>;

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-gray-900">Unmapped Ledger Queue</h2>
          <p className="text-sm text-gray-500 mt-1">{entries.length} pending entries need manual student assignment</p>
        </div>
        <button onClick={fetch} className="flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700">
          <RefreshCw className="w-4 h-4" /> Refresh
        </button>
      </div>

      {entries.length === 0 ? (
        <Card className="p-16 flex flex-col items-center gap-4">
          <div className="w-16 h-16 rounded-2xl bg-emerald-50 flex items-center justify-center">
            <CheckCircle className="w-8 h-8 text-emerald-500" />
          </div>
          <div className="text-center">
            <p className="font-semibold text-gray-900">All caught up!</p>
            <p className="text-sm text-gray-500 mt-1">No pending unmapped entries.</p>
          </div>
        </Card>
      ) : (
        <div className="space-y-3">
          {entries.map(entry => (
            <Card key={entry.id} className="p-5">
              <div className="flex flex-col lg:flex-row lg:items-center gap-4">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <AlertTriangle className="w-4 h-4 text-amber-500 flex-shrink-0" />
                    <p className="font-semibold text-gray-900 truncate">{entry.ledger_name_raw}</p>
                    {entry.entry_type === 'opening_balance' ? (
                      <Badge color="blue" label="Opening Balance" />
                    ) : (
                      <Badge color="gray" label="Payment" />
                    )}
                  </div>
                  <div className="flex flex-wrap gap-3 text-xs text-gray-500">
                    <span className="flex items-center gap-1"><DollarSign className="w-3 h-3" />{fmt(entry.amount)}</span>
                    {entry.payment_date && <span className="flex items-center gap-1"><Clock className="w-3 h-3" />{entry.payment_date}</span>}
                    {entry.voucher_no && <span className="flex items-center gap-1"><FileText className="w-3 h-3" />Vchr: {entry.voucher_no}</span>}
                  </div>
                  {entry.suggested_student_name && (
                    <div className="mt-2 flex items-center gap-2 text-xs text-blue-600 bg-blue-50 rounded-lg px-3 py-1.5 w-fit">
                      <Users className="w-3 h-3" />
                      Suggested: <strong>{entry.suggested_student_name}</strong>
                      <button
                        onClick={() => setSelectedStudents(p => ({ ...p, [entry.id]: { id: entry.suggested_student_id, name: entry.suggested_student_name } }))}
                        className="underline hover:no-underline ml-1"
                      >Use this</button>
                    </div>
                  )}
                </div>
                <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-2 min-w-0 lg:min-w-80">
                  <div className="flex-1">
                    <StudentSearch
                      value={selectedStudents[entry.id]?.name || ''}
                      onSelect={s => setSelectedStudents(p => ({ ...p, [entry.id]: s }))}
                      placeholder="Assign student…"
                    />
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => resolve(entry.id, selectedStudents[entry.id]?.id)}
                      disabled={!!actionLoading[entry.id] || !selectedStudents[entry.id]}
                      className="flex items-center gap-1.5 px-4 py-2.5 bg-emerald-600 text-white text-sm font-medium rounded-xl hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors whitespace-nowrap"
                    >
                      {actionLoading[entry.id] === 'resolve' ? <Spinner size="sm" /> : <Check className="w-4 h-4" />}
                      Confirm
                    </button>
                    <button
                      onClick={() => skip(entry.id)}
                      disabled={!!actionLoading[entry.id]}
                      className="flex items-center gap-1.5 px-3 py-2.5 border border-gray-200 text-gray-600 text-sm font-medium rounded-xl hover:bg-gray-50 disabled:opacity-50 transition-colors"
                    >
                      {actionLoading[entry.id] === 'skip' ? <Spinner size="sm" /> : <X className="w-4 h-4" />}
                    </button>
                  </div>
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 3: Manual Payment Entry
// ═══════════════════════════════════════════════════════════════════════════════
function ManualPayment({ showToast }) {
  const [form, setForm] = useState({
    student_id: null, amount: '', payment_date: new Date().toISOString().slice(0, 10),
    mode: 'cash', receipt_no: '', notes: '',
  });
  const [selectedStudent, setSelectedStudent] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.student_id) { showToast('Please select a student', 'error'); return; }
    if (!form.amount || parseFloat(form.amount) <= 0) { showToast('Enter a valid amount', 'error'); return; }

    setSubmitting(true);
    try {
      const res = await api.post('/api/fees/payments/manual', {
        student_id: form.student_id,
        amount: parseFloat(form.amount),
        payment_date: form.payment_date,
        mode: form.mode,
        receipt_no: form.receipt_no || undefined,
        notes: form.notes || undefined,
      });
      showToast(`Payment of ${fmt(res.data.amount)} recorded (ID: ${res.data.id})`, 'success');
      setForm({ student_id: null, amount: '', payment_date: new Date().toISOString().slice(0, 10), mode: 'cash', receipt_no: '', notes: '' });
      setSelectedStudent(null);
    } catch (err) {
      showToast(err.response?.data?.detail || 'Payment failed', 'error');
    }
    setSubmitting(false);
  };

  const modes = [
    { value: 'cash', label: 'Cash' },
    { value: 'cheque', label: 'Cheque' },
    { value: 'dd', label: 'Demand Draft' },
    { value: 'bank_transfer', label: 'Bank Transfer' },
    { value: 'tally_sync', label: 'Tally Sync' },
  ];

  return (
    <div className="max-w-2xl">
      <div className="mb-6">
        <h2 className="text-xl font-bold text-gray-900">Manual Payment Entry</h2>
        <p className="text-sm text-gray-500 mt-1">Record a payment received directly from a student.</p>
      </div>

      <Card className="p-6">
        <form onSubmit={handleSubmit} className="space-y-5">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">Student *</label>
            <StudentSearch
              value={selectedStudent ? `${selectedStudent.name} (${selectedStudent.register_number})` : ''}
              onSelect={s => { setSelectedStudent(s); setForm(p => ({ ...p, student_id: s?.id || null })); }}
              placeholder="Search student by name or register number…"
            />
            {selectedStudent && (
              <div className="mt-2 text-xs text-gray-500 bg-blue-50 rounded-lg px-3 py-2">
                <span className="font-medium text-blue-700">{selectedStudent.name}</span> · Reg: {selectedStudent.register_number} · Sem {selectedStudent.current_semester}
              </div>
            )}
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5">Amount (₹) *</label>
              <input
                type="number" min="1" step="0.01" required
                value={form.amount}
                onChange={e => setForm(p => ({ ...p, amount: e.target.value }))}
                className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400"
                placeholder="0.00"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5">Payment Date *</label>
              <input
                type="date" required
                value={form.payment_date}
                onChange={e => setForm(p => ({ ...p, payment_date: e.target.value }))}
                className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5">Payment Mode *</label>
              <select
                value={form.mode}
                onChange={e => setForm(p => ({ ...p, mode: e.target.value }))}
                className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400 bg-white"
              >
                {modes.map(m => <option key={m.value} value={m.value}>{m.label}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-1.5">Receipt No.</label>
              <input
                type="text"
                value={form.receipt_no}
                onChange={e => setForm(p => ({ ...p, receipt_no: e.target.value }))}
                className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400"
                placeholder="e.g. REC-2024-001"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">Notes</label>
            <textarea
              rows={3}
              value={form.notes}
              onChange={e => setForm(p => ({ ...p, notes: e.target.value }))}
              className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-400 resize-none"
              placeholder="Optional notes about this payment…"
            />
          </div>

          <button
            type="submit"
            disabled={submitting}
            className="w-full flex items-center justify-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 text-white font-semibold rounded-xl hover:from-blue-700 hover:to-blue-800 disabled:opacity-50 transition-all shadow-sm"
          >
            {submitting ? <Spinner size="sm" /> : <CreditCard className="w-4 h-4" />}
            Record Payment
          </button>
        </form>
      </Card>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 4: Fee Structure Management
// ═══════════════════════════════════════════════════════════════════════════════
function FeeStructureManager({ showToast }) {
  const [structures, setStructures] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form, setForm] = useState({ department_id: '', semester: '', amount: '', academic_year: '' });
  const [submitting, setSubmitting] = useState(false);

  const fetchAll = useCallback(async () => {
    setLoading(true);
    try {
      const [struRes, deptRes] = await Promise.all([
        api.get('/api/fees/structure'),
        api.get('/api/departments/'),
      ]);
      setStructures(struRes.data);
      setDepartments(deptRes.data || []);
    } catch { showToast('Failed to load data', 'error'); }
    setLoading(false);
  }, [showToast]);

  useEffect(() => { fetchAll(); }, [fetchAll]);

  const openNew = () => { setEditing(null); setForm({ department_id: '', semester: '', amount: '', academic_year: '' }); setShowForm(true); };
  const openEdit = (fs) => { setEditing(fs); setForm({ department_id: fs.department_id, semester: fs.semester, amount: fs.amount, academic_year: fs.academic_year }); setShowForm(true); };
  const closeForm = () => { setShowForm(false); setEditing(null); };

  const submit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const payload = { department_id: parseInt(form.department_id), semester: parseInt(form.semester), amount: parseFloat(form.amount), academic_year: form.academic_year };
      if (editing) {
        await api.put(`/api/fees/structure/${editing.id}`, payload);
        showToast('Fee structure updated!', 'success');
      } else {
        await api.post('/api/fees/structure', payload);
        showToast('Fee structure created!', 'success');
      }
      closeForm();
      fetchAll();
    } catch (err) {
      showToast(err.response?.data?.detail || 'Save failed', 'error');
    }
    setSubmitting(false);
  };

  const remove = async (id) => {
    if (!window.confirm('Delete this fee structure?')) return;
    try {
      await api.delete(`/api/fees/structure/${id}`);
      showToast('Deleted!', 'success');
      fetchAll();
    } catch (err) {
      showToast(err.response?.data?.detail || 'Delete failed', 'error');
    }
  };

  if (loading) return <div className="flex items-center justify-center py-24 text-gray-400"><Spinner /><span className="ml-3">Loading…</span></div>;

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-gray-900">Fee Structure</h2>
          <p className="text-sm text-gray-500 mt-1">Define flat fee amounts per department, semester and academic year.</p>
        </div>
        <button onClick={openNew} className="flex items-center gap-2 px-4 py-2.5 bg-blue-600 text-white text-sm font-medium rounded-xl hover:bg-blue-700 transition-colors">
          <Plus className="w-4 h-4" /> Add Structure
        </button>
      </div>

      {/* Form Modal */}
      {showForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
          <Card className="w-full max-w-md p-6">
            <div className="flex items-center justify-between mb-5">
              <h3 className="font-bold text-lg text-gray-900">{editing ? 'Edit' : 'New'} Fee Structure</h3>
              <button onClick={closeForm}><X className="w-5 h-5 text-gray-400" /></button>
            </div>
            <form onSubmit={submit} className="space-y-4">
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">Department *</label>
                <select required value={form.department_id} onChange={e => setForm(p => ({ ...p, department_id: e.target.value }))}
                  className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 bg-white">
                  <option value="">Select department…</option>
                  {departments.map(d => <option key={d.id} value={d.id}>{d.name} ({d.code})</option>)}
                </select>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-1.5">Semester *</label>
                  <select required value={form.semester} onChange={e => setForm(p => ({ ...p, semester: e.target.value }))}
                    className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 bg-white">
                    <option value="">Select…</option>
                    {[1,2,3,4,5,6,7,8].map(s => <option key={s} value={s}>Semester {s}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-1.5">Academic Year *</label>
                  <input required type="text" placeholder="2024-2025" value={form.academic_year}
                    onChange={e => setForm(p => ({ ...p, academic_year: e.target.value }))}
                    className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20" />
                </div>
              </div>
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-1.5">Fee Amount (₹) *</label>
                <input required type="number" min="0" step="0.01" placeholder="0.00" value={form.amount}
                  onChange={e => setForm(p => ({ ...p, amount: e.target.value }))}
                  className="w-full px-3 py-2.5 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20" />
              </div>
              <div className="flex gap-3 pt-2">
                <button type="button" onClick={closeForm} className="flex-1 px-4 py-2.5 border border-gray-200 text-gray-600 text-sm font-medium rounded-xl hover:bg-gray-50">Cancel</button>
                <button type="submit" disabled={submitting}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 bg-blue-600 text-white text-sm font-semibold rounded-xl hover:bg-blue-700 disabled:opacity-50">
                  {submitting ? <Spinner size="sm" /> : null}{editing ? 'Update' : 'Create'}
                </button>
              </div>
            </form>
          </Card>
        </div>
      )}

      <Card className="overflow-hidden">
        {structures.length === 0 ? (
          <div className="p-16 text-center text-gray-400">No fee structures defined yet. Click "Add Structure" to create one.</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50">
                <tr>
                  {['Department', 'Semester', 'Academic Year', 'Fee Amount', 'Actions'].map(h => (
                    <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {structures.map(fs => (
                  <tr key={fs.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-medium text-gray-900">
                      <span className="inline-flex items-center gap-2">
                        <Badge label={fs.department_code} color="blue" />
                        {fs.department_name}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-700">Semester {fs.semester}</td>
                    <td className="px-4 py-3 text-gray-700">{fs.academic_year}</td>
                    <td className="px-4 py-3 font-semibold text-gray-900">{fmt(fs.amount)}</td>
                    <td className="px-4 py-3">
                      <div className="flex gap-2">
                        <button onClick={() => openEdit(fs)} className="p-1.5 text-blue-500 hover:text-blue-700 hover:bg-blue-50 rounded-lg transition-colors"><Edit2 className="w-4 h-4" /></button>
                        <button onClick={() => remove(fs.id)} className="p-1.5 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"><Trash2 className="w-4 h-4" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      {/* Generate Assignments */}
      <GenerateAssignments showToast={showToast} departments={departments} />
    </div>
  );
}

function GenerateAssignments({ showToast, departments }) {
  const [form, setForm] = useState({ department_id: '', semester: '', academic_year: '' });
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState(null);

  const generate = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    setResult(null);
    try {
      const res = await api.post('/api/fees/assignments/generate', {
        department_id: parseInt(form.department_id),
        semester: parseInt(form.semester),
        academic_year: form.academic_year,
      });
      setResult(res.data);
      showToast(res.data.message, 'success');
    } catch (err) {
      showToast(err.response?.data?.detail || 'Generation failed', 'error');
    }
    setSubmitting(false);
  };

  return (
    <Card className="p-5 border-l-4 border-l-purple-500">
      <h3 className="font-semibold text-gray-900 mb-1">Generate Fee Assignments</h3>
      <p className="text-sm text-gray-500 mb-4">Bulk-assign fee dues to all active students in a department+semester.</p>
      <form onSubmit={generate} className="flex flex-wrap gap-3 items-end">
        <div>
          <label className="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Department</label>
          <select required value={form.department_id} onChange={e => setForm(p => ({ ...p, department_id: e.target.value }))}
            className="px-3 py-2 text-sm border border-gray-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-purple-500/20">
            <option value="">Select…</option>
            {departments.map(d => <option key={d.id} value={d.id}>{d.code}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Semester</label>
          <select required value={form.semester} onChange={e => setForm(p => ({ ...p, semester: e.target.value }))}
            className="px-3 py-2 text-sm border border-gray-200 rounded-xl bg-white focus:outline-none focus:ring-2 focus:ring-purple-500/20">
            <option value="">Select…</option>
            {[1,2,3,4,5,6,7,8].map(s => <option key={s} value={s}>Sem {s}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-xs font-bold text-gray-400 uppercase tracking-wider mb-1">Academic Year</label>
          <input required type="text" placeholder="2024-2025" value={form.academic_year}
            onChange={e => setForm(p => ({ ...p, academic_year: e.target.value }))}
            className="px-3 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500/20 w-32" />
        </div>
        <button type="submit" disabled={submitting}
          className="flex items-center gap-2 px-5 py-2 bg-purple-600 text-white text-sm font-semibold rounded-xl hover:bg-purple-700 disabled:opacity-50">
          {submitting ? <Spinner size="sm" /> : <Plus className="w-4 h-4" />}Generate
        </button>
      </form>
      {result && (
        <div className="mt-3 text-sm text-purple-700 bg-purple-50 rounded-lg px-4 py-2">
          ✓ {result.message}
        </div>
      )}
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 5: Student Fee Ledger View
// ═══════════════════════════════════════════════════════════════════════════════
function StudentLedgerView({ showToast }) {
  const [selectedStudent, setSelectedStudent] = useState(null);
  const [summary, setSummary] = useState(null);
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(false);

  const lookup = useCallback(async (student) => {
    if (!student) { setSummary(null); setHistory([]); return; }
    setLoading(true);
    try {
      const [sumRes, histRes] = await Promise.all([
        api.get(`/api/fees/student/${student.id}/summary`),
        api.get(`/api/fees/student/${student.id}/history`),
      ]);
      setSummary(sumRes.data);
      setHistory(histRes.data);
    } catch (err) {
      showToast(err.response?.data?.detail || 'Failed to load student data', 'error');
    }
    setLoading(false);
  }, [showToast]);

  useEffect(() => { if (selectedStudent) lookup(selectedStudent); }, [selectedStudent, lookup]);

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-bold text-gray-900">Student Fee Ledger</h2>
        <p className="text-sm text-gray-500 mt-1">Look up any student's fee summary and payment history.</p>
      </div>

      <Card className="p-4">
        <StudentSearch
          onSelect={s => setSelectedStudent(s)}
          placeholder="Search student to view their fee ledger…"
        />
      </Card>

      {loading && (
        <div className="flex items-center justify-center py-16 text-gray-400">
          <Spinner /><span className="ml-3">Loading student data…</span>
        </div>
      )}

      {summary && !loading && (
        <>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <SummaryCard icon={BookOpen} label="Total Due" value={fmt(summary.total_due)} color="blue" />
            <SummaryCard icon={CheckCircle} label="Total Paid" value={fmt(summary.total_paid)} color="green" />
            <SummaryCard icon={AlertCircle} label="Pending Balance" value={fmt(summary.pending_balance)} color={summary.pending_balance > 0 ? 'red' : 'green'} />
          </div>

          {summary.fee_breakdown && summary.fee_breakdown.length > 0 && (
            <Card className="overflow-hidden mb-6">
              <div className="px-5 py-4 border-b border-gray-50 flex items-center gap-2">
                <BookOpen className="w-4 h-4 text-gray-400" />
                <h3 className="font-semibold text-gray-900">Fee Breakdown</h3>
                <span className="text-xs text-gray-400 bg-gray-100 rounded-full px-2 py-0.5 ml-1">
                  {summary.fee_breakdown.length} {summary.fee_breakdown.length === 1 ? 'item' : 'items'}
                </span>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50">
                    <tr>
                      {['Fee Type', 'Academic Year', 'Semester', 'Amount Due', 'Paid', 'Balance'].map(h => (
                        <th key={h} className="px-5 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {summary.fee_breakdown.map((fee, idx) => {
                      const style = getFeeStyle(fee.fee_type);
                      const Icon = style.icon;
                      const isCleared = (fee.balance ?? fee.amount_due) === 0;
                      return (
                        <tr key={fee.id} className={`transition-colors ${style.rowBg} ${idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/20'}`}>
                          <td className="px-5 py-3.5">
                            <div className="flex items-center gap-3">
                              <div className={`w-8 h-8 rounded-lg ${style.iconBg} flex items-center justify-center flex-shrink-0`}>
                                <Icon className={`w-4 h-4 ${style.iconColor}`} />
                              </div>
                              <span className={`inline-flex items-center px-2.5 py-1 rounded-lg text-xs font-semibold ${style.badge}`}>
                                {fee.fee_type}
                              </span>
                            </div>
                          </td>
                          <td className="px-5 py-3.5 text-gray-600">{fee.academic_year || '—'}</td>
                          <td className="px-5 py-3.5 text-gray-600">Semester {fee.semester}</td>
                          <td className="px-5 py-3.5 text-gray-700">{fmt(fee.amount_due)}</td>
                          <td className="px-5 py-3.5 font-medium text-emerald-700">{fmt(fee.amount_paid ?? 0)}</td>
                          <td className="px-5 py-3.5">
                            {isCleared ? (
                              <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-emerald-100 text-emerald-700 text-xs font-semibold">
                                <CheckCircle className="w-3 h-3" /> Cleared
                              </span>
                            ) : (
                              <span className="font-bold text-red-600">{fmt(fee.balance ?? fee.amount_due)}</span>
                            )}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                  <tfoot className="bg-gray-50 border-t-2 border-gray-100">
                    <tr>
                      <td colSpan={3} className="px-5 py-3 text-sm font-bold text-gray-700">Total</td>
                      <td className="px-5 py-3 font-bold text-gray-800">{fmt(summary.total_due)}</td>
                      <td className="px-5 py-3 font-bold text-emerald-700">{fmt(summary.total_paid)}</td>
                      <td className="px-5 py-3 font-bold text-red-600">{fmt(summary.pending_balance)}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </Card>
          )}

          <Card className="overflow-hidden">
            <div className="px-5 py-4 border-b border-gray-50">
              <h3 className="font-semibold text-gray-900">Payment History — {summary.student_name} ({summary.register_number})</h3>
            </div>
            {history.length === 0 ? (
              <div className="p-12 text-center text-gray-400">No payments recorded yet.</div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50">
                    <tr>
                      {['Date', 'Amount', 'Mode', 'Source', 'Receipt No.', 'Voucher No.', 'Notes'].map(h => (
                        <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {history.map(p => (
                      <tr key={p.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-4 py-3 text-gray-600">{p.payment_date}</td>
                        <td className="px-4 py-3 font-semibold text-gray-900">{fmt(p.amount)}</td>
                        <td className="px-4 py-3"><Badge label={p.mode} color={p.mode === 'cash' ? 'green' : 'blue'} /></td>
                        <td className="px-4 py-3"><Badge label={p.source} color={p.source === 'manual' ? 'purple' : 'gray'} /></td>
                        <td className="px-4 py-3 text-gray-600">{p.receipt_no || '—'}</td>
                        <td className="px-4 py-3 text-gray-600">{p.voucher_no || '—'}</td>
                        <td className="px-4 py-3 text-gray-500 max-w-xs truncate">{p.notes || '—'}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </Card>
        </>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 6: Reports
// ═══════════════════════════════════════════════════════════════════════════════
const DEPT_COLORS = ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#06B6D4', '#EC4899', '#F97316'];

function Reports({ showToast }) {
  const [defaulters, setDefaulters] = useState([]);
  const [summary, setSummary] = useState(null);
  const [departments, setDepartments] = useState([]);
  const [filters, setFilters] = useState({ department_id: '', semester: '', academic_year: '' });
  const [loading, setLoading] = useState(true);
  const [activeView, setActiveView] = useState('defaulters');

  const fetchAll = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filters.department_id) params.set('department_id', filters.department_id);
      if (filters.semester) params.set('semester', filters.semester);
      if (filters.academic_year) params.set('academic_year', filters.academic_year);
      const [defRes, sumRes, deptRes] = await Promise.all([
        api.get(`/api/fees/reports/defaulters?${params}`),
        api.get(`/api/fees/reports/collection-summary?${params}`),
        api.get('/api/departments/'),
      ]);
      setDefaulters(defRes.data);
      setSummary(sumRes.data);
      setDepartments(deptRes.data || []);
    } catch { showToast('Failed to load reports', 'error'); }
    setLoading(false);
  }, [filters, showToast]);

  useEffect(() => { fetchAll(); }, [fetchAll]);

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-gray-900">Reports & Analytics</h2>
          <p className="text-sm text-gray-500 mt-1">Fee collection summary and defaulter tracking.</p>
        </div>
        <button onClick={fetchAll} className="flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700">
          <RefreshCw className="w-4 h-4" /> Refresh
        </button>
      </div>

      {/* Filters */}
      <Card className="p-4 flex flex-wrap gap-3">
        <select value={filters.department_id} onChange={e => setFilters(p => ({ ...p, department_id: e.target.value }))}
          className="px-3 py-2 text-sm border border-gray-200 rounded-xl bg-white focus:outline-none">
          <option value="">All Departments</option>
          {departments.map(d => <option key={d.id} value={d.id}>{d.code} — {d.name}</option>)}
        </select>
        <select value={filters.semester} onChange={e => setFilters(p => ({ ...p, semester: e.target.value }))}
          className="px-3 py-2 text-sm border border-gray-200 rounded-xl bg-white focus:outline-none">
          <option value="">All Semesters</option>
          {[1,2,3,4,5,6,7,8].map(s => <option key={s} value={s}>Sem {s}</option>)}
        </select>
        <input type="text" placeholder="Academic Year (2024-2025)" value={filters.academic_year}
          onChange={e => setFilters(p => ({ ...p, academic_year: e.target.value }))}
          className="px-3 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none w-48" />
      </Card>

      {/* Summary Cards */}
      {summary && (
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <SummaryCard icon={DollarSign} label="Total Collected" value={fmt(summary.grand_total)} color="green" />
          <SummaryCard icon={AlertCircle} label="Defaulters" value={defaulters.length} color="red" sub="students with balance > 0" />
          <SummaryCard icon={TrendingUp} label="Pending Balance" value={fmt(defaulters.reduce((a, b) => a + b.pending_balance, 0))} color="amber" />
        </div>
      )}

      {/* Tab Toggle */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {[['defaulters', 'Defaulters', Users], ['chart', 'Collection Chart', BarChart2]].map(([key, label, Icon]) => (
          <button key={key} onClick={() => setActiveView(key)}
            className={`flex items-center gap-2 px-4 py-2 text-sm font-medium rounded-lg transition-all ${activeView === key ? 'bg-white shadow-sm text-gray-900' : 'text-gray-500 hover:text-gray-700'}`}>
            <Icon className="w-4 h-4" />{label}
          </button>
        ))}
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-16 text-gray-400"><Spinner /><span className="ml-3">Loading…</span></div>
      ) : activeView === 'chart' ? (
        <div className="space-y-5">
          {summary?.monthly?.length > 0 && (
            <Card className="p-5">
              <h3 className="font-semibold text-gray-900 mb-4">Monthly Collection</h3>
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={summary.monthly}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis dataKey="month_label" tick={{ fontSize: 12 }} />
                  <YAxis tick={{ fontSize: 12 }} tickFormatter={v => `₹${(v/1000).toFixed(0)}k`} />
                  <Tooltip formatter={v => [fmt(v), 'Collected']} />
                  <Bar dataKey="total_collected" fill="#3B82F6" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </Card>
          )}
          {summary?.by_department?.length > 0 && (
            <Card className="p-5">
              <h3 className="font-semibold text-gray-900 mb-4">Collection by Department</h3>
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={summary.by_department}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                  <XAxis dataKey="department" tick={{ fontSize: 12 }} />
                  <YAxis tick={{ fontSize: 12 }} tickFormatter={v => `₹${(v/1000).toFixed(0)}k`} />
                  <Tooltip formatter={v => [fmt(v), 'Collected']} />
                  <Bar dataKey="total_collected" radius={[4, 4, 0, 0]}>
                    {summary.by_department.map((_, i) => <Cell key={i} fill={DEPT_COLORS[i % DEPT_COLORS.length]} />)}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </Card>
          )}
        </div>
      ) : (
        <Card className="overflow-hidden">
          {defaulters.length === 0 ? (
            <div className="p-16 flex flex-col items-center gap-4">
              <div className="w-16 h-16 rounded-2xl bg-emerald-50 flex items-center justify-center">
                <CheckCircle className="w-8 h-8 text-emerald-500" />
              </div>
              <div className="text-center">
                <p className="font-semibold text-gray-900">No defaulters found!</p>
                <p className="text-sm text-gray-400 mt-1">All students have cleared their dues.</p>
              </div>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-gray-50">
                  <tr>
                    {['Student', 'Register No.', 'Department', 'Semester', 'Due', 'Paid', 'Balance'].map(h => (
                      <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-50">
                  {defaulters.map(d => (
                    <tr key={d.student_id} className="hover:bg-red-50/30 transition-colors">
                      <td className="px-4 py-3 font-medium text-gray-900">{d.student_name}</td>
                      <td className="px-4 py-3 text-gray-600 font-mono text-xs">{d.register_number}</td>
                      <td className="px-4 py-3 text-gray-600">{d.department_name}</td>
                      <td className="px-4 py-3 text-gray-600">{d.current_semester}</td>
                      <td className="px-4 py-3 text-gray-700">{fmt(d.total_due)}</td>
                      <td className="px-4 py-3 text-emerald-700">{fmt(d.total_paid)}</td>
                      <td className="px-4 py-3">
                        <span className="inline-flex items-center gap-1 font-semibold text-red-700 bg-red-50 px-2 py-0.5 rounded-full text-xs">
                          {fmt(d.pending_balance)}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      )}
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 7: Ledger Mapping Management
// ═══════════════════════════════════════════════════════════════════════════════
function LedgerMappings({ showToast }) {
  const [mappings, setMappings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editing, setEditing] = useState(null);
  const [newStudentForEdit, setNewStudentForEdit] = useState(null);

  const fetch = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/api/fees/mappings');
      setMappings(res.data);
    } catch { showToast('Failed to load mappings', 'error'); }
    setLoading(false);
  }, [showToast]);

  useEffect(() => { fetch(); }, [fetch]);

  const update = async (id, studentId) => {
    if (!studentId) { showToast('Select a student first', 'error'); return; }
    try {
      await api.put(`/api/fees/mappings/${id}`, { student_id: studentId });
      showToast('Mapping updated!', 'success');
      setEditing(null);
      fetch();
    } catch (err) { showToast(err.response?.data?.detail || 'Update failed', 'error'); }
  };

  const remove = async (id) => {
    if (!window.confirm('Delete this ledger mapping?')) return;
    try {
      await api.delete(`/api/fees/mappings/${id}`);
      showToast('Mapping deleted', 'success');
      fetch();
    } catch (err) { showToast(err.response?.data?.detail || 'Delete failed', 'error'); }
  };

  if (loading) return <div className="flex items-center justify-center py-24 text-gray-400"><Spinner /><span className="ml-3">Loading…</span></div>;

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-gray-900">Ledger Mappings</h2>
          <p className="text-sm text-gray-500 mt-1">Confirmed Tally ledger name → student mappings. Future uploads with the same ledger name will auto-match.</p>
        </div>
        <button onClick={fetch} className="text-gray-400 hover:text-gray-600"><RefreshCw className="w-4 h-4" /></button>
      </div>
      <Card className="overflow-hidden">
        {mappings.length === 0 ? (
          <div className="p-12 text-center text-gray-400">No confirmed mappings yet. Resolve items from the Unmapped Queue to build mappings.</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50">
                <tr>
                  {['Ledger Name (Tally)', 'Mapped Student', 'Register No.', 'Confirmed At', 'Actions'].map(h => (
                    <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {mappings.map(m => (
                  <tr key={m.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 max-w-xs">
                      <p className="font-mono text-xs text-gray-700 truncate" title={m.ledger_name_raw}>{m.ledger_name_raw}</p>
                    </td>
                    <td className="px-4 py-3">
                      {editing === m.id ? (
                        <StudentSearch
                          onSelect={s => setNewStudentForEdit(s)}
                          placeholder="Select new student…"
                        />
                      ) : (
                        <span className="font-medium text-gray-900">{m.student_name || '—'}</span>
                      )}
                    </td>
                    <td className="px-4 py-3 text-gray-600 font-mono text-xs">{m.register_number || '—'}</td>
                    <td className="px-4 py-3 text-gray-500 text-xs">{m.confirmed_at ? new Date(m.confirmed_at).toLocaleDateString('en-IN') : '—'}</td>
                    <td className="px-4 py-3">
                      {editing === m.id ? (
                        <div className="flex gap-2">
                          <button onClick={() => update(m.id, newStudentForEdit?.id)} className="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"><Check className="w-4 h-4" /></button>
                          <button onClick={() => { setEditing(null); setNewStudentForEdit(null); }} className="p-1.5 text-gray-400 hover:bg-gray-100 rounded-lg"><X className="w-4 h-4" /></button>
                        </div>
                      ) : (
                        <div className="flex gap-2">
                          <button onClick={() => { setEditing(m.id); setNewStudentForEdit(null); }} className="p-1.5 text-blue-500 hover:bg-blue-50 rounded-lg"><Edit2 className="w-4 h-4" /></button>
                          <button onClick={() => remove(m.id)} className="p-1.5 text-red-400 hover:bg-red-50 rounded-lg"><Trash2 className="w-4 h-4" /></button>
                        </div>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN ACCOUNTANT PORTAL
// ═══════════════════════════════════════════════════════════════════════════════
const TABS = [
  { id: 'upload', label: 'Daily Collection', icon: Upload },
  { id: 'fee_upload', label: 'Fee Upload', icon: FileText },
  { id: 'unmapped', label: 'Unmapped Queue', icon: AlertTriangle },
  { id: 'manual', label: 'Manual Payment', icon: CreditCard },
  { id: 'structure', label: 'Fee Structure', icon: BookOpen },
  { id: 'ledger', label: 'Student Ledger', icon: Eye },
  { id: 'reports', label: 'Reports', icon: BarChart2 },
  { id: 'mappings', label: 'Ledger Mappings', icon: MapPin },
];

export default function AccountantPortal() {
  const [activeTab, setActiveTab] = useState('upload');
  const [toast, setToast] = useState(null);

  const showToast = useCallback((message, type = 'success') => {
    setToast({ message, type, key: Date.now() });
  }, []);

  const tabContent = {
    upload: <UploadCenter showToast={showToast} />,
    fee_upload: <FeeUpload showToast={showToast} />,
    unmapped: <UnmappedQueue showToast={showToast} />,
    manual: <ManualPayment showToast={showToast} />,
    structure: <FeeStructureManager showToast={showToast} />,
    ledger: <StudentLedgerView showToast={showToast} />,
    reports: <Reports showToast={showToast} />,
    mappings: <LedgerMappings showToast={showToast} />,
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-100 px-6 py-5">
        <div className="flex items-center gap-4">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-600 to-indigo-700 flex items-center justify-center">
            <DollarSign className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-xl font-bold text-gray-900">Accounts & Fees Portal</h1>
            <p className="text-sm text-gray-500">Tally import · Payment management · Fee structure · Reports</p>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="bg-white border-b border-gray-100 px-6 overflow-x-auto">
        <nav className="flex gap-1 min-w-max">
          {TABS.map(tab => {
            const Icon = tab.icon;
            const active = activeTab === tab.id;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex items-center gap-2 px-4 py-3.5 text-sm font-medium border-b-2 whitespace-nowrap transition-all ${
                  active
                    ? 'border-blue-600 text-blue-600 bg-blue-50/50'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-200'
                }`}
              >
                <Icon className="w-4 h-4" />
                {tab.label}
              </button>
            );
          })}
        </nav>
      </div>

      {/* Content */}
      <div className="p-6 max-w-7xl mx-auto">
        {tabContent[activeTab]}
      </div>

      {/* Toast */}
      {toast && (
        <Toast
          key={toast.key}
          message={toast.message}
          type={toast.type}
          onClose={() => setToast(null)}
        />
      )}
    </div>
  );
}
