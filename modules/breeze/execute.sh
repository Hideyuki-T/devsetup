#!/usr/bin/env bash
# modules/breeze/execute.sh

log_info "[INFO]: modules/breeze/execute.sh：コンテナ内で Breeze の scaffolding を実行中…"
docker compose exec app bash -lc "\
  php artisan breeze:install --ansi && \
  npm install && npm run dev && \
  php artisan migrate --force \
"

log_info "[SUCCESS]: modules/breeze/execute.sh：完了"
