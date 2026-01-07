@echo off
setlocal EnableDelayedExpansion

:: =============================================================================
:: Script de Restore - Environnement Docker Dev
:: =============================================================================
:: Usage: restore.bat [backup_folder]
::   backup_folder: nom du dossier dans /backups (ex: 20240115_143022)
:: =============================================================================

title Docker Dev Environment - Restore

set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

set BACKUP_FOLDER=%1

echo.
echo %BLUE%========================================%RESET%
echo %BLUE%   Docker Dev Environment - Restore    %RESET%
echo %BLUE%========================================%RESET%
echo.

:: Vérifier les arguments
if "%BACKUP_FOLDER%"=="" (
    echo %YELLOW%Backups disponibles:%RESET%
    echo.
    dir /b "%~dp0..\backups" 2>nul || echo   Aucun backup trouve.
    echo.
    echo Usage: restore.bat [backup_folder]
    exit /b 1
)

set BACKUP_DIR=%~dp0..\backups\%BACKUP_FOLDER%
if not exist "%BACKUP_DIR%" (
    echo %RED%[ERREUR] Dossier de backup introuvable: %BACKUP_DIR%%RESET%
    exit /b 1
)

:: Charger les variables d'environnement
for /f "tokens=1,2 delims==" %%a in (%~dp0..\.env) do (
    set "%%a=%%b"
)

:: Confirmation
echo %YELLOW%[ATTENTION] Cette action va restaurer les donnees depuis:%RESET%
echo   %BACKUP_DIR%
echo.
echo %YELLOW%Les donnees actuelles seront ECRASEES!%RESET%
echo.
set /p CONFIRM="Continuer? (o/N): "
if /i not "!CONFIRM!"=="o" (
    echo.
    echo %YELLOW%Operation annulee.%RESET%
    exit /b 0
)

:: Restore PostgreSQL
if exist "%BACKUP_DIR%\postgres_%POSTGRES_DB%.dump" (
    echo.
    echo %BLUE%[PostgreSQL] Restauration en cours...%RESET%
    docker cp "%BACKUP_DIR%\postgres_%POSTGRES_DB%.dump" dev-postgres:/tmp/backup.dump
    docker exec dev-postgres pg_restore -U %POSTGRES_USER% -d %POSTGRES_DB% --clean --if-exists /tmp/backup.dump
    docker exec dev-postgres rm /tmp/backup.dump
    echo %GREEN%[PostgreSQL] Restauration terminee!%RESET%
)

:: Restore MongoDB
if exist "%BACKUP_DIR%\mongodb" (
    echo.
    echo %BLUE%[MongoDB] Restauration en cours...%RESET%
    docker cp "%BACKUP_DIR%\mongodb" dev-mongodb:/tmp/mongodump
    docker exec dev-mongodb mongorestore --username=%MONGO_ROOT_USERNAME% --password=%MONGO_ROOT_PASSWORD% --authenticationDatabase=admin --drop /tmp/mongodump
    docker exec dev-mongodb rm -rf /tmp/mongodump
    echo %GREEN%[MongoDB] Restauration terminee!%RESET%
)

echo.
echo %GREEN%========================================%RESET%
echo %GREEN%   Restauration terminee!              %RESET%
echo %GREEN%========================================%RESET%
echo.

endlocal
