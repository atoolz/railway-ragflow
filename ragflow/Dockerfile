FROM infiniflow/ragflow:v0.24.0

COPY start.sh /ragflow/start.sh
RUN chmod +x /ragflow/start.sh

EXPOSE 80 9380

ENTRYPOINT ["/ragflow/start.sh"]
