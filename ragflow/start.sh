#!/bin/bash
# Remove any default nginx config and ensure ragflow config is active
rm -f /etc/nginx/conf.d/default.conf
# If nginx.conf has a server block, replace it with a clean one
cat > /etc/nginx/nginx.conf << 'NGINX'
user root;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
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

# Run the original entrypoint
exec /ragflow/entrypoint.sh "$@"
