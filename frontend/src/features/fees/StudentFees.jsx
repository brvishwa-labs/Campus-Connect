import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import { useAuth } from '../../context/AuthContext';
import {
  DollarSign, CheckCircle, AlertCircle, CreditCard,
  FileText, Clock, RefreshCw, Banknote, BookOpen,
  FlaskConical, GraduationCap, ReceiptText, Layers
} from 'lucide-react';

/**
 * StudentFees â€” Fees summary and payment history for the logged-in student.
 * Now shows a per-fee-type breakdown (Tuition Fee, Exam Fee, etc.)
 * in addition to total due / paid / balance.
 */

function fmt(amount) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0,
  }).format(amount || 0);
}

const Card = ({ children, className = '' }) => (
  <div className={`bg-white rounded-2xl border border-gray-100 shadow-sm ${className}`}>
    {children}
  </div>
);

const Spinner = () => (
  <div className="w-6 h-6 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />
);

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

function SummaryCard({ icon: Icon, label, value, subtitle, gradient, textColor }) {
  return (
    <Card className="p-5 flex items-start gap-4 overflow-hidden relative">
      <div className={`absolute inset-0 opacity-5 ${gradient}`} />
      <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${gradient} flex items-center justify-center flex-shrink-0 z-10`}>
        <Icon className="w-6 h-6 text-white" />
      </div>
      <div className="z-10">
        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">{label}</p>
        <p className={`text-2xl font-bold mt-0.5 ${textColor}`}>{value}</p>
        {subtitle && <p className="text-xs text-gray-500 mt-0.5">{subtitle}</p>}
      </div>
    </Card>
  );
}

const modeColors = {
  cash: 'bg-emerald-100 text-emerald-700',
  cheque: 'bg-blue-100 text-blue-700',
  dd: 'bg-indigo-100 text-indigo-700',
  bank_transfer: 'bg-cyan-100 text-cyan-700',
  tally_sync: 'bg-purple-100 text-purple-700',
};

const sourceColors = {
  manual: 'bg-gray-100 text-gray-600',
  tally_upload: 'bg-amber-100 text-amber-700',
};

export default function StudentFees() {
  const { user } = useAuth();
  const [studentId, setStudentId] = useState(null);
  const [summary, setSummary] = useState(null);
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [page, setPage] = useState(0);
  const PAGE_SIZE = 10;

  // Step 1: resolve student ID
  useEffect(() => {
    const fetchStudentId = async () => {
      try {
        const res = await axios.get('/api/student-portal/me');
        setStudentId(res.data?.id);
      } catch {
        setError('Could not load your student profile. Please try again.');
        setLoading(false);
      }
    };
    if (user?.role === 'student') {
      fetchStudentId();
    } else {
      setError('This page is only accessible to students.');
      setLoading(false);
    }
  }, [user]);

  // Step 2: fetch fee data
  const fetchFeeData = useCallback(async () => {
    if (!studentId) return;
    setLoading(true);
    setError(null);
    try {
      const [sumRes, histRes] = await Promise.all([
        axios.get(`/api/fees/student/${studentId}/summary`),
        axios.get(`/api/fees/student/${studentId}/history`),
      ]);
      setSummary(sumRes.data);
      setHistory(histRes.data || []);
    } catch (err) {
      const msg = err.response?.data?.detail;
      if (err.response?.status === 404 || msg?.includes('not found')) {
        setSummary({ total_due: 0, total_paid: 0, pending_balance: 0, fee_breakdown: [] });
        setHistory([]);
      } else {
        setError(msg || 'Failed to load fee information. Please try again later.');
      }
    }
    setLoading(false);
  }, [studentId]);

  useEffect(() => {
    if (studentId) fetchFeeData();
  }, [studentId, fetchFeeData]);

  const paginatedHistory = history.slice(page * PAGE_SIZE, (page + 1) * PAGE_SIZE);
  const totalPages = Math.ceil(history.length / PAGE_SIZE);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="flex flex-col items-center gap-4">
          <Spinner />
          <p className="text-sm text-gray-500">Loading your fee informationâ€¦</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-6">
        <Card className="p-8 max-w-md text-center">
          <div className="w-16 h-16 rounded-2xl bg-red-50 flex items-center justify-center mx-auto mb-4">
            <AlertCircle className="w-8 h-8 text-red-500" />
          </div>
          <h2 className="font-bold text-gray-900 mb-2">Unable to Load Fee Data</h2>
          <p className="text-sm text-gray-500 mb-5">{error}</p>
          <button onClick={fetchFeeData}
            className="flex items-center gap-2 px-5 py-2.5 bg-blue-600 text-white text-sm font-medium rounded-xl hover:bg-blue-700 transition-colors mx-auto">
            <RefreshCw className="w-4 h-4" /> Try Again
          </button>
        </Card>
      </div>
    );
  }

  const isPending = summary?.pending_balance > 0;
  const feeBreakdown = summary?.fee_breakdown || [];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Page Header */}
      <div className="bg-white border-b border-gray-100 px-6 py-5">
        <div className="max-w-5xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-4">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-600 to-indigo-700 flex items-center justify-center">
              <Banknote className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900">My Fees</h1>
              <p className="text-sm text-gray-500">
                {summary?.student_name && `${summary.student_name} Â· `}
                {summary?.register_number && `Reg: ${summary.register_number}`}
              </p>
            </div>
          </div>
          <button
            onClick={fetchFeeData}
            className="flex items-center gap-2 px-4 py-2 text-sm text-gray-500 hover:text-gray-700 border border-gray-200 rounded-xl hover:bg-gray-50 transition-all"
          >
            <RefreshCw className="w-4 h-4" /> Refresh
          </button>
        </div>
      </div>

      <div className="max-w-5xl mx-auto px-6 py-6 space-y-6">

        {/* Balance Alert Banner */}
        {isPending ? (
          <div className="flex items-start gap-3 bg-amber-50 border border-amber-200 rounded-2xl p-4">
            <AlertCircle className="w-5 h-5 text-amber-500 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-semibold text-amber-800">Fee Payment Pending</p>
              <p className="text-sm text-amber-700 mt-0.5">
                You have a pending balance of <strong>{fmt(summary?.pending_balance)}</strong>. Please contact the accounts office to make the payment.
              </p>
            </div>
          </div>
        ) : (
          summary && (
            <div className="flex items-start gap-3 bg-emerald-50 border border-emerald-200 rounded-2xl p-4">
              <CheckCircle className="w-5 h-5 text-emerald-500 flex-shrink-0 mt-0.5" />
              <div>
                <p className="font-semibold text-emerald-800">All Dues Cleared</p>
                <p className="text-sm text-emerald-700 mt-0.5">Your fee account is up to date. No pending dues.</p>
              </div>
            </div>
          )
        )}

        {/* Summary Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <SummaryCard
            icon={DollarSign}
            label="Total Fee"
            value={fmt(summary?.total_due)}
            subtitle="Total fees assigned"
            gradient="from-blue-500 to-blue-600"
            textColor="text-blue-700"
          />
          <SummaryCard
            icon={CheckCircle}
            label="Total Paid"
            value={fmt(summary?.total_paid)}
            subtitle="Payments received and confirmed"
            gradient="from-emerald-500 to-emerald-600"
            textColor="text-emerald-700"
          />
          <SummaryCard
            icon={isPending ? AlertCircle : CheckCircle}
            label="Pending Balance"
            value={fmt(summary?.pending_balance)}
            subtitle={isPending ? 'Please clear this amount' : 'No dues outstanding'}
            gradient={isPending ? 'from-red-500 to-rose-600' : 'from-emerald-500 to-teal-600'}
            textColor={isPending ? 'text-red-700' : 'text-emerald-700'}
          />
        </div>

        {/* ── Fee Breakdown ── */}
        {feeBreakdown.length > 0 && (
          <Card className="overflow-hidden">
            <div className="px-5 py-4 border-b border-gray-50 flex items-center gap-2">
              <BookOpen className="w-4 h-4 text-gray-400" />
              <h2 className="font-semibold text-gray-900">Fee Breakdown</h2>
              <span className="text-xs text-gray-400 bg-gray-100 rounded-full px-2 py-0.5 ml-1">
                {feeBreakdown.length} {feeBreakdown.length === 1 ? 'item' : 'items'}
              </span>
            </div>

            {/* Desktop table */}
            <div className="hidden sm:block overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-gray-50">
                  <tr>
                    {['Fee Type', 'Academic Year', 'Semester', 'Amount Due', 'Paid', 'Balance'].map(h => (
                      <th key={h} className="px-5 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-50">
                  {feeBreakdown.map((fee, idx) => {
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
                    <td className="px-5 py-3 font-bold text-gray-800">{fmt(summary?.total_due)}</td>
                    <td className="px-5 py-3 font-bold text-emerald-700">{fmt(summary?.total_paid)}</td>
                    <td className="px-5 py-3 font-bold text-red-600">{fmt(summary?.pending_balance)}</td>
                  </tr>
                </tfoot>
              </table>
            </div>

            {/* Mobile cards */}
            <div className="sm:hidden divide-y divide-gray-50">
              {feeBreakdown.map((fee) => {
                const style = getFeeStyle(fee.fee_type);
                const Icon = style.icon;
                const isCleared = (fee.balance ?? fee.amount_due) === 0;
                return (
                  <div key={fee.id} className="px-5 py-4">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-3">
                        <div className={`w-9 h-9 rounded-xl ${style.iconBg} flex items-center justify-center flex-shrink-0`}>
                          <Icon className={`w-5 h-5 ${style.iconColor}`} />
                        </div>
                        <div>
                          <span className={`text-xs font-semibold px-2 py-0.5 rounded-lg inline-block ${style.badge}`}>{fee.fee_type}</span>
                          <p className="text-xs text-gray-500 mt-0.5">{fee.academic_year} · Sem {fee.semester}</p>
                        </div>
                      </div>
                      {isCleared ? (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-lg bg-emerald-100 text-emerald-700 text-xs font-semibold">
                          <CheckCircle className="w-3 h-3" /> Cleared
                        </span>
                      ) : (
                        <span className="font-bold text-red-600 text-sm">{fmt(fee.balance ?? fee.amount_due)}</span>
                      )}
                    </div>
                    <div className="flex gap-4 text-xs text-gray-500 pl-12">
                      <span>Due: <span className="font-medium text-gray-700">{fmt(fee.amount_due)}</span></span>
                      <span>Paid: <span className="font-medium text-emerald-700">{fmt(fee.amount_paid ?? 0)}</span></span>
                    </div>
                  </div>
                );
              })}
              <div className="px-5 py-3 flex items-center justify-between bg-gray-50 border-t-2 border-gray-100">
                <p className="text-sm font-bold text-gray-700">Total Pending</p>
                <p className="font-bold text-red-600">{fmt(summary?.pending_balance)}</p>
              </div>
            </div>
          </Card>
        )}

        {/* Payment History */}
        <Card className="overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-50 flex items-center gap-2">
            <Clock className="w-4 h-4 text-gray-400" />
            <h2 className="font-semibold text-gray-900">Payment History</h2>
            {history.length > 0 && (
              <span className="text-xs text-gray-400 bg-gray-100 rounded-full px-2 py-0.5">
                {history.length} payments
              </span>
            )}
          </div>

          {history.length === 0 ? (
            <div className="py-16 flex flex-col items-center gap-4">
              <div className="w-16 h-16 rounded-2xl bg-gray-50 flex items-center justify-center">
                <FileText className="w-8 h-8 text-gray-300" />
              </div>
              <div className="text-center">
                <p className="font-medium text-gray-500">No payments recorded yet</p>
                <p className="text-sm text-gray-400 mt-1">Your payment history will appear here once payments are recorded.</p>
              </div>
            </div>
          ) : (
            <>
              {/* Desktop Table */}
              <div className="hidden sm:block overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50">
                    <tr>
                      {['Date', 'Amount', 'Mode', 'Source', 'Receipt No.', 'Voucher No.', 'Notes'].map(h => (
                        <th key={h} className="px-4 py-3 text-left text-xs font-bold text-gray-400 uppercase tracking-wider">{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {paginatedHistory.map((p, idx) => (
                      <tr key={p.id} className={`transition-colors ${idx % 2 === 0 ? 'bg-white' : 'bg-gray-50/30'} hover:bg-blue-50/30`}>
                        <td className="px-4 py-3.5 text-gray-600 whitespace-nowrap">{p.payment_date}</td>
                        <td className="px-4 py-3.5 font-semibold text-gray-900 whitespace-nowrap">{fmt(p.amount)}</td>
                        <td className="px-4 py-3.5">
                          <span className={`inline-flex px-2 py-0.5 rounded-full text-xs font-semibold capitalize ${modeColors[p.mode] || 'bg-gray-100 text-gray-600'}`}>
                            {p.mode.replace('_', ' ')}
                          </span>
                        </td>
                        <td className="px-4 py-3.5">
                          <span className={`inline-flex px-2 py-0.5 rounded-full text-xs font-semibold ${sourceColors[p.source] || 'bg-gray-100 text-gray-600'}`}>
                            {p.source === 'tally_upload' ? 'Tally' : 'Manual'}
                          </span>
                        </td>
                        <td className="px-4 py-3.5 text-gray-500 font-mono text-xs">{p.receipt_no || 'â€”'}</td>
                        <td className="px-4 py-3.5 text-gray-500 font-mono text-xs">{p.voucher_no || 'â€”'}</td>
                        <td className="px-4 py-3.5 text-gray-400 max-w-xs truncate" title={p.notes}>{p.notes || 'â€”'}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Mobile Cards */}
              <div className="sm:hidden divide-y divide-gray-50">
                {paginatedHistory.map(p => (
                  <div key={p.id} className="px-5 py-4 space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-gray-900 text-lg">{fmt(p.amount)}</span>
                      <span className={`inline-flex px-2 py-0.5 rounded-full text-xs font-semibold capitalize ${modeColors[p.mode] || 'bg-gray-100 text-gray-600'}`}>
                        {p.mode.replace('_', ' ')}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Clock className="w-3 h-3" />
                      {p.payment_date}
                    </div>
                    {p.receipt_no && <p className="text-xs text-gray-400">Receipt: {p.receipt_no}</p>}
                  </div>
                ))}
              </div>

              {/* Pagination */}
              {totalPages > 1 && (
                <div className="px-5 py-4 border-t border-gray-50 flex items-center justify-between">
                  <p className="text-sm text-gray-500">
                    Showing {page * PAGE_SIZE + 1}â€“{Math.min((page + 1) * PAGE_SIZE, history.length)} of {history.length} payments
                  </p>
                  <div className="flex gap-2">
                    <button onClick={() => setPage(p => Math.max(p - 1, 0))} disabled={page === 0}
                      className="px-3 py-1.5 text-sm border border-gray-200 rounded-lg disabled:opacity-40 hover:bg-gray-50 transition-colors">
                      â† Prev
                    </button>
                    <button onClick={() => setPage(p => Math.min(p + 1, totalPages - 1))} disabled={page === totalPages - 1}
                      className="px-3 py-1.5 text-sm border border-gray-200 rounded-lg disabled:opacity-40 hover:bg-gray-50 transition-colors">
                      Next â†’
                    </button>
                  </div>
                </div>
              )}
            </>
          )}
        </Card>

        {/* Info Footer */}
        <Card className="p-5 bg-gradient-to-r from-blue-50 to-indigo-50 border-blue-100">
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 rounded-lg bg-blue-100 flex items-center justify-center flex-shrink-0">
              <CreditCard className="w-4 h-4 text-blue-600" />
            </div>
            <div>
              <p className="font-semibold text-gray-900 text-sm">Payment Information</p>
              <p className="text-xs text-gray-600 mt-1 leading-relaxed">
                Fee payments are processed by the accounts office. If you have made a payment and it's not reflected here,
                please contact the accounts office with your receipt number. This data is updated when payments are recorded
                manually or imported from Tally.
              </p>
            </div>
          </div>
        </Card>

      </div>
    </div>
  );
}
