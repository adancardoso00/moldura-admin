#!/bin/bash
set -e

echo "🚀 Deploy MolduraSaaS Admin..."

# Pull latest
git pull origin main

# Rebuild e sobe
docker compose down
docker compose build --no-cache
docker compose up -d

echo "✅ Admin no ar em https://admin.adan.company"
