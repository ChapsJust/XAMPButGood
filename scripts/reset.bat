@echo off
setlocal EnableDelayedExpansion

:: =============================================================================
:: Script de Reset - Environnement Docker Dev
:: =============================================================================
:: Usage: reset.bat [--force] [--volumes-only]
::   --force        : Pas de confirmation
::   --volumes-only : Supprime uniquement les volumes (garde les images)
:: =============================================================================

title Docker Dev Environment - Reset

:: Couleurs (codes ANSI)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

:: Parse arguments
set FORCE=0
set VOLUMES_ONLY=0
for %%a in (%*) do (
    if "%%a"=="--force" set FORCE=1
    if "%%a"=="--volumes-only" set VOLUMES_ONLY=1
)

:: Header
echo.
echo %BLUE%========================================%RESET%
echo %BLUE%   Docker Dev Environment - Reset      %RESET%
echo %BLUE%========================================%RESET%
echo.

:: Vérifier que Docker est lancé
docker info >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERREUR] Docker n'est pas en cours d'execution!%RESET%
    echo Veuillez demarrer Docker Desktop et reessayer.
    pause
    exit /b 1
)

:: Confirmation
if %FORCE%==0 (
    echo %YELLOW%[ATTENTION] Cette action va:%RESET%
    echo   - Arreter tous les containers du projet
    echo   - Supprimer tous les volumes ^(PERTE DE DONNEES^)
    echo   - Redemarrer les services proprement
    echo.
    set /p CONFIRM="Continuer? (o/N): "
    if /i not "!CONFIRM!"=="o" (
        echo.
        echo %YELLOW%Operation annulee.%RESET%
        exit /b 0
    )
)

echo.
echo %BLUE%[1/5] Arret des containers...%RESET%
docker-compose down --remove-orphans
if errorlevel 1 (
    echo %YELLOW%[WARN] Certains containers n'etaient pas en cours d'execution%RESET%
)

echo.
echo %BLUE%[2/5] Suppression des volumes...%RESET%
docker volume rm dev-postgres-data dev-mongodb-data dev-mongodb-config dev-redis-data dev-sqlserver-data 2>nul
if errorlevel 1 (
    echo %YELLOW%[WARN] Certains volumes n'existaient pas%RESET%
)

if %VOLUMES_ONLY%==1 (
    echo.
    echo %GREEN%[OK] Volumes supprimes. Utilisez 'docker-compose up -d' pour redemarrer.%RESET%
    exit /b 0
)

echo.
echo %BLUE%[3/5] Nettoyage des ressources orphelines...%RESET%
docker network prune -f >nul 2>&1

echo.
echo %BLUE%[4/5] Recreation des services...%RESET%
docker-compose up -d

echo.
echo %BLUE%[5/5] Verification de la sante des services...%RESET%
timeout /t 10 /nobreak >nul
docker-compose ps

echo.
echo %GREEN%========================================%RESET%
echo %GREEN%   Reset termine avec succes!          %RESET%
echo %GREEN%========================================%RESET%
echo.
echo Les services sont accessibles sur:
echo   - PostgreSQL : localhost:5432
echo   - MongoDB    : localhost:27017
echo   - Redis      : localhost:6379
echo.
echo Pour SQL Server: docker-compose --profile sqlserver up -d
echo.

endlocal
