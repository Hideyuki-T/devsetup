#!/usr/bin/env bash
#Breeze モジュール設定フェーズ

log_info "[INFO]: modules/breeze/configure.sh:Breeze のインストールコマンドを実行中だよ。。。"

cd src

#Breeze の認証スキャフォールド実行
docker compose exec app php artisan breeze:install --ansi

log_info "[INFO]: modules/breeze/configure.sh: npm・vite の依存もまとめてセットアップするよ！"

docker compose exec app npm install --silent

log_info "[INFO]: modules/breeze/configure.sh: 設定フェーズ終了！"
