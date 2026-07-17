import React from 'react';
import { AlertCircle } from 'lucide-react';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null, errorInfo: null };
  }

  static getDerivedStateFromError(error) {
    // Update state so the next render will show the fallback UI.
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    // You can also log the error to an error reporting service
    console.error("ErrorBoundary caught an error", error, errorInfo);
    this.setState({ errorInfo });
  }

  render() {
    if (this.state.hasError) {
      // You can render any custom fallback UI
      return (
        <div className="flex items-center justify-center min-h-screen bg-gray-50 p-4">
          <div className="max-w-2xl w-full bg-white rounded-2xl shadow-xl overflow-hidden border border-red-100">
            <div className="bg-red-50 p-6 border-b border-red-100 flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center flex-shrink-0">
                <AlertCircle className="w-6 h-6 text-red-600" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-red-900">Something went wrong</h1>
                <p className="text-sm text-red-600 mt-1">A component in the application crashed.</p>
              </div>
            </div>
            
            <div className="p-6 overflow-auto max-h-[60vh] bg-gray-50">
              <div className="mb-4">
                <h3 className="font-semibold text-gray-900 mb-2">Error Message:</h3>
                <div className="bg-white p-4 rounded-lg border border-gray-200 text-red-600 font-mono text-sm whitespace-pre-wrap break-words">
                  {this.state.error && this.state.error.toString()}
                </div>
              </div>
              
              {this.state.errorInfo && (
                <div>
                  <h3 className="font-semibold text-gray-900 mb-2">Component Stack:</h3>
                  <div className="bg-gray-900 p-4 rounded-lg overflow-x-auto">
                    <pre className="text-gray-300 font-mono text-xs whitespace-pre-wrap">
                      {this.state.errorInfo.componentStack}
                    </pre>
                  </div>
                </div>
              )}
            </div>
            
            <div className="p-4 border-t border-gray-100 bg-white flex justify-end">
              <button 
                onClick={() => window.location.href = '/'}
                className="px-4 py-2 bg-[#0f172a] text-white rounded-lg text-sm font-medium hover:bg-gray-800 transition-colors"
              >
                Return to Dashboard
              </button>
            </div>
          </div>
        </div>
      );
    }

    return this.props.children; 
  }
}

export default ErrorBoundary;
