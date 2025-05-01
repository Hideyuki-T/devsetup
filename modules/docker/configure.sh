### modules/docker/configure.sh
```bash
#!/usr/bin/env bash
set -euo pipefail
# modules/docker/configure.sh：Docker 設定フェーズ

log_info "modules/docker/configure.sh：使用したいポート番号を選択してください。"
read -rp "使用したいポート番号を入力してね。： " port
if ! [[ "$port" =~ ^[0-9]+$ ]]; then
  log_error "ポート番号は数字で入力してください。。。"
  exit 1
fi
log_info "modules/docker/configure.sh：ポート番号確認 -> ${port}"

# PROJECT_DIR へ移動
cd "${PROJECT_DIR}" || exit 1

# 初回だけ .env を生成
if [ ! -f ".env" ]; then
  log_info "modules/docker/configure.sh：.env ファイルを生成中…"
  cat > .env <<EOL
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:${port}
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_NAME=${PROJECT_NAME}
DB_ROOT_PASSWORD=12345
DB_USER=me
DB_PASSWORD=54321
PHP_DOCKERFILE=docker/php/Dockerfile
NGINX_CONTAINER_NAME=${PROJECT_NAME}_nginx
APP_CONTAINER_NAME=${PROJECT_NAME}_app
WEB_PORT=${port}
DB_CONTAINER_NAME=${PROJECT_NAME}_db
EOL
  log_info "modules/docker/configure.sh：.env を作成しました：${PROJECT_DIR}/.env"
else
  log_info "modules/docker/configure.sh：.env は既に存在しますので、上書きせずスキップしますね。"
fi

# docker-compose.yml を生成
log_info "modules/docker/configure.sh：docker-compose.yml を生成中…"
set -a; source .env; set +a
envsubst < "${DEVSETUP_ROOT}/templates/php-nginx-mysql/docker-compose.yml.template" \
         > docker-compose.yml
log_info "modules/docker/configure.sh：docker-compose.yml を作成しました：${PROJECT_DIR}/docker-compose.yml"
```