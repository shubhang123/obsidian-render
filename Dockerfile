# Dockerfile for Render deployment
FROM ghcr.io/sytone/obsidian-remote:latest

# Set environment variables
ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC
ENV OBSIDIAN_VAULT=/vaults

# Create vault directory
RUN mkdir -p /vaults /config

# Expose the web port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080 || exit 1
