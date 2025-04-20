#!/usr/bin/env bash
# Docker モジュール：初期化フェーズ

log_info "[INFO]: modules/docker/init.sh：テンプレートをコピー中…"

# 出力先ディレクトリを作成
mkdir -p docker

cp -R templates/php-nginx-mysql/docker/* docker/

cp templates/php-nginx-mysql/docker-compose.yml.template docker-compose.yml.template

log_info "[SUCCESS]: modules/docker/init.sh：コピー完了"
docker compose up -d --build
log_info "[SUCCESS]: modules/docker/init.sh：コンテナが立ち上がりました"
