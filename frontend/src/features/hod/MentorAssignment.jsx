import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Users, Search, AlertCircle, FileText, FileSpreadsheet } from 'lucide-react';
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

export const MentorAssignment = () => {
  const [mentors, setMentors] = useState([]);
  const [faculty, setFaculty] = useState([]);
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedSectionId, setSelectedSectionId] = useState('');
  const [selectedStudentIds, setSelectedStudentIds] = useState([]);
  const [showExportModal, setShowExportModal] = useState(false);
  const [pendingExportType, setPendingExportType] = useState(null);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [mRes, fRes, sRes] = await Promise.all([
        axios.get('/api/hod/mentors'),
        axios.get('/api/hod/faculty'),
        axios.get('/api/hod/students')
      ]);
      setMentors(mRes.data);
      setFaculty(fRes.data);
      setStudents(sRes.data);
      setError(null);
    } catch (err) {
      setError('Failed to load data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleStudentClick = (e, studentId) => {
    if (e.ctrlKey || e.metaKey) {
      setSelectedStudentIds(prev => 
        prev.includes(studentId) ? prev.filter(id => id !== studentId) : [...prev, studentId]
      );
    } else {
      setSelectedStudentIds([studentId]);
    }
  };

  const handleDragStart = (e, studentId) => {
    const idsToDrag = selectedStudentIds.includes(studentId) 
      ? selectedStudentIds 
      : [studentId];
    
    if (!selectedStudentIds.includes(studentId)) {
      setSelectedStudentIds([studentId]);
    }
    
    e.dataTransfer.setData("studentIds", JSON.stringify(idsToDrag));
    
    if (idsToDrag.length > 1) {
      const dragGhost = document.createElement("div");
      dragGhost.textContent = `Moving ${idsToDrag.length} students`;
      dragGhost.className = "bg-indigo-600 text-white px-4 py-2 rounded-lg shadow-lg font-bold";
      dragGhost.style.position = "absolute";
      dragGhost.style.top = "-1000px";
      document.body.appendChild(dragGhost);
      e.dataTransfer.setDragImage(dragGhost, 0, 0);
      setTimeout(() => document.body.removeChild(dragGhost), 0);
    }
  };

  const handleDragOver = (e) => {
    e.preventDefault();
  };

  const handleDropToFaculty = async (e, facultyId) => {
    e.preventDefault();
    try {
      const rawData = e.dataTransfer.getData("studentIds");
      if (!rawData) return;
      const studentIds = JSON.parse(rawData);
      if (!studentIds.length) return;

      const yr = new Date().getFullYear();
      await Promise.all(studentIds.map(studentId => 
        axios.post('/api/hod/mentors', {
          mentor_id: facultyId,
          student_id: studentId,
          academic_year: `${yr}-${yr+1}`
        })
      ));
      
      setMentors(prev => {
        const filtered = prev.filter(m => !studentIds.includes(m.student_id));
        const newAssignments = studentIds.map(id => ({ student_id: id, mentor_id: facultyId }));
        return [...filtered, ...newAssignments];
      });
      setSelectedStudentIds([]);
    } catch (err) {
      console.error("Failed to assign mentors", err);
      alert("Failed to assign mentors");
    }
  };

  const handleDropToUnassigned = async (e) => {
    e.preventDefault();
    try {
      const rawData = e.dataTransfer.getData("studentIds");
      if (!rawData) return;
      const studentIds = JSON.parse(rawData);
      if (!studentIds.length) return;

      const currentlyAssignedIds = mentors
        .filter(m => studentIds.includes(m.student_id))
        .map(m => m.student_id);

      await Promise.all(currentlyAssignedIds.map(studentId => 
        axios.delete(`/api/hod/mentors/student/${studentId}`)
      ));
      
      setMentors(prev => prev.filter(m => !studentIds.includes(m.student_id)));
      setSelectedStudentIds([]);
    } catch (err) {
      console.error("Failed to unassign mentors", err);
      alert("Failed to unassign mentors");
    }
  };

  const handleClearMentor = async (facultyId, studentIdsToClear) => {
    if (!window.confirm(`Are you sure you want to remove all ${studentIdsToClear.length} students from this mentor?`)) {
      return;
    }
    
    try {
      await Promise.all(studentIdsToClear.map(studentId => 
        axios.delete(`/api/hod/mentors/student/${studentId}`)
      ));
      
      setMentors(prev => prev.filter(m => !(m.mentor_id === facultyId && studentIdsToClear.includes(m.student_id))));
    } catch (err) {
      console.error("Failed to clear mentor", err);
      alert("Failed to clear mentor assignments");
    }
  };

  const getExportData = () => {
    const assignedIds = new Set(mentors.map(m => m.student_id));
    const assignedStudents = students.filter(s => assignedIds.has(s.id));
    const facultyMap = new Map(faculty.map(f => [f.id, `${f.first_name} ${f.last_name}`]));
    const studentToMentorMap = new Map(mentors.map(m => [m.student_id, m.mentor_id]));

    const groupedByYear = {};
    assignedStudents.forEach(student => {
      const year = student.section?.year || 'Unknown';
      const mentorName = facultyMap.get(studentToMentorMap.get(student.id)) || 'Unknown Mentor';
      
      if (!groupedByYear[year]) {
        groupedByYear[year] = [];
      }
      
      groupedByYear[year].push({
        'Student Name': `${student.first_name} ${student.last_name}`,
        'Mentor': mentorName,
        'Register Number': student.register_number,
        'Section': student.section?.name || 'N/A'
      });
    });
    return groupedByYear;
  };

  const handleExport = async (selectedYear) => {
    setShowExportModal(false);
    if (pendingExportType === 'excel') {
      exportToExcel(selectedYear);
    } else {
      await exportToPDF(selectedYear);
    }
  };

  const exportToExcel = (selectedYear) => {
    const dataByYear = getExportData();
    if (Object.keys(dataByYear).length === 0) {
      alert("No students are currently assigned to mentors.");
      return;
    }

    const wb = XLSX.utils.book_new();
    const yearsToExport = selectedYear === 'All' ? Object.keys(dataByYear).sort() : [selectedYear];

    yearsToExport.forEach(year => {
      if (!dataByYear[year]) return;
      const ws = XLSX.utils.json_to_sheet(dataByYear[year]);
      const colWidths = [
        { wch: 30 }, // Name
        { wch: 30 }, // Mentor
        { wch: 15 }, // Reg No
        { wch: 10 }  // Section
      ];
      ws['!cols'] = colWidths;
      XLSX.utils.book_append_sheet(wb, ws, `Year ${year}`);
    });
    
    const fileName = selectedYear === 'All' ? 'Mentor_Assignment_Report.xlsx' : `Mentor_Assignment_Year_${selectedYear}.xlsx`;
    XLSX.writeFile(wb, fileName);
  };

  const exportToPDF = async (selectedYear) => {
    const dataByYear = getExportData();
    if (Object.keys(dataByYear).length === 0) {
      alert("No students are currently assigned to mentors.");
      return;
    }

    const doc = new jsPDF();
    
    // Load Logo
    const loadLogo = () => {
      return new Promise((resolve) => {
        const img = new Image();
        img.src = '/logo.png';
        img.onload = () => {
          const canvas = document.createElement('canvas');
          canvas.width = img.width;
          canvas.height = img.height;
          const ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0);
          resolve(canvas.toDataURL('image/png'));
        };
        img.onerror = () => {
          resolve(null);
        };
      });
    };

    const logoBase64 = await loadLogo();
    let startY = 15;
    if (logoBase64) {
      const logoWidth = 120;
      const logoHeight = 25;
      const xPos = (210 - logoWidth) / 2;
      doc.addImage(logoBase64, 'PNG', xPos, 10, logoWidth, logoHeight);
      startY = 45;
    }

    doc.setFontSize(16);
    const title = 'Mentor Assignment Report';
    const titleWidth = doc.getTextWidth(title);
    doc.text(title, (210 - titleWidth) / 2, startY);
    
    let yPos = startY + 12;
    const yearsToExport = selectedYear === 'All' ? Object.keys(dataByYear).sort() : [selectedYear];

    yearsToExport.forEach((year, index) => {
      if (!dataByYear[year]) return;
      if (index > 0) {
        doc.addPage();
        yPos = 15;
      }
      doc.setFontSize(12);
      doc.text(`Academic Year: ${year}`, 14, yPos);
      
      const tableData = dataByYear[year].map(row => [
        row['Student Name'],
        row['Mentor'],
        row['Register Number'],
        row['Section']
      ]);
      
      autoTable(doc, {
        startY: yPos + 5,
        head: [['Student Name', 'Mentor', 'Register Number', 'Section']],
        body: tableData,
        theme: 'grid',
        headStyles: { fillColor: [79, 70, 229] },
        styles: { fontSize: 9 }
      });
      yPos = doc.lastAutoTable.finalY + 15;
    });
    
    const fileName = selectedYear === 'All' ? 'Mentor_Assignment_Report.pdf' : `Mentor_Assignment_Year_${selectedYear}.pdf`;
    doc.save(fileName);
  };

  // Compute derived state
  const assignedStudentIds = new Set(mentors.map(m => m.student_id));
  
  const unassignedStudents = students
    .filter(s => !assignedStudentIds.has(s.id))
    .filter(s => {
      if (selectedSectionId && s.section?.id.toString() !== selectedSectionId) return false;
      if (!searchTerm) return true;
      const search = searchTerm.toLowerCase();
      return s.first_name?.toLowerCase().includes(search) || 
             s.last_name?.toLowerCase().includes(search) || 
             s.register_number?.toLowerCase().includes(search);
    });

  const availableSections = Array.from(new Map(
    students.filter(s => s.section).map(s => [s.section.id, s.section])
  ).values());

  const facultyBuckets = faculty.map(fac => {
    const assignedIds = mentors.filter(m => m.mentor_id === fac.id).map(m => m.student_id);
    const assignedStudents = students.filter(s => assignedIds.includes(s.id));
    return { ...fac, assignedStudents };
  });

  if (loading) return <div className="flex justify-center items-center h-64 text-slate-500">Loading Kanban board...</div>;
  if (error) return <div className="p-4 bg-red-50 text-red-600 rounded-xl flex items-center"><AlertCircle className="mr-2" />{error}</div>;

  return (
    <div className="flex flex-col h-[calc(100vh-8rem)] space-y-6">
      <div className="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 flex items-center justify-between shrink-0">
        <div className="flex items-center space-x-4">
          <div className="p-3 bg-indigo-50 text-indigo-600 rounded-xl">
            <Users className="w-6 h-6" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-800">Mentor Kanban</h1>
            <p className="text-slate-500 text-sm">Drag and drop students to assign mentors</p>
          </div>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={() => { setPendingExportType('excel'); setShowExportModal(true); }}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-50 text-emerald-600 hover:bg-emerald-100 font-semibold text-sm rounded-lg transition-colors border border-emerald-100"
          >
            <FileSpreadsheet className="w-4 h-4" />
            Excel
          </button>
          <button
            onClick={() => { setPendingExportType('pdf'); setShowExportModal(true); }}
            className="flex items-center gap-2 px-4 py-2 bg-red-50 text-red-600 hover:bg-red-100 font-semibold text-sm rounded-lg transition-colors border border-red-100"
          >
            <FileText className="w-4 h-4" />
            PDF
          </button>
        </div>
      </div>

      <div className="flex flex-1 gap-6 min-h-0 overflow-x-auto pb-4">
        
        {/* Unassigned Students Column */}
        <div 
          className="w-80 shrink-0 flex flex-col bg-slate-50 rounded-2xl border border-slate-200 overflow-hidden sticky left-0 z-10 shadow-[4px_0_15px_-3px_rgba(0,0,0,0.1)]"
          onDragOver={handleDragOver}
          onDrop={handleDropToUnassigned}
        >
          <div className="p-4 bg-white border-b border-slate-200">
            <h2 className="font-bold text-slate-800 flex justify-between items-center">
              Unassigned Pool
              <span className="bg-slate-100 text-slate-600 px-2 py-0.5 rounded-full text-xs">{unassignedStudents.length}</span>
            </h2>
            <div className="mt-3 space-y-2">
              <div className="relative">
                <Search className="w-4 h-4 absolute left-3 top-2.5 text-slate-400" />
                <input 
                  type="text" 
                  placeholder="Search students..." 
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="w-full pl-9 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:ring-indigo-500 focus:border-indigo-500"
                />
              </div>
              <select
                value={selectedSectionId}
                onChange={(e) => setSelectedSectionId(e.target.value)}
                className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:ring-indigo-500 focus:border-indigo-500 text-slate-600"
              >
                <option value="">All Sections</option>
                {availableSections.map(sec => (
                  <option key={sec.id} value={sec.id}>
                    {sec.name} (Year {sec.year})
                  </option>
                ))}
              </select>
            </div>
          </div>
          
          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {unassignedStudents.length === 0 ? (
              <div className="text-center text-sm text-slate-400 mt-10">No unassigned students found.</div>
            ) : (
              unassignedStudents.map(student => (
                <div 
                  key={student.id}
                  draggable
                  onClick={(e) => handleStudentClick(e, student.id)}
                  onDragStart={(e) => handleDragStart(e, student.id)}
                  className={`p-3 rounded-xl shadow-sm border cursor-grab active:cursor-grabbing hover:shadow-md transition-all ${selectedStudentIds.includes(student.id) ? 'bg-indigo-50 border-indigo-500 ring-1 ring-indigo-500' : 'bg-white border-slate-200 hover:border-indigo-300'}`}
                >
                  <div className="font-semibold text-slate-800 text-sm">{student.first_name} {student.last_name}</div>
                  <div className="text-xs text-slate-500 mt-1 flex justify-between">
                    <span>{student.register_number}</span>
                    <span>Yr {student.section?.year} {student.section?.name}</span>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Faculty Columns */}
        {facultyBuckets.map(fac => (
          <div 
            key={fac.id}
            className="w-80 shrink-0 flex flex-col bg-slate-50 rounded-2xl border border-slate-200 overflow-hidden transition-colors hover:bg-indigo-50/30"
            onDragOver={handleDragOver}
            onDrop={(e) => handleDropToFaculty(e, fac.id)}
          >
            <div className="p-4 bg-white border-b border-slate-200">
              <h2 className="font-bold text-slate-800 truncate" title={`${fac.first_name} ${fac.last_name}`}>
                {fac.first_name} {fac.last_name}
              </h2>
              <div className="text-xs text-slate-500 mt-1 flex justify-between items-center">
                <span className="truncate pr-2">{fac.designation}</span>
                <span className="bg-indigo-100 text-indigo-700 font-medium px-2 py-0.5 rounded-full shrink-0">
                  {fac.assignedStudents.length} mentees
                </span>
              </div>
              {fac.assignedStudents.length > 0 && (
                <button 
                  onClick={() => handleClearMentor(fac.id, fac.assignedStudents.map(s => s.id))}
                  className="mt-3 w-full py-1.5 px-3 bg-red-50 text-red-600 hover:bg-red-100 rounded-lg text-xs font-semibold transition-colors flex items-center justify-center gap-1"
                >
                  <AlertCircle className="w-3 h-3" /> Clear All Mentees
                </button>
              )}
            </div>
            
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              {fac.assignedStudents.length === 0 ? (
                <div className="h-full flex items-center justify-center border-2 border-dashed border-slate-200 rounded-xl">
                  <span className="text-sm text-slate-400">Drop students here</span>
                </div>
              ) : (
                fac.assignedStudents.map(student => (
                  <div 
                    key={student.id}
                    draggable
                    onClick={(e) => handleStudentClick(e, student.id)}
                    onDragStart={(e) => handleDragStart(e, student.id)}
                    className={`p-3 rounded-xl shadow-sm border cursor-grab active:cursor-grabbing hover:shadow-md transition-all ${selectedStudentIds.includes(student.id) ? 'bg-indigo-50 border-indigo-500 ring-1 ring-indigo-500' : 'bg-white border-indigo-100 hover:border-indigo-300'}`}
                  >
                    <div className="font-semibold text-slate-800 text-sm">{student.first_name} {student.last_name}</div>
                    <div className="text-xs text-slate-500 mt-1 flex justify-between">
                      <span>{student.register_number}</span>
                      <span>Yr {student.section?.year} {student.section?.name}</span>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        ))}
        
      </div>

      {showExportModal && (
        <div className="fixed inset-0 bg-slate-900/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-6 w-[400px] shadow-xl border border-slate-100">
            <h2 className="text-xl font-bold text-slate-800 mb-4">Export Settings</h2>
            <p className="text-sm text-slate-500 mb-6">Select which academic year you want to export, or export all years.</p>
            
            <div className="space-y-2 mb-6">
              <button 
                onClick={() => handleExport('All')}
                className="w-full text-left px-4 py-3 rounded-lg border border-slate-200 hover:border-indigo-500 hover:bg-indigo-50 transition-colors font-medium text-slate-700 hover:text-indigo-700 flex justify-between items-center"
              >
                All Years
                <span className="text-xs bg-slate-100 text-slate-500 px-2 py-1 rounded-full">Complete Report</span>
              </button>
              
              {Object.keys(getExportData()).sort().map(year => (
                <button 
                  key={year}
                  onClick={() => handleExport(year)}
                  className="w-full text-left px-4 py-3 rounded-lg border border-slate-200 hover:border-indigo-500 hover:bg-indigo-50 transition-colors font-medium text-slate-700 hover:text-indigo-700"
                >
                  Year {year}
                </button>
              ))}
            </div>
            
            <div className="flex justify-end">
              <button 
                onClick={() => setShowExportModal(false)}
                className="px-4 py-2 text-slate-500 hover:text-slate-700 hover:bg-slate-50 rounded-lg font-medium transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
