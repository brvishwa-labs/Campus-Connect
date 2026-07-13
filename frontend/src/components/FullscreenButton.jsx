import React, { useState, useEffect } from 'react';
import { Maximize, Minimize } from 'lucide-react';

const FullscreenButton = () => {
  const [isFullscreen, setIsFullscreen] = useState(false);
  const [isStandalone, setIsStandalone] = useState(false);

  useEffect(() => {
    // Check if the app is already running as an installed PWA (no browser UI)
    const checkStandalone = () => {
      return window.matchMedia('(display-mode: standalone)').matches || 
             window.matchMedia('(display-mode: fullscreen)').matches || 
             window.navigator.standalone;
    };
    
    setIsStandalone(checkStandalone());

    const handleFullscreenChange = () => {
      setIsFullscreen(!!document.fullscreenElement);
    };

    document.addEventListener('fullscreenchange', handleFullscreenChange);
    return () => document.removeEventListener('fullscreenchange', handleFullscreenChange);
  }, []);

  // If already installed and running as an app, we don't need this button
  if (isStandalone) return null;

  const toggleFullscreen = () => {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().catch(err => {
        console.error(`Error attempting to enable fullscreen: ${err.message}`);
      });
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      }
    }
  };

  return (
    <button
      onClick={toggleFullscreen}
      className="md:hidden fixed bottom-6 left-4 z-[9999] p-2.5 bg-gray-900/60 text-white rounded-full backdrop-blur-md shadow-lg active:scale-95 transition-transform border border-white/20"
      aria-label="Toggle Fullscreen"
      title="Enter Full Screen"
    >
      {isFullscreen ? <Minimize size={18} /> : <Maximize size={18} />}
    </button>
  );
};

export default FullscreenButton;
