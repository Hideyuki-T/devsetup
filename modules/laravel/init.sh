#!/usr/bin/env bash
set -euo pipefail
# modules/laravel/init.sh：コンテナ内で Laravel プロジェクトを src/ に生成するフェーズ

source "${DEVSETUP_ROOT}/framework/logger.sh"
log_info "modules/laravel/init.sh：Docker コンテナ内で Laravel を生成中…"

# プロジェクトルートへ移動
cd "${PROJECT_DIR}"

# 既存の src/ はコンテナ⇆ホスト両方でクリア
docker compose exec -T app bash -lc "\
  chmod -R u+rw /var/www/html/src || true && \
  rm -rf /var/www/html/src \
"

# 空の src/ をコンテナ内で再作成
docker compose exec -T app mkdir -p /var/www/html/src

# コンテナ内で composer create-project を実行
docker compose exec -T app bash -lc "\
  composer create-project laravel/laravel /var/www/html/src --quiet --remove-vcs \
"

log_info "modules/laravel/init.sh：生成完了 → src/ inside コンテナ"
