#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/configure.sh：コンテナ内で .env 設定フェーズ開始"

cd "${PROJECT_DIR}"

# ❶ .env.example → src/.env を生成（まだ無ければ）
docker compose exec -T app bash -lc "\
  if [ -f /var/www/html/src/.env.example ] && [ ! -f /var/www/html/src/.env ]; then
    echo '→ .env.example → src/.env を生成'
    cp /var/www/html/src/.env.example /var/www/html/src/.env
  fi
"

# ❷ DB_DATABASE を sed で書き換え（拡張子なし -i）
docker compose exec -T app bash -lc "\
  sed -i 's/^DB_DATABASE=.*/DB_DATABASE=${PROJECT_NAME}/' /var/www/html/src/.env
"

log_info "modules/laravel/configure.sh：コンテナ内で src/.env の調整完了"
