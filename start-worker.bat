@echo off
REM Flamenco Worker Startup Script
REM Run this on BOTH machines (manager machine and worker machine)
REM Edit MANAGER_IP below before running

REM ========================================
REM EDIT THIS: Set your manager machine's IP
set MANAGER_IP=192.168.0.178
REM ========================================

echo ========================================
echo  FLAMENCO WORKER - Starting up...
echo ========================================
echo.
echo Connecting to manager at:
echo  http://%MANAGER_IP%
echo.
echo Keep this window open while rendering!
echo Press Ctrl+C to stop the worker.
echo.

REM CRITICAL: Must cd into BlenderFarm root so Blender
REM can find blend files using relative paths
cd /d C:\BlenderFarm

REM Start the worker pointing at the manager
C:\BlenderFarm\flamenco-3.9-windows-amd64\flamenco-worker.exe -manager http://%MANAGER_IP%

pause
