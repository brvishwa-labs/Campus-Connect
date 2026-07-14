import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Building2, Plus, Edit2, Trash2, Search, X, Target, Save, ChevronDown, ChevronUp, Loader2 } from 'lucide-react';

// ── Reusable form field components ──────────────────────────────────────────

const FormField = ({ label, required, children }) => (
  <div>
    <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">
      {label}{required && <span className="text-red-500 ml-0.5">*</span>}
    </label>
    {children}
  </div>
);

const inputCls =
  'w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none';
const textareaCls =
  'w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500 focus:bg-white transition-all outline-none resize-none';

// ── Program Outcomes Section ─────────────────────────────────────────────────

const ProgramOutcomesSection = () => {
  const [outcomes, setOutcomes] = useState('');
  const [savedOutcomes, setSavedOutcomes] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [expanded, setExpanded] = useState(true);
  const [saveMsg, setSaveMsg] = useState(null);

  useEffect(() => {
    axios.get('/api/departments/program-outcomes')
      .then(r => {
        const val = r.data.outcomes || '';
        setOutcomes(val);
        setSavedOutcomes(val);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const handleSave = async () => {
    setSaving(true);
    setSaveMsg(null);
    try {
      const res = await axios.put('/api/departments/program-outcomes', { outcomes });
      const val = res.data.outcomes || '';
      setSavedOutcomes(val);
      setSaveMsg({ type: 'success', text: 'Program Outcomes saved successfully.' });
    } catch (err) {
      setSaveMsg({ type: 'error', text: err.response?.data?.detail || 'Failed to save.' });
    } finally {
      setSaving(false);
      setTimeout(() => setSaveMsg(null), 4000);
    }
  };

  const isDirty = outcomes !== savedOutcomes;

  return (
    <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 overflow-hidden">
      {/* Section header */}
      <button
        type="button"
        onClick={() => setExpanded(e => !e)}
        className="w-full flex items-center justify-between px-6 py-4 hover:bg-gray-50/50 transition-colors"
      >
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-indigo-50 rounded-2xl flex items-center justify-center">
            <Target className="w-5 h-5 text-indigo-600" />
          </div>
          <div className="text-left">
            <h2 className="text-base font-bold text-gray-900">Program Outcomes (POs)</h2>
            <p className="text-xs text-gray-500 font-medium">
              Institution-wide · Editable by Admin · Viewable by all faculty
            </p>
          </div>
        </div>
        {expanded ? (
          <ChevronUp className="w-5 h-5 text-gray-400" />
        ) : (
          <ChevronDown className="w-5 h-5 text-gray-400" />
        )}
      </button>

      {expanded && (
        <div className="px-6 pb-6 border-t border-gray-100 pt-5 space-y-4">
          {loading ? (
            <div className="flex items-center justify-center py-8">
              <Loader2 className="w-6 h-6 animate-spin text-gray-400" />
            </div>
          ) : (
            <>
              <p className="text-xs text-gray-500 leading-relaxed">
                Enter each Program Outcome on a new line (e.g., "PO1: Engineering Knowledge ...").
                This content is shared across the entire institution and will be included in faculty academic reports.
              </p>

              {saveMsg && (
                <div className={`px-4 py-3 rounded-xl text-sm font-medium border ${
                  saveMsg.type === 'success'
                    ? 'bg-green-50 text-green-700 border-green-100'
                    : 'bg-red-50 text-red-600 border-red-100'
                }`}>
                  {saveMsg.text}
                </div>
              )}

              <textarea
                id="program-outcomes-textarea"
                rows={10}
                value={outcomes}
                onChange={e => setOutcomes(e.target.value)}
                placeholder={
                  'PO1: Engineering Knowledge — Apply knowledge of mathematics, science, engineering fundamentals...\n' +
                  'PO2: Problem Analysis — Identify, formulate, review research literature...\n' +
                  'PO3: Design/Development of Solutions...\n...'
                }
                className={textareaCls}
              />

              <div className="flex justify-end">
                <button
                  type="button"
                  onClick={handleSave}
                  disabled={saving || !isDirty}
                  id="save-program-outcomes-btn"
                  className="flex items-center gap-2 px-5 py-2.5 bg-indigo-600 text-white text-sm font-bold rounded-xl hover:bg-indigo-700 transition-colors shadow-sm disabled:opacity-50"
                >
                  {saving ? (
                    <><Loader2 className="w-4 h-4 animate-spin" /> Saving...</>
                  ) : (
                    <><Save className="w-4 h-4" /> Save Program Outcomes</>
                  )}
                </button>
              </div>
            </>
          )}
        </div>
      )}
    </div>
  );
};

// ── Main Departments Component ───────────────────────────────────────────────

export const Departments = () => {
  const [departments, setDepartments] = useState([]);
  const [faculty, setFaculty] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingDept, setEditingDept] = useState(null);

  // Form state
  const emptyForm = { name: '', code: '', vision: '', mission: '', peos: '', psos: '' };
  const [formData, setFormData] = useState(emptyForm);
  const [formError, setFormError] = useState(null);
  const [formLoading, setFormLoading] = useState(false);

  // Search state
  const [searchTerm, setSearchTerm] = useState('');

  const fetchDepartments = async () => {
    try {
      setLoading(true);
      const [deptRes, facRes] = await Promise.all([
        axios.get('/api/departments/'),
        axios.get('/api/faculty/')
      ]);
      setDepartments(deptRes.data);
      setFaculty(facRes.data);
      setError(null);
    } catch (err) {
      console.error(err);
      setError('Failed to load departments');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDepartments();
  }, []);

  const handleOpenModal = (dept = null) => {
    if (dept) {
      setEditingDept(dept);
      setFormData({
        name: dept.name || '',
        code: dept.code || '',
        vision: dept.vision || '',
        mission: dept.mission || '',
        peos: dept.peos || '',
        psos: dept.psos || '',
      });
    } else {
      setEditingDept(null);
      setFormData(emptyForm);
    }
    setFormError(null);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingDept(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormLoading(true);
    setFormError(null);

    try {
      if (editingDept) {
        await axios.put(`/api/departments/${editingDept.id}`, formData);
      } else {
        await axios.post('/api/departments/', formData);
      }
      await fetchDepartments();
      handleCloseModal();
    } catch (err) {
      setFormError(err.response?.data?.detail || 'Failed to save department');
    } finally {
      setFormLoading(false);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this department?')) {
      try {
        await axios.delete(`/api/departments/${id}`);
        await fetchDepartments();
      } catch (err) {
        alert(err.response?.data?.detail || 'Failed to delete department');
      }
    }
  };

  const filteredDepartments = departments.filter(d =>
    d.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    d.code.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      {/* Header Area */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-6 rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100">
        <div className="flex items-center space-x-4">
          <div className="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center">
            <Building2 className="w-6 h-6 text-primary-600" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Departments</h1>
            <p className="text-sm text-gray-500 font-medium">Manage academic departments</p>
          </div>
        </div>
        <button
          id="add-department-btn"
          onClick={() => handleOpenModal()}
          className="flex items-center px-5 py-2.5 bg-primary-600 text-white text-sm font-bold rounded-xl hover:bg-primary-700 transition-colors shadow-sm"
        >
          <Plus className="w-4 h-4 mr-2" /> Add Department
        </button>
      </div>

      {/* Main Content Area */}
      <div className="bg-white rounded-[24px] shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-100 overflow-hidden">
        {/* Toolbar */}
        <div className="p-4 border-b border-gray-100 flex items-center">
          <div className="relative w-full max-w-md">
            <Search className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search departments..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              id="department-search"
              className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border-none rounded-xl text-sm font-medium focus:ring-2 focus:ring-primary-500/20 focus:bg-white transition-all outline-none"
            />
          </div>
        </div>

        {/* Table */}
        <div className="overflow-x-auto">
          {error ? (
            <div className="p-8 text-center text-red-500 font-medium">{error}</div>
          ) : loading ? (
            <div className="p-8 text-center text-gray-500 font-medium">Loading departments...</div>
          ) : filteredDepartments.length === 0 ? (
            <div className="p-16 flex flex-col items-center justify-center text-center">
              <div className="w-16 h-16 bg-gray-50 rounded-2xl flex items-center justify-center mb-4">
                <Building2 className="w-8 h-8 text-gray-400" />
              </div>
              <h3 className="text-lg font-bold text-gray-900 mb-1">No Departments Found</h3>
              <p className="text-gray-500 text-sm">Get started by creating a new academic department.</p>
            </div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-gray-50/50 border-b border-gray-100">
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-[120px]">Code</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Department Name</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">HOD</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Vision / Mission</th>
                  <th className="px-6 py-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {filteredDepartments.map((dept) => (
                  <tr key={dept.id} className="hover:bg-gray-50/50 transition-colors group">
                    <td className="px-6 py-4">
                      <span className="px-2.5 py-1 bg-blue-50 text-primary-700 font-bold text-xs rounded-lg border border-blue-100">
                        {dept.code}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="font-bold text-gray-900 text-sm">{dept.name}</div>
                      {(dept.peos || dept.psos) && (
                        <div className="flex gap-1 mt-1">
                          {dept.peos && (
                            <span className="px-1.5 py-0.5 bg-violet-50 text-violet-600 text-[10px] font-bold rounded border border-violet-100">PEOs</span>
                          )}
                          {dept.psos && (
                            <span className="px-1.5 py-0.5 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded border border-emerald-100">PSOs</span>
                          )}
                        </div>
                      )}
                    </td>
                    <td className="px-6 py-4">
                      {dept.hod_id ? (
                        (() => {
                          const hod = faculty.find(f => f.id === dept.hod_id);
                          return hod ? (
                            <span className="text-sm font-medium text-gray-900">{hod.first_name} {hod.last_name}</span>
                          ) : (
                            <span className="text-sm font-medium text-gray-900">User #{dept.hod_id}</span>
                          );
                        })()
                      ) : (
                        <span className="text-xs font-medium text-gray-400 bg-gray-100 px-2 py-1 rounded-md">Not Assigned</span>
                      )}
                    </td>
                    <td className="px-6 py-4 max-w-[200px]">
                      {dept.vision && (
                        <div className="text-xs text-gray-500 line-clamp-1">{dept.vision}</div>
                      )}
                      {dept.mission && (
                        <div className="text-xs text-gray-400 line-clamp-1 mt-0.5">{dept.mission}</div>
                      )}
                      {!dept.vision && !dept.mission && (
                        <span className="text-xs text-gray-300">—</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button
                          onClick={() => handleOpenModal(dept)}
                          className="p-1.5 text-gray-400 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
                          title="Edit"
                        >
                          <Edit2 className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(dept.id)}
                          className="p-1.5 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                          title="Delete"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* ── Program Outcomes Section ───────────────────────────────────────── */}
      <ProgramOutcomesSection />

      {/* Create/Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-900/40 backdrop-blur-sm">
          <div className="bg-white rounded-[24px] shadow-2xl w-full max-w-2xl overflow-hidden transform transition-all">
            <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
              <h3 className="text-lg font-bold text-gray-900">
                {editingDept ? 'Edit Department' : 'Create Department'}
              </h3>
              <button
                onClick={handleCloseModal}
                className="p-1.5 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-xl transition-colors"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="p-6 space-y-5 max-h-[80vh] overflow-y-auto">
              {formError && (
                <div className="p-3 bg-red-50 text-red-600 text-sm font-medium rounded-xl border border-red-100">
                  {formError}
                </div>
              )}

              {/* Row: Name + Code */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div className="sm:col-span-2">
                  <FormField label="Department Name" required>
                    <input
                      type="text"
                      required
                      id="dept-name-input"
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      className={inputCls}
                      placeholder="e.g. Computer Science and Engineering"
                    />
                  </FormField>
                </div>
                <div>
                  <FormField label="Code" required>
                    <input
                      type="text"
                      required
                      id="dept-code-input"
                      value={formData.code}
                      onChange={(e) => setFormData({ ...formData, code: e.target.value.toUpperCase() })}
                      className={inputCls}
                      placeholder="e.g. CSE"
                    />
                  </FormField>
                </div>
              </div>

              {/* Divider */}
              <div className="border-t border-gray-100 pt-1">
                <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4">
                  Department Identity
                </p>
              </div>

              {/* Department Vision */}
              <FormField label="Department Vision">
                <textarea
                  id="dept-vision-input"
                  rows={3}
                  value={formData.vision}
                  onChange={(e) => setFormData({ ...formData, vision: e.target.value })}
                  className={textareaCls}
                  placeholder="To be a globally recognized department..."
                />
              </FormField>

              {/* Department Mission */}
              <FormField label="Department Mission">
                <textarea
                  id="dept-mission-input"
                  rows={3}
                  value={formData.mission}
                  onChange={(e) => setFormData({ ...formData, mission: e.target.value })}
                  className={textareaCls}
                  placeholder="To impart quality education through innovation..."
                />
              </FormField>

              {/* PEOs */}
              <FormField label="Programme Educational Objectives (PEOs)">
                <textarea
                  id="dept-peos-input"
                  rows={4}
                  value={formData.peos}
                  onChange={(e) => setFormData({ ...formData, peos: e.target.value })}
                  className={textareaCls}
                  placeholder={"PEO1: Graduates will demonstrate technical proficiency...\nPEO2: Graduates will exhibit professional conduct...\nPEO3: Graduates will engage in lifelong learning..."}
                />
              </FormField>

              {/* PSOs */}
              <FormField label="Programme Specific Outcomes (PSOs)">
                <textarea
                  id="dept-psos-input"
                  rows={4}
                  value={formData.psos}
                  onChange={(e) => setFormData({ ...formData, psos: e.target.value })}
                  className={textareaCls}
                  placeholder={"PSO1: Apply knowledge of computing to solve domain-specific problems...\nPSO2: Design and develop software/hardware solutions..."}
                />
              </FormField>

              <div className="pt-4 border-t border-gray-100 flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="px-5 py-2.5 text-sm font-bold text-gray-600 hover:bg-gray-100 rounded-xl transition-colors"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={formLoading}
                  id="dept-submit-btn"
                  className="px-5 py-2.5 bg-primary-600 text-white text-sm font-bold rounded-xl hover:bg-primary-700 transition-colors shadow-sm disabled:opacity-50"
                >
                  {formLoading ? 'Saving...' : editingDept ? 'Save Changes' : 'Create Department'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
