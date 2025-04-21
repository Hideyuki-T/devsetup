#!/usr/bin/env bash
# modules/breeze/configure.sh：設定フェーズ

log_info "[INFO]: modules/breeze/configure.sh：Docker コンテナ内で Breeze UI をインストール中..."

APP="${APP_CONTAINER_NAME:-app}"
WORKDIR="/var/www/html"

# Breeze のスキャフォールをBladeで構築中
docker compose exec -T -w "$WORKDIR" "$APP" php artisan breeze:install blade

# フロントエンドビルド
docker compose exec -T -w "$WORKDIR" "$APP" npm install
docker compose exec -T -w "$WORKDIR" "$APP" npm run build

log_info "[SUCCESS]: modules/breeze/configure.sh：Breeze UI セットアップ完了！""
