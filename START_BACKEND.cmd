@echo off
echo ============================================
echo   Campus Connect - Starting Backend
echo ============================================
echo.

cd /d "C:\Users\ADVANCED COMPUTING\Desktop\Campus-Connect\backend"

echo Starting FastAPI server...
echo Backend API will be available at: http://127.0.0.1:8000
echo Docs available at: http://127.0.0.1:8000/docs
echo.
echo Press Ctrl+C to stop the server
echo.

call uvicorn app.main:app --reload
