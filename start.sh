#!/usr/bin/env bash

set -e

if [ ! -f .env ]; then
  echo ".env file not found"
  exit 1
fi

# If config directory exists, assume initial setup is already done
if [ -d "config" ]; then
  echo "Existing config directory detected. Skipping nginx setup..."

  docker compose pull
  docker compose up -d

  echo
  docker ps

  exit 0
fi

set -a
source .env
set +a

required_vars=(
  JELLYFIN_DOMAIN
  REQUEST_DOMAIN
  SONARR_DOMAIN
  RADARR_DOMAIN
  PROWLARR_DOMAIN
  TORRENT_DOMAIN
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Missing required variable: $var"
    echo "Update .env before starting the stack."
    exit 1
  fi
done

mkdir -p nginx/generated

echo "Generating nginx configs..."

for file in nginx/*.conf; do
  filename=$(basename "$file")
  envsubst '${JELLYFIN_DOMAIN} ${REQUEST_DOMAIN} ${SONARR_DOMAIN} ${RADARR_DOMAIN} ${PROWLARR_DOMAIN} ${TORRENT_DOMAIN}' < "$file" > "nginx/generated/$filename"
done

echo "Creating nginx symlinks..."

for file in nginx/generated/*.conf; do
  filename=$(basename "$file")

  sudo ln -sfn \
    "$(pwd)/$file" \
    "/etc/nginx/sites-enabled/$filename"
done

echo "Validating nginx config..."
sudo nginx -t

echo "Reloading nginx..."
sudo systemctl reload nginx

echo "Starting containers..."

docker compose pull
docker compose up -d

echo
docker ps