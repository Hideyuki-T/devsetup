#!/usr/bin/env bash
# modules/breeze/execute.sh

APP="${APP_CONTAINER_NAME:-app}"
WORKDIR="/var/www/html"

log_info "[INFO]: modules/breeze/execute.sh：Breeze フロントビルド＆マイグレーションを実行中…"

docker compose exec -T -w "$WORKDIR" "$APP" bash -lc "\
  npm run dev && \
  php artisan migrate --force \
"

log_info "[SUCCESS]: modules/breeze/execute.sh：実行完了！"
