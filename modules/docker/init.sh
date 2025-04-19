#!/usr/bin/env bash
# Docker モジュール：初期化フェーズ

log_info "modules/docker/init.sh：テンプレートをコピー中…"

# 出力先ディレクトリを作成
mkdir -p docker

# 1) templates から docker 内のファイルをコピー
cp -R templates/php-nginx-mysql/docker/* docker/

# 2) docker-compose テンプレートをルート直下に配置
cp templates/php-nginx-mysql/docker-compose.yml.template docker-compose.yml.template

log_info "modules/docker/init.sh：コピー完了 (docker/, docker-compose.yml.template)"
