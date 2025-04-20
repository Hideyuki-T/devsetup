#!/usr/bin/env bash
# modules/laravel/init.sh

log_info "[INFO]: modules/laravel/init.sh：コンテナ内で Laravel プロジェクトを作成中…"

docker compose exec app \
  composer create-project laravel/laravel /var/www/html --prefer-dist

log_info "[SUCCESS]: modules/laravel/init.sh：完了"
