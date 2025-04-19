#!/usr/bin/env bash
# Docker モジュール：設定フェーズ

# envsubst の存在チェック
if ! command -v envsubst &> /dev/null; then
  log_error "envsubst が見つかりません。"
  exit 1
fi

# ポート番号の入力
log_info "modules/docker/configure.sh：ポート番号を選択してね。"
read -rp "使用したいポート番号を入力してね。： " port

# .env の生成
log_info "modules/docker/configure.sh：.env を生成中…"
cat > .env <<EOL
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:$port
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=root
DB_PASSWORD=
PHP_DOCKERFILE=docker/php/Dockerfile
NGINX_CONTAINER_NAME=nginx
APP_CONTAINER_NAME=app
WEB_PORT=$port
DB_CONTAINER_NAME=mysql
DB_ROOT_PASSWORD=
EOL

log_info "modules/docker/configure.sh：設定完了 (.env にポート $port を反映しました)"

# docker-compose.yml の生成
log_info "modules/docker/configure.sh：docker-compose.yml を生成中…"
rm -f docker-compose.yml
set -o allexport
source .env
set +o allexport

envsubst < templates/php-nginx-mysql/docker-compose.yml.template > docker-compose.yml
log_info "modules/docker/configure.sh：docker-compose.yml を生成しました。"
