#!/bin/bash
#=========================================
# build_laravel.sh  –  Laravel 単体セットアップ
#=========================================

TARGET_PROJECT_DIR="$1"
project_name="$2"
APP_CONTAINER_NAME="${project_name}_app"

[ -z "$TARGET_PROJECT_DIR" ] && { echo "[ERROR] 引数不足 (-＿-)"; exit 1; }

#── バージョン決定 ────────────────────────────
if [ -z "$LARAVEL_VERSION" ]; then
  read -p "Laravel バージョン（例 12.*、空で最新版）: " ver
  LARAVEL_VERSION="${ver}"
fi
# 'latest' と書かれたら空に変換（Composer が理解）
[ "$LARAVEL_VERSION" = "latest" ] && LARAVEL_VERSION=""

echo "[INFO] Laravel(${LARAVEL_VERSION:-latest}) をインストール"

#── コンテナ内でインストール ───────────────────
docker exec -it "$APP_CONTAINER_NAME" bash -c "\
  if [ -z \"$LARAVEL_VERSION\" ]; then
    composer create-project laravel/laravel /var/www/html
  else
    composer create-project laravel/laravel /var/www/html \"$LARAVEL_VERSION\"
  fi"

echo "[SUCCESS] Laravel "
exit 0
