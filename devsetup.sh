#!/bin/bash
#===============================================
# devsetup.sh  –  フロント窓口(　´∀｀)ｂｸﾞｯ
#===============================================

# ヘルパー読み込み
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIR}/functions/port_checker.sh"
source "${SCRIPT_DIR}/functions/env_generator.sh"
source "${SCRIPT_DIR}/functions/compose_generator.sh"
source "${SCRIPT_DIR}/functions/logger.sh"

PROJECTS_DIR="$(dirname "${SCRIPT_DIR}")"

log_info "初期設定開始"
echo "作成したい設定を選択してくださいな。"
echo " [1] PHP + nginx + MySQL"
echo " [2] PHP + nginx + MySQL + Laravel"
echo " [3] PHP + nginx + MySQL + Laravel + Breeze"
echo " ※追加テンプレートは順次拡張予定"

# ── 選択入力 ──────────────────────────────
read -p "どれにします？: " env_choice
if [ "$env_choice" -lt 1 ] || [ "$env_choice" -gt 3 ]; then
  log_error "有効な選択肢は 1〜3 。"; exit 1
fi

read -p "プロジェクト名はどうする？: " project_name
TARGET_PROJECT_DIR="${PROJECTS_DIR}/${project_name}"
[ -d "$TARGET_PROJECT_DIR" ] && { log_error "既に存在しますね(´・ω・｀)"; exit 1; }

# ── ディレクトリ／テンプレ生成 ───────────────
mkdir -p "${TARGET_PROJECT_DIR}/"{docker,src}
TEMPLATE_DIR="${SCRIPT_DIR}/templates/php-nginx-mysql"
cp -r "${TEMPLATE_DIR}/docker" "${TARGET_PROJECT_DIR}/"

# ── Docker 用環境変数 ──────────────────────
export APP_CONTAINER_NAME="${project_name}_app"
export NGINX_CONTAINER_NAME="${project_name}_nginx"
export DB_CONTAINER_NAME="${project_name}_mysql"
export PHP_DOCKERFILE="docker/php/Dockerfile"
export DB_HOST="db"  DB_PORT="3306"  WEB_PORT="8080"
export DB_NAME="${project_name}_db" DB_USER="user" DB_PASSWORD="12345" DB_ROOT_PASSWORD="54321"
WEB_PORT=$(check_port_availability "$WEB_PORT"); export WEB_PORT
DB_PORT=$(check_port_availability "$DB_PORT"); export DB_PORT

compose_generator "${TEMPLATE_DIR}/docker-compose.yml.template" "${TARGET_PROJECT_DIR}/docker-compose.yml"
env_generator     "${TEMPLATE_DIR}/.env.template"                 "${TARGET_PROJECT_DIR}/.env"
log_info "[完了] テンプレート生成"

# ── Docker ビルド & 起動 ───────────────────
cd "${TARGET_PROJECT_DIR}"
log_info "コンテナ起動щ(ﾟдﾟщ)ｶﾓｰﾝ"
docker compose up -d --build

# ── 設定別追加処理を委譲 ───────────────────
case "$env_choice" in
  1)
    "${SCRIPT_DIR}/scripts/build_base.sh"    "$TARGET_PROJECT_DIR" "$project_name"
    ;;
  2)
    "${SCRIPT_DIR}/scripts/build_laravel.sh" "$TARGET_PROJECT_DIR" "$project_name"
    read -p "Laravel のマイグレーションを実行しますか？|ω・｀) (Y/n): " mig
    mig=$(echo "$mig" | tr '[:upper:]' '[:lower:]')
    [[ "$mig" =~ ^(y|yes|)$ || -z "$mig" ]] && \
      docker exec -it "$APP_CONTAINER_NAME" php artisan migrate:fresh --force
    ;;
  3)
    "${SCRIPT_DIR}/scripts/build_breeze.sh"  "$TARGET_PROJECT_DIR" "$project_name"
    ;;
esac

log_success "[SUCCESS] '${project_name}' "
