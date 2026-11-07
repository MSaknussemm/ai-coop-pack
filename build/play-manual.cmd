@echo off
cd /d "%~dp0"
set TH07_MP_TEST_BOT=1
set TH07_MP_LOG=%~dp0mp_log.txt
set TH07_BOT_LOG=%~dp0bot_log.txt
echo Starting Touhou 7 co-op: P1 = you, P2 = bot
echo Click "Start Game (local)" yourself and pick difficulty / shot.
start "" "%~dp0th07_multi.exe"
