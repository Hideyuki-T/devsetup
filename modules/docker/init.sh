#!/usr/bin/env bash

set -euo pipefail
# modules/docker/init.sh：Docker 初期化フェーズ

log_info "modules/docker/init.sh：テンプレートをコピー中…"

# 1) プロジェクト内に docker ディレクトリを作成
mkdir -p "${PROJECT_DIR}/docker"

# 2) Dockerfile 等をホスト側テンプレートからコピー
cp -R "${DEVSETUP_ROOT}/templates/php-nginx-mysql/docker/"* "${PROJECT_DIR}/docker/"

log_info "modules/docker/init.sh：コピー完了 （docker ディレクトリのみ）"
