FROM mysql:8.0.39

ENV MYSQL_ROOT_PASSWORD=infini_rag_flow
ENV MYSQL_DATABASE=rag_flow

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
