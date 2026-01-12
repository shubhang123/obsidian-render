#!/bin/bash
set -e

PUID=${PUID:-1000}
PGID=${PGID:-1000}

echo "🚀 Starting Obsidian (PUID=$PUID, PGID=$PGID)"

# Update user/group IDs if different
if [ "$(id -u obsidian)" != "$PUID" ]; then
    deluser obsidian 2>/dev/null || true
    delgroup obsidian 2>/dev/null || true
    addgroup -g "$PGID" obsidian
    adduser -u "$PUID" -G obsidian -h /home/obsidian -s /bin/bash -D obsidian
fi

# Fix permissions
chown -R obsidian:obsidian /home/obsidian /vaults /config 2>/dev/null || true

# Link config
mkdir -p /home/obsidian/.config
[ ! -L "/home/obsidian/.config/obsidian" ] && ln -sf /config /home/obsidian/.config/obsidian

# Start supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf
