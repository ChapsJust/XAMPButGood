@echo off
setlocal EnableDelayedExpansion

:: =============================================================================
:: Script de Backup - Environnement Docker Dev
:: =============================================================================
:: Usage: backup.bat [service]
::   service: postgres, mongodb, all (default)
:: =============================================================================

title Docker Dev Environment - Backup

:: Couleurs
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

:: Configuration
set SERVICE=%1
if "%SERVICE%"=="" set SERVICE=all

:: Timestamp pour les fichiers
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%

:: Créer le dossier de backup
set BACKUP_DIR=%~dp0..\backups\%TIMESTAMP%
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

echo.
echo %BLUE%========================================%RESET%
echo %BLUE%   Docker Dev Environment - Backup     %RESET%
echo %BLUE%========================================%RESET%
echo.
echo Dossier de backup: %BACKUP_DIR%
echo.

:: Vérifier que Docker est lancé
docker info >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERREUR] Docker n'est pas en cours d'execution!%RESET%
    pause
    exit /b 1
)

:: Charger les variables d'environnement
for /f "tokens=1,2 delims==" %%a in (%~dp0..\.env) do (
    set "%%a=%%b"
)

:: Backup PostgreSQL
if "%SERVICE%"=="postgres" goto :backup_postgres
if "%SERVICE%"=="all" goto :backup_postgres
goto :skip_postgres

:backup_postgres
echo %BLUE%[PostgreSQL] Backup en cours...%RESET%
docker exec dev-postgres pg_dump -U %POSTGRES_USER% -d %POSTGRES_DB% --format=custom --file=/tmp/backup.dump
if errorlevel 1 (
    echo %RED%[PostgreSQL] Echec du backup!%RESET%
    goto :skip_postgres
)
docker cp dev-postgres:/tmp/backup.dump "%BACKUP_DIR%\postgres_%POSTGRES_DB%.dump"
docker exec dev-postgres rm /tmp/backup.dump
echo %GREEN%[PostgreSQL] Backup termine: postgres_%POSTGRES_DB%.dump%RESET%

:skip_postgres

:: Backup MongoDB
if "%SERVICE%"=="mongodb" goto :backup_mongodb
if "%SERVICE%"=="all" goto :backup_mongodb
goto :skip_mongodb

:backup_mongodb
echo.
echo %BLUE%[MongoDB] Backup en cours...%RESET%
docker exec dev-mongodb mongodump --username=%MONGO_ROOT_USERNAME% --password=%MONGO_ROOT_PASSWORD% --authenticationDatabase=admin --out=/tmp/mongodump
if errorlevel 1 (
    echo %RED%[MongoDB] Echec du backup!%RESET%
    goto :skip_mongodb
)
docker cp dev-mongodb:/tmp/mongodump "%BACKUP_DIR%\mongodb"
docker exec dev-mongodb rm -rf /tmp/mongodump
echo %GREEN%[MongoDB] Backup termine: mongodb/%RESET%

:skip_mongodb

:: Résumé
echo.
echo %GREEN%========================================%RESET%
echo %GREEN%   Backup termine!                     %RESET%
echo %GREEN%========================================%RESET%
echo.
echo Fichiers sauvegardes dans:
echo   %BACKUP_DIR%
echo.
dir /b "%BACKUP_DIR%"
echo.

endlocal
