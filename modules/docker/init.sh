#!/usr/bin/env bash
# Docker モジュール：初期化フェーズ

log_info "modules/docker/init.sh：テンプレートをコピー中…"

# 出力先ディレクトリを作成
mkdir -p "${PROJECT_DIR}/docker"

# Dockerfile 等をコピー
cp -R "${DEVSETUP_ROOT}/templates/php-nginx-mysql/docker/"* "${PROJECT_DIR}/docker/"

# docker-compose テンプレートは一旦プロジェクト直下に置く
cp "${DEVSETUP_ROOT}/templates/php-nginx-mysql/docker-compose.yml.template" \
   "${PROJECT_DIR}/docker-compose.yml.template"

log_info "modules/docker/init.sh：コピー完了"
