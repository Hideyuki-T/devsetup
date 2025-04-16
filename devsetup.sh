#!/bin/bash

# ヘルパースクリプト読み込み
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${SCRIPT_DIR}/functions/port_checker.sh"
source "${SCRIPT_DIR}/functions/env_generator.sh"
source "${SCRIPT_DIR}/functions/compose_generator.sh"
source "${SCRIPT_DIR}/functions/logger.sh"

PROJECTS_DIR="$(pwd)/projects"

log_info "初期設定開始"
echo "作成したい設定を選択してくださいな。"
echo " [1] PHP + nginx + MySQL"
echo " 追加したい設定はここに "

read -p "どれにしますか？:" env_choice

if [ "$env_choice" -ne 1 ]; then
  log_error "今は 1 だけだよ。"
  exit 1
fi
read -p "プロジェクト名はどうする？: " project_name
TARGET_PROJECT_DIR="${PROJECTS_DIR}/${project_name}"

if [ -d "${TARGET_PROJECT_DIR}" ]; then
  log_error "プロジェクト '${project_name}' は既にあるよ。"
  exit 1
fi

mkdir -p "${TARGET_PROJECT_DIR}/docker"
mkdir -p "${TARGET_PROJECT_DIR}/src"
log_info "プロジェクトディレクトリを生成したよ: ${TARGET_PROJECT_DIR}"

TEMPLATE_DIR="${SCRIPT_DIR}/templates/php-nginx-mysql"
echo "DEBUG: TEMPLATE_DIR = ${TEMPLATE_DIR}"
echo "DEBUG: コピー元 = ${TEMPLATE_DIR}/docker"

cp -r "${TEMPLATE_DIR}/docker" "${TARGET_PROJECT_DIR}/"

export APP_CONTAINER_NAME="${project_name}_app"
export NGINX_CONTAINER_NAME="${project_name}_nginx"
export DB_CONTAINER_NAME="${project_name}_mysql"
export PHP_DOCKERFILE="docker/php/Dockerfile"
export DB_HOST="db"
export DB_PORT="3306"
export DB_NAME="${project_name}_db"
export DB_USER="user"
export DB_PASSWORD="12345"
export DB_ROOT_PASSWORD="54321"
export WEB_PORT="8080"

WEB_PORT=$(check_port_availability "${WEB_PORT}")
export WEB_PORT
DB_PORT=$(check_port_availability "${DB_PORT}")
export DB_PORT

log_info "選択したポート番号 → webポート: ${WEB_PORT} dbポート: ${DB_PORT}"

compose_generator "${TEMPLATE_DIR}/docker-compose.yml.template" "${TARGET_PROJECT_DIR}/docker-compose.yml"
env_generator "${TEMPLATE_DIR}/.env.template" "${TARGET_PROJECT_DIR}/.env"

log_info "[完了]テンプレート設定ファイルを作成"

cd "${TARGET_PROJECT_DIR}"
log_info "コンテナ起動"
docker compose up -d --build

log_success "[完成]'${project_name}'"
