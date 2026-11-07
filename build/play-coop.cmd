@echo off
cd /d "%~dp0"
set TH07_MP_TEST_BOT=1
set TH07_MP_LOG=%~dp0mp_log.txt
set TH07_BOT_LOG=%~dp0bot_log.txt
echo ============================================================
echo  P1 = YOU    P2 = BOT
echo  1) In the launcher, click "Start Game (local)" yourself.
echo  2) In the title menu, pick Start / difficulty / shot yourself.
echo  3) The bot only takes over P2 once the stage actually starts.
echo ============================================================
start "" "%~dp0th07_multi.exe"
