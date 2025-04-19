# modules/laravel/execute.sh
#!/usr/bin/env bash
# Laravel モジュール：実行フェーズ

log_info "modules/laravel/execute.sh：コンテナ内で依存インストールとマイグレーションを実行中…"

# Docker サービス起動
docker compose up -d

# DB コンテナの応答待機
log_info "modules/laravel/execute.sh：DBコンテナの起動待ち…"
until docker compose exec db mysqladmin ping -h mysql --silent; do
  sleep 1
  log_debug "DBコンテナ応答待機中…"
done

# Composer install
log_info "modules/laravel/execute.sh：依存インストールを実行中…"
docker compose exec app composer install --no-interaction --prefer-dist

# アプリケーションキー生成
docker compose exec app php artisan key:generate

# マイグレーション実行（開発向けリフレッシュ）
log_info "modules/laravel/execute.sh：マイグレーションをリフレッシュ実行…"
docker compose exec app php artisan migrate:fresh --force

log_info "modules/laravel/execute.sh：Laravel セットアップ完了"
