FROM python:3.12-slim-bookworm

LABEL maintainer="473011317@qq.com"
LABEL org.opencontainers.image.title="cf2dns"
LABEL org.opencontainers.image.description="Cloudflare optimized IP updater"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt

COPY cf2dns.py log.py ./
COPY dns ./dns

RUN useradd --system --create-home --uid 10001 appuser && \
    mkdir -p /app/logs && \
    chown -R appuser:appuser /app

USER appuser

CMD ["sh", "-c", "while true; do python cf2dns.py; sleep ${INTERVAL_SECONDS:-900}; done"]
