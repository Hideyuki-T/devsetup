#!/usr/bin/env bash
set -euo pipefail
# modules/laravel/init.sh：ホスト側で Laravel プロジェクトを src/ に生成

source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/laravel/init.sh：ホストの src/ に Laravel を生成中…"

# 古い src ディレクトリを丸ごと削除
if [ -d "${PROJECT_DIR}/src" ]; then
  log_info "modules/laravel/init.sh：既存の src/ ディレクトリを丸ごと削除します"
  rm -rf "${PROJECT_DIR}/src"
fi

# クリーンな src ディレクトリを作成
mkdir -p "${PROJECT_DIR}/src"

# Composer create-project を実行（既存 VCS 情報も除去）
composer create-project laravel/laravel "${PROJECT_DIR}/src" --quiet --remove-vcs

log_info "modules/laravel/init.sh：生成完了 → ${PROJECT_DIR}/src"
