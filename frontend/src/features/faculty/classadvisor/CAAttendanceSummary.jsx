import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { BarChart2, AlertTriangle, Users, ChevronLeft, ChevronRight, Calendar as CalendarIcon, CheckCircle, XCircle, Clock, Download, FileText, FileSpreadsheet, Search, Percent, ShieldAlert, CheckCircle2 } from 'lucide-react';
import * as XLSX from 'xlsx';
import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

export const CAAttendanceSummary = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all'); // 'all' | 'critical' | 'healthy'

  // Report State
  const [showReportModal, setShowReportModal] = useState(false);
  const [reportFormat, setReportFormat] = useState('excel');
  const [reportStartDate, setReportStartDate] = useState('');
  const [reportEndDate, setReportEndDate] = useState('');
  const [generatingReport, setGeneratingReport] = useState(false);

  const openReportModal = () => {
    const today = new Date();
    const tzDate = new Date(today.getTime() - (today.getTimezoneOffset() * 60000)).toISOString().split('T')[0];
    setReportStartDate(tzDate);
    setReportEndDate(tzDate);
    setShowReportModal(true);
  };

  const fetchSummary = () => {
    setLoading(true);
    axios.get('/api/class-advisor/attendance-summary')
      .then(r => {
        setData(r.data);
        setError(null);
      })
      .catch(err => {
        setError(err.response?.data?.detail || 'Failed to load attendance summary');
      })
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    fetchSummary();
  }, []);

  // Calendar Logic
  const year = currentMonth.getFullYear();
  const month = currentMonth.getMonth();
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const firstDayOfMonth = new Date(year, month, 1).getDay();

  const handlePrevMonth = () => setCurrentMonth(new Date(year, month - 1, 1));
  const handleNextMonth = () => setCurrentMonth(new Date(year, month + 1, 1));

  const isToday = (day) => {
    const today = new Date();
    return today.getDate() === day && today.getMonth() === month && today.getFullYear() === year;
  };

  const isSelected = (day) => {
    return selectedDate.getDate() === day && selectedDate.getMonth() === month && selectedDate.getFullYear() === year;
  };

  // Report Generation
  const handleGenerateReport = async () => {
    setGeneratingReport(true);
    try {
      if (!reportStartDate || !reportEndDate) {
        alert("Please select both start and end dates.");
        setGeneratingReport(false);
        return;
      }
      
      const sDateObj = new Date(reportStartDate);
      const eDateObj = new Date(reportEndDate);

      if (sDateObj > eDateObj) {
        alert("Start date cannot be after end date.");
        setGeneratingReport(false);
        return;
      }

      const startDate = reportStartDate;
      const endDate = reportEndDate;

      // Load logo image as base64
      let logoData = null;
      try {
        logoData = await new Promise((resolve) => {
          const img = new Image();
          img.onload = () => {
            const canvas = document.createElement('canvas');
            canvas.width = img.width;
            canvas.height = img.height;
            const ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0);
            resolve({
              data: canvas.toDataURL('image/png'),
              width: img.width,
              height: img.height
            });
          };
          img.onerror = () => resolve(null);
          img.src = '/logo.png';
        });
      } catch (e) {
        console.error('Failed to load logo', e);
      }

      // Fetch attendance data
      const res = await axios.get(`/api/class-advisor/attendance-report?start_date=${startDate}&end_date=${endDate}`);
      const reportData = res.data;

      // Deterministically generate all dates for the range
      const dates = [];
      const columnHeaders = [];
      let curr = new Date(sDateObj);
      while (curr <= eDateObj) {
        const dateStr = new Date(curr.getTime() - (curr.getTimezoneOffset() * 60000)).toISOString().split('T')[0];
        dates.push(dateStr);
        const [y, m, d] = dateStr.split('-');
        columnHeaders.push(`${d}/${m}`);
        curr.setDate(curr.getDate() + 1);
      }

      const sDateFmt = startDate.split('-').reverse().join('/');
      const eDateFmt = endDate.split('-').reverse().join('/');
      const reportTitle = startDate === endDate 
        ? `Attendance Report - ${sDateFmt}`
        : `Attendance Report - ${sDateFmt} to ${eDateFmt}`;

      const headers = ['Register Number', 'Name', ...columnHeaders];
      
      const rows = reportData.map(s => {
        const row = [s.register_number, `${s.first_name} ${s.last_name}`];
        dates.forEach(d => {
          const status = s.attendance ? s.attendance[d] : null;
          if (status === 'present') row.push('P');
          else if (status === 'absent') row.push('A');
          else row.push('-');
        });
        return row;
      });

      if (reportFormat === 'excel') {
        const ws = XLSX.utils.aoa_to_sheet([[reportTitle], headers, ...rows]);
        ws['!merges'] = [
          { s: { r: 0, c: 0 }, e: { r: 0, c: headers.length - 1 } }
        ];
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, 'Attendance');
        XLSX.writeFile(wb, `Attendance_Report_${startDate}_to_${endDate}.xlsx`);
      } else {
        const doc = new jsPDF({ orientation: dates.length > 7 ? 'landscape' : 'portrait' });
        
        const pageWidth = doc.internal.pageSize.getWidth();
        const margin = 15;
        let cursorY = 15;
        let logoTargetWidth = 0;
        let logoTargetHeight = 0;

        // ── Logo ────────────────────────────────────────────────────────────
        if (logoData) {
          logoTargetWidth = pageWidth - margin * 2;
          logoTargetHeight = (logoData.height / logoData.width) * logoTargetWidth;
          if (logoTargetHeight > 35) {
            logoTargetHeight = 35;
            logoTargetWidth = (logoData.width / logoData.height) * logoTargetHeight;
          }
          const xPos = (pageWidth - logoTargetWidth) / 2;
          doc.addImage(logoData.data, 'PNG', xPos, cursorY, logoTargetWidth, logoTargetHeight);
          cursorY += logoTargetHeight + 6;
        }

        // ── Report title ────────────────────────────────────────────────────
        doc.setFontSize(13);
        doc.setFont('helvetica', 'bold');
        doc.setTextColor(30);
        doc.text(reportTitle, pageWidth / 2, cursorY, { align: 'center' });
        cursorY += 10;

        // ── Attendance Table Only ─────────────────────────────────────────────
        const tableStartY = cursorY;

        const tableOptions = {
          head: [headers],
          body: rows,
          startY: tableStartY,
          margin: { top: 15, bottom: 15, left: margin, right: margin },
          theme: 'grid',
          styles: { fontSize: 7, cellPadding: 2, halign: 'center' },
          columnStyles: { 0: { halign: 'left', cellWidth: 'auto' }, 1: { halign: 'left', cellWidth: 'auto' } },
          headStyles: { fillColor: [79, 70, 229], halign: 'center', fontStyle: 'bold' },
          didDrawPage: (data) => {
            const pageHeight = doc.internal.pageSize.getHeight();
            const pageWidth = doc.internal.pageSize.getWidth();

            // Outer Page Border (10mm from page edges, matching Logbook Report style)
            const borderMargin = 10;
            doc.setDrawColor(3, 78, 161); // #034ea1
            doc.setLineWidth(0.5);
            doc.rect(borderMargin, borderMargin, pageWidth - borderMargin * 2, pageHeight - borderMargin * 2);

            // Footer Page Number
            doc.setFontSize(8);
            doc.setFont('helvetica', 'normal');
            doc.setTextColor(120);
            doc.text(
              `Page ${data.pageNumber}`,
              pageWidth - margin,
              pageHeight - 6,
              { align: 'right' }
            );
          }
        };

        if (typeof doc.autoTable === 'function') {
          doc.autoTable(tableOptions);
        } else if (typeof autoTable === 'function') {
          autoTable(doc, tableOptions);
        } else if (autoTable?.default) {
          autoTable.default(doc, tableOptions);
        }
        doc.save(`Attendance_Report_${startDate}_to_${endDate}.pdf`);
      }
      setShowReportModal(false);
    } catch (err) {
      console.error('Error generating attendance report PDF:', err);
      alert('Failed to generate report: ' + (err?.response?.data?.detail || err?.message || err || 'Unknown error'));
    } finally {
      setGeneratingReport(false);
    }
  };

  // Stats
  const totalStudents = data.length;
  const avgAttendance = totalStudents > 0 
    ? (data.reduce((sum, s) => sum + s.percentage, 0) / totalStudents).toFixed(1) 
    : '0.0';
  const criticalCount = data.filter(s => s.percentage < 75).length;
  const healthyCount = data.filter(s => s.percentage >= 75).length;

  const filteredData = data.filter(s => {
    const name = `${s.first_name} ${s.last_name}`.toLowerCase();
    const reg = s.register_number.toLowerCase();
    const matchesSearch = name.includes(searchTerm.toLowerCase()) || reg.includes(searchTerm.toLowerCase());
    
    if (!matchesSearch) return false;
    if (filterType === 'critical') return s.percentage < 75;
    if (filterType === 'healthy') return s.percentage >= 75;
    return true;
  });

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      
      {/* Report Modal */}
      {showReportModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-900/50 backdrop-blur-sm">
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl w-full max-w-md overflow-hidden animate-in fade-in zoom-in-95 duration-200">
            <div className="p-6">
              <h3 className="text-xl font-bold text-gray-900 dark:text-white mb-4">Generate Report</h3>
              
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Report Date Range</label>
                  <div className="flex gap-4">
                    <div className="flex-1">
                      <label className="block text-xs font-semibold text-gray-500 dark:text-gray-400 mb-1">From</label>
                      <input 
                        type="date"
                        value={reportStartDate}
                        onChange={(e) => setReportStartDate(e.target.value)}
                        className="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 rounded-xl bg-gray-50 dark:bg-gray-900/50 text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-600 focus:border-transparent outline-none transition-all"
                      />
                    </div>
                    <div className="flex-1">
                      <label className="block text-xs font-semibold text-gray-500 dark:text-gray-400 mb-1">To</label>
                      <input 
                        type="date"
                        value={reportEndDate}
                        onChange={(e) => setReportEndDate(e.target.value)}
                        className="w-full px-3 py-2 border border-gray-200 dark:border-gray-700 rounded-xl bg-gray-50 dark:bg-gray-900/50 text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-600 focus:border-transparent outline-none transition-all"
                      />
                    </div>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Format</label>
                  <div className="flex gap-4">
                    <label className="flex-1 cursor-pointer">
                      <input type="radio" className="peer sr-only" name="format" checked={reportFormat === 'excel'} onChange={() => setReportFormat('excel')} />
                      <div className="p-3 flex items-center justify-center gap-2 rounded-xl border border-gray-200 dark:border-gray-700 peer-checked:border-green-600 peer-checked:bg-green-50 dark:peer-checked:bg-green-900/20 text-gray-600 dark:text-gray-300 peer-checked:text-green-700 dark:peer-checked:text-green-400 font-medium transition-all">
                        <FileSpreadsheet className="w-5 h-5" /> Excel
                      </div>
                    </label>
                    <label className="flex-1 cursor-pointer">
                      <input type="radio" className="peer sr-only" name="format" checked={reportFormat === 'pdf'} onChange={() => setReportFormat('pdf')} />
                      <div className="p-3 flex items-center justify-center gap-2 rounded-xl border border-gray-200 dark:border-gray-700 peer-checked:border-red-600 peer-checked:bg-red-50 dark:peer-checked:bg-red-900/20 text-gray-600 dark:text-gray-300 peer-checked:text-red-700 dark:peer-checked:text-red-400 font-medium transition-all">
                        <FileText className="w-5 h-5" /> PDF
                      </div>
                    </label>
                  </div>
                </div>
              </div>

              <div className="mt-8 flex gap-3">
                <button 
                  onClick={() => setShowReportModal(false)}
                  className="flex-1 px-4 py-2.5 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 font-bold rounded-xl transition-colors"
                >
                  Cancel
                </button>
                <button 
                  onClick={handleGenerateReport}
                  disabled={generatingReport}
                  className="flex-1 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl transition-colors flex justify-center items-center gap-2 disabled:opacity-70"
                >
                  {generatingReport ? (
                    <><div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></div> Generating...</>
                  ) : (
                    <><Download className="w-4 h-4" /> Generate</>
                  )}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Page Header */}
      <div className="mb-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4 flex-shrink-0">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white tracking-tight flex items-center gap-2 mb-1">
            <BarChart2 className="w-6 h-6 text-indigo-600" /> Attendance Summary Dashboard
          </h1>
          <p className="text-sm text-gray-500">Overview of student attendance percentages and class statistics.</p>
        </div>
        
        <button 
          onClick={openReportModal}
          className="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-sm rounded-xl transition-colors shadow-sm shadow-indigo-600/20 w-fit"
        >
          <Download className="w-4 h-4" /> Generate Date Range Report
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white dark:bg-gray-800 p-5 rounded-2xl border border-gray-150 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 rounded-xl">
            <Users className="w-6 h-6" />
          </div>
          <div>
            <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Total Enrolled</p>
            <p className="text-2xl font-bold text-gray-900 dark:text-white mt-0.5">{totalStudents}</p>
          </div>
        </div>
        
        <div className="bg-white dark:bg-gray-800 p-5 rounded-2xl border border-gray-150 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-indigo-50 dark:bg-indigo-900/20 text-indigo-600 dark:text-indigo-400 rounded-xl">
            <Percent className="w-6 h-6" />
          </div>
          <div>
            <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Avg Attendance</p>
            <p className="text-2xl font-bold text-gray-900 dark:text-white mt-0.5">{avgAttendance}%</p>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-5 rounded-2xl border border-gray-150 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-xl animate-pulse">
            <AlertTriangle className="w-6 h-6" />
          </div>
          <div>
            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide">Critical (<span className="text-red-500 font-bold">75%</span>)</p>
            <p className="text-2xl font-bold text-red-600 dark:text-red-400 mt-0.5">{criticalCount}</p>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-5 rounded-2xl border border-gray-150 dark:border-gray-700 shadow-sm flex items-center gap-4">
          <div className="p-3 bg-green-50 dark:bg-green-900/20 text-green-600 dark:text-green-400 rounded-xl">
            <CheckCircle2 className="w-6 h-6" />
          </div>
          <div>
            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide">Healthy (≥ 75%)</p>
            <p className="text-2xl font-bold text-green-600 dark:text-green-400 mt-0.5">{healthyCount}</p>
          </div>
        </div>
      </div>

      {/* Main Student Table Area */}
      <div className="bg-white dark:bg-gray-800 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden flex flex-col">
        {/* Toolbar */}
        <div className="p-5 border-b border-gray-100 dark:border-gray-700 flex flex-col md:flex-row justify-between items-center gap-4">
          {/* Quick Filter Tabs */}
          <div className="flex gap-1.5 bg-gray-100 dark:bg-gray-900/50 p-1 rounded-xl w-full md:w-auto">
            {[
              { id: 'all', label: 'All Students', count: totalStudents },
              { id: 'critical', label: 'Critical (<75%)', count: criticalCount, color: 'text-red-600 dark:text-red-400' },
              { id: 'healthy', label: 'Healthy (≥75%)', count: healthyCount, color: 'text-green-600 dark:text-green-400' }
            ].map(tab => (
              <button
                key={tab.id}
                onClick={() => setFilterType(tab.id)}
                className={`flex-1 md:flex-none px-4 py-2 rounded-lg text-xs font-bold transition-all flex items-center justify-center gap-1.5 ${
                  filterType === tab.id
                    ? 'bg-white dark:bg-gray-800 text-gray-900 dark:text-white shadow-sm'
                    : 'text-gray-500 hover:text-gray-700 dark:hover:text-gray-300'
                }`}
              >
                <span className={tab.color}>{tab.label}</span>
                <span className={`px-1.5 py-0.5 rounded-full text-[9px] font-bold ${
                  filterType === tab.id
                    ? 'bg-gray-100 dark:bg-gray-900 text-gray-750 dark:text-gray-250'
                    : 'bg-gray-200/60 dark:bg-gray-800 text-gray-500'
                }`}>{tab.count}</span>
              </button>
            ))}
          </div>

          {/* Search bar */}
          <div className="relative w-full md:w-80">
            <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input 
              type="text" 
              placeholder="Search student name or register..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-9 pr-4 py-2 bg-gray-50 dark:bg-gray-900/50 border border-gray-200 dark:border-gray-700 rounded-xl text-xs font-medium focus:ring-2 focus:ring-indigo-500/20 focus:bg-white transition-all outline-none"
            />
          </div>
        </div>

        {/* Table/List content */}
        <div className="p-4 sm:p-6 overflow-x-auto">
          {loading ? (
            <div className="py-24 text-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600 mx-auto"></div>
              <p className="mt-4 text-sm text-gray-500 font-medium">Loading summary...</p>
            </div>
          ) : error ? (
            <div className="py-24 text-center text-red-500 font-medium">{error}</div>
          ) : filteredData.length === 0 ? (
            <div className="py-24 text-center text-gray-500 font-medium">No students match this filter.</div>
          ) : (
            <div className="divide-y divide-gray-100 dark:divide-gray-700">
              {filteredData.map((s, idx) => {
                const isCritical = s.percentage < 75;
                return (
                  <div key={s.student_id} className={`flex flex-col sm:flex-row sm:items-center justify-between py-4 gap-4 ${
                    isCritical ? 'bg-red-50/20 dark:bg-red-900/5 px-2 rounded-xl' : ''
                  }`}>
                    {/* Student Identity */}
                    <div className="flex items-center gap-4 flex-1 min-w-0">
                      <div className="text-xs font-bold text-gray-400 w-6 shrink-0 text-center">{idx + 1}</div>
                      <div className={`w-10 h-10 shrink-0 rounded-xl flex items-center justify-center font-extrabold text-sm ${
                        isCritical 
                          ? 'bg-red-100 text-red-700 border border-red-200 dark:bg-red-950 dark:text-red-300 dark:border-red-900' 
                          : 'bg-indigo-50 text-indigo-700 border border-indigo-100 dark:bg-indigo-950 dark:text-indigo-300 dark:border-indigo-900'
                      }`}>
                        {s.first_name.charAt(0)}{s.last_name.charAt(0)}
                      </div>
                      <div className="min-w-0 flex-1">
                        <p className="text-sm font-bold text-gray-900 dark:text-white truncate flex items-center gap-2">
                          {s.first_name} {s.last_name}
                          {isCritical && (
                            <span className="px-2 py-0.5 bg-red-100 text-red-800 text-[9px] rounded font-bold uppercase tracking-wider border border-red-250 animate-pulse shrink-0">
                              Critical Alert
                            </span>
                          )}
                        </p>
                        <p className="text-[11px] font-mono text-gray-400 mt-0.5">{s.register_number}</p>
                      </div>
                    </div>

                    {/* Progress Bar & Class counts */}
                    <div className="flex items-center gap-6 flex-1 max-w-md w-full">
                      <div className="flex-1">
                        <div className="flex justify-between text-[10px] font-medium text-gray-400 mb-1">
                          <span>Classes Attended</span>
                          <span className="font-bold text-gray-700 dark:text-gray-300">{s.present_days} / {s.total_days} hours</span>
                        </div>
                        <div className="w-full h-2 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
                          <div 
                            className={`h-full rounded-full transition-all duration-500 ${
                              isCritical ? 'bg-red-500' : s.percentage >= 85 ? 'bg-green-500' : 'bg-indigo-500'
                            }`}
                            style={{ width: `${s.percentage}%` }}
                          />
                        </div>
                      </div>

                      {/* Percentage display */}
                      <div className="w-20 text-right shrink-0">
                        <span className={`text-base font-extrabold ${
                          isCritical ? 'text-red-600 dark:text-red-400' : 'text-gray-900 dark:text-white'
                        }`}>
                          {s.percentage}%
                        </span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
