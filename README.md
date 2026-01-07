# 🐳 XAMPP-Docker

> A modern Docker-based replacement for XAMPP  
> Un remplacement moderne de XAMPP basé sur Docker

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)

## 🎯 Why This Project?

| XAMPP               | XAMPP-Docker                      |
| ------------------- | --------------------------------- |
| Heavy installation  | `docker compose up -d`            |
| One DB version only | Any version you want              |
| Hard to share       | Git clone = same setup everywhere |
| Port conflicts      | Configurable ports via `.env`     |
| Mixed data          | Isolated volumes per service      |

---

## 🛠 Stack

| Service        | Port  | Image                | Memory Limit |
| -------------- | ----- | -------------------- | ------------ |
| **PostgreSQL** | 5432  | `postgres:16-alpine` | 512 MB       |
| **MySQL**      | 3306  | `mysql:8.4`          | 512 MB       |
| **MongoDB**    | 27017 | `mongo:7.0`          | 512 MB       |
| **Redis**      | 6379  | `redis:7-alpine`     | 256 MB       |

### Optional Admin Interfaces

| Service             | Port | Description          |
| ------------------- | ---- | -------------------- |
| **Adminer**         | 8080 | SQL databases web UI |
| **Mongo Express**   | 8081 | MongoDB web UI       |
| **Redis Commander** | 8082 | Redis web UI         |
| **MailHog**         | 8025 | Email testing        |

---

## 🚀 Quick Start

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) or Docker Engine (Linux)
- Git

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/xampp-docker.git
cd xampp-docker

# 2. Copy config file
cp .env.example .env

# 3. Start databases
docker compose up -d

# 4. Check status
docker compose ps
```

✅ Done! Your databases are ready.

---

## 📖 Usage

### Start Services

```bash
# Databases only (PostgreSQL, MySQL, MongoDB, Redis)
docker compose up -d

# With admin web interfaces
docker compose --profile admin up -d

# Everything (databases + admin + MailHog)
docker compose --profile full up -d
```

### Stop Services

```bash
# Stop and remove containers (keeps data)
docker compose down

# Stop without removing
docker compose stop
```

### Start Only What You Need

```bash
# Only PostgreSQL
docker compose up -d postgres

# PostgreSQL + Redis
docker compose up -d postgres redis

# Stop one service
docker compose stop mysql
```

### View Logs

```bash
# All services
docker compose logs -f

# One service
docker compose logs -f postgres
```

---

## ⚙️ Configuration

Edit the `.env` file to customize:

```env
# PostgreSQL
POSTGRES_USER=devuser
POSTGRES_PASSWORD=devpass123
POSTGRES_DB=devdb
POSTGRES_PORT=5432

# MySQL
MYSQL_ROOT_PASSWORD=rootpass123
MYSQL_DATABASE=devdb
MYSQL_USER=devuser
MYSQL_PASSWORD=devpass123
MYSQL_PORT=3306

# MongoDB
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=mongopass123
MONGO_DB=devdb
MONGO_PORT=27017

# Redis
REDIS_PASSWORD=redispass123
REDIS_PORT=6379
```

### Port Conflict?

Change the port in `.env`:

```env
POSTGRES_PORT=5433
```

Then restart: `docker compose up -d postgres`

---

## 🔌 Connect to Databases

### Connection Info

| Service    | Host        | Port    | User      | Password       | Database |
| ---------- | ----------- | ------- | --------- | -------------- | -------- |
| PostgreSQL | `localhost` | `5432`  | `devuser` | `devpass123`   | `devdb`  |
| MySQL      | `localhost` | `3306`  | `devuser` | `devpass123`   | `devdb`  |
| MongoDB    | `localhost` | `27017` | `admin`   | `mongopass123` | `admin`  |
| Redis      | `localhost` | `6379`  | -         | `redispass123` | -        |

### Connection Strings

**PostgreSQL:**

```
Host=localhost;Port=5432;Database=devdb;Username=devuser;Password=devpass123
```

**MySQL:**

```
Server=localhost;Port=3306;Database=devdb;User=devuser;Password=devpass123
```

**MongoDB:**

```
mongodb://admin:mongopass123@localhost:27017/devdb?authSource=admin
```

**Redis:**

```
localhost:6379,password=redispass123
```

### From Another Docker Container

Use service names instead of `localhost`:

```
Host=postgres;Port=5432;Database=devdb;...
Host=mysql;Port=3306;Database=devdb;...
```

---

## 🛠 Useful Commands

### Access Database CLI

```bash
# PostgreSQL
docker exec -it dev-postgres psql -U devuser -d devdb

# MySQL
docker exec -it dev-mysql mysql -u devuser -p devdb

# MongoDB
docker exec -it dev-mongodb mongosh -u admin -p mongopass123

# Redis
docker exec -it dev-redis redis-cli -a redispass123
```

### Create a New Database

```bash
# PostgreSQL
docker exec -it dev-postgres psql -U devuser -c "CREATE DATABASE myproject;"

# MySQL
docker exec -it dev-mysql mysql -u root -prootpass123 -e "CREATE DATABASE myproject;"
```

### Reset Everything (⚠️ Deletes All Data)

```bash
docker compose down -v
docker compose up -d
```

### Clean Up Docker

```bash
# Remove stopped containers and unused images
docker system prune -a

# Nuclear option - removes EVERYTHING
docker system prune -a --volumes
```

---

## 🌐 Web Interfaces

Start with `docker compose --profile admin up -d` then open:

| Interface       | URL                   | Use For                       |
| --------------- | --------------------- | ----------------------------- |
| Adminer         | http://localhost:8080 | PostgreSQL & MySQL            |
| Mongo Express   | http://localhost:8081 | MongoDB                       |
| Redis Commander | http://localhost:8082 | Redis                         |
| MailHog         | http://localhost:8025 | Email testing (profile: full) |

---

## ❓ Troubleshooting

### Port Already in Use

```
Error: bind: address already in use
```

Change the port in `.env` and restart.

### Container Won't Start

```bash
# Check logs
docker compose logs postgres

# Check status
docker compose ps
```

### Windows: File Mounting Issues

Make sure Docker Desktop has access to your drive:  
Settings → Resources → File Sharing

### Full Reset

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📝 License

MIT - Use freely for personal and commercial projects.

---

**Made with ❤️ by the community** | [Issues](../../issues) | [Discussions](../../discussions)
