#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"
source "${DEVSETUP_ROOT}/functions/env_generator.sh"

SYM_DIR="${PROJECT_DIR}/symfony"

log_info "modules/symfony/configure.sh：.env の準備"
if [[ ! -f "${SYM_DIR}/.env" ]]; then
  if [[ -f "${SYM_DIR}/.env.dist" ]]; then
    cp "${SYM_DIR}/.env.dist" "${SYM_DIR}/.env"
    log_info "modules/symfony/configure.sh：.env を .env.dist から生成しました"
  else
    log_error "modules/symfony/configure.sh：.env.dist が見つかりません (${SYM_DIR}/.env.dist)"
    exit 1
  fi
else
  log_info "modules/symfony/configure.sh：.env は既に存在します"
fi

log_info "modules/symfony/configure.sh：Doctrine ORM パックをインストールします"
cd "${PROJECT_DIR}"
docker compose exec -T app bash -lc "\
  cd /var/www/html/symfony && \
  composer require symfony/orm-pack doctrine/doctrine-migrations-bundle --no-interaction --quiet \
"

# 環境変数 DATABASE_URL を .env にセット
DB_URL="mysql://${DB_USER:-me}:${DB_PASSWORD:-54321}@db:${DB_PORT:-3306}/${DB_NAME:-test5}?serverVersion=8.0"
add_env_var "DATABASE_URL" "${DB_URL}" "${SYM_DIR}/.env"
log_info "modules/symfony/configure.sh：.env への DATABASE_URL 設定完了"
