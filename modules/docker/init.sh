#!/usr/bin/env bash
# Docker モジュール：初期化フェーズ

log_info "[INFO]: modules/docker/init.sh：テンプレートをコピー中…"

# 出力先ディレクトリを作成
mkdir -p docker

cp -R templates/php-nginx-mysql/docker/* docker/

if ! [[ -d templates/php-nginx-mysql/docker ]]; then
  log_error "テンプレートが見つからないよ。。。存在を確認してください。"
  exit 1
fi

cp templates/php-nginx-mysql/docker-compose.yml.template docker-compose.yml.template

if ! command -v docker &> /dev/null; then
  log_error "Docker がインストールされてないよ〜。。。インストールしてね。"
  exit 1
fi

log_info "[SUCCESS]: modules/docker/init.sh：コピー完了"
docker compose up -d --build
log_info "[SUCCESS]: modules/docker/init.sh：コンテナが立ち上がりました"
