# =============================================================================
# XAMPP-Docker Makefile
# =============================================================================
# Usage: make [command]
# =============================================================================

.PHONY: help up down start stop restart logs ps clean reset

# Default target
help:
	@echo ""
	@echo "XAMPP-Docker - Commandes disponibles:"
	@echo ""
	@echo "  make up        - Démarrer tous les services"
	@echo "  make down      - Arrêter et supprimer les containers"
	@echo "  make stop      - Arrêter les services (garde les données)"
	@echo "  make start     - Redémarrer les services arrêtés"
	@echo "  make restart   - Redémarrer tous les services"
	@echo "  make logs      - Voir les logs (Ctrl+C pour quitter)"
	@echo "  make ps        - Voir le statut des services"
	@echo "  make clean     - Nettoyer les ressources Docker inutilisées"
	@echo "  make reset     - ATTENTION: Reset complet (supprime les données)"
	@echo ""
	@echo "Services individuels:"
	@echo "  make up-postgres   - Démarrer PostgreSQL seulement"
	@echo "  make up-mysql      - Démarrer MySQL seulement"
	@echo "  make up-mongodb    - Démarrer MongoDB seulement"
	@echo "  make up-redis      - Démarrer Redis seulement"
	@echo ""
	@echo "Accès aux shells:"
	@echo "  make shell-postgres  - Shell PostgreSQL (psql)"
	@echo "  make shell-mysql     - Shell MySQL"
	@echo "  make shell-mongodb   - Shell MongoDB (mongosh)"
	@echo "  make shell-redis     - Shell Redis (redis-cli)"
	@echo ""

# =============================================================================
# Commandes principales
# =============================================================================

up:
	docker compose up -d
	@echo ""
	@echo "✅ Services démarrés! Utilisez 'make ps' pour vérifier."

down:
	docker compose down

stop:
	docker compose stop

start:
	docker compose start

restart:
	docker compose restart

logs:
	docker compose logs -f

ps:
	docker compose ps

clean:
	docker system prune -f
	@echo "✅ Nettoyage terminé!"

reset:
	@echo "⚠️  ATTENTION: Cette action va supprimer TOUTES les données!"
	@read -p "Êtes-vous sûr? (oui/non): " confirm && [ "$$confirm" = "oui" ] || exit 1
	docker compose down -v --remove-orphans
	docker compose up -d
	@echo "✅ Reset complet terminé!"

# =============================================================================
# Services individuels
# =============================================================================

up-postgres:
	docker compose up -d postgres
	@echo "✅ PostgreSQL démarré sur localhost:5432"

up-mysql:
	docker compose up -d mysql
	@echo "✅ MySQL démarré sur localhost:3306"

up-mongodb:
	docker compose up -d mongodb
	@echo "✅ MongoDB démarré sur localhost:27017"

up-redis:
	docker compose up -d redis
	@echo "✅ Redis démarré sur localhost:6379"

# =============================================================================
# Shells interactifs
# =============================================================================

shell-postgres:
	docker exec -it dev-postgres psql -U devuser -d devdb

shell-mysql:
	docker exec -it dev-mysql mysql -u devuser -p devdb

shell-mongodb:
	docker exec -it dev-mongodb mongosh -u admin -p mongopass123!

shell-redis:
	docker exec -it dev-redis redis-cli -a redispass123!

# =============================================================================
# Logs individuels
# =============================================================================

logs-postgres:
	docker compose logs -f postgres

logs-mysql:
	docker compose logs -f mysql

logs-mongodb:
	docker compose logs -f mongodb

logs-redis:
	docker compose logs -f redis
