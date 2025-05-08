#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/execute.sh：MySQL 起動待ち"
for i in {1..15}; do
  if docker compose exec -T db mysqladmin ping -h db --silent; then
    log_info "MySQL が応答しました（${i}秒）"
    break
  fi
  sleep 1
done

log_info "modules/symfony/execute.sh：Doctrine データベース作成"
docker compose exec -T app bash -lc "\
  cd /var/www/html/symfony && \
  php bin/console doctrine:database:create --if-not-exists \
"

log_info "modules/symfony/execute.sh：マイグレーション実行"
docker compose exec -T app bash -lc "\
  cd /var/www/html/symfony && \
  php bin/console doctrine:migrations:migrate --no-interaction \
"

log_info "modules/symfony/execute.sh：Symfony 実行フェーズ完了"
