package templates

var Services = map[string]string{
	"postgres": `  postgres:
    image: postgres:16-alpine
    container_name: dev-postgres
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-devuser}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-devpass}
      POSTGRES_DB: ${POSTGRES_DB:-devdb}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
`,
	"mysql": `  mysql:
    image: mysql:8
    container_name: dev-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-rootpass}
      MYSQL_DATABASE: ${MYSQL_DATABASE:-devdb}
      MYSQL_USER: ${MYSQL_USER:-devuser}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD:-devpass}
    ports:
      - "${MYSQL_PORT:-3306}:3306"
    volumes:
      - mysql_data:/var/lib/mysql
`,
	"mongodb": `  mongodb:
    image: mongo:7
    container_name: dev-mongodb
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER:-admin}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-mongopass}
    ports:
      - "${MONGO_PORT:-27017}:27017"
    volumes:
      - mongodb_data:/data/db
`,
	"redis": `  redis:
    image: redis:7-alpine
    container_name: dev-redis
    ports:
      - "${REDIS_PORT:-6379}:6379"
    volumes:
      - redis_data:/data
`,
}

var Volumes = map[string]string{
	"postgres": "  postgres_data:\n",
	"mysql":    "  mysql_data:\n",
	"mongodb":  "  mongodb_data:\n",
	"redis":    "  redis_data:\n",
}

var EnvVars = map[string]string{
	"postgres": `# PostgreSQL
POSTGRES_USER=devuser
POSTGRES_PASSWORD=devpass
POSTGRES_DB=devdb
POSTGRES_PORT=5432
`,
	"mysql": `# MySQL
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=devdb
MYSQL_USER=devuser
MYSQL_PASSWORD=devpass
MYSQL_PORT=3306
`,
	"mongodb": `# MongoDB
MONGO_USER=admin
MONGO_PASSWORD=mongopass
MONGO_PORT=27017
`,
	"redis": `# Redis
REDIS_PORT=6379
`,
}