# Obsidian Docker 🗃️

Run Obsidian in your browser - perfect for work environments where you can't install desktop apps.

## Quick Start (Local)

```bash
docker-compose up -d
```

Access at: http://localhost:8080

---

## Deploy to Railway 🚂 (Recommended)

### Step 1: One-Click Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/obsidian)

**Or manually:**

1. Go to [railway.app](https://railway.app) and sign in with GitHub
2. Click **"New Project"** → **"Deploy from GitHub repo"**
3. Select your `obsidian-render` repo
4. Railway auto-detects `railway.json`
5. Click **"Deploy"** → Wait 2-3 minutes

### Step 2: Add Persistent Storage

1. In your Railway project, click **"+ New"** → **"Volume"**
2. Set mount path: `/vaults`
3. Click **"Deploy"**

### Step 3: Access Obsidian

Railway gives you a URL like: `https://obsidian-render-production.up.railway.app`

---

## Deploy to Render ☁️

### Step 1: Deploy

1. Go to [render.com/dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprint"**
3. Connect your GitHub repo
4. Render detects `render.yaml` automatically
5. Click **"Apply"** → Wait 5-10 minutes

### Step 2: Access

URL format: `https://obsidian-xxxx.onrender.com`

---

## Using Obsidian Git Plugin

1. Open Obsidian in browser
2. **Settings → Community Plugins → Browse** → Install **"Obsidian Git"**
3. Use HTTPS + [Personal Access Token](https://github.com/settings/tokens) for auth

---

## Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Local development |
| `Dockerfile` | Container build |
| `railway.json` | Railway deployment |
| `render.yaml` | Render deployment |

---

## Cost Comparison

| Platform | Free Tier | Paid |
|----------|-----------|------|
| **Railway** | $5 credit/mo | $5+/mo |
| **Render** | Spins down after 15min | $7/mo |

> **Tip**: Railway is better for daily use (no cold starts on free tier).

---

## Troubleshooting

**Container won't start?** Check logs in dashboard, need 512MB+ RAM

**Git plugin not working?** Use HTTPS + Personal Access Token (not SSH)

**Vault not persisting?** Add a volume mounted to `/vaults`

