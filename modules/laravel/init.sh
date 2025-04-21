#!/usr/bin/env bash
# modules/laravel/init.sh：ホスト上で Laravel プロジェクトを作成

log_info "modules/laravel/init.sh：ホスト上で Laravel プロジェクトを作成中…"

PROJECT_DIR="./src"
LARAVEL_VER="${LARAVEL_VERSION:-12.*}"

# src ディレクトリが残っていたら消しておく
rm -rf "$PROJECT_DIR"

# ホスト上で create-project → ./src に展開
composer create-project laravel/laravel "$PROJECT_DIR" "$LARAVEL_VER" --prefer-dist

log_info "modules/laravel/init.sh：完了 (プロジェクトは $PROJECT_DIR に作成されました)"
