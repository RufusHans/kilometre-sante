@echo off
chcp 65001 >nul
title Kilometre-Sante
cd /d "%~dp0"

echo.
echo  ========================================
echo   KILOMETRE-SANTE - Demarrage
echo  ========================================
echo.

REM Serveur dans une fenetre separee (reste visible en cas d'erreur)
start "Kilometre-Sante SERVEUR" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\serve.ps1"

echo  Attente du serveur (3 secondes)...
timeout /t 3 /nobreak >nul

REM Ouvrir le navigateur sur localhost (pas 127.0.0.1)
start "" "http://localhost:8080/"

echo.
echo  Le navigateur doit s'ouvrir sur http://localhost:8080/
echo.
echo  Si la page est vide ou blanche :
echo    1. Regardez la fenetre "Kilometre-Sante SERVEUR" (message vert = OK)
echo    2. Tapez MANUELLEMENT : http://localhost:8080/
echo    3. N'ouvrez PAS index.html par double-clic
echo.
echo  Pour arreter : fermez la fenetre SERVEUR.
echo.
pause
