@echo off
title Tidy Suite
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start Tidy Suite.ps1" %*
if errorlevel 1 (
  echo.
  echo The Tidy Suite launcher stopped. The message above says why.
  pause
)
