FROM infiniflow/ragflow:v0.24.0

# Replace nginx.conf to remove embedded default server block
# Keep ragflow.conf.python template in conf.d for entrypoint to use
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

EXPOSE 80 9380
