@echo off
REM Flamenco Manager Startup Script
REM Run this on your MANAGER machine (the one that coordinates renders)
REM Keep this window open — closing it stops the manager

echo ========================================
echo  FLAMENCO MANAGER - Starting up...
echo ========================================
echo.
echo Manager will be available at:
echo  http://localhost
echo  http://[YOUR-IP]
echo.
echo Keep this window open while rendering!
echo Press Ctrl+C to stop the manager.
echo.

REM CRITICAL: Must cd into the flamenco folder before running
REM This ensures Blender finds blend files in the correct location
cd /d C:\BlenderFarm\flamenco-3.9-windows-amd64

REM Start the manager
flamenco-manager.exe

pause
