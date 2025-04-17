#!/bin/bash
# Laravel 単体インストール

TARGET_PROJECT_DIR="$1"; project_name="$2"; APP_CONTAINER_NAME="${project_name}_app"
[ -z "$TARGET_PROJECT_DIR" ] && { echo "[ERROR] 引数不足(-＿-)"; exit 1; }

# バージョンを確認／入力
if [ -z "$LARAVEL_VERSION" ]; then
  read -p "Laravel バージョン（例 12.*、空なら最新を選択するよ(「・ω・)「 ｶﾞｵｰ）: " ver
  LARAVEL_VERSION="${ver:-latest}"
fi

echo "[INFO] Laravel(${LARAVEL_VERSION}) をインストール"
docker exec -it "$APP_CONTAINER_NAME" bash -c "\
  composer create-project laravel/laravel /var/www/html ${LARAVEL_VERSION}"
echo "[SUCCESS] Laravel インストール完了"
exit 0
