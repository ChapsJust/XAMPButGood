# 🐳 XAMPP-Docker

> A modern Docker-based replacement for XAMPP/DevilBox simpler  
> Un remplacement moderne de XAMPP/DevilBox basé sur Docker

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

| Service        | Port  | Image                  | Memory Limit |
| -------------- | ----- | ---------------------- | ------------ |
| **PostgreSQL** | 5432  | `postgres:18.1-alpine` | 256 MB       |
| **MySQL**      | 3306  | `mysql:9.3`            | 256 MB       |
| **MongoDB**    | 27017 | `mongo:8.2`            | 350 MB       |
| **Redis**      | 6379  | `redis:8.4-alpine`     | 128 MB       |

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
- Make (optional, see [Makefile section](#-makefile-shortcuts))

### Installation

```bash
git clone https://github.com/ChapsJust/XAMPButGood.git
cd XAMPButGood

cp .env.example .env

docker compose up -d

docker compose ps
```

Done!

---

## ⚡ Makefile Shortcuts

This project includes a Makefile for common commands. Much faster than typing full Docker commands!

### Install Make (Windows)

```bash
# Using Chocolatey
choco install make

# Using winget
winget install GnuWin32.Make
```

Make is pre-installed on Mac and Linux.

### Available Commands

```bash
make help      # Show all available commands
```

| Command              | Description                                    |
| -------------------- | ---------------------------------------------- |
| `make up`            | Start databases only                           |
| `make admin`         | Start databases + admin web interfaces         |
| `make full`          | Start everything (databases + admin + MailHog) |
| `make down`          | Stop and remove containers                     |
| `make stop`          | Stop without removing                          |
| `make restart`       | Restart all services                           |
| `make ps`            | Show container status                          |
| `make logs`          | View all logs (follow mode)                    |
| `make logs-postgres` | View PostgreSQL logs only                      |
| `make health`        | Check health status of all services            |
| `make clean`         | Remove containers + volumes                    |
| `make reset`         | Full reset (containers + volumes + images)     |
| `make validate`      | Validate docker-compose.yml syntax             |

### Database CLI Access

```bash
make shell-postgres   # Open psql
make shell-mysql      # Open MySQL CLI
make shell-mongo      # Open mongosh
make shell-redis      # Open redis-cli
```

---

## 📖 Usage (Without Make)

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
# Stop without removing
docker compose stop

# Stop and remove containers
docker compose --profile full down

# Erase all containers + volumes
docker compose --profile full down -v

# Erase all containers + volumes + images (Fresh Restart)
docker compose --profile full down -v --rmi all
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

Edit the `.env` file to customize ports, passwords, and database names.

### Port Conflict?

Change the port in `.env`:

```env
POSTGRES_PORT=5433
```

Then restart: `docker compose up -d postgres` or `make up`

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

Or with Make: `make shell-postgres`, `make shell-mysql`, etc.

### Create a New Database

```bash
# PostgreSQL
docker exec -it dev-postgres psql -U devuser -c "CREATE DATABASE myproject;"

# MySQL
docker exec -it dev-mysql mysql -u root -prootpass123 -e "CREATE DATABASE myproject;"
```

### Reset Everything (Deletes All Data)

```bash
make reset
# or
docker compose --profile full down -v --rmi all
docker compose up -d
```

---

## 🌐 Web Interfaces

Start with `make admin` or `docker compose --profile admin up -d` then open:

| Interface       | URL                   | Use For                       |
| --------------- | --------------------- | ----------------------------- |
| Adminer         | http://localhost:8080 | PostgreSQL & MySQL            |
| Mongo Express   | http://localhost:8081 | MongoDB                       |
| Redis Commander | http://localhost:8082 | Redis                         |
| MailHog         | http://localhost:8025 | Email testing (profile: full) |

### MailHog Email Example (PowerShell)

```powershell
Send-MailMessage -From "test@test.com" -To "user@example.com" -Subject "Test Email" -Body "Hello from MailHog!" -SmtpServer "localhost" -Port 1025
```

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
# or
make logs-postgres

# Check status
docker compose ps
# or
make ps
```

### Network Issues After Reset

If you see `network not found` errors:

```bash
docker network prune -f
make full
```

### Windows: File Mounting Issues

Make sure Docker Desktop has access to your drive:  
Settings → Resources → File Sharing

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📝 License

MIT - Use freely for personal and commercial projects.

---

**Made with ❤️ by the community** | [Issues](../../issues) | [Discussions](../../discussions)
