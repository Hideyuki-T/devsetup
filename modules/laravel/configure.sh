#!/usr/bin/env bash
# modules/laravel/configure.sh：ホスト側の .env を src/ で調整

log_info "modules/laravel/configure.sh：.env を調整中…"

# .env.example → .env
cp "${PROJECT_DIR}/src/.env.example" "${PROJECT_DIR}/src/.env"

# DB 名を sed で書き換え
sed -i '' "s/^DB_DATABASE=.*/DB_DATABASE=${PROJECT_NAME}/" \
        "${PROJECT_DIR}/src/.env"

log_info "modules/laravel/configure.sh：src/.env の DB_DATABASE を更新しました！"
