# 🐳 XAMPP-Docker

> Un remplacement moderne de XAMPP basé sur Docker  
> A modern Docker-based XAMPP replacement

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

## 📋 Table des matières

- [Pourquoi ce projet?](#-pourquoi-ce-projet)
- [Stack technique](#-stack-technique)
- [Installation rapide](#-installation-rapide)
- [Utilisation](#-utilisation)
- [Configuration](#-configuration)
- [Connexion aux bases de données](#-connexion-aux-bases-de-données)
- [Commandes utiles](#-commandes-utiles)
- [Contribuer](#-contribuer)
- [Roadmap](#-roadmap)

---

## 🎯 Pourquoi ce projet?

**XAMPP c'est bien, mais Docker c'est mieux:**

| XAMPP                    | XAMPP-Docker                     |
| ------------------------ | -------------------------------- |
| Installation lourde      | `docker compose up -d`           |
| Une seule version par DB | Toutes les versions disponibles  |
| Difficile à partager     | Un repo Git = même setup partout |
| Conflits de ports        | Ports configurables via `.env`   |
| Données mélangées        | Volumes isolés par service       |

---

## 🛠 Stack technique

| Service        | Port  | Image                  | Description                  |
| -------------- | ----- | ---------------------- | ---------------------------- |
| **PostgreSQL** | 5432  | `postgres:18.1-alpine` | Base relationnelle moderne   |
| **MySQL**      | 3306  | `mysql:9.3`            | Base relationnelle classique |
| **MongoDB**    | 27017 | `mongo:8.2`            | Base NoSQL documents         |
| **Redis**      | 6379  | `redis:8.4-alpine`     | Cache & sessions             |

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Docker Network (dev-network)                  │
│                                                                  │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐   │
│  │ PostgreSQL │ │   MySQL    │ │  MongoDB   │ │   Redis    │   │
│  │   :5432    │ │   :3306    │ │  :27017    │ │   :6379    │   │
│  └────────────┘ └────────────┘ └────────────┘ └────────────┘   │
│                                                                  │
└──────────┬─────────────┬─────────────┬─────────────┬────────────┘
           │             │             │             │
           ▼             ▼             ▼             ▼
      localhost     localhost     localhost     localhost
        :5432         :3306         :27017        :6379
           │             │             │             │
           └─────────────┴──────┬──────┴─────────────┘
                                │
                    ┌───────────┴───────────┐
                    │    Votre machine      │
                    │  DBeaver / VS Code    │
                    │  .NET / Node / PHP    │
                    └───────────────────────┘
```

---

## 🚀 Installation rapide

### Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) ou Docker Engine (Linux)
- Git

### Installation

```bash
# 1. Cloner le repo
git clone https://github.com/VOTRE_USERNAME/xampp-docker.git
cd xampp-docker

# 2. Copier la configuration
cp .env.example .env

# 3. Lancer les services
docker compose up -d

# 4. Vérifier que tout tourne
docker compose ps
```

✅ C'est tout! Vos bases de données sont prêtes.

---

## 📖 Utilisation

### Démarrer/Arrêter

```bash
# Tout démarrer
docker compose up -d

# Tout arrêter
docker compose down

# Arrêter SANS supprimer les données
docker compose stop
```

### Démarrer seulement ce dont vous avez besoin

```bash
# Seulement PostgreSQL
docker compose up -d postgres

# PostgreSQL + Redis
docker compose up -d postgres redis

# Arrêter un service spécifique
docker compose stop mongodb
```

### Voir les logs

```bash
# Tous les services
docker compose logs -f

# Un service spécifique
docker compose logs -f mysql
```

---

## ⚙️ Configuration

### Variables d'environnement (.env)

```env
# PostgreSQL
POSTGRES_USER=devuser
POSTGRES_PASSWORD=devpass123!
POSTGRES_DB=devdb
POSTGRES_PORT=5432

# MySQL
MYSQL_ROOT_PASSWORD=rootpass123!
MYSQL_DATABASE=devdb
MYSQL_USER=devuser
MYSQL_PASSWORD=devpass123!
MYSQL_PORT=3306

# MongoDB
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=mongopass123!
MONGO_DB=devdb
MONGO_PORT=27017

# Redis
REDIS_PASSWORD=redispass123!
REDIS_PORT=6379
```

### Changer les ports (en cas de conflit)

Si le port 5432 est déjà utilisé:

```env
POSTGRES_PORT=5433
```

Puis relancez: `docker compose up -d postgres`

---

## 🔌 Connexion aux bases de données

### DBeaver / DataGrip / TablePlus

| Service    | Host        | Port    | User      | Password        | Database |
| ---------- | ----------- | ------- | --------- | --------------- | -------- |
| PostgreSQL | `localhost` | `5432`  | `devuser` | `devpass123!`   | `devdb`  |
| MySQL      | `localhost` | `3306`  | `devuser` | `devpass123!`   | `devdb`  |
| MongoDB    | `localhost` | `27017` | `admin`   | `mongopass123!` | `admin`  |
| Redis      | `localhost` | `6379`  | -         | `redispass123!` | -        |

### Connection Strings

**PostgreSQL:**

```
Host=localhost;Port=5432;Database=devdb;Username=devuser;Password=devpass123!
```

**MySQL:**

```
Server=localhost;Port=3306;Database=devdb;User=devuser;Password=devpass123!
```

**MongoDB:**

```
mongodb://admin:mongopass123!@localhost:27017/devdb?authSource=admin
```

**Redis:**

```
localhost:6379,password=redispass123!
```

### Depuis un autre container Docker

Utilisez les noms de service au lieu de `localhost`:

```
Host=postgres;Port=5432;Database=devdb;...
Host=mysql;Port=3306;Database=devdb;...
```

---

## 🛠 Commandes utiles

### Accès direct aux bases

```bash
# PostgreSQL
docker exec -it dev-postgres psql -U devuser -d devdb

# MySQL
docker exec -it dev-mysql mysql -u devuser -p devdb

# MongoDB
docker exec -it dev-mongodb mongosh -u admin -p mongopass123!

# Redis
docker exec -it dev-redis redis-cli -a redispass123!
```

### Créer une nouvelle base de données

```bash
# PostgreSQL
docker exec -it dev-postgres psql -U devuser -c "CREATE DATABASE nouveau_projet;"

# MySQL
docker exec -it dev-mysql mysql -u root -prootpass123! -e "CREATE DATABASE nouveau_projet;"
```

### Reset complet (ATTENTION: supprime toutes les données)

```bash
docker compose down -v
docker compose up -d
```

### Nettoyage Docker

```bash
# Supprimer les containers arrêtés
docker container prune

# Supprimer les images non utilisées
docker image prune

# Nettoyage complet (attention!)
docker system prune -a --volumes
```

---

## 🤝 Contribuer

Les contributions sont les bienvenues! Ce projet est conçu pour apprendre Docker ensemble.

### Comment contribuer

1. **Fork** le repo
2. **Clone** votre fork: `git clone <>`
3. **Créez une branche**: `git checkout -b feature/ma-feature`
4. **Committez**: `git commit -m "Add: ma nouvelle feature"`
5. **Push**: `git push origin feature/ma-feature`
6. **Ouvrez une Pull Request**

### Idées de contributions

- 🐛 Corriger des bugs
- 📝 Améliorer la documentation
- 🌍 Traduire en d'autres langues
- ➕ Ajouter de nouveaux services (voir Roadmap)
- 🧪 Ajouter des scripts utiles
- 🎨 Améliorer les scripts existants

### Guidelines

- Gardez les choses simples (KISS)
- Documentez vos changements
- Testez sur Windows ET Linux si possible

## ❓ Troubleshooting

### Port déjà utilisé

```
Error: bind: address already in use
```

**Solution:** Changez le port dans `.env`:

```env
POSTGRES_PORT=5433
```

### Container ne démarre pas

```bash
# Voir les logs
docker compose logs postgres

# Vérifier le statut
docker compose ps
```

### Réinitialiser complètement

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

### Windows: problème de montage de fichiers

Si vous avez des erreurs de montage, vérifiez que Docker Desktop a accès à votre disque dans Settings > Resources > File Sharing.

---

## 📝 License

MIT - Utilisez librement pour vos projets personnels et professionnels.

---

**Maintenu par la communauté** | [Issues](../../issues) | [Discussions](../../discussions)
