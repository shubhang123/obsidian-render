# Obsidian Docker 🗃️

Run Obsidian in your browser - perfect for work environments where you can't install desktop apps.

## Quick Start (Local)

```bash
docker-compose up -d
```

Access at: http://localhost:8080

---

## Deploy to Render ☁️

### Prerequisites
- GitHub account
- Render account (free at [render.com](https://render.com))

### Step 1: Push to GitHub

```bash
# Initialize git (if not already)
git init
git add .
git commit -m "Initial commit - Obsidian Docker"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/obsidian-docker.git
git push -u origin main
```

### Step 2: Deploy on Render

1. Go to [render.com/dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprint"**
3. Connect your GitHub repo
4. Render will detect `render.yaml` automatically
5. Click **"Apply"**
6. Wait 5-10 minutes for deployment

### Step 3: Access Your Obsidian

Once deployed, Render gives you a URL like:
```
https://obsidian-xxxx.onrender.com
```

Open it in your browser - that's your Obsidian! 🎉

---

## Using Obsidian Git Plugin

1. Open Obsidian in browser
2. Go to **Settings → Community Plugins → Browse**
3. Install **"Obsidian Git"**
4. Configure with your GitHub repo URL
5. Use HTTPS + Personal Access Token for auth:
   - Generate at: github.com/settings/tokens
   - Use token as password when prompted

---

## Configuration

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Local development |
| `Dockerfile` | Container build definition |
| `render.yaml` | Render deployment blueprint |
| `vaults/` | Your Obsidian vault files |
| `config/` | Obsidian settings & plugins |

---

## Cost

| Render Plan | RAM | Cost |
|-------------|-----|------|
| Free | 512MB | $0/mo (spins down after inactivity) |
| Starter | 512MB | $7/mo (always on) |
| Standard | 2GB | $25/mo |

> **Tip**: Free tier works but has cold starts (~30s). Starter plan recommended for daily use.

---

## Troubleshooting

**Container won't start?**
- Check logs in Render dashboard
- Ensure you have enough RAM (512MB minimum)

**Git plugin not working?**
- Use HTTPS (not SSH) on Render
- Create a GitHub Personal Access Token
- Enter token as password when prompted

**Vault not persisting?**
- Ensure disk is mounted (check render.yaml)
- Free tier may not have persistent disks
