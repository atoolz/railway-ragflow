FROM infiniflow/ragflow:v0.24.0

# Remove ONLY the default nginx config (keep ragflow.conf.* templates intact)
RUN rm -f /etc/nginx/conf.d/default.conf

EXPOSE 80 9380
