@echo off
title Kilometre-Sante - Serveur local
cd /d "%~dp0"
echo.
echo  Kilometre-Sante demarre sur http://localhost:8080
echo  Fermez cette fenetre pour arreter le serveur.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\serve.ps1"
pause
