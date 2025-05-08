#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/init.sh：Symfony プロジェクト準備フェーズ

log_info "modules/symfony/init.sh：Symfony プロジェクトの雛形を準備します…"

# プロジェクトディレクトリ直下に Symfony 用ディレクトリを作成（任意、空ディレクトリでも可）
mkdir -p "${PROJECT_DIR}/symfony"
export SYMFONY_DIR="${PROJECT_DIR}/symfony"

log_info "modules/symfony/init.sh：雛形ディレクトリを作成しました：${SYMFONY_DIR}"
