@echo off
echo ============================================
echo   Campus Connect - Starting Backend
echo ============================================
echo.

cd /d "%~dp0backend"

echo Starting FastAPI server on network...
echo Backend API will be available on all network interfaces
echo Port: 8000
echo Docs available at: /docs
echo.
echo Press Ctrl+C to stop the server
echo.

call .\venv\Scripts\python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
