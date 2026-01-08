# XAMPP-Docker

A simple Docker-based local development environment. Modern alternative to XAMPP/WAMP.

## Quick Start

```bash
git clone https://github.com/ChapsJust/XAMPButGood.git
cd XAMPButGood
cp .env.example .env
docker compose up -d
```

That's it. Your databases are running.

---

## Services

| Service    | Port  | User    | Password     | Database |
| ---------- | ----- | ------- | ------------ | -------- |
| PostgreSQL | 5432  | devuser | devpass123   | devdb    |
| MySQL      | 3306  | devuser | devpass123   | devdb    |
| MongoDB    | 27017 | admin   | mongopass123 | -        |
| Redis      | 6379  | -       | redispass123 | -        |

Edit `.env` to change ports or passwords.

---

## CLI Tool (Optional)

The `devstack` CLI lets you quickly scaffold new projects with only the services you need.

### Installation

**Windows (PowerShell as Admin):**

```powershell
Invoke-WebRequest -Uri "https://github.com/ChapsJust/XAMPButGood/releases/latest/download/devstack-windows.exe" -OutFile "$env:LOCALAPPDATA\Microsoft\WindowsApps\devstack.exe"
```

**macOS:**

```bash
curl -L https://github.com/ChapsJust/XAMPButGood/releases/latest/download/devstack-darwin -o /usr/local/bin/devstack
chmod +x /usr/local/bin/devstack
```

**Linux:**

```bash
curl -L https://github.com/ChapsJust/XAMPButGood/releases/latest/download/devstack-linux -o /usr/local/bin/devstack
chmod +x /usr/local/bin/devstack
```

### CLI Commands

```bash
# Create a new project with specific services
devstack init postgres redis

# Add services to existing project
devstack add mysql mongodb

# List available services
devstack list

# Start/stop services
devstack up
devstack down

# Show running services
devstack ps
```

### Example Workflow

```bash
mkdir my-project && cd my-project
devstack init postgres redis    # Creates docker-compose.yml + .env
devstack up                     # Starts containers
# ... develop your app ...
devstack down                   # Stop when done
```

---

## Docker Commands

If you prefer using Docker directly:

```bash
docker compose up -d              # Start all services
docker compose up -d postgres     # Start only PostgreSQL
docker compose down               # Stop services
docker compose down -v            # Stop + delete data
docker compose ps                 # Show status
docker compose logs -f postgres   # View logs
```

---

## Connection Strings

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
mongodb://admin:mongopass123@localhost:27017/?authSource=admin
```

**Redis:**

```
localhost:6379,password=redispass123
```

### From Another Docker Container

Use service names instead of `localhost`:

```
Host=postgres;Port=5432;...
Host=mysql;Port=3306;...
```

---

## Database CLI Access

```bash
# PostgreSQL
docker exec -it dev-postgres psql -U devuser -d devdb

# MySQL
docker exec -it dev-mysql mysql -u devuser -pdevpass123 devdb

# MongoDB
docker exec -it dev-mongodb mongosh -u admin -p mongopass123

# Redis
docker exec -it dev-redis redis-cli -a redispass123
```

---

## Troubleshooting

**Port already in use:**  
Edit `.env`, change the port (e.g., `POSTGRES_PORT=5433`), then `docker compose up -d`

**Container won't start:**  
Check logs: `docker compose logs postgres`

**Reset everything:**

```bash
docker compose down -v
docker compose up -d
```

---

## License

MIT
