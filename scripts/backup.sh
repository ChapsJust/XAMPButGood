#!/bin/bash

# =============================================================================
# Script de Backup - Environnement Docker Dev
# =============================================================================
# Usage: ./backup.sh [service]
#   service: postgres, mongodb, all (default)
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SERVICE=${1:-all}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Se placer dans le bon répertoire
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Créer le dossier de backup
BACKUP_DIR="./backups/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Docker Dev Environment - Backup     ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Dossier de backup: $BACKUP_DIR"
echo ""

# Vérifier que Docker est lancé
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}[ERREUR] Docker n'est pas en cours d'exécution!${NC}"
    exit 1
fi

# Charger les variables d'environnement
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Backup PostgreSQL
backup_postgres() {
    echo -e "${BLUE}[PostgreSQL] Backup en cours...${NC}"
    if docker exec dev-postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --format=custom --file=/tmp/backup.dump 2>/dev/null; then
        docker cp dev-postgres:/tmp/backup.dump "$BACKUP_DIR/postgres_${POSTGRES_DB}.dump"
        docker exec dev-postgres rm /tmp/backup.dump
        echo -e "${GREEN}[PostgreSQL] Backup terminé: postgres_${POSTGRES_DB}.dump${NC}"
    else
        echo -e "${RED}[PostgreSQL] Échec du backup (container non disponible?)${NC}"
    fi
}

# Backup MongoDB
backup_mongodb() {
    echo -e "${BLUE}[MongoDB] Backup en cours...${NC}"
    if docker exec dev-mongodb mongodump --username="$MONGO_ROOT_USERNAME" --password="$MONGO_ROOT_PASSWORD" --authenticationDatabase=admin --out=/tmp/mongodump 2>/dev/null; then
        docker cp dev-mongodb:/tmp/mongodump "$BACKUP_DIR/mongodb"
        docker exec dev-mongodb rm -rf /tmp/mongodump
        echo -e "${GREEN}[MongoDB] Backup terminé: mongodb/${NC}"
    else
        echo -e "${RED}[MongoDB] Échec du backup (container non disponible?)${NC}"
    fi
}

# Exécuter les backups selon le service demandé
case $SERVICE in
    postgres)
        backup_postgres
        ;;
    mongodb)
        backup_mongodb
        ;;
    all)
        backup_postgres
        echo ""
        backup_mongodb
        ;;
    *)
        echo -e "${RED}Service inconnu: $SERVICE${NC}"
        echo "Usage: ./backup.sh [postgres|mongodb|all]"
        exit 1
        ;;
esac

# Résumé
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Backup terminé!                     ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Fichiers sauvegardés dans:"
echo "  $BACKUP_DIR"
echo ""
ls -la "$BACKUP_DIR"
echo ""
