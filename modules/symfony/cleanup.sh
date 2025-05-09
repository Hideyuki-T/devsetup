#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/cleanup.sh：完了確認。"
docker compose exec -T app bash -c "grep DATABASE_URL /var/www/html/.env"

source "${DEVSETUP_ROOT}/modules/common/symfony.sh"

