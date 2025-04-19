#!/usr/bin/env bash
# Laravel モジュール：設定フェーズ

log_info "modules/laravel/configure.sh：DB 接続設定を反映中…"


source config/user.conf

# .env ファイルへ書き換え
ENV_FILE="src/.env"
cp src/.env.example "$ENV_FILE"
sed -i "s/DB_HOST=.*/DB_HOST=${DB_HOST:-mysql}/" "$ENV_FILE"
sed -i "s/DB_PORT=.*/DB_PORT=${DB_PORT:-3306}/" "$ENV_FILE"
sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE:-app}/" "$ENV_FILE"
sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME:-root}/" "$ENV_FILE"
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD:-}/" "$ENV_FILE"

log_info "modules/laravel/configure.sh：.env への設定完了"
