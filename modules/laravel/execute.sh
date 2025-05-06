#!/usr/bin/env bash
set -euo pipefail
# modules/laravel/execute.sh：Laravel 実行フェーズ

log_info "modules/laravel/execute.sh：Artisan 処理の前に DB の準備を待機中…"

(
  cd "${PROJECT_DIR}"

  # ① Docker コンテナが立ち上がったあと MySQL の準備完了を待つ
  for i in {1..15}; do
    if docker compose exec -T db mysqladmin ping -h db --silent; then
      log_info "MySQL が応答しました（${i}秒経過）"
      break
    fi
    log_debug "MySQL 未準備…待機中 (${i}/15)"
    sleep 1
    if (( i == 15 )); then
      log_error "応答しませんね……"
      exit 1
    fi
  done

  # ② アプリケーションキー生成
  docker compose exec app php artisan key:generate
  log_info "キー生成完了"

  # ③ 全テーブルをリセット＆再作成＋シード
  docker compose exec app php artisan migrate:fresh --force --seed
  log_info "migrate:fresh でテーブルをまっさらにして再作成しましたよ！"
)
