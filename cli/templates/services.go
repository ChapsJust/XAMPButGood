package templates

// Updated January 2025 - Latest stable Docker image versions

var Services = map[string]string{
	// ==================== DATABASES ====================
	
	"postgres": `  postgres:
    image: postgres:18-alpine
    container_name: dev-postgres
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-devuser}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-devpass}
      POSTGRES_DB: ${POSTGRES_DB:-devdb}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-devuser}"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"mysql": `  mysql:
    image: mysql:9
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
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"mysql-lts": `  mysql:
    image: mysql:8.4
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
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"mariadb": `  mariadb:
    image: mariadb:12
    container_name: dev-mariadb
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD:-rootpass}
      MARIADB_DATABASE: ${MARIADB_DATABASE:-devdb}
      MARIADB_USER: ${MARIADB_USER:-devuser}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD:-devpass}
    ports:
      - "${MARIADB_PORT:-3306}:3306"
    volumes:
      - mariadb_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"mariadb-lts": `  mariadb:
    image: mariadb:11-lts
    container_name: dev-mariadb
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD:-rootpass}
      MARIADB_DATABASE: ${MARIADB_DATABASE:-devdb}
      MARIADB_USER: ${MARIADB_USER:-devuser}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD:-devpass}
    ports:
      - "${MARIADB_PORT:-3306}:3306"
    volumes:
      - mariadb_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"mongodb": `  mongodb:
    image: mongo:8
    container_name: dev-mongodb
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER:-admin}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-mongopass}
      MONGO_INITDB_DATABASE: ${MONGO_DATABASE:-devdb}
    ports:
      - "${MONGO_PORT:-27017}:27017"
    volumes:
      - mongodb_data:/data/db
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"redis": `  redis:
    image: redis:8-alpine
    container_name: dev-redis
    command: redis-server --appendonly yes
    ports:
      - "${REDIS_PORT:-6379}:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
`,
	"redis-password": `  redis:
    image: redis:8-alpine
    container_name: dev-redis
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD:-redispass}
    ports:
      - "${REDIS_PORT:-6379}:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD:-redispass}", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
`,

	// ==================== SEARCH ENGINES ====================
	
	"elasticsearch": `  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.17.0
    container_name: dev-elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "${ELASTICSEARCH_PORT:-9200}:9200"
      - "${ELASTICSEARCH_TRANSPORT_PORT:-9300}:9300"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    healthcheck:
      test: ["CMD-SHELL", "curl -s http://localhost:9200/_cluster/health | grep -vq '\"status\":\"red\"'"]
      interval: 20s
      timeout: 10s
      retries: 5
`,
	"meilisearch": `  meilisearch:
    image: getmeili/meilisearch:v1.12
    container_name: dev-meilisearch
    environment:
      MEILI_MASTER_KEY: ${MEILI_MASTER_KEY:-masterkey}
      MEILI_ENV: ${MEILI_ENV:-development}
    ports:
      - "${MEILISEARCH_PORT:-7700}:7700"
    volumes:
      - meilisearch_data:/meili_data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:7700/health"]
      interval: 10s
      timeout: 5s
      retries: 5
`,

	// ==================== MESSAGE BROKERS ====================
	
	"rabbitmq": `  rabbitmq:
    image: rabbitmq:4-management-alpine
    container_name: dev-rabbitmq
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER:-admin}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD:-adminpass}
    ports:
      - "${RABBITMQ_PORT:-5672}:5672"
      - "${RABBITMQ_MANAGEMENT_PORT:-15672}:15672"
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "check_running"]
      interval: 30s
      timeout: 10s
      retries: 5
`,
	"kafka": `  kafka:
    image: apache/kafka:4.1.1
    container_name: dev-kafka
    environment:
      KAFKA_NODE_ID: 1
      KAFKA_PROCESS_ROLES: broker,controller
      KAFKA_LISTENERS: PLAINTEXT://:9092,CONTROLLER://:9093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:${KAFKA_PORT:-9092}
      KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9093
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_LOG_DIRS: /tmp/kraft-combined-logs
      CLUSTER_ID: MkU3OEVBNTcwNTJENDM2Qk
    ports:
      - "${KAFKA_PORT:-9092}:9092"
    volumes:
      - kafka_data:/tmp/kraft-combined-logs
`,

	// ==================== GRAPH DATABASES ====================
	
	"neo4j": `  neo4j:
    image: neo4j:5-community
    container_name: dev-neo4j
    environment:
      NEO4J_AUTH: ${NEO4J_USER:-neo4j}/${NEO4J_PASSWORD:-password}
    ports:
      - "${NEO4J_HTTP_PORT:-7474}:7474"
      - "${NEO4J_BOLT_PORT:-7687}:7687"
    volumes:
      - neo4j_data:/data
      - neo4j_logs:/logs
    healthcheck:
      test: ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:7474 || exit 1"]
      interval: 15s
      timeout: 10s
      retries: 5
`,

	// ==================== TIME SERIES DATABASES ====================
	
	"influxdb": `  influxdb:
    image: influxdb:2-alpine
    container_name: dev-influxdb
    environment:
      DOCKER_INFLUXDB_INIT_MODE: setup
      DOCKER_INFLUXDB_INIT_USERNAME: ${INFLUXDB_USER:-admin}
      DOCKER_INFLUXDB_INIT_PASSWORD: ${INFLUXDB_PASSWORD:-adminpass}
      DOCKER_INFLUXDB_INIT_ORG: ${INFLUXDB_ORG:-devorg}
      DOCKER_INFLUXDB_INIT_BUCKET: ${INFLUXDB_BUCKET:-devbucket}
    ports:
      - "${INFLUXDB_PORT:-8086}:8086"
    volumes:
      - influxdb_data:/var/lib/influxdb2
      - influxdb_config:/etc/influxdb2
    healthcheck:
      test: ["CMD", "influx", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
`,

	// ==================== CACHING ====================
	
	"memcached": `  memcached:
    image: memcached:1.6-alpine
    container_name: dev-memcached
    command: memcached -m ${MEMCACHED_MEMORY:-64}
    ports:
      - "${MEMCACHED_PORT:-11211}:11211"
    healthcheck:
      test: ["CMD", "nc", "-z", "localhost", "11211"]
      interval: 10s
      timeout: 5s
      retries: 5
`,

	// ==================== OBJECT STORAGE ====================
	
	"minio": `  minio:
    image: minio/minio:latest
    container_name: dev-minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER:-minioadmin}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD:-minioadmin}
    ports:
      - "${MINIO_API_PORT:-9000}:9000"
      - "${MINIO_CONSOLE_PORT:-9001}:9001"
    volumes:
      - minio_data:/data
    healthcheck:
      test: ["CMD", "mc", "ready", "local"]
      interval: 10s
      timeout: 5s
      retries: 5
`,

	// ==================== WEB SERVERS / REVERSE PROXY ====================
	
	"nginx": `  nginx:
    image: nginx:1.29-alpine
    container_name: dev-nginx
    ports:
      - "${NGINX_HTTP_PORT:-80}:80"
      - "${NGINX_HTTPS_PORT:-443}:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./nginx/html:/usr/share/nginx/html:ro
    healthcheck:
      test: ["CMD", "nginx", "-t"]
      interval: 30s
      timeout: 10s
      retries: 3
`,
	"traefik": `  traefik:
    image: traefik:v3.3
    container_name: dev-traefik
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entryPoints.web.address=:80"
      - "--entryPoints.websecure.address=:443"
    ports:
      - "${TRAEFIK_HTTP_PORT:-80}:80"
      - "${TRAEFIK_HTTPS_PORT:-443}:443"
      - "${TRAEFIK_DASHBOARD_PORT:-8080}:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - traefik_data:/etc/traefik
`,

	// ==================== MONITORING ====================
	
	"prometheus": `  prometheus:
    image: prom/prometheus:v3.2.1
    container_name: dev-prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    ports:
      - "${PROMETHEUS_PORT:-9090}:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:9090/-/healthy"]
      interval: 30s
      timeout: 10s
      retries: 3
`,
	"grafana": `  grafana:
    image: grafana/grafana:11.5.0
    container_name: dev-grafana
    environment:
      GF_SECURITY_ADMIN_USER: ${GRAFANA_USER:-admin}
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD:-admin}
      GF_USERS_ALLOW_SIGN_UP: false
    ports:
      - "${GRAFANA_PORT:-3000}:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    healthcheck:
      test: ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
`,

	// ==================== ADMIN TOOLS ====================
	
	"adminer": `  adminer:
    image: adminer:latest
    container_name: dev-adminer
    ports:
      - "${ADMINER_PORT:-8080}:8080"
    environment:
      ADMINER_DEFAULT_SERVER: ${ADMINER_DEFAULT_SERVER:-postgres}
`,
	"phpmyadmin": `  phpmyadmin:
    image: phpmyadmin:latest
    container_name: dev-phpmyadmin
    environment:
      PMA_HOST: ${PMA_HOST:-mysql}
      PMA_PORT: ${PMA_PORT:-3306}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-rootpass}
    ports:
      - "${PHPMYADMIN_PORT:-8080}:80"
`,
	"pgadmin": `  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: dev-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: ${PGADMIN_EMAIL:-admin@admin.com}
      PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_PASSWORD:-admin}
    ports:
      - "${PGADMIN_PORT:-5050}:80"
    volumes:
      - pgadmin_data:/var/lib/pgadmin
`,
	"mongo-express": `  mongo-express:
    image: mongo-express:latest
    container_name: dev-mongo-express
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: ${MONGO_USER:-admin}
      ME_CONFIG_MONGODB_ADMINPASSWORD: ${MONGO_PASSWORD:-mongopass}
      ME_CONFIG_MONGODB_URL: mongodb://${MONGO_USER:-admin}:${MONGO_PASSWORD:-mongopass}@mongodb:27017/
      ME_CONFIG_BASICAUTH: false
    ports:
      - "${MONGO_EXPRESS_PORT:-8081}:8081"
    depends_on:
      - mongodb
`,
	"redis-commander": `  redis-commander:
    image: rediscommander/redis-commander:latest
    container_name: dev-redis-commander
    environment:
      REDIS_HOSTS: local:redis:6379
    ports:
      - "${REDIS_COMMANDER_PORT:-8081}:8081"
    depends_on:
      - redis
`,

	// ==================== MAIL TESTING ====================
	
	"mailhog": `  mailhog:
    image: mailhog/mailhog:latest
    container_name: dev-mailhog
    ports:
      - "${MAILHOG_SMTP_PORT:-1025}:1025"
      - "${MAILHOG_WEB_PORT:-8025}:8025"
`,
	"mailpit": `  mailpit:
    image: axllent/mailpit:latest
    container_name: dev-mailpit
    ports:
      - "${MAILPIT_SMTP_PORT:-1025}:1025"
      - "${MAILPIT_WEB_PORT:-8025}:8025"
    volumes:
      - mailpit_data:/data
`,
}

var Volumes = map[string]string{
	"postgres":      "  postgres_data:\n",
	"mysql":         "  mysql_data:\n",
	"mysql-lts":     "  mysql_data:\n",
	"mariadb":       "  mariadb_data:\n",
	"mariadb-lts":   "  mariadb_data:\n",
	"mongodb":       "  mongodb_data:\n",
	"redis":         "  redis_data:\n",
	"redis-password": "  redis_data:\n",
	"elasticsearch": "  elasticsearch_data:\n",
	"meilisearch":   "  meilisearch_data:\n",
	"rabbitmq":      "  rabbitmq_data:\n",
	"kafka":         "  kafka_data:\n",
	"neo4j":         "  neo4j_data:\n  neo4j_logs:\n",
	"influxdb":      "  influxdb_data:\n  influxdb_config:\n",
	"memcached":     "",
	"minio":         "  minio_data:\n",
	"nginx":         "",
	"traefik":       "  traefik_data:\n",
	"prometheus":    "  prometheus_data:\n",
	"grafana":       "  grafana_data:\n",
	"adminer":       "",
	"phpmyadmin":    "",
	"pgadmin":       "  pgadmin_data:\n",
	"mongo-express": "",
	"redis-commander": "",
	"mailhog":       "",
	"mailpit":       "  mailpit_data:\n",
}

var EnvVars = map[string]string{
	"postgres": `# PostgreSQL 18
POSTGRES_USER=devuser
POSTGRES_PASSWORD=devpass
POSTGRES_DB=devdb
POSTGRES_PORT=5432
`,
	"mysql": `# MySQL 9
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=devdb
MYSQL_USER=devuser
MYSQL_PASSWORD=devpass
MYSQL_PORT=3306
`,
	"mysql-lts": `# MySQL 8.4 LTS
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=devdb
MYSQL_USER=devuser
MYSQL_PASSWORD=devpass
MYSQL_PORT=3306
`,
	"mariadb": `# MariaDB 12
MARIADB_ROOT_PASSWORD=rootpass
MARIADB_DATABASE=devdb
MARIADB_USER=devuser
MARIADB_PASSWORD=devpass
MARIADB_PORT=3306
`,
	"mariadb-lts": `# MariaDB 11 LTS
MARIADB_ROOT_PASSWORD=rootpass
MARIADB_DATABASE=devdb
MARIADB_USER=devuser
MARIADB_PASSWORD=devpass
MARIADB_PORT=3306
`,
	"mongodb": `# MongoDB 8
MONGO_USER=admin
MONGO_PASSWORD=mongopass
MONGO_DATABASE=devdb
MONGO_PORT=27017
`,
	"redis": `# Redis 8
REDIS_PORT=6379
`,
	"redis-password": `# Redis 8 with Password
REDIS_PORT=6379
REDIS_PASSWORD=redispass
`,
	"elasticsearch": `# Elasticsearch 8.17
ELASTICSEARCH_PORT=9200
ELASTICSEARCH_TRANSPORT_PORT=9300
`,
	"meilisearch": `# Meilisearch
MEILISEARCH_PORT=7700
MEILI_MASTER_KEY=masterkey
MEILI_ENV=development
`,
	"rabbitmq": `# RabbitMQ 4
RABBITMQ_USER=admin
RABBITMQ_PASSWORD=adminpass
RABBITMQ_PORT=5672
RABBITMQ_MANAGEMENT_PORT=15672
`,
	"kafka": `# Apache Kafka 4.1
KAFKA_PORT=9092
`,
	"neo4j": `# Neo4j 5
NEO4J_USER=neo4j
NEO4J_PASSWORD=password
NEO4J_HTTP_PORT=7474
NEO4J_BOLT_PORT=7687
`,
	"influxdb": `# InfluxDB 2
INFLUXDB_USER=admin
INFLUXDB_PASSWORD=adminpass
INFLUXDB_ORG=devorg
INFLUXDB_BUCKET=devbucket
INFLUXDB_PORT=8086
`,
	"memcached": `# Memcached 1.6
MEMCACHED_PORT=11211
MEMCACHED_MEMORY=64
`,
	"minio": `# MinIO
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
MINIO_API_PORT=9000
MINIO_CONSOLE_PORT=9001
`,
	"nginx": `# Nginx 1.29
NGINX_HTTP_PORT=80
NGINX_HTTPS_PORT=443
`,
	"traefik": `# Traefik 3.3
TRAEFIK_HTTP_PORT=80
TRAEFIK_HTTPS_PORT=443
TRAEFIK_DASHBOARD_PORT=8080
`,
	"prometheus": `# Prometheus
PROMETHEUS_PORT=9090
`,
	"grafana": `# Grafana 11.5
GRAFANA_USER=admin
GRAFANA_PASSWORD=admin
GRAFANA_PORT=3000
`,
	"adminer": `# Adminer
ADMINER_PORT=8080
ADMINER_DEFAULT_SERVER=postgres
`,
	"phpmyadmin": `# phpMyAdmin
PHPMYADMIN_PORT=8080
PMA_HOST=mysql
PMA_PORT=3306
`,
	"pgadmin": `# pgAdmin
PGADMIN_EMAIL=admin@admin.com
PGADMIN_PASSWORD=admin
PGADMIN_PORT=5050
`,
	"mongo-express": `# Mongo Express
MONGO_EXPRESS_PORT=8081
`,
	"redis-commander": `# Redis Commander
REDIS_COMMANDER_PORT=8081
`,
	"mailhog": `# MailHog
MAILHOG_SMTP_PORT=1025
MAILHOG_WEB_PORT=8025
`,
	"mailpit": `# Mailpit
MAILPIT_SMTP_PORT=1025
MAILPIT_WEB_PORT=8025
`,
}

// ServiceCategories 
var ServiceCategories = map[string][]string{
	"databases": {
		"postgres",
		"mysql",
		"mysql-lts",
		"mariadb",
		"mariadb-lts",
		"mongodb",
	},
	"caching": {
		"redis",
		"redis-password",
		"memcached",
	},
	"search": {
		"elasticsearch",
		"meilisearch",
	},
	"messaging": {
		"rabbitmq",
		"kafka",
	},
	"graph": {
		"neo4j",
	},
	"timeseries": {
		"influxdb",
	},
	"storage": {
		"minio",
	},
	"webservers": {
		"nginx",
		"traefik",
	},
	"monitoring": {
		"prometheus",
		"grafana",
	},
	"admin": {
		"adminer",
		"phpmyadmin",
		"pgadmin",
		"mongo-express",
		"redis-commander",
		"portainer",
	},
	"mail": {
		"mailhog",
		"mailpit",
	},
}

// ServiceDescriptions 
var ServiceDescriptions = map[string]string{
	"postgres":        "PostgreSQL 18",
	"mysql":           "MySQL 9",
	"mysql-lts":       "MySQL 8.4 LTS",
	"mariadb":         "MariaDB 12",
	"mariadb-lts":     "MariaDB 11 LTS",
	"mongodb":         "MongoDB 8",
	"redis-password":  "Redis 8",
	"elasticsearch":   "Elasticsearch 8.17",
	"meilisearch":     "Meilisearch",
	"rabbitmq":        "RabbitMQ 4",
	"kafka":           "Apache Kafka 4.1",
	"neo4j":           "Neo4j 5",
	"influxdb":        "InfluxDB 2",
	"memcached":       "Memcached 1.6",
	"minio":           "MinIO",
	"nginx":           "Nginx 1.29",
	"traefik":         "Traefik 3.3",
	"prometheus":      "Prometheus",
	"grafana":         "Grafana 11.5",
	"adminer":         "Adminer",
	"phpmyadmin":      "phpMyAdmin",
	"pgadmin":         "pgAdmin",
	"mongo-express":   "Mongo Express",
	"redis-commander": "Redis Commander",
	"mailhog":         "MailHog",
	"mailpit":         "Mailpit",
}