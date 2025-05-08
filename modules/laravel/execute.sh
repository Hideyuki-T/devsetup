#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/execute.sh：Artisan コマンドをコンテナ内で実行します"

cd "${PROJECT_DIR}"
# MySQL 起動待ち
for i in {1..15}; do
  if docker compose exec -T db mysqladmin ping -h db --silent; then
    log_info "MySQL が応答しました（${i}秒）"
    break
  fi
  sleep 1
done

# キー生成
docker compose exec -T app bash -lc "cd /var/www/html && php artisan key:generate --quiet"
log_info "Artisan key:generate 完了"

# マイグレート＆シード
docker compose exec -T app bash -lc "cd /var/www/html && php artisan migrate:fresh --force --seed"
log_info "Artisan migrate:fresh & seed 完了"
