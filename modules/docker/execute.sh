#!/usr/bin/env bash
set -euo pipefail
# Docker モジュール：実行フェーズ

log_info "modules/docker/execute.sh：コンテナをビルド＆起動中…"

(
  cd "${PROJECT_DIR}"
  docker compose down -v
  docker compose up -d --build
)

log_info "modules/docker/execute.sh：コンテナが立ち上がりました"
