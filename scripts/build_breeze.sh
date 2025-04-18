#!/bin/bash
# Laravel + Breeze 自動セットアップ

TARGET_PROJECT_DIR="$1"; project_name="$2"; APP_CONTAINER_NAME="${project_name}_app"
[ -z "$TARGET_PROJECT_DIR" ] && { echo "[ERROR] 引数不足(-＿-)"; exit 1; }

# バージョン確認／入力
if [ -z "$LARAVEL_VERSION" ]; then
  read -p "Laravel バージョン（例 12.*、空で最新版）: " ver
  LARAVEL_VERSION="${ver}"             # ← デフォルトを付けない
fi
[ "$LARAVEL_VERSION" = "latest" ] && LARAVEL_VERSION=""

echo "[INFO] Laravel(${LARAVEL_VERSION:-latest}) & Breeze を導入"
docker exec -it "$APP_CONTAINER_NAME" bash -c "\
  if [ -z \"$LARAVEL_VERSION\" ]; then \
    composer create-project laravel/laravel /var/www/html ; \
  else \
    composer create-project laravel/laravel /var/www/html \"$LARAVEL_VERSION\" ; \
  fi && \
  cd /var/www/html && \
  composer require laravel/breeze --dev && \
  php artisan breeze:install && \
  npm install && npm run build"

# マイグレーション
read -p "Breeze マイグレーションを実行しますか？|д´)ﾁﾗｯ (Y/n): " mig
mig=$(echo "$mig" | tr '[:upper:]' '[:lower:]')
[[ "$mig" =~ ^(y|yes|)$ || -z "$mig" ]] && \
  docker exec -it "$APP_CONTAINER_NAME" php /var/www/html/artisan migrate:fresh --force

echo "[SUCCESS] Breeze "
exit 0
