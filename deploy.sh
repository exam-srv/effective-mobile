#!/bin/bash
set -e

echo "Запуск deploy $(date)"

cd "$(git rev-parse --show-toplevel)" || exit 1

git pull origin main

docker compose pull
docker compose up -d --build

sleep 5

echo "healthcheck"
RESPONSE=$(curl -s --max-time 10 http://localhost)
if [[ "$RESPONSE" == *"Hello from Effective Mobile!"* ]]; then
  echo "Deploy successful! Response: $RESPONSE"
else
  echo "Health check failed, got: $RESPONSE"
  exit 1
fi

echo "Deploy finished at $(date)"
