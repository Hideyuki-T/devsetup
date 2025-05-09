#!/usr/bin/env bash
set -euo pipefail

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/init.sh：コンテナ内で symfony をインストールします。"

cd "${PROJECT_DIR}"

# composer create-project を --force オプションで上書
docker compose exec -T app bash -lc "\
  composer create-project symfony/skeleton /var/www/html --quiet --remove-vcs --ansi \
"

log_info "modules/laravel/init.sh：symfony インストール完了"
