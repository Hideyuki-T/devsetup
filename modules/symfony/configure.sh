#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

# - .env 書き換え

log_info "configure.sh：.env を symfony 用に整形します"

env_path="/var/www/html/.env"
database_url="DATABASE_URL=\"mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}\""

docker compose exec app bash -c "sed -i '/^DATABASE_URL=/d' ${env_path} && echo ${database_url} >> ${env_path}"
log_info "configure.sh：.env の DATABASE_URL を再定義しました ⇒ ${database_url}"
