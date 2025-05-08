#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/configure.sh：Symfony 設定フェーズ

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/configure.sh：Symfony 環境設定を行います"

# .env ファイルがあればコピー
ENV_FILE="${PROJECT_DIR}/symfony/.env"
if [ ! -f "$ENV_FILE" ]; then
  docker compose exec -T app bash -lc "cd /var/www/html/symfony && cp .env .env.local"
  log_info "modules/symfony/configure.sh：.env.local を生成"
fi

log_info "modules/symfony/configure.sh：設定フェーズ完了"
