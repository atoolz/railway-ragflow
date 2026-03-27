FROM elasticsearch:8.11.3

ENV discovery.type=single-node
ENV xpack.security.enabled=true
ENV xpack.security.http.ssl.enabled=false
ENV xpack.security.transport.ssl.enabled=false
ENV bootstrap.memory_lock=false
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV ELASTIC_PASSWORD=infini_rag_flow

EXPOSE 9200
