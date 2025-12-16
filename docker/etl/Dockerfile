# Base image Python 3.11 slim
FROM python:3.11-slim

LABEL maintainer="Data Warehouse Pariwisata Jakarta"
LABEL description="ETL Pipeline Container with PostgreSQL 18 Client"

WORKDIR /app

# Install system dependencies and PostgreSQL repository
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3-dev \
    libpq-dev \
    curl \
    bash \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Makassar
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add PostgreSQL 18 repository
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install PostgreSQL 18 client tools
RUN apt-get update && apt-get install -y \
    postgresql-client-18 \
    && rm -rf /var/lib/apt/lists/*

# Verify PostgreSQL client version
RUN echo "PostgreSQL Client Version:" && pg_dump --version && psql --version

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Create directories (akan di-mount via volume)
RUN mkdir -p /app/scripts/etl /app/data /app/logs /app/data/backups

# Copy .env to container (optional, better via volume mount)
COPY .env /app/.env

# Set environment
ENV PYTHONPATH=/app/scripts
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import sys; sys.exit(0)" || exit 1

# Keep container running
CMD ["tail", "-f", "/dev/null"]
