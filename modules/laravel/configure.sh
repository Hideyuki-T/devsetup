#!/usr/bin/env bash
# modules/laravel/configure.sh：Docker内でLaravelの.envを設定

APP_CONTAINER_NAME="${APP_CONTAINER_NAME:-app}"
LARAVEL_DIR="/var/www/html"

log_info "[INFO]: modules/laravel/configure.sh: Laravel の .env を調整中…"

# Laravelディレクトリ内に .env がなければ .env.example をコピー
docker exec "$APP_CONTAINER_NAME" bash -c "if [[ ! -f $LARAVEL_DIR/.env ]]; then cp $LARAVEL_DIR/.env.example $LARAVEL_DIR/.env; fi"

# DB設定を sed で書き換える
docker exec "$APP_CONTAINER_NAME" sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' "$LARAVEL_DIR/.env"
docker exec "$APP_CONTAINER_NAME" sed -i 's/^DB_HOST=.*/DB_HOST=mysql/' "$LARAVEL_DIR/.env"
docker exec "$APP_CONTAINER_NAME" sed -i 's/^DB_PORT=.*/DB_PORT=3306/' "$LARAVEL_DIR/.env"
docker exec "$APP_CONTAINER_NAME" sed -i 's/^DB_DATABASE=.*/DB_DATABASE=app/' "$LARAVEL_DIR/.env"
docker exec "$APP_CONTAINER_NAME" sed -i 's/^DB_USERNAME=.*/DB_USERNAME=me/' "$LARAVEL_DIR/.env"
docker exec "$APP_CONTAINER_NAME" sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=54321/' "$LARAVEL_DIR/.env"

# アプリケーションキーの生成
docker exec "$APP_CONTAINER_NAME" php "$LARAVEL_DIR/artisan" key:generate

log_info "[SUCCESS]: modules/laravel/configure.sh：.env 設定とキー生成が完了"
