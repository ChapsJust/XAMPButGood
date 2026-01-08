# Contributing to XAMPP-Docker

Thank you for your interest in contributing to XAMPP-Docker! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project follows a simple code of conduct: be respectful, be inclusive, and focus on what's best for the community. We welcome contributors of all experience levels.

## Getting Started

### Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Git
- A code editor with YAML support

### Local Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/xampp-docker.git
cd xampp-docker

# Create environment file
cp .env.example .env

# Start services to verify everything works
docker compose up -d

# Verify all services are healthy
docker compose ps
```

## How to Contribute

### Reporting Bugs

Before submitting a bug report, please check existing [Issues](../../issues) to avoid duplicates.

When creating a bug report, include:

- Clear description of the problem
- Steps to reproduce the issue
- Expected vs actual behavior
- Your environment (OS, Docker version, etc.)
- Relevant logs (`docker compose logs <service>`)

### Suggesting Features

1. Open a [Discussion](../../discussions) to gather feedback
2. If the idea is well-received, create an issue with the `enhancement` label
3. Wait for maintainer approval before starting work

### Submitting Code

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test locally with `docker compose up -d`
5. Commit using conventional format (see below)
6. Push and open a Pull Request

## Development Workflow

### Project Structure

```
xampp-docker/
├── .github/
│   └── workflows/
│       └── validate.yml      # CI validation workflow
├── docker-compose.yml        # Service definitions
├── .env.example              # Configuration template
├── .env                      # Local config (gitignored)
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── LICENSE
└── Makefile                  # Development shortcuts
```

### Testing Changes

Always verify your changes work correctly:

```bash
# Validate docker-compose syntax
docker compose config --quiet

# Start services
docker compose up -d

# Check health status
docker compose ps

# View logs if issues occur
docker compose logs <service-name>

# Clean up
docker compose down -v
```

## Style Guidelines

### Docker Compose Services

Follow this template when adding or modifying services:

```yaml
service_name:
  image: image:version-tag # Always pin a specific version
  container_name: dev-service # Use "dev-" prefix
  restart: unless-stopped
  environment:
    VAR: ${VAR} # Reference .env variables
  ports:
    - "${PORT:-default}:internal" # Configurable with fallback
  volumes:
    - named_volume:/path # Use named volumes
  networks:
    - dev-network
  healthcheck: # Required for all database services
    test: ["CMD", "..."]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 30s
  deploy:
    resources:
      limits:
        memory: 256M # Set appropriate memory limits
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
```

### Naming Conventions

| Element    | Convention            | Example             |
| ---------- | --------------------- | ------------------- |
| Containers | `dev-{service}`       | `dev-postgres`      |
| Volumes    | `dev-{service}-data`  | `dev-postgres-data` |
| Variables  | `SERVICE_VARIABLE`    | `POSTGRES_USER`     |
| Branches   | `feature/description` | `feature/add-nginx` |

### Commit Messages

Use conventional commit format:

```
type: short description
```

**Types:**

- `feat:` New feature or service
- `fix:` Bug fix
- `docs:` Documentation changes
- `refactor:` Code changes without feature/fix
- `chore:` Maintenance tasks

**Examples:**

```
feat: add Nginx reverse proxy service
fix: resolve MySQL healthcheck timeout on Windows
docs: update connection strings in README
refactor: optimize PostgreSQL memory settings
```

## Pull Request Process

### Before Submitting

Ensure your PR meets these requirements:

- [ ] Code follows the style guidelines
- [ ] All services start successfully (`docker compose up -d`)
- [ ] Healthchecks pass (`docker compose ps` shows "healthy")
- [ ] New variables are added to `.env.example`
- [ ] README is updated if adding new services
- [ ] Commit messages follow conventional format

### Review Process

1. A maintainer will review your PR
2. CI checks must pass (syntax validation, service startup)
3. Address any requested changes
4. Once approved, a maintainer will merge your PR

### After Merging

Your contribution will be included in the next release. Thank you for helping improve XAMPP-Docker!

## Getting Help

- Open a [Discussion](../../discussions) for questions
- Check existing [Issues](../../issues) for known problems
- Review the [README](README.md) for usage documentation

---

Thank you for contributing! 🙏
