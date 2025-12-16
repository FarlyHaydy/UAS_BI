# Base image Python 3.11 slim
FROM python:3.11-slim

LABEL maintainer="Data Warehouse Pariwisata Jakarta"
LABEL description="Streamlit Dashboard Container"

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Makassar
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy requirements
COPY requirements.txt .

# Install Python dependencies including Streamlit
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir streamlit==1.29.0 plotly==5.18.0

# Create dashboard directory (akan di-mount via volume)
RUN mkdir -p /app/dashboard

# Create .streamlit config
RUN mkdir -p /app/.streamlit && \
    echo '[server]\n\
headless = true\n\
port = 8501\n\
enableCORS = false\n\
enableXsrfProtection = false\n\
\n\
[browser]\n\
gatherUsageStats = false\n\
serverAddress = "0.0.0.0"\n\
' > /app/.streamlit/config.toml

EXPOSE 8501

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8501/_stcore/health || exit 1

# Command akan di-override di docker-compose
CMD ["streamlit", "run", "/app/dashboard/app.py", "--server.port=8501", "--server.address=0.0.0.0"]
