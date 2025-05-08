#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/cleanup.sh：後始末フェーズ

log_info "modules/symfony/cleanup.sh：不要ファイルの整理を行います…"

# 空の README を作成しておく
touch "${SYMFONY_DIR}/README.md"

# パーミッション調整（必要に応じて）
chmod -R 755 "${SYMFONY_DIR}/public"

log_info "modules/symfony/cleanup.sh：整理完了"
