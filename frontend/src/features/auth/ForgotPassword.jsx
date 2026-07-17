import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, User, Mail, CheckCircle } from 'lucide-react';
import axios from 'axios';

export default function ForgotPassword() {
  const [step, setStep] = useState(1);
  const [email, setEmail] = useState('');
  
  // Fetched details
  const [role, setRole] = useState('');
  const [name, setName] = useState('');
  const [collegeId, setCollegeId] = useState('');
  const [department, setDepartment] = useState('');
  
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleLookup = async (e) => {
    e.preventDefault();
    if (!email) return;
    
    setIsSubmitting(true);
    setError(null);
    
    try {
      const res = await axios.get(`/api/auth/lookup-user?email=${encodeURIComponent(email)}`);
      setRole(res.data.role);
      setName(res.data.name);
      setCollegeId(res.data.college_id);
      setDepartment(res.data.department);
      setStep(2);
    } catch (err) {
      setError(err.response?.data?.detail || "User not found with this email address.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleSubmitRequest = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);
    
    try {
      await axios.post('/api/auth/forgot-password', {
        role,
        name,
        college_id: collegeId,
        department,
        email
      });
      setIsSuccess(true);
    } catch (err) {
      setError(err.response?.data?.detail || "An error occurred while submitting the request.");
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isSuccess) {
    return (
      <div className="min-h-screen w-full flex items-center justify-center bg-gray-50 relative font-sans p-4">
        <div className="w-full max-w-[440px] bg-white rounded-[24px] shadow-xl border border-gray-100 p-8 sm:p-10 relative z-20 text-center">
          <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
            <CheckCircle className="h-6 w-6 text-green-600" />
          </div>
          <h2 className="text-2xl font-bold text-gray-900 tracking-tight mb-2">Request Sent!</h2>
          <p className="text-[14px] text-gray-500 mb-8">
            The administrator has been notified of your password reset request. Please wait for them to process it and check your email.
          </p>
          <button
            onClick={() => navigate('/login')}
            className="w-full flex items-center justify-center px-4 py-3 border border-transparent rounded-xl shadow-sm text-[15px] font-semibold text-white bg-primary-600 hover:bg-primary-700 transition-all"
          >
            Back to login
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-gray-50 relative font-sans p-4">
      <div className="w-full max-w-[440px] bg-white rounded-[24px] shadow-xl border border-gray-100 p-8 sm:p-10 relative z-20">
        
        <button 
          onClick={() => step === 2 ? setStep(1) : navigate('/login')}
          className="flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors mb-6 group"
        >
          <ArrowLeft className="w-4 h-4 mr-1 group-hover:-translate-x-1 transition-transform" />
          {step === 2 ? 'Back to email entry' : 'Back to login'}
        </button>

        <div className="text-center mb-8">
          <h2 className="text-2xl font-bold text-gray-900 tracking-tight mb-2">
            Forgot Password
          </h2>
          <p className="text-[14px] text-gray-500">
            {step === 1 
              ? "Enter your email address to find your account." 
              : "Verify your details to request a password reset."}
          </p>
        </div>

        {error && (
          <div className="bg-red-50 text-red-600 p-3 rounded-xl text-sm font-medium border border-red-100 text-center mb-4">
            {error}
          </div>
        )}

        {step === 1 ? (
          <form className="space-y-4" onSubmit={handleLookup}>
            <div>
              <label className="block text-[13px] font-bold text-gray-700 mb-1.5">Email Address</label>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="block w-full px-4 py-3 text-[15px] border border-gray-200 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent bg-gray-50/50 transition-all outline-none"
                placeholder="e.g. user@svcet.edu"
              />
            </div>

            <div className="pt-2">
              <button
                type="submit"
                disabled={isSubmitting || !email}
                className="w-full flex items-center justify-center px-4 py-3 border border-transparent rounded-xl shadow-sm text-[15px] font-semibold text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all disabled:opacity-50"
              >
                {isSubmitting ? (
                  <div className="w-5 h-5 border-2 border-white/20 border-t-white rounded-full animate-spin"></div>
                ) : (
                  'Next'
                )}
              </button>
            </div>
          </form>
        ) : (
          <form className="space-y-4" onSubmit={handleSubmitRequest}>
            <div className="bg-gray-50/50 border border-gray-200 rounded-xl p-4 space-y-3">
              <div className="flex justify-between border-b border-gray-200 pb-2">
                <span className="text-xs font-bold text-gray-500 uppercase">Account Details</span>
                <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase ${
                  role === 'faculty' ? 'bg-indigo-100 text-indigo-700' : 'bg-blue-100 text-blue-700'
                }`}>
                  {role}
                </span>
              </div>
              
              <div>
                <p className="text-[11px] text-gray-500 font-semibold uppercase">Full Name</p>
                <p className="text-[15px] font-medium text-gray-900">{name || '-'}</p>
              </div>
              
              <div>
                <p className="text-[11px] text-gray-500 font-semibold uppercase">ID / Register Number</p>
                <p className="text-[15px] font-medium text-gray-900">{collegeId || '-'}</p>
              </div>
              
              <div>
                <p className="text-[11px] text-gray-500 font-semibold uppercase">Department</p>
                <p className="text-[15px] font-medium text-gray-900">{department || '-'}</p>
              </div>
              
              <div>
                <p className="text-[11px] text-gray-500 font-semibold uppercase">Email</p>
                <p className="text-[15px] font-medium text-gray-900">{email}</p>
              </div>
            </div>

            <div className="pt-2">
              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full flex items-center justify-center px-4 py-3 border border-transparent rounded-xl shadow-sm text-[15px] font-semibold text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-all disabled:opacity-50"
              >
                {isSubmitting ? (
                  <div className="w-5 h-5 border-2 border-white/20 border-t-white rounded-full animate-spin"></div>
                ) : (
                  <>
                    <Mail className="w-5 h-5 mr-2" />
                    Confirm & Send Request
                  </>
                )}
              </button>
            </div>
          </form>
        )}

      </div>
    </div>
  );
}
