import React, { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import axios from 'axios';
import {
  User, Mail, Phone, Building2, BookOpen, MapPin, Users,
  GraduationCap, Briefcase, Shield, Eye, EyeOff, Edit2, Check, X
} from 'lucide-react';
import OnboardingForm from './OnboardingForm';

// ── Shared helpers ────────────────────────────────────────────────────────────

const InfoRow = ({ label, value }) => {
  if (!value) return null;
  return (
    <div className="bg-gray-50 rounded-xl px-4 py-3">
      <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-0.5">{label}</p>
      <p className="text-sm font-semibold text-gray-900 break-words">{value}</p>
    </div>
  );
};

const ReadOnlyRow = ({ label, value }) => {
  return (
    <div className="bg-gray-50 rounded-xl px-4 py-3">
      <div className="flex items-center justify-between mb-0.5">
        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">{label}</p>
      </div>
      <p className="text-sm font-semibold text-gray-900">{value || <span className="text-gray-400">—</span>}</p>
    </div>
  );
};

const SectionCard = ({ title, icon: Icon, children }) => (
  <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
    <h2 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
      <Icon className="w-4 h-4" /> {title}
    </h2>
    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">{children}</div>
  </div>
);

// ── Inline editable field ─────────────────────────────────────────────────────

const EditableRow = ({ label, value, field, onSave }) => {
  const [editing, setEditing] = useState(false);
  const [val, setVal] = useState(value || '');
  const [saving, setSaving] = useState(false);

  const handleSave = async () => {
    setSaving(true);
    await onSave(field, val);
    setSaving(false);
    setEditing(false);
  };

  return (
    <div className="bg-gray-50 rounded-xl px-4 py-3">
      <div className="flex items-center justify-between mb-0.5">
        <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">{label}</p>
        {!editing ? (
          <button onClick={() => setEditing(true)} className="text-gray-400 hover:text-primary-600 transition-colors">
            <Edit2 className="w-3.5 h-3.5" />
          </button>
        ) : (
          <div className="flex gap-1">
            <button onClick={handleSave} disabled={saving} className="text-green-600 hover:text-green-700"><Check className="w-3.5 h-3.5" /></button>
            <button onClick={() => { setEditing(false); setVal(value || ''); }} className="text-red-400 hover:text-red-600"><X className="w-3.5 h-3.5" /></button>
          </div>
        )}
      </div>
      {editing ? (
        <input
          autoFocus
          value={val}
          onChange={e => setVal(e.target.value)}
          className="w-full text-sm font-semibold text-gray-900 bg-white border border-primary-300 rounded-lg px-2 py-1 outline-none focus:ring-2 focus:ring-primary-500/20"
        />
      ) : (
        <p className="text-sm font-semibold text-gray-900">{val || <span className="text-gray-400">—</span>}</p>
      )}
    </div>
  );
};

// ── Change Password ───────────────────────────────────────────────────────────

const ChangePassword = ({ role }) => {
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({ current_password: '', new_password: '', confirm: '' });
  const [show, setShow] = useState(false);
  const [msg, setMsg] = useState(null);
  const [saving, setSaving] = useState(false);

  const handleSubmit = async e => {
    e.preventDefault();
    if (form.new_password !== form.confirm) { setMsg({ type: 'error', text: 'Passwords do not match' }); return; }
    if (form.new_password.length < 6) { setMsg({ type: 'error', text: 'At least 6 characters required' }); return; }
    setSaving(true);
    try {
      await axios.put('/api/auth/profile', { current_password: form.current_password, new_password: form.new_password });
      setMsg({ type: 'success', text: 'Password changed successfully' });
      setForm({ current_password: '', new_password: '', confirm: '' });
      setOpen(false);
    } catch (err) {
      setMsg({ type: 'error', text: err.response?.data?.detail || 'Failed to change password' });
    } finally { setSaving(false); }
  };

  return (
    <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
      <h2 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
        <Shield className="w-4 h-4" /> Account & Security
      </h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-4">
        <InfoRow label="Role" value={role ? role.charAt(0).toUpperCase() + role.slice(1) : "Student"} />
      </div>
      {msg && (
        <div className={`mb-3 px-4 py-2 rounded-xl text-sm font-medium ${msg.type === 'error' ? 'bg-red-50 text-red-600' : 'bg-green-50 text-green-700'}`}>
          {msg.text}
        </div>
      )}
      {!open ? (
        <button onClick={() => { setOpen(true); setMsg(null); }}
          className="px-4 py-2 bg-primary-50 text-primary-700 text-sm font-bold rounded-xl hover:bg-primary-100 transition-colors">
          Change Password
        </button>
      ) : (
        <form onSubmit={handleSubmit} className="space-y-3 max-w-sm">
          {['current_password', 'new_password', 'confirm'].map((field, i) => (
            <div key={field} className="relative">
              <input
                type={show ? 'text' : 'password'}
                placeholder={['Current Password', 'New Password', 'Confirm New Password'][i]}
                value={form[field]}
                onChange={e => setForm(p => ({ ...p, [field]: e.target.value }))}
                required
                className="w-full px-4 py-2.5 pr-10 bg-gray-50 border border-gray-200 rounded-xl text-sm font-medium outline-none focus:ring-2 focus:ring-primary-500/20 focus:border-primary-500"
              />
              {i === 0 && (
                <button type="button" onClick={() => setShow(p => !p)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                  {show ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              )}
            </div>
          ))}
          <div className="flex gap-2">
            <button type="submit" disabled={saving}
              className="px-5 py-2 bg-primary-600 text-white text-sm font-bold rounded-xl hover:bg-primary-700 transition-colors disabled:opacity-50">
              {saving ? 'Saving...' : 'Update'}
            </button>
            <button type="button" onClick={() => setOpen(false)}
              className="px-5 py-2 bg-gray-100 text-gray-600 text-sm font-bold rounded-xl hover:bg-gray-200 transition-colors">
              Cancel
            </button>
          </div>
        </form>
      )}
    </div>
  );
};

// ── Student Profile ───────────────────────────────────────────────────────────

const AttBadge = ({ pct }) => {
  if (pct === null || pct === undefined) return <span className="text-xs text-gray-400">No data</span>;
  const low = pct < 75;
  return (
    <span className={`px-2.5 py-1 rounded-lg text-xs font-bold ${low ? 'bg-red-50 text-red-700' : 'bg-green-50 text-green-700'}`}>
      {pct}%
    </span>
  );
};

const StudentProfile = ({ profile, onUpdate }) => {
  const handleSave = async (field, value) => {
    try {
      await axios.put('/api/auth/profile', { [field]: value });
      onUpdate(field, value);
    } catch (err) {
      alert(err.response?.data?.detail || 'Failed to save');
    }
  };

  const courses = profile.enrolled_courses || [];

  return (
    <>
      {/* Personal Info */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <h2 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
          <User className="w-4 h-4" /> Personal Information
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <InfoRow label="Full Name"       value={`${profile.first_name} ${profile.last_name}`} />
          <InfoRow label="Register Number" value={profile.register_number} />
          <InfoRow label="College Email"   value={profile.college_email} />
          <EditableRow label="Personal Email" value={profile.personal_email} field="personal_email" onSave={handleSave} />
          <EditableRow label="Phone Number"   value={profile.phone}           field="phone"           onSave={handleSave} />
          <InfoRow label="Gender"         value={profile.gender} />
          <InfoRow label="Date of Birth"  value={profile.date_of_birth} />
          <EditableRow label="Blood Group" value={profile.blood_group} field="blood_group" onSave={handleSave} />
          <InfoRow label="Religion"       value={profile.religion} />
        </div>
      </div>

      {/* Academic Info */}
      <SectionCard title="Academic Information" icon={GraduationCap}>
        <InfoRow label="Department"       value={profile.department_name ? `${profile.department_name} (${profile.department_code})` : null} />
        <InfoRow label="Batch"            value={profile.batch} />
        <InfoRow label="Current Year"     value={profile.current_year ? `Year ${profile.current_year}` : null} />
        <InfoRow label="Current Semester" value={profile.current_semester ? `Semester ${profile.current_semester}` : null} />
        <InfoRow label="Section"          value={profile.section_name} />
        <InfoRow label="Admission Date"   value={profile.admission_date} />
        <InfoRow label="Admission Type"   value={profile.admission_type} />
        <InfoRow label="Class Advisor"    value={profile.class_advisor} />
        <InfoRow label="Mentor"           value={profile.mentor} />
        <InfoRow label="Student Status"   value={profile.is_active ? 'Active' : 'Inactive'} />
      </SectionCard>

      {/* Overall Attendance */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <h2 className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 flex items-center gap-2">
          <BookOpen className="w-4 h-4" /> Academic Performance
        </h2>
        {/* Overall attendance bar */}
        <div className={`flex items-center justify-between rounded-xl px-4 py-3 mb-4 ${
          profile.overall_attendance !== null && profile.overall_attendance < 75 ? 'bg-red-50' : 'bg-green-50'
        }`}>
          <span className="text-sm font-semibold text-gray-700">Overall Attendance</span>
          <AttBadge pct={profile.overall_attendance} />
        </div>

        {/* Per-course table */}
        {courses.length === 0 ? (
          <p className="text-sm text-gray-400 font-medium">No courses enrolled yet.</p>
        ) : (
          <div className="space-y-2">
            {courses.map(c => {
              const pct = c.attendance_percentage;
              const low = pct !== null && pct < 75;
              return (
                <div key={c.code} className={`rounded-xl border p-3 ${low ? 'border-red-100 bg-red-50/30' : 'border-gray-100 bg-gray-50'}`}>
                  <div className="flex items-start justify-between gap-3">
                    <div className="min-w-0">
                      <p className="text-sm font-bold text-gray-900 truncate">{c.name}</p>
                      <p className="text-xs text-gray-400">{c.code} · {c.credits} credits · <span className="capitalize">{c.course_type}</span> · Sem {c.semester}</p>
                    </div>
                    <div className="flex-shrink-0 text-right">
                      <AttBadge pct={pct} />
                      {c.total_classes > 0 && (
                        <p className="text-xs text-gray-400 mt-1">{c.classes_attended}/{c.total_classes} classes</p>
                      )}
                    </div>
                  </div>
                  {pct !== null && (
                    <div className="mt-2 bg-gray-200 rounded-full h-1.5 overflow-hidden">
                      <div
                        className={`h-1.5 rounded-full ${low ? 'bg-red-400' : 'bg-green-500'}`}
                        style={{ width: `${Math.min(100, pct)}%` }}
                      />
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Parent / Guardian Info */}
      <SectionCard title="Parent / Guardian Details" icon={Users}>
        <InfoRow label="Primary Contact" value={profile.primary_contact ? profile.primary_contact.charAt(0).toUpperCase() + profile.primary_contact.slice(1) : 'Father'} />
        <InfoRow label="Father's Name"   value={profile.father_name} />
        <InfoRow label="Father's Phone"  value={profile.father_phone} />
        <InfoRow label="Mother's Name"   value={profile.mother_name} />
        <InfoRow label="Mother's Phone"  value={profile.mother_phone} />
        {profile.guardian_name && <InfoRow label="Guardian's Name" value={profile.guardian_name} />}
        {profile.guardian_phone && <InfoRow label="Guardian's Phone" value={profile.guardian_phone} />}
      </SectionCard>

      {/* Account & Security */}
      <ChangePassword role={profile.role} />
    </>
  );
};

// ── Generic Profile (faculty, hod, authority, admin) ─────────────────────────

const GenericProfile = ({ profile, onUpdate }) => {
  const role = profile.role;
  const isFacultyOrHod = role === 'faculty' || role === 'hod';

  const handleSave = async (field, value) => {
    try {
      await axios.put('/api/auth/profile', { [field]: value });
      onUpdate(field, value);
    } catch (err) {
      alert(err.response?.data?.detail || 'Failed to save');
    }
  };

  let totalCalculatedExperience = 0;
  if (isFacultyOrHod) {
    if (profile.past_experience) {
      profile.past_experience.forEach(exp => {
        if (exp.from_date && exp.to_date) {
          const from = new Date(exp.from_date);
          const to = new Date(exp.to_date);
          if (to > from) {
            totalCalculatedExperience += (to - from) / (1000 * 60 * 60 * 24 * 365.25);
          }
        }
      });
    }
    if (profile.date_of_joining) {
      const joining = new Date(profile.date_of_joining);
      const today = new Date();
      if (today > joining) {
        totalCalculatedExperience += (today - joining) / (1000 * 60 * 60 * 24 * 365.25);
      }
    }
    totalCalculatedExperience = Number(totalCalculatedExperience.toFixed(1));
  }

  return (
    <>
      <SectionCard title="Personal Information" icon={User}>
        <InfoRow label="Email"        value={profile.college_email || profile.email} />
        {isFacultyOrHod ? <EditableRow label="Phone" value={profile.phone} field="phone" onSave={handleSave} /> : <InfoRow label="Phone" value={profile.phone} />}
        <InfoRow label="Gender"       value={profile.gender} />
        <InfoRow label="Date of Birth" value={profile.date_of_birth} />
        {isFacultyOrHod ? <EditableRow label="Blood Group" value={profile.blood_group} field="blood_group" onSave={handleSave} /> : <InfoRow label="Blood Group" value={profile.blood_group} />}
        <InfoRow label="Religion"     value={profile.religion} />
        <InfoRow label="Nationality"  value={profile.nationality} />
        {isFacultyOrHod && <EditableRow label="Personal Email" value={profile.personal_email} field="personal_email" onSave={handleSave} />}
        {isFacultyOrHod && <InfoRow label="PAN Card" value={profile.pan_card} />}
        {isFacultyOrHod && <InfoRow label="Aadhar Number" value={profile.aadhar_number} />}
      </SectionCard>

      {(role === 'faculty' || role === 'hod') && (
        <>
          <SectionCard title="Accommodation & Transport" icon={MapPin}>
            <InfoRow label="Accommodation" value={profile.accommodation} />
            <InfoRow label="Transportation" value={profile.transportation} />
            {profile.transportation === 'BUS' && <InfoRow label="Bus Number" value={profile.bus_number} />}
          </SectionCard>

          <SectionCard title="Parent / Guardian Details" icon={Users}>
            <InfoRow label="Father's Name" value={profile.father_name} />
            <InfoRow label="Mother's Name" value={profile.mother_name} />
            {profile.guardian_name && <InfoRow label="Guardian's Name" value={profile.guardian_name} />}
          </SectionCard>

          <SectionCard title="Emergency Contacts" icon={Users}>
            {profile.emergency_contacts && profile.emergency_contacts.length > 0 ? (
              <div className="col-span-full space-y-3">
                {profile.emergency_contacts.map((c, i) => (
                  <div key={i} className="bg-gray-50 rounded-xl p-3 border border-gray-100 flex items-center justify-between">
                    <div>
                      <p className="text-sm font-bold text-gray-900">{c.name}</p>
                      <p className="text-xs text-gray-500">{c.relation}</p>
                    </div>
                    <div className="font-medium text-sm text-gray-800">{c.number}</div>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-gray-400">No emergency contacts added.</p>
            )}
          </SectionCard>

          <SectionCard title="Academic History" icon={GraduationCap}>
            {profile.academic_history ? (
              <div className="col-span-full grid grid-cols-1 sm:grid-cols-2 gap-4">
                <InfoRow label="10th Details" value={profile.academic_history.tenth?.school ? `${profile.academic_history.tenth.school}, ${profile.academic_history.tenth.board} (${profile.academic_history.tenth.percentage}%)` : null} />
                <InfoRow label="12th Details" value={profile.academic_history.twelfth?.school ? `${profile.academic_history.twelfth.school}, ${profile.academic_history.twelfth.board} (${profile.academic_history.twelfth.percentage}%)` : null} />
                <InfoRow label="UG Details" value={profile.academic_history.ug?.degree ? `${profile.academic_history.ug.degree}, ${profile.academic_history.ug.university} (${profile.academic_history.ug.percentage}%)` : null} />
                {Array.isArray(profile.academic_history.pg) ? (
                  profile.academic_history.pg.map((pgItem, index) => (
                    <InfoRow key={index} label={profile.academic_history.pg.length > 1 ? `PG ${index + 1} Details` : "PG Details"} value={pgItem.degree ? `${pgItem.degree}, ${pgItem.university} (${pgItem.percentage}%)` : null} />
                  ))
                ) : (
                  <InfoRow label="PG Details" value={profile.academic_history.pg?.degree ? `${profile.academic_history.pg.degree}, ${profile.academic_history.pg.university} (${profile.academic_history.pg.percentage}%)` : null} />
                )}
                <InfoRow label="PhD Details" value={profile.academic_history.phd?.specialization ? `${profile.academic_history.phd.specialization}, ${profile.academic_history.phd.university} (${profile.academic_history.phd.year})` : 'Not Provided'} />
              </div>
            ) : (
              <p className="text-sm text-gray-400">Academic history not provided.</p>
            )}
          </SectionCard>

          <SectionCard title="Past Experience" icon={Briefcase}>
            {profile.past_experience && profile.past_experience.length > 0 ? (
              <div className="col-span-full space-y-3">
                {profile.past_experience.map((exp, i) => {
                  let calculatedExp = 0;
                  if (exp.from_date && exp.to_date) {
                    const from = new Date(exp.from_date);
                    const to = new Date(exp.to_date);
                    if (to > from) {
                      calculatedExp = (to - from) / (1000 * 60 * 60 * 24 * 365.25);
                    }
                  }
                  return (
                    <div key={i} className="bg-gray-50 rounded-xl p-3 border border-gray-100 flex items-center justify-between">
                      <div>
                        <p className="text-sm font-bold text-gray-900">{exp.institution}</p>
                        <p className="text-xs text-gray-500">
                          {exp.from_date ? new Date(exp.from_date).toLocaleDateString() : 'N/A'} - {exp.to_date ? new Date(exp.to_date).toLocaleDateString() : 'N/A'}
                        </p>
                      </div>
                      <div className="font-medium text-sm text-primary-600 px-3 py-1 bg-primary-50 rounded-lg">
                        {calculatedExp > 0 ? calculatedExp.toFixed(1) : 0} Years
                      </div>
                    </div>
                  );
                })}
                {profile.date_of_joining && (
                  <div className="bg-primary-50 rounded-xl p-3 border border-primary-100 flex items-center justify-between">
                    <div>
                      <p className="text-sm font-bold text-gray-900">Sri Venkateshwaraa College of Engineering and Technology, Puducherry</p>
                      <p className="text-xs text-gray-500">
                        {new Date(profile.date_of_joining).toLocaleDateString()} - Present
                      </p>
                    </div>
                    <div className="font-medium text-sm text-primary-600 px-3 py-1 bg-white rounded-lg shadow-sm">
                      {(((new Date() - new Date(profile.date_of_joining)) / (1000 * 60 * 60 * 24 * 365.25)).toFixed(1))} Years
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <p className="text-sm text-gray-400">No past experience added.</p>
            )}
          </SectionCard>

          <SectionCard title="Professional Details" icon={Briefcase}>
            <InfoRow label="Department"     value={profile.department_name ? `${profile.department_name} (${profile.department_code})` : null} />
            <InfoRow label="Employee ID"    value={profile.employee_id} />
            <InfoRow label="Designation"    value={profile.designation} />
            <InfoRow label="Qualification"  value={profile.qualification} />
            <InfoRow label="Specialization" value={profile.specialization} />
            <InfoRow label="Total Experience" value={totalCalculatedExperience > 0 ? `${totalCalculatedExperience} years` : (profile.experience_years ? `${profile.experience_years} years` : null)} />
            <InfoRow label="Date of Joining" value={profile.date_of_joining} />
          </SectionCard>
        </>
      )}

      {role === 'authority' && (
        <SectionCard title="Authority Details" icon={Building2}>
          <InfoRow label="Title"       value={profile.title} />
          <InfoRow label="Employee ID" value={profile.employee_id} />
        </SectionCard>
      )}

      {isFacultyOrHod ? (
        <SectionCard title="Address" icon={MapPin}>
          <EditableRow label="Address" value={profile.address_line1} field="address_line1" onSave={handleSave} />
          <EditableRow label="City"    value={profile.city}    field="city"    onSave={handleSave} />
          <EditableRow label="State"   value={profile.state}   field="state"   onSave={handleSave} />
          <EditableRow label="Pincode" value={profile.pincode} field="pincode" onSave={handleSave} />
        </SectionCard>
      ) : (
        (profile.address_line1 || profile.city) && (
          <SectionCard title="Address" icon={MapPin}>
            <InfoRow label="Address" value={[profile.address_line1, profile.address_line2].filter(Boolean).join(', ')} />
            <InfoRow label="City"    value={profile.city} />
            <InfoRow label="State"   value={profile.state} />
            <InfoRow label="Pincode" value={profile.pincode} />
          </SectionCard>
        )
      )}

      <ChangePassword role={profile.role} />
    </>
  );
};

// ── Main Profile Component ────────────────────────────────────────────────────

export const Profile = () => {
  const { user } = useAuth();
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios.get('/api/auth/profile')
      .then(r => setProfile(r.data))
      .catch(() => setError('Failed to load profile'))
      .finally(() => setLoading(false));
  }, []);

  const handleUpdate = (field, value) => {
    setProfile(prev => ({ ...prev, [field]: value }));
  };

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-gray-500">
        <div className="animate-spin rounded-full h-10 w-10 border-4 border-primary-100 border-t-primary-600 mb-4"></div>
        <p className="font-medium">Loading profile...</p>
      </div>
    );
  }
  if (error)   return <div className="p-8 text-center text-red-500">{error}</div>;
  if (!profile) return null;

  const isOnboarding = profile.role !== 'admin' && profile.role !== 'authority' && (!profile.date_of_birth || !profile.gender);

  if (isOnboarding) {
    return (
      <OnboardingForm 
        profile={profile} 
        onComplete={() => {
          setLoading(true);
          axios.get('/api/auth/profile')
            .then(r => setProfile(r.data))
            .catch(() => setError('Failed to load profile'))
            .finally(() => setLoading(false));
        }} 
      />
    );
  }

  const name = `${profile.first_name || ''} ${profile.last_name || ''}`.trim() || profile.email;

  return (
    <div className="max-w-3xl mx-auto space-y-5">
      {/* Banner */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 flex items-center gap-5">
        <div className="w-16 h-16 rounded-2xl bg-primary-600 flex items-center justify-center text-white text-2xl font-extrabold flex-shrink-0">
          {name.charAt(0).toUpperCase()}
        </div>
        <div className="flex-1 min-w-0">
          <h1 className="text-2xl font-bold text-gray-900 truncate">{name}</h1>
          <p className="text-sm text-gray-500 mt-0.5 capitalize">
            {profile.designation || profile.title || profile.role}
          </p>
          {profile.register_number && <p className="text-xs text-gray-400 mt-0.5">Reg: {profile.register_number}</p>}
          {profile.employee_id     && <p className="text-xs text-gray-400 mt-0.5">ID: {profile.employee_id}</p>}
        </div>
        <span className={`px-3 py-1 rounded-xl text-xs font-bold flex-shrink-0 ${profile.is_active !== false ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700'}`}>
          {profile.is_active !== false ? 'Active' : 'Inactive'}
        </span>
      </div>

      {profile.role === 'student'
        ? <StudentProfile profile={profile} onUpdate={handleUpdate} />
        : <GenericProfile profile={profile} onUpdate={handleUpdate} />
      }
    </div>
  );
};
