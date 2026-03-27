FROM quay.io/minio/minio:latest

ENV MINIO_ROOT_USER=rag_flow
ENV MINIO_ROOT_PASSWORD=infini_rag_flow

EXPOSE 9000 9001

CMD ["server", "/data", "--console-address", ":9001"]
