#!/usr/bin/env bash
# modules/breeze/execute.sh：実行フェーズ

log_info "[INFO]: modules/breeze/execute.sh：Breeze の scaffolding を実行中…"

# src ディレクトリに移動
cd src

# Breeze のインストール
php artisan breeze:install

# マイグレーション＋ビルド
php artisan migrate --force
npm install
npm run dev

log_info "[SUCCESS]: modules/breeze/execute.sh：Laravel Breeze セットアップ完了"
