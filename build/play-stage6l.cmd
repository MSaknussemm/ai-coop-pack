@echo off
cd /d "%~dp0"
set TH07_MP_TEST_BOT=1
set TH07_MP_TEST_TITLE_BOT=1
set TH07_MP_TEST_START_STAGE=6
set TH07_MP_TEST_DIFFICULTY=3
set TH07_MP_BOT_P1=1
set TH07_MP_LOG=%~dp0mp_log.txt
set TH07_BOT_LOG=%~dp0bot_log.txt
echo Starting Stage 6 Lunatic: both seats bot
start "" "%~dp0th07_multi.exe"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0auto-local.ps1"
