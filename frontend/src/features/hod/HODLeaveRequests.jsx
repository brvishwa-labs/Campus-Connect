import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import {
  Calendar, Plus, Clock, CheckCircle, XCircle, AlertCircle,
  Loader2, FileText, Users, Shield, ChevronDown, ChevronUp,
  ArrowRight
} from 'lucide-react';

// ─── Status Configuration ────────────────────────────────────────────────────
const STATUS_CFG = {
  pending_alternate_hod: {
    label: 'Awaiting Delegate Acceptance',
    color: 'text-amber-700',
    bg: 'bg-amber-50',
    border: 'border-amber-300',
    dot: 'bg-amber-500',
    step: 1
  },
  pending_dean: {
    label: 'Pending Dean',
    color: 'text-blue-700',
    bg: 'bg-blue-50',
    border: 'border-blue-300',
    dot: 'bg-blue-500',
    step: 2
  },
  pending_om: {
    label: 'Pending Office Manager',
    color: 'text-purple-700',
    bg: 'bg-purple-50',
    border: 'border-purple-300',
    dot: 'bg-purple-500',
    step: 3
  },
  pending_principal: {
    label: 'Pending Principal',
    color: 'text-indigo-700',
    bg: 'bg-indigo-50',
    border: 'border-indigo-300',
    dot: 'bg-indigo-500',
    step: 4
  },
  approved: {
    label: 'Approved',
    color: 'text-emerald-700',
    bg: 'bg-emerald-50',
    border: 'border-emerald-300',
    dot: 'bg-emerald-500',
    step: 5
  },
  rejected: {
    label: 'Rejected',
    color: 'text-red-700',
    bg: 'bg-red-50',
    border: 'border-red-300',
    dot: 'bg-red-500',
    step: -1
  },
  withdrawn: {
    label: 'Withdrawn',
    color: 'text-gray-700',
    bg: 'bg-gray-50',
    border: 'border-gray-300',
    dot: 'bg-gray-400',
    step: -1
  }
};

const fmt = (iso) =>
  iso ? new Date(iso + 'T00:00:00').toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' }) : '—';

// ─── Approval Progress Bar ───────────────────────────────────────────────────
const ApprovalProgress = ({ status }) => {
  const cfg = STATUS_CFG[status] || STATUS_CFG.pending_alternate_hod;
  const steps = [
    { label: 'Delegate', key: 'pending_alternate_hod' },
    { label: 'Dean', key: 'pending_dean' },
    { label: 'OM', key: 'pending_om' },
    { label: 'Principal', key: 'pending_principal' },
    { label: 'Approved', key: 'approved' },
  ];

  const isRejected = status === 'rejected' || status === 'withdrawn';

  return (
    <div className="flex items-center gap-1 mt-3">
      {steps.map((step, idx) => {
        const stepCfg = STATUS_CFG[step.key] || {};
        const isDone = !isRejected && cfg.step > stepCfg.step;
        const isCurrent = !isRejected && cfg.step === stepCfg.step;
        const isPending = !isRejected && cfg.step < stepCfg.step;

        return (
          <React.Fragment key={step.key}>
            <div className="flex flex-col items-center">
              <div className={`w-6 h-6 rounded-full flex items-center justify-center text-[9px] font-black transition-all ${
                isRejected
                  ? 'bg-gray-100 text-gray-400'
                  : isDone
                    ? 'bg-emerald-500 text-white'
                    : isCurrent
                      ? `${stepCfg.dot || 'bg-amber-500'} text-white ring-2 ring-offset-1 ring-amber-400`
                      : 'bg-gray-100 text-gray-400'
              }`}>
                {isDone ? <CheckCircle className="w-3 h-3" /> : idx + 1}
              </div>
              <span className={`text-[9px] mt-0.5 font-semibold ${
                isCurrent ? 'text-gray-800' : 'text-gray-400'
              }`}>{step.label}</span>
            </div>
            {idx < steps.length - 1 && (
              <div className={`flex-1 h-px mb-3 ${isDone ? 'bg-emerald-400' : 'bg-gray-200'}`} />
            )}
          </React.Fragment>
        );
      })}
    </div>
  );
};


// --- Reassign Delegate Modal --------------------------------------------------
const ReassignDelegateModal = ({ isOpen, onClose, onSubmit, facultyList, isSubmitting }) => {
  const [selectedFaculty, setSelectedFaculty] = useState('');

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-900/50 backdrop-blur-sm">
      <div className="bg-white rounded-2xl max-w-md w-full shadow-xl overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        <div className="p-6 border-b border-gray-100 flex items-center justify-between">
          <div>
            <h2 className="text-xl font-bold text-gray-900">Reassign Delegate</h2>
            <p className="text-sm text-gray-500 mt-1">Select a new faculty member to act as HOD.</p>
          </div>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600 transition-colors">
            <XCircle className="w-6 h-6" />
          </button>
        </div>
        
        <div className="p-6 space-y-4">
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">New Alternate HOD</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Users className="h-5 w-5 text-gray-400" />
              </div>
              <select
                value={selectedFaculty}
                onChange={(e) => setSelectedFaculty(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 transition-all"
                required
              >
                <option value="">Select faculty member...</option>
                {facultyList.map(fac => (
                  <option key={fac.id} value={fac.id}>
                    {fac.first_name} {fac.last_name} ({fac.employee_id})
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>

        <div className="p-6 pt-0 flex gap-3">
          <button
            type="button"
            onClick={onClose}
            className="flex-1 px-4 py-2.5 text-sm font-semibold text-gray-600 bg-gray-100 rounded-xl hover:bg-gray-200 transition-colors"
          >
            Cancel
          </button>
          <button
            type="button"
            onClick={() => onSubmit(selectedFaculty)}
            disabled={!selectedFaculty || isSubmitting}
            className="flex-1 flex items-center justify-center gap-2 px-4 py-2.5 text-sm font-semibold text-white bg-primary-600 rounded-xl hover:bg-primary-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isSubmitting ? <Loader2 className="w-4 h-4 animate-spin" /> : <CheckCircle className="w-4 h-4" />}
            Confirm
          </button>
        </div>
      </div>
    </div>
  );
};


// ─── Individual Leave Card ───────────────────────────────────────────────────
const LeaveCard = ({ req, onReassign }) => {
  const [expanded, setExpanded] = useState(false);
  const status = (req.status || 'pending_alternate_hod').toLowerCase();
  const cfg = STATUS_CFG[status] || STATUS_CFG.pending_alternate_hod;

  const hodArrangement = req.arrangements?.find(a => a.subject === 'HOD Duties');
  const isDeclinedDelegate = hodArrangement?.status?.toLowerCase() === 'rejected' && status === 'pending_alternate_hod';

  return (
    <div className={`bg-white rounded-2xl border ${isDeclinedDelegate ? 'border-red-300' : cfg.border} shadow-sm overflow-hidden`}>
      {/* Color top bar */}
      <div className={`h-1 ${isDeclinedDelegate ? 'bg-red-500' : cfg.dot}`} />

      <div className="p-5 space-y-4">
        {/* Header row */}
        <div className="flex items-start justify-between gap-3">
          <div>
            <div className="flex items-center gap-2 flex-wrap">
              <p className="font-bold text-gray-900 text-[15px]">{req.leave_type}</p>
              <span className={`text-[10px] font-bold uppercase tracking-wider px-2.5 py-0.5 rounded-full border ${isDeclinedDelegate ? 'bg-red-50 text-red-700 border-red-300' : `${cfg.bg} ${cfg.color} ${cfg.border}`}`}>
                {isDeclinedDelegate ? 'Delegate Declined' : cfg.label}
              </span>
            </div>
            <p className="text-[12px] text-gray-500 mt-0.5">Submitted on {fmt(req.created_at?.split('T')[0])}</p>
          </div>
        </div>

        {/* Date info */}
        <div className="flex items-center gap-2 text-[13px] text-gray-700 bg-gray-50 rounded-xl px-3 py-2">
          <Calendar className="w-4 h-4 text-gray-400 flex-shrink-0" />
          <span>{fmt(req.from_date)}</span>
          <ArrowRight className="w-3 h-3 text-gray-400" />
          <span>{fmt(req.to_date)}</span>
          <span className="ml-auto text-[11px] font-bold text-gray-500 bg-white border border-gray-200 px-2 py-0.5 rounded-full">
            {req.duration_days} day{req.duration_days !== 1 ? 's' : ''}
          </span>
        </div>

        {/* Reason */}
        <p className="text-[13px] text-gray-600 leading-relaxed line-clamp-2">{req.reason || 'No reason provided.'}</p>

        {/* Decline Banner */}
        {isDeclinedDelegate && (
          <div className="flex items-start justify-between gap-4 bg-red-50 border border-red-200 rounded-xl p-4">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-[13px] font-bold text-red-800">Delegate Declined Request</p>
                <p className="text-[12px] text-red-600 mt-0.5">
                  <span className="font-semibold">{req.alternate_hod_faculty_name}</span> has declined to handle HOD duties. Please reassign the delegation to proceed.
                </p>
              </div>
            </div>
            <button
              onClick={() => onReassign(req.id)}
              className="flex-shrink-0 bg-red-600 hover:bg-red-700 text-white text-[12px] font-semibold px-4 py-2 rounded-lg transition-colors"
            >
              Reassign Delegate
            </button>
          </div>
        )}

        {/* Delegate info */}
        {!isDeclinedDelegate && req.alternate_hod_faculty_name && (
          <div className={`flex items-start gap-2 rounded-xl px-3 py-2.5 border ${
            status === 'approved' ? 'bg-emerald-50 border-emerald-200' : 'bg-amber-50 border-amber-200'
          }`}>
            <Shield className={`w-4 h-4 flex-shrink-0 mt-0.5 ${status === 'approved' ? 'text-emerald-600' : 'text-amber-600'}`} />
            <div>
              <p className={`text-[11px] font-bold uppercase tracking-wider ${status === 'approved' ? 'text-emerald-700' : 'text-amber-700'}`}>
                {status === 'approved' ? 'Active Delegate' : 'Designated Delegate'}
              </p>
              <p className="text-[13px] font-semibold text-gray-800 mt-0.5">{req.alternate_hod_faculty_name}</p>
              {status === 'approved' && (
                <p className="text-[11px] text-emerald-700 mt-0.5">
                  Currently handling HOD duties for this department
                </p>
              )}
            </div>
          </div>
        )}

        {/* Approval Progress */}
        <div>
          <p className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Approval Progress</p>
          <ApprovalProgress status={status} />
        </div>

        {/* Rejection reason */}
        {req.rejection_reason && (
          <div className="flex items-start gap-2 bg-red-50 border border-red-200 rounded-xl px-3 py-2.5">
            <AlertCircle className="w-4 h-4 text-red-500 flex-shrink-0 mt-px" />
            <div>
              <p className="text-[11px] font-bold text-red-700 uppercase tracking-wider">Rejected</p>
              <p className="text-[12px] text-red-600 mt-0.5">{req.rejection_reason}</p>
            </div>
          </div>
        )}

        {/* Arrangements toggle */}
        {req.arrangements && req.arrangements.length > 0 && (
          <>
            <button
              onClick={() => setExpanded(p => !p)}
              className="flex items-center gap-1.5 text-[12px] font-semibold text-primary-600 hover:text-primary-800 transition-colors"
            >
              {expanded ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
              {req.arrangements.length} Arrangement{req.arrangements.length !== 1 ? 's' : ''}
            </button>

            {expanded && (
              <div className="space-y-2">
                {req.arrangements.map(arr => (
                  <div key={arr.id} className="flex items-start gap-2 bg-gray-50 rounded-xl px-3 py-2 text-[12px]">
                    <Users className="w-3.5 h-3.5 text-gray-400 mt-px flex-shrink-0" />
                    <div>
                      <span className="font-semibold text-gray-800">{arr.substitute_faculty_name}</span>
                      {arr.subject !== 'HOD Duties' && (
                        <span className="text-gray-500 ml-1.5">· {arr.subject} · {arr.class_section}</span>
                      )}
                      {arr.subject === 'HOD Duties' && (
                        <span className="text-amber-600 font-medium ml-1.5">· HOD Duties</span>
                      )}
                      <span className={`ml-2 text-[10px] font-bold uppercase px-1.5 py-0.5 rounded-full ${
                        arr.status?.toLowerCase() === 'accepted' ? 'bg-emerald-100 text-emerald-700' :
                        arr.status?.toLowerCase() === 'rejected' ? 'bg-red-100 text-red-700' :
                        'bg-amber-100 text-amber-700'
                      }`}>{arr.status}</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
};

// ─── Main Component ──────────────────────────────────────────────────────────
export const HODLeaveRequests = () => {
  const [requests, setRequests] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [filter, setFilter] = useState('all');
  
  // Reassign Modal State
  const [isReassignModalOpen, setIsReassignModalOpen] = useState(false);
  const [reassignReqId, setReassignReqId] = useState(null);
  const [facultyList, setFacultyList] = useState([]);
  const [isReassigning, setIsReassigning] = useState(false);

  useEffect(() => {
    fetchRequests();
    fetchFacultyList();
  }, []);

  const fetchRequests = async () => {
    try {
      const res = await axios.get('/api/leave/hod-my-requests');
      setRequests(res.data);
    } catch (err) {
      console.error(err);
      setError('Failed to fetch your leave requests.');
    } finally {
      setIsLoading(false);
    }
  };

  const fetchFacultyList = async () => {
    try {
      const res = await axios.get('/api/leave/hod-leave-preparation-data');
      if (res.data?.department_faculty) {
        setFacultyList(res.data.department_faculty);
      }
    } catch (err) {
      console.error("Failed to fetch faculty list:", err);
    }
  };

  const handleOpenReassign = (reqId) => {
    setReassignReqId(reqId);
    setIsReassignModalOpen(true);
  };

  const handleReassignSubmit = async (newFacultyId) => {
    setIsReassigning(true);
    try {
      await axios.put(`/api/leave/requests/${reassignReqId}/reassign-delegate`, {
        new_faculty_id: parseInt(newFacultyId, 10)
      });
      setIsReassignModalOpen(false);
      setReassignReqId(null);
      // Refresh requests to show the updated status
      await fetchRequests();
    } catch (err) {
      console.error(err);
      alert(err.response?.data?.detail || 'Failed to reassign delegate. Please try again.');
    } finally {
      setIsReassigning(false);
    }
  };

  const FILTERS = [
    { key: 'all', label: 'All' },
    { key: 'pending', label: 'Pending' },
    { key: 'approved', label: 'Approved' },
    { key: 'rejected', label: 'Rejected' },
  ];

  const filtered = requests.filter(r => {
    const s = (r.status || '').toLowerCase();
    if (filter === 'all') return true;
    if (filter === 'pending') return !['approved', 'rejected', 'withdrawn'].includes(s);
    return s === filter;
  });

  const pendingCount = requests.filter(r => !['approved', 'rejected', 'withdrawn'].includes((r.status || '').toLowerCase())).length;

  return (
    <div className="max-w-5xl mx-auto space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-[#0f172a] tracking-tight">My HOD Leave Requests</h1>
          <p className="text-sm text-gray-500 mt-1">Track and manage your HOD leave applications and delegation status.</p>
        </div>
        <div className="flex items-center gap-3">
          {pendingCount > 0 && (
            <span className="inline-flex items-center gap-1.5 bg-amber-100 text-amber-700 font-bold text-sm px-3 py-1.5 rounded-full">
              <Clock className="w-3.5 h-3.5" />
              {pendingCount} Pending
            </span>
          )}
          <Link
            to="/hod/compensation-registry"
            className="inline-flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 hover:bg-gray-50 text-gray-700 text-sm font-semibold rounded-xl transition-colors shadow-sm"
          >
            <FileText className="w-4 h-4" />
            Compensation Registry
          </Link>
          <Link
            to="/hod/leave/substitutes"
            className="inline-flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 hover:bg-gray-50 text-gray-700 text-sm font-semibold rounded-xl transition-colors shadow-sm"
          >
            <Users className="w-4 h-4" />
            Peer Approvals
          </Link>
          <Link
            to="/hod/apply-leave"
            className="inline-flex items-center gap-2 px-4 py-2 bg-primary-600 text-white text-sm font-semibold rounded-xl hover:bg-primary-700 transition-colors shadow-sm"
          >
            <Plus className="w-4 h-4" />
            Apply Leave
          </Link>
        </div>
      </div>

      {/* Error Banner */}
      {error && (
        <div className="bg-red-50 text-red-700 p-4 rounded-xl flex items-start gap-3 border border-red-200">
          <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
          <p className="text-sm font-medium">{error}</p>
        </div>
      )}

      {/* Filter Tabs */}
      {requests.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {FILTERS.map(({ key, label }) => (
            <button
              key={key}
              onClick={() => setFilter(key)}
              className={`px-4 py-1.5 rounded-full text-sm font-semibold transition-colors ${
                filter === key
                  ? 'bg-[#0f172a] text-white'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              {label}
              {key === 'pending' && pendingCount > 0 && (
                <span className="ml-1.5 bg-amber-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full">
                  {pendingCount}
                </span>
              )}
            </button>
          ))}
        </div>
      )}

      {/* Content */}
      {isLoading ? (
        <div className="flex flex-col items-center justify-center py-20">
          <Loader2 className="w-8 h-8 animate-spin text-primary-400 mb-3" />
          <p className="text-sm text-gray-500">Loading your requests...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-sm border border-gray-200 p-12 text-center">
          <div className="w-16 h-16 bg-gray-50 rounded-2xl border-2 border-dashed border-gray-200 flex items-center justify-center mx-auto mb-4">
            <FileText className="w-7 h-7 text-gray-300" strokeWidth={1.3} />
          </div>
          <h3 className="text-lg font-bold text-gray-900 mb-1">
            {filter === 'all' ? 'No leave requests yet' : `No ${filter} requests`}
          </h3>
          <p className="text-sm text-gray-500 mb-6">
            {filter === 'all'
              ? "You haven't submitted any HOD leave applications yet."
              : `You have no ${filter} HOD leave requests.`}
          </p>
          {filter === 'all' && (
            <Link
              to="/hod/apply-leave"
              className="inline-flex items-center gap-2 px-5 py-2 bg-primary-50 text-primary-700 text-sm font-semibold rounded-xl hover:bg-primary-100 transition-colors"
            >
              <Plus className="w-4 h-4" />
              Apply for Leave
            </Link>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-5">
          {filtered.map(req => (
            <LeaveCard key={req.id} req={req} onReassign={handleOpenReassign} />
          ))}
        </div>
      )}

      <ReassignDelegateModal 
        isOpen={isReassignModalOpen}
        onClose={() => setIsReassignModalOpen(false)}
        onSubmit={handleReassignSubmit}
        facultyList={facultyList}
        isSubmitting={isReassigning}
      />
    </div>
  );
};

export default HODLeaveRequests;
