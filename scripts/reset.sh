#!/bin/bash

# =============================================================================
# Script de Reset - Environnement Docker Dev
# =============================================================================
# Usage: ./reset.sh [--force] [--volumes-only]
#   --force        : Pas de confirmation
#   --volumes-only : Supprime uniquement les volumes (garde les images)
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
FORCE=0
VOLUMES_ONLY=0
for arg in "$@"; do
    case $arg in
        --force) FORCE=1 ;;
        --volumes-only) VOLUMES_ONLY=1 ;;
    esac
done

# Header
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Docker Dev Environment - Reset      ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Vérifier que Docker est lancé
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}[ERREUR] Docker n'est pas en cours d'exécution!${NC}"
    echo "Veuillez démarrer Docker et réessayer."
    exit 1
fi

# Se placer dans le bon répertoire
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Confirmation
if [ $FORCE -eq 0 ]; then
    echo -e "${YELLOW}[ATTENTION] Cette action va:${NC}"
    echo "  - Arrêter tous les containers du projet"
    echo "  - Supprimer tous les volumes (PERTE DE DONNÉES)"
    echo "  - Redémarrer les services proprement"
    echo ""
    read -p "Continuer? (o/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[oOyY]$ ]]; then
        echo ""
        echo -e "${YELLOW}Opération annulée.${NC}"
        exit 0
    fi
fi

echo ""
echo -e "${BLUE}[1/5] Arrêt des containers...${NC}"
docker-compose down --remove-orphans || true

echo ""
echo -e "${BLUE}[2/5] Suppression des volumes...${NC}"
docker volume rm dev-postgres-data dev-mongodb-data dev-mongodb-config dev-redis-data dev-sqlserver-data 2>/dev/null || true

if [ $VOLUMES_ONLY -eq 1 ]; then
    echo ""
    echo -e "${GREEN}[OK] Volumes supprimés. Utilisez 'docker-compose up -d' pour redémarrer.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}[3/5] Nettoyage des ressources orphelines...${NC}"
docker network prune -f > /dev/null 2>&1 || true

echo ""
echo -e "${BLUE}[4/5] Recréation des services...${NC}"
docker-compose up -d

echo ""
echo -e "${BLUE}[5/5] Vérification de la santé des services...${NC}"
sleep 10
docker-compose ps

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Reset terminé avec succès!          ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Les services sont accessibles sur:"
echo "  - PostgreSQL : localhost:5432"
echo "  - MongoDB    : localhost:27017"
echo "  - Redis      : localhost:6379"
echo ""
echo "Pour SQL Server: docker-compose --profile sqlserver up -d"
echo ""
