#!/usr/bin/env bash
# modules/breeze/execute.sh：Breeze インストール＆ビルド

set -euo pipefail

# 1) プロジェクトディレクトリに移動し、.env を読み込む
cd "${PROJECT_DIR}"
if [[ -f .env ]]; then
  set -a; source .env; set +a
fi

# 2) Compose のサービスキーと実際のコンテナ名を分ける
SERVICE_KEY="app"                       # docker-compose.yml の services: 以下のキー
CONTAINER_NAME="${APP_CONTAINER_NAME}"  # .env で設定した container_name
WORKDIR="/var/www/html"

# 3) Docker コンテナをビルド＆起動
log_info "modules/breeze/execute.sh：Docker コンテナをビルド＆起動…"
docker compose up -d --build

# 4) コンテナ起動待ち（最大15秒）
for i in {1..15}; do
  if docker ps \
      --filter "name=^${CONTAINER_NAME}$" \
      --filter "status=running" \
      --format '{{.Names}}' \
    | grep -q "^${CONTAINER_NAME}$"; then
    log_info "コンテナ '${CONTAINER_NAME}' が稼働中（${i}秒経過）"
    break
  fi
  log_debug "コンテナ '${CONTAINER_NAME}' 未起動…待機中 (${i}/15)"
  sleep 1
  if (( i == 15 )); then
    log_error "コンテナ '${CONTAINER_NAME}' が一向に起動せず…"
    exit 1
  fi
done

# 5) Composer 依存追加
log_info "modules/breeze/execute.sh：Composer に laravel/breeze を追加中…"
docker compose exec -T -w "${WORKDIR}" "${SERVICE_KEY}" \
  composer require laravel/breeze --dev
log_info "modules/breeze/execute.sh：Composer 依存追加 完了"

# 6) Breeze スキャフォール生成
log_info "modules/breeze/execute.sh：artisan breeze:install 開始…"
docker compose exec -it -w "${WORKDIR}" "${SERVICE_KEY}" \
  php artisan breeze:install
log_info "modules/breeze/execute.sh：breeze:install 完了"

# 7) npm install & ビルド
log_info "modules/breeze/execute.sh：npm install 実行中…"
docker compose exec -T -w "${WORKDIR}" "${SERVICE_KEY}" \
  npm install
log_info "modules/breeze/execute.sh：npm install 完了"

log_info "modules/breeze/execute.sh：npm run build 実行中…"
docker compose exec -T -w "${WORKDIR}" "${SERVICE_KEY}" \
  npm run build
log_info "modules/breeze/execute.sh：npm build 完了"

# 8) マイグレーション
log_info "modules/breeze/execute.sh：マイグレーション実行中…"
docker compose exec -T -w "${WORKDIR}" "${SERVICE_KEY}" \
  php artisan migrate:fresh --force --seed
log_info "modules/breeze/execute.sh：マイグレーション完了"

log_info "modules/breeze/execute.sh：Breeze セットアップ完了"
