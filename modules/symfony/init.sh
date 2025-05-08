#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/init.sh：Symfony プロジェクトの初期生成フェーズ

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/init.sh：コンテナ内で Symfony プロジェクトを生成します"

# プロジェクトルートへ移動
cd "${PROJECT_DIR}"

# 既存の symfony ディレクトリを削除（権限調整を含む）
docker compose exec -T app bash -lc "chmod -R u+rw /var/www/html/symfony || true && rm -rf /var/www/html/symfony"

# symfony ディレクトリを再作成
docker compose exec -T app mkdir -p /var/www/html/symfony

# コンテナ内で Symfony Skeleton をインストール
docker compose exec -T app bash -lc "composer create-project symfony/skeleton /var/www/html/symfony --quiet"

log_info "modules/symfony/init.sh：Symfony プロジェクト生成完了 → symfony/ inside コンテナ"
