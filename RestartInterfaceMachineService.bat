@echo off

cd /d "%~dp0"

powershell.exe -ExecutionPolicy Bypass -File "RestartInterfaceMachineService.ps1" -DelaySeconds 5

pause