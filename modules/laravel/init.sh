#!/usr/bin/env bash
# modules/laravel/init.sh

# 1) プロジェクト名とlaravelバージョンを読み込む
read -rp "Project name: " PROJECT
read -rp "Laravel version (default: 12.*):" VERSION
VERSION=${VERSION:-12.*}

log_info "[INFO]: modules/laravel/init.sh: コンテナ内で laravelプロジェクトを作成中"

# 2) コンテナ内で create-project を実行
docker compose exec app \
  composer create-project laravel/laravel "/var/html/www/${PROJECT}" "${VERSION}" --prefer-dist
log_info "[SUCCESS]: modules/laravel/init.sh:完了 (./${PROJECT}に Laravel ${VERSION} を生成したよ。)"
