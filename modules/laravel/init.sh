#!/usr/bin/env bash
# modules/laravel/init.sh：Dockerコンテナ内で Laravel プロジェクトを作成

log_info "modules/laravel/init.sh：Docker コンテナ内で Laravel プロジェクトを作成中…"

APP_CONTAINER_NAME="${APP_CONTAINER_NAME:-app}"
PROJECT_DIR="/var/www/html"
LARAVEL_VER="${LARAVEL_VERSION:-12.*}"

# コンテナ内の src ディレクトリ削除
docker exec "$APP_CONTAINER_NAME" rm -rf "$PROJECT_DIR"

# Laravel プロジェクト作成
docker exec "$APP_CONTAINER_NAME" composer create-project laravel/laravel "$PROJECT_DIR" "$LARAVEL_VER" --prefer-dist

# パーミッション修正
docker exec "$APP_CONTAINER_NAME" chown -R www-data:www-data "$PROJECT_DIR"

log_info "modules/laravel/init.sh：完了（$APP_CONTAINER_NAME 内に Laravel プロジェクトを作成しました）"
