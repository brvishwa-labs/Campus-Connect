import { useState, useEffect } from 'react';
import DataTable from '../../components/ui/DataTable';
import Modal from '../../components/ui/Modal';
import api from '../../api/axios';
import { Building2, Edit2, Trash2, ShieldAlert } from 'lucide-react';
import { cn } from '../../utils/cn';

export default function Departments() {
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(true);
  
  // Modal State
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [formData, setFormData] = useState({ name: '', code: '' });
  
  useEffect(() => {
    fetchDepartments();
  }, []);

  const fetchDepartments = async () => {
    try {
      setLoading(true);
      const res = await api.get('/admin/departments/');
      setDepartments(res.data);
    } catch (err) {
      console.warn("Backend unavailable, using mock departments");
      setDepartments([
        { id: 1, name: 'Computer Science', code: 'CS', is_active: true, created_at: '2023-01-10T00:00:00Z' },
        { id: 2, name: 'Mechanical Engineering', code: 'ME', is_active: true, created_at: '2023-02-15T00:00:00Z' },
        { id: 3, name: 'Civil Engineering', code: 'CE', is_active: true, created_at: '2023-03-20T00:00:00Z' },
        { id: 4, name: 'Electrical Engineering', code: 'EE', is_active: false, created_at: '2023-04-25T00:00:00Z' },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleAddSubmit = async (e) => {
    e.preventDefault();
    try {
      await api.post('/admin/departments/', formData);
      fetchDepartments();
      setIsAddModalOpen(false);
      setFormData({ name: '', code: '' });
    } catch (err) {
      console.error(err);
      // For mock UI purposes, we'll just prepend it to state
      const newDept = {
        id: Date.now(),
        name: formData.name,
        code: formData.code,
        is_active: true,
        created_at: new Date().toISOString()
      };
      setDepartments([newDept, ...departments]);
      setIsAddModalOpen(false);
      setFormData({ name: '', code: '' });
    }
  };

  const columns = [
    {
      header: 'Department',
      accessor: 'name',
      sortable: true,
      render: (row) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-indigo-50 flex items-center justify-center text-indigo-600">
            <Building2 className="w-5 h-5" />
          </div>
          <div className="font-medium text-slate-900">{row.name}</div>
        </div>
      )
    },
    {
      header: 'Code',
      accessor: 'code',
      sortable: true,
      render: (row) => <span className="font-semibold text-slate-500">{row.code}</span>
    },
    {
      header: 'Status',
      accessor: 'is_active',
      render: (row) => (
        <span className={cn(
          "px-2.5 py-1 rounded-full text-xs font-bold uppercase tracking-wider",
          row.is_active ? "bg-emerald-50 text-emerald-600" : "bg-red-50 text-red-600"
        )}>
          {row.is_active ? 'Active' : 'Inactive'}
        </span>
      )
    },
    {
      header: 'Actions',
      render: (row) => (
        <div className="flex items-center gap-2">
          <button className="p-2 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors">
            <Edit2 className="w-4 h-4" />
          </button>
          <button className="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors">
            <Trash2 className="w-4 h-4" />
          </button>
        </div>
      )
    }
  ];

  return (
    <div className="max-w-7xl mx-auto space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Departments</h1>
          <p className="text-sm font-medium text-slate-500 mt-1">
            Manage academic departments across the institution.
          </p>
        </div>
      </div>

      {loading ? (
        <div className="glass-card rounded-2xl h-96 flex items-center justify-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-600"></div>
        </div>
      ) : (
        <DataTable 
          columns={columns} 
          data={departments} 
          searchPlaceholder="Search departments..."
          onAddClick={() => setIsAddModalOpen(true)}
          addLabel="Add Department"
        />
      )}

      {/* Add Department Modal */}
      <Modal
        isOpen={isAddModalOpen}
        onClose={() => setIsAddModalOpen(false)}
        title="Add New Department"
      >
        <form onSubmit={handleAddSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Department Name</label>
            <input 
              type="text" 
              required
              value={formData.name}
              onChange={(e) => setFormData({...formData, name: e.target.value})}
              placeholder="e.g. Computer Science"
              className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-slate-700 mb-1">Department Code</label>
            <input 
              type="text" 
              required
              value={formData.code}
              onChange={(e) => setFormData({...formData, code: e.target.value.toUpperCase()})}
              placeholder="e.g. CS"
              className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all uppercase"
            />
          </div>
          
          <div className="bg-blue-50 text-blue-700 p-3 rounded-lg text-xs flex items-start gap-2 mt-4">
            <ShieldAlert className="w-4 h-4 shrink-0 mt-0.5" />
            <p>You can assign a Head of Department (HOD) from the HOD Management tab after creating the department.</p>
          </div>

          <div className="pt-4 flex justify-end gap-3 border-t border-slate-100">
            <button 
              type="button"
              onClick={() => setIsAddModalOpen(false)}
              className="px-4 py-2 text-sm font-medium text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
            >
              Cancel
            </button>
            <button 
              type="submit"
              className="px-4 py-2 text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-lg transition-colors shadow-sm shadow-indigo-200"
            >
              Create Department
            </button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
