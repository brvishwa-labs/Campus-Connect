import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Users, BookOpen, X, Search } from 'lucide-react';

export const FacultyList = () => {
  const [faculty, setFaculty] = useState([]);
  const [filteredFaculty, setFilteredFaculty] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFaculty, setSelectedFaculty] = useState(null);
  const [profileModal, setProfileModal] = useState({ open: false, data: null, loading: false });

  useEffect(() => {
    const fetchFaculty = async () => {
      try {
        const res = await axios.get('/api/authorities/faculty');
        setFaculty(res.data);
        setFilteredFaculty(res.data);
      } catch (err) {
        setError('Failed to load faculty');
      } finally {
        setLoading(false);
      }
    };
    fetchFaculty();
  }, []);

  useEffect(() => {
    if (searchQuery.trim() === '') {
      setFilteredFaculty(faculty);
    } else {
      const query = searchQuery.toLowerCase();
      const filtered = faculty.filter(f => 
        f.first_name?.toLowerCase().includes(query) ||
        f.last_name?.toLowerCase().includes(query) ||
        f.employee_id?.toLowerCase().includes(query) ||
        f.department_name?.toLowerCase().includes(query) ||
        f.college_email?.toLowerCase().includes(query)
      );
      setFilteredFaculty(filtered);
    }
  }, [searchQuery, faculty]);

  const handleSelectFaculty = async (facultyMember) => {
    setSelectedFaculty(facultyMember);
    setProfileModal({ open: true, data: null, loading: true });
    try {
      const res = await axios.get(`/api/authorities/faculty/${facultyMember.id}/profile`);
      setProfileModal({ open: true, data: res.data, loading: false });
    } catch (err) {
      console.error('Failed to load profile:', err);
      setProfileModal({ open: true, data: { error: 'Failed to load profile data' }, loading: false });
    }
  };

  const closeProfileModal = () => {
    setProfileModal({ open: false, data: null, loading: false });
    setSelectedFaculty(null);
  };

  return (
    <div className="flex h-screen overflow-hidden bg-gray-50">
      {/* Left Sidebar - Faculty List */}
      <div className="w-80 bg-white border-r border-gray-200 flex flex-col">
        {/* Header */}
        <div className="p-4 border-b border-gray-200">
          <div className="flex items-center space-x-3 mb-4">
            <div className="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center">
              <Users className="w-5 h-5 text-blue-600" />
            </div>
            <div>
              <h2 className="text-lg font-bold text-gray-900">Faculty</h2>
              <p className="text-xs text-gray-500">{filteredFaculty.length} members</p>
            </div>
          </div>
          
          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search faculty..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>

        {/* Faculty List */}
        <div className="flex-1 overflow-y-auto">
          {error ? (
            <div className="p-4 text-center text-red-500 text-sm">{error}</div>
          ) : loading ? (
            <div className="p-4 text-center text-gray-500 text-sm">Loading...</div>
          ) : filteredFaculty.length === 0 ? (
            <div className="p-8 text-center">
              <Users className="w-12 h-12 text-gray-300 mx-auto mb-3" />
              <p className="text-sm text-gray-500">No faculty found</p>
            </div>
          ) : (
            <div className="divide-y divide-gray-100">
              {filteredFaculty.map(f => (
                <button
                  key={f.id}
                  onClick={() => handleSelectFaculty(f)}
                  className={`w-full p-4 text-left hover:bg-gray-50 transition-colors ${
                    selectedFaculty?.id === f.id ? 'bg-blue-50 border-l-4 border-blue-600' : ''
                  }`}
                >
                  <div className="flex items-start space-x-3">
                    <div className="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center text-white font-bold text-sm flex-shrink-0">
                      {f.first_name?.charAt(0)}{f.last_name?.charAt(0)}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-bold text-gray-900 truncate">
                        {f.first_name} {f.last_name}
                      </p>
                      <p className="text-xs text-gray-500 truncate">{f.employee_id}</p>
                      <p className="text-xs text-blue-600 truncate">{f.department_name}</p>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Right Content - Faculty Details */}
      <div className="flex-1 overflow-y-auto">
        {!selectedFaculty ? (
          <div className="flex items-center justify-center h-full">
            <div className="text-center">
              <Users className="w-16 h-16 text-gray-300 mx-auto mb-4" />
              <h3 className="text-lg font-bold text-gray-900 mb-2">Select a Faculty Member</h3>
              <p className="text-sm text-gray-500">Click on a faculty member to view their profile</p>
            </div>
          </div>
        ) : profileModal.loading ? (
          <div className="flex items-center justify-center h-full">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
        ) : profileModal.data?.error ? (
          <div className="p-8">
            <div className="bg-red-50 text-red-600 p-4 rounded-xl text-sm font-medium border border-red-100">
              {profileModal.data.error}
            </div>
          </div>
        ) : profileModal.data ? (
          <div className="p-8 max-w-4xl mx-auto">
            {/* Profile Header */}
            <div className="bg-gradient-to-br from-blue-50 to-blue-100/50 p-6 rounded-xl border border-blue-200 mb-6">
              <div className="flex items-center space-x-4">
                <div className="w-20 h-20 rounded-full bg-blue-600 flex items-center justify-center text-white font-bold text-2xl">
                  {profileModal.data.first_name?.charAt(0)}{profileModal.data.last_name?.charAt(0)}
                </div>
                <div className="flex-1">
                  <h2 className="text-2xl font-bold text-gray-900 mb-1">
                    {profileModal.data.first_name} {profileModal.data.last_name}
                  </h2>
                  <p className="text-blue-600 font-medium">{profileModal.data.designation || 'Faculty'}</p>
                  <p className="text-sm text-gray-600 mt-1">{profileModal.data.department_name}</p>
                </div>
              </div>
            </div>

            <div className="space-y-6">
              {/* Basic Info */}
              <div className="bg-white border border-gray-200 rounded-xl p-6">
                <h3 className="text-lg font-bold text-gray-900 mb-4">Basic Information</h3>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Employee ID</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.employee_id}</p>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Date of Joining</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.date_of_joining || 'N/A'}</p>
                  </div>
                </div>
              </div>

              {/* Contact Info */}
              <div className="bg-white border border-gray-200 rounded-xl p-6">
                <h3 className="text-lg font-bold text-gray-900 mb-4">Contact Information</h3>
                <div className="space-y-3">
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">College Email</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.college_email}</p>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Personal Email</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.personal_email || 'N/A'}</p>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Phone</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.phone || 'N/A'}</p>
                  </div>
                </div>
              </div>

              {/* Personal Info */}
              <div className="bg-white border border-gray-200 rounded-xl p-6">
                <h3 className="text-lg font-bold text-gray-900 mb-4">Personal Information</h3>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Gender</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.gender || 'N/A'}</p>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Date of Birth</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.date_of_birth || 'N/A'}</p>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Blood Group</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.blood_group || 'N/A'}</p>
                  </div>
                  <div>
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Qualification</p>
                    <p className="text-sm font-medium text-gray-900">{profileModal.data.highest_qualification || 'N/A'}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
};
