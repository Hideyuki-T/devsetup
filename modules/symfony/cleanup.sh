#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/cleanup.sh：後始末フェーズ

log_info "modules/symfony/cleanup.sh：不要ファイルの整理を行います…"

# 空の README を作成しておく
touch "${SYMFONY_DIR}/README.md"

# パーミッション調整：public ディレクトリが存在する場合のみ
if [ -d "${SYMFONY_DIR}/public" ]; then
  chmod -R 755 "${SYMFONY_DIR}/public"
  log_info "modules/symfony/cleanup.sh：public ディレクトリのパーミッションを調整しました"
else
  log_info "modules/symfony/cleanup.sh：public ディレクトリが存在しないため、スキップします"
fi

log_info "modules/symfony/cleanup.sh：整理完了"
