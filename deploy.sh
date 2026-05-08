#!/bin/bash

set -e

cd ~/my-web-app || exit 1

git pull origin main

docker compose pull
docker compose up -d --build
