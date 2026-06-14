#!/usr/bin/env bash

set -e

if [ ! -f .env ]; then
  echo ".env file not found"
  exit 1
fi

source .env

mkdir -p nginx/generated

echo "Generating nginx configs..."

for file in nginx/*.conf; do
  filename=$(basename "$file")
  envsubst < "$file" > "nginx/generated/$filename"
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