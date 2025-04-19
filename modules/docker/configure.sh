# modules/docker/configure.sh
#!/usr/bin/env bash
# Docker モジュール：設定フェーズ

log_info "modules/docker/configure.sh：ポート番号を選択してね。"
read -rp "使用したいポート番号を入力してね。： " port

log_info "modules/docker/configure.sh：.env を生成中…"
cat > .env <<EOL
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:${port}
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_NAME=app
# ルートユーザーの固定パスワード
DB_ROOT_PASSWORD=12345
# 一般ユーザー "me" の固定認証情報
DB_USER=me
DB_PASSWORD=54321
PHP_DOCKERFILE=docker/php/Dockerfile
NGINX_CONTAINER_NAME=nginx
APP_CONTAINER_NAME=app
WEB_PORT=${port}
DB_CONTAINER_NAME=mysql
EOL

log_info "modules/docker/configure.sh：設定完了 (.env に認証情報を反映しました)"

# docker-compose.yml の再生成
log_info "modules/docker/configure.sh：docker-compose.yml を生成中…"
set -o allexport
source .env
set +o allexport

docker compose down -v

envsubst < templates/php-nginx-mysql/docker-compose.yml.template > docker-compose.yml
log_info "modules/docker/configure.sh：docker-compose.yml を生成しました。"
