#!/usr/bin/env bash
# Laravel モジュール：設定フェーズ

# 1) init で作成した .env を読み込む
if [[ -f .env ]]; then
  source .env
else
  log_error "modules/laravel/configure.sh: .envが見つからないよ。。。"
  exit 1
fi

# 2) 作業ディレクトリへ移動
log_info "modules/laravel/configure.sh: DB 接続設定を反映中。。。"

# .env.example をコピー
cd .env.example .env 2>/dev/null || true

# sed でDB を更新
sed -i '' "s/^DB_CONNECTION=.*/DB_CONNECTION=mysql/" .env

log_info "modules/laravel/configure.sh: .envへの設定完了！"
