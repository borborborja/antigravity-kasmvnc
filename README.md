# Antigravity KasmVNC

[![Docker Build](https://github.com/borborborja/antigravity-kasmvnc/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/borborborja/antigravity-kasmvnc/actions/workflows/docker-publish.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/borborbor/antigravity-kasmvnc)](https://hub.docker.com/r/borborbor/antigravity-kasmvnc)

A Docker container running **Antigravity** in a web-accessible desktop environment using [LinuxServer.io's Webtop](https://github.com/linuxserver/docker-webtop) with KasmVNC.

## Docker Hub

**Pre-built image available:** [`borborbor/antigravity-kasmvnc`](https://hub.docker.com/r/borborbor/antigravity-kasmvnc)

```bash
docker pull borborbor/antigravity-kasmvnc:latest
```

## Features

- 🖥️ **Web-based Desktop** - Access Antigravity through your browser via KasmVNC
- 🌐 **Google Chrome** - Pre-installed and ready for Antigravity (auto-updates on restart)
- ⚡ **Optimized Rendering** - Low minimum quality for high responsiveness even on slow connections
- 📋 **Seamless Clipboard** - Automatic bidirectional clipboard sync (best in Chromium browsers)
- 🔄 **Auto-updates** - Antigravity automatically updates on container restart
- 🔒 **Secure Access** - Password-protected web interface with optional SSL
- ⚙️ **Configurable** - Pass custom arguments to Antigravity via environment variables
- 💾 **Persistent Storage** - Projects and extensions persist across restarts

## Quick Start

### Option 1: Use Pre-built Image (Recommended)

```bash
docker run -d \
  --name antigravity \
  -p 3000:3000 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e CUSTOM_USER=admin \
  -e PASSWORD=changeme \
  -v ./config:/config \
  -v ./projects:/config/Projects \
  --shm-size=1gb \
  borborbor/antigravity-kasmvnc:latest
```

### Option 2: Build Locally

```bash
git clone https://github.com/borborborja/antigravity-kasmvnc.git
cd antigravity-kasmvnc
docker build -t antigravity-kasmvnc .
docker run -d --name antigravity -p 3000:3000 -e PASSWORD=changeme --shm-size=1gb antigravity-kasmvnc
```

Then open http://localhost:3000 in your browser.

## Docker Compose

Copy `docker-compose.example.yaml` to `docker-compose.yaml` and customize:

```bash
cp docker-compose.example.yaml docker-compose.yaml
# Edit docker-compose.yaml with your settings
docker compose up -d
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `Europe/London` | Timezone |
| `TITLE` | `Antigravity` | Browser tab title |
| `CUSTOM_USER` | `abc` | Login username |
| `PASSWORD` | - | Login password (required) |
| `ANTIGRAVITY_ARGS` | - | Extra arguments for Antigravity (e.g., `--force-device-scale-factor=1.5`) |

## Volumes

| Path | Description |
|------|-------------|
| `/config` | Main configuration directory |
| `/config/Projects` | Antigravity projects |
| `/config/.antigravity` | Antigravity extensions and settings |

## SSL Configuration

To enable HTTPS, place your certificates in the config SSL directory:

```bash
mkdir -p ./config/ssl
# Place your cert.pem and cert.key files in ./config/ssl/
```

The container will automatically use HTTPS when certificates are present.

## Resource Recommendations

- **Memory**: 2GB minimum recommended
- **CPU**: 1.5 cores recommended
- **Shared Memory**: 1GB (`--shm-size=1gb`) for browser stability

## License

This project packages Antigravity in a containerized environment. See [Antigravity](https://antigravity.dev) for the application license.
