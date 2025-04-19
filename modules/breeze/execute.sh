#!/usr/bin/env bash
# Breeze モジュール実行フェーズ

log_info "[INFO]: modules/breeze/execute.sh: ビルド・マイグレーション実行中。。。"

# Viteのビルド（開発モード）
docker compose exec app npm run dev &

docker compose exec app php artisan migrate --force

log_info "[INFO]: modules/breeze/execute.sh:Breezeセットアップ完了！"
