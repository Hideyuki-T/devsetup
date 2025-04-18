#!/usr/bin/env bash
# Docker モジュール：初期化フェーズ

log_info "modules/docker/init.sh：テンプレートをコピー中…"

# 1) docker ディレクトリをコピー
cp -R templates/php-nginx-mysql/docker ./docker

# 2) docker-compose.yml テンプレートをリネームしつつコピー
cp templates/php-nginx-mysql/docker-compose.yml.template ./docker-compose.yml

log_info "modules/docker/init.sh：コピー完了"
