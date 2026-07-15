import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Users, Search, AlertCircle } from 'lucide-react';

export const MentorAssignment = () => {
  const [mentors, setMentors] = useState([]);
  const [faculty, setFaculty] = useState([]);
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedSectionId, setSelectedSectionId] = useState('');
  const [selectedStudentIds, setSelectedStudentIds] = useState([]);

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
    </div>
  );
};
