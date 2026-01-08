# XAMPP-Docker

Docker-based local development databases. Simple alternative to XAMPP.

## Quick Start

```bash
git clone https://github.com/ChapsJust/XAMPButGood.git
cd XAMPButGood
cp .env.example .env
docker compose up -d
```

## Services

| Service    | Port  | User    | Password     | Database |
| ---------- | ----- | ------- | ------------ | -------- |
| PostgreSQL | 5432  | devuser | devpass123   | devdb    |
| MySQL      | 3306  | devuser | devpass123   | devdb    |
| MongoDB    | 27017 | admin   | mongopass123 | -        |
| Redis      | 6379  | -       | redispass123 | -        |

## Commands

```bash
docker compose up -d          # Start
docker compose down           # Stop
docker compose logs -f        # Logs
docker compose ps             # Status
```

## Connection Strings

```
# PostgreSQL
Host=localhost;Port=5432;Database=devdb;Username=devuser;Password=devpass123

# MySQL
Server=localhost;Port=3306;Database=devdb;User=devuser;Password=devpass123

# MongoDB
mongodb://admin:mongopass123@localhost:27017/?authSource=admin

# Redis
localhost:6379,password=redispass123
```

## Port Conflict?

Edit `.env`, change the port, restart.

## License

MIT - Use freely for personal and commercial projects.

---

**Made with ❤️ by the community** | [Issues](../../issues) | [Discussions](../../discussions)
