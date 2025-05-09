#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

# - .env.local.php 再生成
# - キャッシュクリア

log_info "execute.sh：.env.local.php を削除します"
docker compose exec -T app bash -c 'rm -f /var/www/html/.env.local.php'

log_info "execute.sh：.env.local.php を再生成します"
docker compose exec -T app bash -lc 'cd /var/www/html && composer dump-env dev'

log_info "execute.sh：Symfony キャッシュをクリアします"
docker compose exec -T app bash -lc 'cd /var/www/html && php bin/console cache:clear'
