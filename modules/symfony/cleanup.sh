#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/cleanup.sh：Symfony クリーンアップフェーズ

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/cleanup.sh：不要ファイルのクリーンアップを行います"

docker compose exec -T app bash -lc "cd /var/www/html/symfony && php bin/console cache:clear"

log_info "modules/symfony/cleanup.sh：クリーンアップ完了"
