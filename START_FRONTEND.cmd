@echo off
echo ============================================
echo   Campus Connect - Starting Frontend
echo ============================================
echo.

cd /d "%~dp0frontend"

echo Starting development server on network...
echo Frontend will be exposed on your local IP address
echo.
echo Press Ctrl+C to stop the server
echo.

call npm run dev -- --host
