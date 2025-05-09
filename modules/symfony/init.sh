#!/usr/bin/env bash
set -euo pipefail

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/init.sh：事前チェックとしてコンテナ再構築を開始します。"

docker compose down --volumes --remove-orphans
docker compose build --no-cache app
docker compose up -d

# - Symfonyプロジェクトのインストール
# - PHP拡張の確認

log_info "init.sh：PHP拡張のロード状態を確認します"

PDO_EXTENSIONS=$(docker compose exec -T app php -m | grep -i pdo || true)

if ! echo "$PDO_EXTENSIONS" | grep -q 'PDO'; then
  log_error "PHP拡張 'PDO' が読み込まれてないです。Dockerfileの内容を再確認を。"
  exit 1
fi

if ! echo "$PDO_EXTENSIONS" | grep -q 'pdo_mysql'; then
  log_error "PHP拡張 'pdo_mysql' が読み込まれてないです。MySQL接続は不可能です。"
  exit 1
fi

log_info "init.sh：PHP拡張確認済み（PDO + pdo_mysql）"

cd "${PROJECT_DIR}"

log_info "init.sh：Symfony プロジェクトを作成中..."
docker compose exec -T app bash -lc "composer create-project symfony/skeleton /var/www/html --quiet --remove-vcs --ansi"
log_info "init.sh：Symfony インストール完了"
