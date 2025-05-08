#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/execute.sh：Symfony 実行フェーズ

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/execute.sh：Symfony コマンドを実行します"

(
  cd "${PROJECT_DIR}"

  # マイグレーション適用など
  docker compose exec -T app bash -lc "cd /var/www/html/symfony && php bin/console doctrine:database:create --if-not-exists"
  docker compose exec -T app bash -lc "cd /var/www/html/symfony && php bin/console doctrine:migrations:migrate --no-interaction"

  log_info "modules/symfony/execute.sh：Doctrine マイグレーション実行完了"
)
