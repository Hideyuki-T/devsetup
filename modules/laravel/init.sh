#!/usr/bin/env bash

set -euo pipefail
# modules/laravel/init.sh：ホスト側で Laravel プロジェクトを src/ に生成

log_info "modules/laravel/init.sh：ホストの src/ に Laravel を生成中…"

# PROJECT_DIR/src に Laravel ルートをインストール
composer create-project laravel/laravel "${PROJECT_DIR}/src" --quiet

log_info "modules/laravel/init.sh：生成完了 → ${PROJECT_DIR}/src"
