#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/cleanup.sh：後始末フェーズ

log_info "modules/symfony/cleanup.sh：不要ファイルの整理を行います…"

# README を app 配下に配置
touch "${PROJECT_DIR}/app/README.md"

# 権限調整：app/public が存在する場合のみ
if [ -d "${PROJECT_DIR}/app/public" ]; then
  chmod -R 755 "${PROJECT_DIR}/app/public"
  log_info "modules/symfony/cleanup.sh：app/public のパーミッションを調整しました"
else
  log_info "modules/symfony/cleanup.sh：app/public が存在しないため、スキップします"
fi

log_info "modules/symfony/cleanup.sh：整理完了"
