@echo off
echo ============================================
echo   Campus Connect - Install Dependencies
echo ============================================
echo.

cd /d "C:\Users\ADVANCED COMPUTING\Desktop\Campus-Connect\frontend"

echo [1/2] Installing frontend dependencies...
echo.
call npm install
echo.

if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Installation Complete!
echo ============================================
echo.
echo Dependencies installed successfully.
echo.
echo To start the frontend, run:
echo   npm run dev
echo.
echo Or double-click: START_FRONTEND.cmd
echo.
pause
