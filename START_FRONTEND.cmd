@echo off
echo ============================================
echo   Campus Connect - Starting Frontend
echo ============================================
echo.

cd /d "%~dp0frontend"

echo Starting development server...
echo Frontend will be available at: http://localhost:5173
echo.
echo Press Ctrl+C to stop the server
echo.

call npm run dev
