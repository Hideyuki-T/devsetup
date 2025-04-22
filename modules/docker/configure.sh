#!/usr/bin/env bash
# modules/docker/configure.sh：Docker 設定フェーズ

# 1) ログ出力＋ポート番号読み取り
log_info "modules/docker/configure.sh：使用したいポート番号を選択してください。"
read -rp "使用したいポート番号を入力してね。： " port
if ! [[ "$port" =~ ^[0-9]+$ ]]; then
  log_error "ポート番号は数字で入力してくださいね"
  exit 1
fi
log_info "modules/docker/configure.sh：ポート番号確認 -> ${port}"

# 2) PROJECT_DIR へ移動して処理を完結
(
  cd "${PROJECT_DIR}"

  # 3) .env を生成
  log_info "modules/docker/configure.sh：.env ファイルを生成中…"
  cat > .env <<EOL
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:${port}
DB_CONNECTION=mysql
DB_HOST=mysql
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

  # 4) docker-compose.yml を生成
  log_info "modules/docker/configure.sh：docker-compose.yml を生成中…"
  set -a; source .env; set +a
  envsubst < "${DEVSETUP_ROOT}/templates/php-nginx-mysql/docker-compose.yml.template" \
           > docker-compose.yml
  log_info "modules/docker/configure.sh：docker-compose.yml を作成しました：${PROJECT_DIR}/docker-compose.yml"
)
