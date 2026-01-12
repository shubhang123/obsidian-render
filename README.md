# Obsidian Docker 🗃️

Ultra-lightweight, high-performance Obsidian in your browser. Custom Alpine-based image with native-like input latency.

## Features

✅ **Multi-architecture**: ARM64 (Raspberry Pi) + AMD64 (Cloud)  
✅ **Lightweight**: Alpine base (~400MB vs ~2GB for linuxserver)  
✅ **Low latency**: Optimized VNC settings for responsive typing  
✅ **Persistent**: Vaults and config survive container restarts  

---

## Quick Start

```bash
# Build and run
docker-compose up -d --build

# Access at http://localhost:8080
```

---

## Deploy to Cloud

### Railway (Recommended)

1. Push to GitHub
2. [railway.app](https://railway.app) → New Project → Deploy from GitHub
3. Add Volume: mount path `/vaults`

### Render

1. [render.com](https://render.com) → New Blueprint → Connect repo
2. Auto-detects `render.yaml`

### Raspberry Pi

```bash
# On your Pi (64-bit OS required)
git clone https://github.com/YOUR_USERNAME/obsidian-render.git
cd obsidian-render
docker-compose up -d --build
```

---

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Alpine-based, multi-arch build |
| `docker-compose.yml` | Local/Pi deployment |
| `supervisord.conf` | Process management |
| `start.sh` | Startup script |
| `railway.json` | Railway config |
| `render.yaml` | Render config |

---

## Performance Tuning

The image includes:
- **x11vnc**: Low-latency flags (`-defer 5 -wait 5 -ncache 10`)
- **Electron**: Optimized flags (disabled throttling, hardware accel)
- **Display**: 1920x1080 @ 96 DPI

For even lower latency on fast networks, edit `supervisord.conf`:
```ini
# Change defer/wait to 1ms (may increase CPU usage)
-defer 1 -wait 1
```

---

## Obsidian Git Plugin

1. Install from Community Plugins
2. Use HTTPS + [Personal Access Token](https://github.com/settings/tokens)

---

## Troubleshooting

**Slow typing?** Check network latency; use wired connection if possible

**Won't start on Pi?** Ensure 64-bit OS and 2GB+ RAM

**Vault lost?** Mount `/vaults` volume for persistence
