#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/init.sh：ホスト上の symfony ディレクトリをリセット"
rm -rf "${PROJECT_DIR}/symfony"

log_info "modules/symfony/init.sh：コンテナ内の symfony ディレクトリもリセット"
docker compose exec -T app bash -lc 'rm -rf /var/www/html/symfony'

log_info "modules/symfony/init.sh：コンテナ内で Symfony プロジェクトを作成します"
(
  cd "${PROJECT_DIR}"
  docker compose exec -T app bash -lc "\
    composer create-project symfony/website-skeleton symfony \
      --no-interaction --quiet --no-scripts \
  "
)
log_info "modules/symfony/init.sh：Symfony プロジェクト作成完了"
