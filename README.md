# 🐳 Docker Dev Environment

> Environnement de développement Docker local pour backend C#/.NET  
> Local Docker development environment for C#/.NET backend

## 📋 Table des matières / Table of Contents

- [Vue d'ensemble / Overview](#-vue-densemble--overview)
- [Prérequis / Prerequisites](#-prérequis--prerequisites)
- [Installation rapide / Quick Start](#-installation-rapide--quick-start)
- [Services disponibles / Available Services](#-services-disponibles--available-services)
- [Configuration](#-configuration)
- [Connexion DBeaver](#-connexion-dbeaver)
- [Connexion depuis .NET](#-connexion-depuis-net)
- [Scripts de gestion / Management Scripts](#-scripts-de-gestion--management-scripts)
- [Commandes Docker utiles / Useful Docker Commands](#-commandes-docker-utiles--useful-docker-commands)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Vue d'ensemble / Overview

**FR:** Cet environnement remplace XAMPP pour le développement backend. Il fournit une stack de bases de données conteneurisées, facilement accessible via DBeaver ou depuis vos applications .NET.

**EN:** This environment replaces XAMPP for backend development. It provides a containerized database stack, easily accessible via DBeaver or from your .NET applications.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Network (dev-network)              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  PostgreSQL │  │   MongoDB   │  │    Redis    │         │
│  │   :5432     │  │   :27017    │  │   :6379     │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────┐  (optionnel/optional)                      │
│  │ SQL Server  │                                            │
│  │   :1433     │                                            │
│  └─────────────┘                                            │
└─────────────────────────────────────────────────────────────┘
         │                    │                  │
         ▼                    ▼                  ▼
    localhost:5432      localhost:27017    localhost:6379
         │                    │                  │
         ▼                    ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│                      Votre machine                          │
│         DBeaver / Visual Studio / .NET Applications         │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚙️ Prérequis / Prerequisites

- **Docker Desktop** (Windows/Mac) ou Docker Engine (Linux)
- **Docker Compose** v2.x (inclus dans Docker Desktop)
- **4 GB RAM minimum** (8 GB recommandé si SQL Server activé)

### Vérification / Verification

```bash
docker --version       # Docker version 24.x ou supérieur
docker compose version # Docker Compose version v2.x
```

---

## 🚀 Installation rapide / Quick Start

### 1. Cloner ou créer le projet

```bash
# Si vous avez cloné le repo
cd docker-dev-env

# Ou créer le dossier et copier les fichiers
```

### 2. Configurer l'environnement

```bash
# Windows
copy .env.example .env

# Linux/Mac
cp .env.example .env
```

Éditez `.env` avec vos valeurs (voir section [Configuration](#-configuration)).

### 3. Démarrer les services

```bash
# Démarrer PostgreSQL, MongoDB, Redis
docker compose up -d

# Avec SQL Server (nécessite plus de RAM)
docker compose --profile sqlserver up -d
```

### 4. Vérifier le statut

```bash
docker compose ps
```

✅ Tous les services devraient afficher `healthy` après quelques secondes.

---

## 📦 Services disponibles / Available Services

| Service    | Port  | Image                           | Description                    |
|------------|-------|--------------------------------|--------------------------------|
| PostgreSQL | 5432  | `postgres:16.4-alpine`         | Base relationnelle principale  |
| MongoDB    | 27017 | `mongo:7.0`                    | Base NoSQL documents           |
| Redis      | 6379  | `redis:7.4-alpine`             | Cache & sessions               |
| SQL Server | 1433  | `mssql/server:2022-latest`     | Optionnel - compatibilité MS   |

---

## 🔧 Configuration

### Variables d'environnement (.env)

```env
# PostgreSQL
POSTGRES_USER=devuser           # Utilisateur de la DB
POSTGRES_PASSWORD=devpass123!   # Mot de passe
POSTGRES_DB=devdb               # Nom de la base
POSTGRES_PORT=5432              # Port exposé

# MongoDB
MONGO_ROOT_USERNAME=admin       # Utilisateur root
MONGO_ROOT_PASSWORD=mongopass123!
MONGO_DB=devdb                  # Base par défaut
MONGO_PORT=27017

# Redis
REDIS_PASSWORD=redispass123!    # Mot de passe Redis
REDIS_PORT=6379

# SQL Server (optionnel)
MSSQL_SA_PASSWORD=SqlServer2024!  # Min 8 chars, complexité requise
MSSQL_PORT=1433
```

### Limites de ressources

Les limites sont configurées dans `docker-compose.yml`:

| Service    | Memory Limit | Memory Reserved |
|------------|-------------|-----------------|
| PostgreSQL | 512 MB      | 256 MB          |
| MongoDB    | 512 MB      | 256 MB          |
| Redis      | 256 MB      | 128 MB          |
| SQL Server | 2 GB        | 1 GB            |

---

## 🔌 Connexion DBeaver

### PostgreSQL

| Paramètre      | Valeur                     |
|----------------|----------------------------|
| Host           | `localhost`                |
| Port           | `5432`                     |
| Database       | `devdb` (ou votre valeur)  |
| Username       | `devuser` (ou votre valeur)|
| Password       | (votre mot de passe .env)  |

**Connection String:**
```
jdbc:postgresql://localhost:5432/devdb
```

### MongoDB

| Paramètre      | Valeur                     |
|----------------|----------------------------|
| Host           | `localhost`                |
| Port           | `27017`                    |
| Database       | `devdb`                    |
| Authentication | `admin` (authSource)       |
| Username       | `admin`                    |
| Password       | (votre mot de passe .env)  |

**Connection String:**
```
mongodb://admin:mongopass123!@localhost:27017/devdb?authSource=admin
```

### Redis

| Paramètre      | Valeur                     |
|----------------|----------------------------|
| Host           | `localhost`                |
| Port           | `6379`                     |
| Password       | (votre mot de passe .env)  |

> 💡 Pour Redis, utilisez Redis Insight ou Another Redis Desktop Manager

### SQL Server

| Paramètre      | Valeur                     |
|----------------|----------------------------|
| Host           | `localhost`                |
| Port           | `1433`                     |
| Username       | `sa`                       |
| Password       | (votre MSSQL_SA_PASSWORD)  |

**Connection String:**
```
jdbc:sqlserver://localhost:1433;encrypt=true;trustServerCertificate=true
```

---

## 💻 Connexion depuis .NET

### appsettings.json / appsettings.Development.json

```json
{
  "ConnectionStrings": {
    "PostgreSQL": "Host=localhost;Port=5432;Database=devdb;Username=devuser;Password=devpass123!",
    "MongoDB": "mongodb://admin:mongopass123!@localhost:27017/devdb?authSource=admin",
    "Redis": "localhost:6379,password=redispass123!",
    "SqlServer": "Server=localhost,1433;Database=master;User Id=sa;Password=SqlServer2024!;TrustServerCertificate=True"
  }
}
```

### Packages NuGet recommandés

```bash
# PostgreSQL
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL

# MongoDB
dotnet add package MongoDB.Driver

# Redis
dotnet add package StackExchange.Redis

# SQL Server
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
```

### Exemple de configuration (Program.cs)

```csharp
// PostgreSQL avec EF Core
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("PostgreSQL")));

// MongoDB
builder.Services.AddSingleton<IMongoClient>(sp =>
    new MongoClient(builder.Configuration.GetConnectionString("MongoDB")));

// Redis
builder.Services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = builder.Configuration.GetConnectionString("Redis");
});
```

### Connexion depuis un autre container Docker

Quand votre application .NET tourne aussi dans Docker, utilisez les noms de service au lieu de `localhost`:

```json
{
  "ConnectionStrings": {
    "PostgreSQL": "Host=postgres;Port=5432;Database=devdb;Username=devuser;Password=devpass123!",
    "MongoDB": "mongodb://admin:mongopass123!@mongodb:27017/devdb?authSource=admin",
    "Redis": "redis:6379,password=redispass123!",
    "SqlServer": "Server=sqlserver,1433;Database=master;User Id=sa;Password=SqlServer2024!;TrustServerCertificate=True"
  }
}
```

---

## 📜 Scripts de gestion / Management Scripts

### Reset complet (Windows)

```batch
scripts\reset.bat
scripts\reset.bat --force        # Sans confirmation
scripts\reset.bat --volumes-only # Supprime volumes seulement
```

### Reset complet (Linux/Mac)

```bash
chmod +x scripts/*.sh  # Première fois seulement
./scripts/reset.sh
./scripts/reset.sh --force
```

### Backup

```batch
# Windows
scripts\backup.bat              # Backup tout
scripts\backup.bat postgres     # PostgreSQL seulement
scripts\backup.bat mongodb      # MongoDB seulement
```

```bash
# Linux/Mac
./scripts/backup.sh
./scripts/backup.sh postgres
./scripts/backup.sh mongodb
```

Les backups sont sauvegardés dans `backups/YYYYMMDD_HHMMSS/`.

### Restore

```batch
# Windows - Liste les backups disponibles
scripts\restore.bat

# Restaurer un backup spécifique
scripts\restore.bat 20240115_143022
```

```bash
# Linux/Mac
./scripts/restore.sh
./scripts/restore.sh 20240115_143022
```

---

## 🛠 Commandes Docker utiles / Useful Docker Commands

### Gestion des services

```bash
# Démarrer
docker compose up -d

# Arrêter
docker compose down

# Redémarrer un service
docker compose restart postgres

# Voir les logs
docker compose logs -f              # Tous les services
docker compose logs -f postgres     # Un service spécifique

# Statut
docker compose ps
```

### Accès aux containers

```bash
# Shell PostgreSQL
docker exec -it dev-postgres psql -U devuser -d devdb

# Shell MongoDB
docker exec -it dev-mongodb mongosh -u admin -p mongopass123!

# Shell Redis
docker exec -it dev-redis redis-cli -a redispass123!

# Shell SQL Server
docker exec -it dev-sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "SqlServer2024!" -C
```

### Gestion des volumes

```bash
# Lister les volumes
docker volume ls

# Supprimer un volume spécifique
docker volume rm dev-postgres-data

# Supprimer tous les volumes du projet
docker compose down -v
```

### Nettoyage

```bash
# Supprimer containers arrêtés
docker container prune

# Supprimer images non utilisées
docker image prune

# Nettoyage complet (attention!)
docker system prune -a --volumes
```

---

## ❓ Troubleshooting

### Le container ne démarre pas

```bash
# Vérifier les logs
docker compose logs [service_name]

# Vérifier la santé
docker inspect --format='{{.State.Health.Status}}' dev-postgres
```

### Port déjà utilisé

```
Error: bind: address already in use
```

**Solution:** Changez le port dans `.env` ou arrêtez le service qui utilise ce port.

```bash
# Windows - Trouver le processus
netstat -ano | findstr :5432

# Linux/Mac
lsof -i :5432
```

### SQL Server ne démarre pas

**Erreur:** `sqlservr: This program requires a machine with at least 2000 megabytes of memory.`

**Solution:** 
1. Allouer plus de RAM à Docker Desktop (Settings > Resources)
2. Minimum 2 GB pour SQL Server

### MongoDB authentication failed

Vérifiez que vous utilisez `authSource=admin` dans la connection string:

```
mongodb://user:pass@localhost:27017/dbname?authSource=admin
```

### Réinitialiser complètement

```bash
# Arrêter et supprimer tout
docker compose down -v --remove-orphans

# Supprimer les images (optionnel)
docker compose down --rmi all

# Redémarrer proprement
docker compose up -d
```

### Vérifier les health checks

```bash
# Status de tous les services
docker compose ps

# Détails d'un service
docker inspect dev-postgres --format='{{json .State.Health}}' | jq
```

---

## 📁 Structure du projet

```
docker-dev-env/
├── docker-compose.yml      # Orchestration des services
├── .env                    # Configuration (non versionné)
├── .env.example            # Template de configuration
├── .gitignore              # Fichiers ignorés par Git
├── README.md               # Cette documentation
├── backups/                # Sauvegardes (non versionné)
├── volumes/                # Données locales (non versionné)
└── scripts/
    ├── init/
    │   ├── postgres-init.sql   # Initialisation PostgreSQL
    │   └── mongo-init.js       # Initialisation MongoDB
    ├── backup.bat/.sh          # Script de sauvegarde
    ├── restore.bat/.sh         # Script de restauration
    └── reset.bat/.sh           # Script de réinitialisation
```

---

## 🔐 Sécurité

⚠️ **Cette configuration est pour le DÉVELOPPEMENT uniquement!**

Pour la production, modifiez:
- Utilisez des mots de passe forts et uniques
- Ne pas exposer les ports sur 0.0.0.0
- Activer TLS/SSL pour toutes les connexions
- Utiliser des secrets Docker ou un vault
- Configurer des utilisateurs avec privilèges limités

---

## 📝 License

MIT - Utilisez librement pour vos projets personnels et professionnels.

---

## 🤝 Contribution

Les PRs sont les bienvenues! Pour les changements majeurs, ouvrez d'abord une issue.
