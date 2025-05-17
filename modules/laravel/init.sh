#!/usr/bin/env bash
set -euo pipefail

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/init.sh：コンテナ内で Laravel をインストールします"

cd "${PROJECT_DIR}"

read -rp "Laravel のバージョンはどうしますか？（空Enterでデフォルト: 12.*）: " USER_INPUT
LARAVEL_VERSION="${USER_INPUT:-12.*}"

if [[ -z "${LARAVEL_VERSION}" ]]; then
  log_error "LARAVEL_VERSION が空です。"
  exit 1
fi

log_info "modules/laravel/init.sh: Laravel バージョン ${LARAVEL_VERSION} を指定してインストールするよ！"

# composer create-project を実行
docker compose exec -T app bash -lc "\
  composer create-project laravel/laravel:${LARAVEL_VERSION} /var/www/html --quiet --remove-vcs --ansi \
"

log_info "modules/laravel/init.sh：Laravel インストール完了"
