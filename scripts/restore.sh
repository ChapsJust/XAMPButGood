#!/bin/bash

# =============================================================================
# Script de Restore - Environnement Docker Dev
# =============================================================================
# Usage: ./restore.sh [backup_folder]
#   backup_folder: nom du dossier dans /backups (ex: 20240115_143022)
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BACKUP_FOLDER=$1

# Se placer dans le bon répertoire
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Docker Dev Environment - Restore    ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Vérifier les arguments
if [ -z "$BACKUP_FOLDER" ]; then
    echo -e "${YELLOW}Backups disponibles:${NC}"
    echo ""
    ls -1 ./backups 2>/dev/null || echo "  Aucun backup trouvé."
    echo ""
    echo "Usage: ./restore.sh [backup_folder]"
    exit 1
fi

BACKUP_DIR="./backups/$BACKUP_FOLDER"
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}[ERREUR] Dossier de backup introuvable: $BACKUP_DIR${NC}"
    exit 1
fi

# Charger les variables d'environnement
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Confirmation
echo -e "${YELLOW}[ATTENTION] Cette action va restaurer les données depuis:${NC}"
echo "  $BACKUP_DIR"
echo ""
echo -e "${YELLOW}Les données actuelles seront ÉCRASÉES!${NC}"
echo ""
read -p "Continuer? (o/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[oOyY]$ ]]; then
    echo ""
    echo -e "${YELLOW}Opération annulée.${NC}"
    exit 0
fi

# Restore PostgreSQL
if [ -f "$BACKUP_DIR/postgres_${POSTGRES_DB}.dump" ]; then
    echo ""
    echo -e "${BLUE}[PostgreSQL] Restauration en cours...${NC}"
    docker cp "$BACKUP_DIR/postgres_${POSTGRES_DB}.dump" dev-postgres:/tmp/backup.dump
    docker exec dev-postgres pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists /tmp/backup.dump || true
    docker exec dev-postgres rm /tmp/backup.dump
    echo -e "${GREEN}[PostgreSQL] Restauration terminée!${NC}"
fi

# Restore MongoDB
if [ -d "$BACKUP_DIR/mongodb" ]; then
    echo ""
    echo -e "${BLUE}[MongoDB] Restauration en cours...${NC}"
    docker cp "$BACKUP_DIR/mongodb" dev-mongodb:/tmp/mongodump
    docker exec dev-mongodb mongorestore --username="$MONGO_ROOT_USERNAME" --password="$MONGO_ROOT_PASSWORD" --authenticationDatabase=admin --drop /tmp/mongodump
    docker exec dev-mongodb rm -rf /tmp/mongodump
    echo -e "${GREEN}[MongoDB] Restauration terminée!${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Restauration terminée!              ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
