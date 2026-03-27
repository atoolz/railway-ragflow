#!/bin/bash
set -e

# Remove any default nginx config
rm -f /etc/nginx/conf.d/default.conf

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
    access_log /dev/stdout;
    sendfile on;
    keepalive_timeout 65;
    client_max_body_size 1024m;

    include /etc/nginx/conf.d/*.conf;
}
NGINX

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

# Debug: find ragflow nginx configs
echo "=== Looking for ragflow nginx configs ==="
find / -name "ragflow.conf*" -o -name "ragflow*.conf" 2>/dev/null | head -20
echo "=== Looking for nginx conf dirs ==="
find /etc/nginx -type f 2>/dev/null
echo "=== conf.d contents ==="
ls -la /etc/nginx/conf.d/

# Run the original entrypoint
exec /ragflow/entrypoint.sh "$@"
