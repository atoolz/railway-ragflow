<p align="center">
  <img src="https://raw.githubusercontent.com/infiniflow/ragflow/main/web/src/assets/logo-with-text.png" alt="RAGFlow" width="320">
</p>

<p align="center">
  <strong>RAGFlow on Railway. Deep document understanding RAG engine with one-click deploy.</strong>
</p>

<p align="center">
  <a href="https://railway.com/template/ragflow">
    <img src="https://railway.com/button.svg" alt="Deploy on Railway">
  </a>
</p>

<p align="center">
  <a href="https://github.com/atoolz/railway-ragflow/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/atoolz/railway-ragflow?style=flat-square&color=00c9a7" alt="License">
  </a>
  <img src="https://img.shields.io/badge/RAGFlow-v0.24.0-7C3AED?style=flat-square" alt="RAGFlow v0.24.0">
  <img src="https://img.shields.io/badge/Elasticsearch-8.11.3-005571?style=flat-square" alt="Elasticsearch 8.11.3">
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat-square" alt="MySQL 8.0">
</p>

<br>

## What's Inside

A production-ready deployment of [RAGFlow](https://github.com/infiniflow/ragflow), an open-source RAG (Retrieval-Augmented Generation) engine based on deep document understanding. It provides truthful Q&A capabilities backed by well-founded citations from complex formatted data.

| Service | Image | Role |
|---------|-------|------|
| **RAGFlow** | `infiniflow/ragflow:v0.24.0` | RAG engine with web UI, API, and document processing |
| **Elasticsearch** | `elasticsearch:8.11.3` | Vector search and document indexing |
| **MySQL** | `mysql:8.0.39` | Metadata, user data, and configuration storage |
| **MinIO** | `minio/minio:latest` | S3-compatible object storage for documents |
| **Redis** | `valkey/valkey:8` | Caching, sessions, and task queues |

<br>

## Key Features

- **Deep Document Understanding**: Extracts knowledge from PDFs, Word docs, Excel, PPTs, images, and more with layout-aware chunking
- **Template-based Chunking**: Intelligent document parsing that preserves structure and context
- **Multi-model Support**: Connect any LLM (OpenAI, Anthropic, local models via Ollama, etc.)
- **Citation-backed Answers**: Every answer includes traceable references to source documents
- **Agentic RAG**: Build complex RAG workflows with the visual agent editor
- **MCP Server**: Built-in Model Context Protocol server for tool integration

<br>

## Deploy to Railway

Click the button above or:

1. Fork this repo
2. Create a new project on [Railway](https://railway.com)
3. Add five services, each pointing to a subdirectory in this repo:

| Service | Root Directory | Port |
|---------|---------------|------|
| RAGFlow | `ragflow/` | 80 |
| Elasticsearch | `elasticsearch/` | 9200 |
| MySQL | `mysql/` | 3306 |
| MinIO | `minio/` | 9000 |
| Redis | `redis/` | 6379 |

4. Configure environment variables (see below)
5. Set RAGFlow as the public-facing service
6. Deploy

<br>

## Environment Variables

### RAGFlow (required)

| Variable | Default | Description |
|----------|---------|-------------|
| `MYSQL_HOST` | `mysql` | MySQL service hostname (use Railway reference: `${{MySQL.RAILWAY_PRIVATE_DOMAIN}}`) |
| `MYSQL_PORT` | `3306` | MySQL port |
| `MYSQL_PASSWORD` | - | MySQL root password (use Railway reference: `${{MySQL.MYSQL_ROOT_PASSWORD}}`) |
| `ES_HOST` | `es01` | Elasticsearch hostname (use Railway reference: `${{Elasticsearch.RAILWAY_PRIVATE_DOMAIN}}`) |
| `ELASTIC_PASSWORD` | - | Elasticsearch password (use Railway reference: `${{Elasticsearch.ELASTIC_PASSWORD}}`) |
| `MINIO_HOST` | `minio` | MinIO hostname (use Railway reference: `${{MinIO.RAILWAY_PRIVATE_DOMAIN}}`) |
| `MINIO_PASSWORD` | - | MinIO password (use Railway reference: `${{MinIO.MINIO_ROOT_PASSWORD}}`) |
| `REDIS_HOST` | `redis` | Redis hostname (use Railway reference: `${{Redis.RAILWAY_PRIVATE_DOMAIN}}`) |
| `REDIS_PASSWORD` | - | Redis password (use Railway reference: `${{Redis.REDIS_PASSWORD}}`) |

### RAGFlow (optional)

| Variable | Default | Description |
|----------|---------|-------------|
| `DOC_ENGINE` | `elasticsearch` | Document engine (`elasticsearch`, `opensearch`, `infinity`) |
| `REGISTER_ENABLED` | `1` | Allow user registration (`1` = enabled, `0` = disabled) |
| `DOC_BULK_SIZE` | `4` | Documents processed per batch |
| `EMBEDDING_BATCH_SIZE` | `16` | Embeddings generated per batch |
| `TZ` | `UTC` | Timezone |
| `MAX_CONTENT_LENGTH` | `1073741824` | Max upload file size in bytes (1GB) |

### Elasticsearch

| Variable | Default | Description |
|----------|---------|-------------|
| `ELASTIC_PASSWORD` | - | Password for the `elastic` user (generate a strong one) |
| `ES_JAVA_OPTS` | `-Xms1g -Xmx1g` | JVM heap size (adjust based on Railway plan) |

### MySQL

| Variable | Default | Description |
|----------|---------|-------------|
| `MYSQL_ROOT_PASSWORD` | - | Root password (generate a strong one) |
| `MYSQL_DATABASE` | `rag_flow` | Database name |

### MinIO

| Variable | Default | Description |
|----------|---------|-------------|
| `MINIO_ROOT_USER` | `rag_flow` | MinIO access key |
| `MINIO_ROOT_PASSWORD` | - | MinIO secret key (generate a strong one) |

### Redis

| Variable | Default | Description |
|----------|---------|-------------|
| `REDIS_PASSWORD` | - | Redis password (generate a strong one) |

<br>

## Resource Requirements

RAGFlow is a resource-intensive application. Recommended minimums for Railway:

| Service | RAM | Storage |
|---------|-----|---------|
| RAGFlow | 4 GB | 2 GB |
| Elasticsearch | 2 GB | 20 GB |
| MySQL | 1 GB | 10 GB |
| MinIO | 512 MB | 50 GB |
| Redis | 512 MB | 1 GB |
| **Total** | **~8 GB** | **~83 GB** |

<br>

## Architecture

```
                    ┌─────────────────┐
                    │   User Browser  │
                    └────────┬────────┘
                             │ :80
                    ┌────────▼────────┐
                    │    RAGFlow      │
                    │  (Web UI + API) │
                    └──┬──┬──┬──┬────┘
           ┌───────────┘  │  │  └───────────┐
           │              │  │              │
    ┌──────▼──────┐ ┌─────▼──▼─────┐ ┌─────▼─────┐
    │ Elasticsearch│ │    MySQL     │ │   MinIO   │
    │   :9200     │ │    :3306     │ │   :9000   │
    │  (vectors)  │ │  (metadata)  │ │  (files)  │
    └─────────────┘ └──────────────┘ └───────────┘
                           │
                    ┌──────▼──────┐
                    │    Redis    │
                    │    :6379    │
                    │   (cache)   │
                    └─────────────┘
```

<br>

## After Deployment

1. Access the RAGFlow web UI through the public URL Railway assigns
2. Create an admin account on first visit
3. Go to **Model Providers** and configure at least one LLM (OpenAI, Anthropic, Ollama, etc.)
4. Create a **Knowledge Base** and upload your documents
5. Create an **Assistant** linked to your knowledge base
6. Start asking questions with citation-backed answers

<br>

## Upstream

This template deploys [RAGFlow](https://github.com/infiniflow/ragflow) by [InfiniFlow](https://github.com/infiniflow). All credit for the RAG engine goes to the original maintainers.

<br>

## License

[MIT](LICENSE)

---

<p align="center">
  <sub>Built by <a href="https://github.com/atoolz">AToolZ</a></sub>
</p>
