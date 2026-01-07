# =============================================================================
# XAMPP-Docker Makefile
# =============================================================================
# Usage: make [command]
# =============================================================================

.PHONY: help up down start stop restart logs ps clean reset

.DEFAULT_GOAL := help

# Colors
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RESET := \033[0m

# =============================================================================
# HELP
# =============================================================================

help:
	@echo ""
	@echo "$(CYAN)╔══════════════════════════════════════════════════════════════╗$(RESET)"
	@echo "$(CYAN)║              XAMPP-Docker - Commandes disponibles            ║$(RESET)"
	@echo "$(CYAN)╚══════════════════════════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(GREEN)Démarrage:$(RESET)"
	@echo "  make up              Démarrer les bases de données"
	@echo "  make up-admin        Démarrer avec interfaces web (Adminer, etc.)"
	@echo "  make up-full         Démarrer tout (DBs + Admin + MailHog)"
	@echo ""
	@echo "$(GREEN)Arrêt:$(RESET)"
	@echo "  make down            Arrêter et supprimer les containers"
	@echo "  make stop            Arrêter (garde les données)"
	@echo ""
	@echo "$(GREEN)Status & Logs:$(RESET)"
	@echo "  make ps              Voir le statut des services"
	@echo "  make logs            Voir tous les logs"
	@echo "  make logs-[service]  Logs d'un service (postgres, mysql, etc.)"
	@echo ""
	@echo "$(GREEN)Services individuels:$(RESET)"
	@echo "  make up-postgres     Démarrer PostgreSQL seulement"
	@echo "  make up-mysql        Démarrer MySQL seulement"
	@echo "  make up-mongodb      Démarrer MongoDB seulement"
	@echo "  make up-redis        Démarrer Redis seulement"
	@echo ""
	@echo "$(GREEN)Shells:$(RESET)"
	@echo "  make shell-postgres  Ouvrir psql"
	@echo "  make shell-mysql     Ouvrir mysql CLI"
	@echo "  make shell-mongodb   Ouvrir mongosh"
	@echo "  make shell-redis     Ouvrir redis-cli"
	@echo ""
	@echo "$(GREEN)Maintenance:$(RESET)"
	@echo "  make clean           Nettoyer Docker (containers/images orphelins)"
	@echo "  make reset           $(YELLOW)⚠️  Reset complet (supprime les données!)$(RESET)"
	@echo ""
	@echo "$(GREEN)URLs des interfaces web (avec make up-admin):$(RESET)"
	@echo "  Adminer:         http://localhost:8080"
	@echo "  Mongo Express:   http://localhost:8081"
	@echo "  Redis Commander: http://localhost:8082"
	@echo "  MailHog:         http://localhost:8025 (avec make up-full)"
	@echo ""

# =============================================================================
# MAIN COMMANDS
# =============================================================================

up:
	@docker compose up -d
	@echo ""
	@echo "$(GREEN)✅ Databases démarrées!$(RESET)"
	@echo ""
	@echo "Ports disponibles:"
	@echo "  PostgreSQL: localhost:5432"
	@echo "  MySQL:      localhost:3306"
	@echo "  MongoDB:    localhost:27017"
	@echo "  Redis:      localhost:6379"
	@echo ""
	@echo "Tip: Utilisez 'make up-admin' pour les interfaces web"

up-admin:
	@docker compose --profile admin up -d
	@echo ""
	@echo "$(GREEN)✅ Databases + Interfaces web démarrées!$(RESET)"
	@echo ""
	@echo "Interfaces web:"
	@echo "  Adminer:         http://localhost:8080"
	@echo "  Mongo Express:   http://localhost:8081"
	@echo "  Redis Commander: http://localhost:8082"

up-full:
	@docker compose --profile full up -d
	@echo ""
	@echo "$(GREEN)✅ Stack complète démarrée!$(RESET)"
	@echo ""
	@echo "Interfaces web:"
	@echo "  Adminer:         http://localhost:8080"
	@echo "  Mongo Express:   http://localhost:8081"
	@echo "  Redis Commander: http://localhost:8082"
	@echo "  MailHog:         http://localhost:8025 (SMTP: 1025)"

down:
	@docker compose --profile full down
	@echo "$(GREEN)✅ Tous les services arrêtés$(RESET)"

stop:
	@docker compose --profile full stop

start:
	@docker compose --profile full start

restart:
	@docker compose --profile full restart

logs:
	@docker compose logs -f

ps:
	@docker compose --profile full ps

clean:
	@docker system prune -f
	@echo "$(GREEN)✅ Nettoyage terminé$(RESET)"

reset:
	@echo "$(YELLOW)⚠️  ATTENTION: Cette action va supprimer TOUTES les données!$(RESET)"
	@read -p "Tapez 'reset' pour confirmer: " confirm && [ "$$confirm" = "reset" ] || (echo "Annulé." && exit 1)
	@docker compose --profile full down -v --remove-orphans
	@docker compose up -d
	@echo "$(GREEN)✅ Reset complet terminé$(RESET)"

# =============================================================================
# INDIVIDUAL SERVICES
# =============================================================================

up-postgres:
	@docker compose up -d postgres
	@echo "$(GREEN)✅ PostgreSQL démarré sur localhost:5432$(RESET)"

up-mysql:
	@docker compose up -d mysql
	@echo "$(GREEN)✅ MySQL démarré sur localhost:3306$(RESET)"

up-mongodb:
	@docker compose up -d mongodb
	@echo "$(GREEN)✅ MongoDB démarré sur localhost:27017$(RESET)"

up-redis:
	@docker compose up -d redis
	@echo "$(GREEN)✅ Redis démarré sur localhost:6379$(RESET)"

stop-postgres:
	@docker compose stop postgres

stop-mysql:
	@docker compose stop mysql

stop-mongodb:
	@docker compose stop mongodb

stop-redis:
	@docker compose stop redis

# =============================================================================
# SHELLS
# =============================================================================

shell-postgres:
	@docker exec -it dev-postgres psql -U $${POSTGRES_USER:-devuser} -d $${POSTGRES_DB:-devdb}

shell-mysql:
	@docker exec -it dev-mysql mysql -u $${MYSQL_USER:-devuser} -p $${MYSQL_DB:-devdb}

shell-mongodb:
	@docker exec -it dev-mongodb mongosh -u $${MONGO_ROOT_USERNAME:-admin} -p $${MONGO_ROOT_PASSWORD:-mongopass123} --authenticationDatabase admin

shell-redis:
	@docker exec -it dev-redis redis-cli -a $${REDIS_PASSWORD:-redispass123}

# =============================================================================
# LOGS
# =============================================================================

logs-postgres:
	@docker compose logs -f postgres

logs-mysql:
	@docker compose logs -f mysql

logs-mongodb:
	@docker compose logs -f mongodb

logs-redis:
	@docker compose logs -f redis

logs-adminer:
	@docker compose logs -f adminer

logs-mailhog:
	@docker compose logs -f mailhog

# =============================================================================
# DATABASE CREATION
# =============================================================================

create-db-postgres:
	@read -p "Nom de la database: " dbname && \
	docker exec -it dev-postgres psql -U $${POSTGRES_USER:-devuser} -c "CREATE DATABASE $$dbname;"
	@echo "$(GREEN)✅ Database créée$(RESET)"

create-db-mysql:
	@read -p "Nom de la database: " dbname && \
	docker exec -it dev-mysql mysql -u root -p$${MYSQL_ROOT_PASSWORD:-rootpass123} -e "CREATE DATABASE $$dbname;"
	@echo "$(GREEN)✅ Database créée$(RESET)"