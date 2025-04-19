#!/usr/bin/env bash
# Docker モジュール：初期化フェーズ

log_info "modules/docker/init.sh：テンプレートをコピー中…"

# 1) 作業先の docker ディレクトリを確保
mkdir -p docker

# 2) nginx と php の設定をそれぞれコピー
cp -R templates/php-nginx-mysql/docker/nginx    docker/
cp -R templates/php-nginx-mysql/docker/php      docker/

# 3) docker-compose ファイルを正しい名前で出力
cp templates/php-nginx-mysql/docker-compose.yml.template docker-compose.yml

log_info "modules/docker/init.sh：コピー完了"
