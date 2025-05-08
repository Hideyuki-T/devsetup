#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/init.sh：Symfony プロジェクト準備フェーズ

log_info "modules/symfony/init.sh：Symfony プロジェクトの雛形を準備します…"

# 既存の公開用ディレクトリを削除し、新規 public を確保
rm -rf "${PROJECT_DIR}/public"
mkdir -p "${PROJECT_DIR}/public"

rm -rf "${PROJECT_DIR}/src"

# Symfony 用に app を生成
mkdir -p "${PROJECT_DIR}/app"
export SYMFONY_DIR="${PROJECT_DIR}/app"

log_info "modules/symfony/init.sh：雛形ディレクトリを作成しました：${SYMFONY_DIR}"
