# Lightweight Obsidian Docker Image
# Base: Debian Bookworm Slim (Native glibc support)
# Supports: linux/amd64, linux/arm64

FROM debian:bookworm-slim

ARG OBSIDIAN_VERSION=1.10.6
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:0 \
    PUID=1000 \
    PGID=1000 \
    # Performance flags
    ELECTRON_DISABLE_GPU=false \
    ELECTRON_ENABLE_LOGGING=false

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # X11 & VNC
    xvfb \
    x11vnc \
    novnc \
    websockify \
    openbox \
    supervisor \
    # Obsidian dependencies
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    # AppImage dependencies
    zlib1g \
    # Tools
    curl \
    wget \
    ca-certificates \
    procps \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/* && \
    # Fix for AppImage extraction: symlink libz.so
    ln -s /lib/$(uname -m)-linux-gnu/libz.so.1 /usr/lib/libz.so

# Create user
RUN groupadd -g ${PGID} obsidian && \
    useradd -u ${PUID} -g obsidian -m -s /bin/bash obsidian

# Download and install Obsidian (AppImage for both archs to ensure consistency)
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        ARCH_SUFFIX="arm64"; \
    else \
        ARCH_SUFFIX="x86_64"; \
    fi && \
    wget -q "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}-${ARCH_SUFFIX}.AppImage" -O /opt/obsidian.AppImage && \
    chmod +x /opt/obsidian.AppImage && \
    # Extract AppImage
    cd /opt && ./obsidian.AppImage --appimage-extract && \
    rm /opt/obsidian.AppImage && \
    mv /opt/squashfs-root /opt/obsidian && \
    chmod +x /opt/obsidian/obsidian && \
    ln -s /opt/obsidian/obsidian /usr/bin/obsidian && \
    chown -R obsidian:obsidian /opt/obsidian

# noVNC setup
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Copy config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Directories
RUN mkdir -p /vaults /config /home/obsidian/.config/obsidian && \
    chown -R obsidian:obsidian /vaults /config /home/obsidian

VOLUME ["/vaults", "/config"]
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080 || exit 1

CMD ["/start.sh"]
