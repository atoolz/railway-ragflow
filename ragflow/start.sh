#!/bin/bash
set -e

# Replace nginx.conf to remove embedded default server block
cat > /etc/nginx/nginx.conf << 'NGINX'
user root;
worker_processes auto;
error_log /dev/stderr notice;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    client_max_body_size 1024m;

    include /etc/nginx/conf.d/*.conf;
}
NGINX

# Create ragflow nginx config (not included in v0.24.0 image)
cat > /etc/nginx/conf.d/ragflow.conf << 'RAGFLOW'
server {
    listen 80 default_server;
    server_name _;
    root /ragflow/web/dist;

    gzip on;
    gzip_min_length 1k;
    gzip_comp_level 9;
    gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
    gzip_vary on;

    location ~ ^/api/v1/admin {
        proxy_pass http://127.0.0.1:9381;
        include proxy.conf;
    }

    location ~ ^/(v1|api) {
        proxy_pass http://127.0.0.1:9380;
        include proxy.conf;
    }

    location / {
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    location ~ ^/static/(css|js|media)/ {
        expires 10y;
        access_log off;
    }
}
RAGFLOW

# Ensure proxy.conf exists
if [ ! -f /etc/nginx/proxy.conf ]; then
    cat > /etc/nginx/proxy.conf << 'PROXY'
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_buffering off;
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
PROXY
fi

# Remove default configs
rm -f /etc/nginx/conf.d/default.conf

# Wait for Elasticsearch to be ready before starting RAGFlow
if [ -n "$ES_HOST" ]; then
    echo "Waiting for Elasticsearch at $ES_HOST:9200..."
    for i in $(seq 1 60); do
        if curl -sf -u "elastic:${ELASTIC_PASSWORD}" "http://${ES_HOST}:9200/" > /dev/null 2>&1; then
            echo "Elasticsearch is ready after ${i}s"
            break
        fi
        if [ "$i" -eq 60 ]; then
            echo "WARNING: Elasticsearch not ready after 60s, starting anyway..."
        fi
        sleep 2
    done
fi

# Wait for MySQL to be ready
if [ -n "$MYSQL_HOST" ]; then
    echo "Waiting for MySQL at $MYSQL_HOST:${MYSQL_PORT:-3306}..."
    for i in $(seq 1 30); do
        if mysqladmin ping -h "$MYSQL_HOST" -P "${MYSQL_PORT:-3306}" -u "${MYSQL_USER:-root}" -p"$MYSQL_PASSWORD" --silent 2>/dev/null; then
            echo "MySQL is ready after ${i}s"
            break
        fi
        if [ "$i" -eq 30 ]; then
            echo "WARNING: MySQL not ready after 30s, starting anyway..."
        fi
        sleep 2
    done
fi

# Run the original entrypoint
exec /ragflow/entrypoint.sh "$@"
