#!/usr/bin/env bash
# Laravel モジュール：実行フェーズ

log_info "modules/laravel/execute.sh：依存インストールを実行中…"
cd src
composer install --no-interaction --prefer-dist
php artisan key:generate

log_info "modules/laravel/execute.sh：マイグレーションを実行中…"
php artisan migrate --force

log_info "modules/laravel/execute.sh：Laravel セットアップ完了"
