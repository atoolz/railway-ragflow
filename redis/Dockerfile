FROM valkey/valkey:8

ENV REDIS_PASSWORD=infini_rag_flow

EXPOSE 6379

CMD ["sh", "-c", "valkey-server --requirepass $REDIS_PASSWORD --save 60 1 --loglevel warning"]
