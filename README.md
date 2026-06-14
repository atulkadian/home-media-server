# Home Media Server

A personal media setup for managing downloads, TV and movies.

## What’s in this setup

This stack currently includes:

- Plex for streaming
- Overseerr for requests
- Sonarr for TV shows
- Radarr for movies
- Prowlarr for indexers
- qBittorrent for downloads
- Nginx for local routing

## Requirements

This assumes the host already has:

- Docker and Docker Compose
- Nginx installed
- `sudo` access
- A media root such as `/home/ubuntu/media`

## Setup

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with the local values for this host:
   - `TZ`
   - `PUID` / `PGID`
   - `MEDIA_ROOT`
   - the domain names used here for Plex, Overseerr, Sonarr, Radarr, Prowlarr, and qBittorrent

3. Create the media folders used by this setup:

   ```bash
   sudo mkdir -p /home/ubuntu/media/{downloads,movies,tv}
   sudo chown -R $USER:$USER /home/ubuntu/media
   ```

   If you changed `MEDIA_ROOT` in `.env`, use that path instead.

4. Start the services:

   ```bash
   ./start.sh
   ```

5. Open the configured domains in the browser for this setup.

## Local access

- Plex: `http://<your-plex-domain>`
- Overseerr: `http://<your-request-domain>`
- Sonarr: `http://<your-sonarr-domain>`
- Radarr: `http://<your-radarr-domain>`
- Prowlarr: `http://<your-prowlarr-domain>`
- qBittorrent: `http://<your-torrent-domain>`

## Stop the services

```bash
./stop.sh
```

## Useful checks

See which containers are running:

```bash
docker compose ps
```

View logs for a service:

```bash
docker compose logs -f <service-name>
```

## Notes

- The `start.sh` script generates Nginx configs from `nginx/*.conf`, validates them, reloads Nginx, and then starts the containers.
- App data for this setup is kept under `config/`.
- The main compose file is `docker-compose.yml`.
