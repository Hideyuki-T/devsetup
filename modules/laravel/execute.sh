#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/execute.sh：コンテナ内 Artisan 実行フェーズ開始"

cd "${PROJECT_DIR}"

# MySQL 準備待ち
for i in {1..15}; do
  if docker compose exec -T db mysqladmin ping -h db --silent; then
    log_info "MySQL が応答しました（${i} 秒経過）"
    break
  fi
  log_debug "MySQL 未準備…待機中 (${i}/15)"
  sleep 1
  if (( i == 15 )); then
    log_error "MySQL が応答しませんでした。"
    exit 1
  fi
done

# key:generate
docker compose exec -T app bash -lc "\
  cd /var/www/html/src && php artisan key:generate --quiet
"
log_info "キー生成完了"

# ③ migrate:fresh & seed
docker compose exec -T app bash -lc "\
  cd /var/www/html/src && php artisan migrate:fresh --force --seed
"
log_info "migrate:fresh とシード完了"

log_info "modules/laravel/execute.sh：コンテナ内 Artisan フェーズ完了"
