#!/bin/bash
set -e

cd "$(git rev-parse --show-toplevel)" || exit 1

git pull origin main

docker compose pull
docker compose up -d --build
