# Ultra-Lightweight Obsidian Docker Image
# Base: Alpine Linux (~5MB) + glibc compatibility
# Supports: linux/amd64, linux/arm64

FROM alpine:3.19

# Latest stable: 1.10.6 (Nov 2025) - Update this when new versions release
ARG OBSIDIAN_VERSION=1.10.6
ARG TARGETARCH

ENV DISPLAY=:0 \
    PUID=1000 \
    PGID=1000 \
    # Performance: reduce Electron memory usage
    ELECTRON_DISABLE_GPU=false \
    ELECTRON_ENABLE_LOGGING=false

# Install minimal dependencies
RUN apk add --no-cache \
    # glibc compatibility (required for Electron/Obsidian)
    gcompat \
    # X11 minimal
    xvfb \
    x11vnc \
    # noVNC for web access
    novnc \
    websockify \
    # Lightweight window manager
    openbox \
    # Obsidian/Electron dependencies
    gtk+3.0 \
    libnotify \
    nss \
    libxss \
    libxtst \
    alsa-lib \
    libdrm \
    mesa-gbm \
    # Essential tools
    curl \
    wget \
    git \
    bash \
    supervisor \
    ttf-dejavu \
    # Reduce image size
    && rm -rf /var/cache/apk/*

# Create obsidian user
RUN addgroup -g ${PGID} obsidian && \
    adduser -u ${PUID} -G obsidian -h /home/obsidian -s /bin/bash -D obsidian

# Download Obsidian AppImage (works on both architectures)
RUN ARCH_SUFFIX=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") && \
    wget -q "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}-${ARCH_SUFFIX}.AppImage" \
    -O /opt/obsidian.AppImage && \
    chmod +x /opt/obsidian.AppImage && \
    # Extract AppImage for faster startup
    cd /opt && ./obsidian.AppImage --appimage-extract && \
    rm /opt/obsidian.AppImage && \
    mv /opt/squashfs-root /opt/obsidian && \
    chown -R obsidian:obsidian /opt/obsidian

# noVNC setup
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Copy config files
COPY supervisord.conf /etc/supervisord.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Create directories
RUN mkdir -p /vaults /config /home/obsidian/.config && \
    chown -R obsidian:obsidian /vaults /config /home/obsidian

VOLUME ["/vaults", "/config"]
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD wget -q --spider http://localhost:8080 || exit 1

CMD ["/start.sh"]
