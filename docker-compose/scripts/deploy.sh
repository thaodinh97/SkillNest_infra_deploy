#!/bin/bash

echo "Bắt đầu Deploy SkillNest..."

# 1. Pull code infra mới nhất
git pull origin main

# 2. Pull image mới nhất từ Docker Hub 
docker-compose pull

# 3. Khởi động lại các container 
docker-compose up -d

# 4. Dọn dẹp image cũ cho nhẹ máy
docker image prune -f

echo "Deploy hoàn tất!"