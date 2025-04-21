#!/usr/bin/env bash
# modules/laravel/execute.sh：コンテナ内で依存インストール＆マイグレーション

log_info "modules/laravel/execute.sh：コンテナ内で依存インストールとマイグレーションを実行中…"

# 古いコンテナ・ボリュームを破棄
docker compose down -v

# コンテナ起動
log_info "modules/laravel/execute.sh：docker-compose を起動中…"
docker compose up -d

# DB が立ち上がるまで待機
log_info "modules/laravel/execute.sh：DBコンテナの起動待ち…"
until docker compose exec -T db mysqladmin ping -h localhost --silent; do
  sleep 1
  log_debug "DBコンテナ応答待機中…"
done

# 以降は app コンテナ内 /var/www/html に対して実行
APP="app"
WORKDIR="/var/www/html"

log_info "modules/laravel/execute.sh：Composer install…"
docker compose exec -T -w "$WORKDIR" $APP composer install --no-interaction --prefer-dist

log_info "modules/laravel/execute.sh：キー生成…"
docker compose exec -T -w "$WORKDIR" $APP php artisan key:generate

log_info "modules/laravel/execute.sh：マイグレーション実行…"
docker compose exec -T -w "$WORKDIR" $APP php artisan migrate:fresh --force

log_info "modules/laravel/execute.sh：Laravel セットアップ完了"
