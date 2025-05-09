#!/usr/bin/env bash

set -euo pipefail

# modules/menu/init.sh：プロジェクト作成フェーズ

source "$(dirname "${BASH_SOURCE[0]}")/../../framework/logger.sh"

# 有効化フラグおよび順序付きモジュール配列
ENABLED_MODULES=()
declare -A ENABLED
export ENABLED_MODULES

# 1) 対話式でプロジェクト名を取得（既存との競合チェックも）
while true; do
  read -rp "プロジェクト名はどうしますか？: " PROJECT_NAME

  if [[ -z "$PROJECT_NAME" ]]; then
    log_warn "プロジェクト名が空です。もう一度入力してください。"
    continue
  fi

  BASE_DIR="${DEVSETUP_ROOT}/.."
  PROJECT_DIR="${BASE_DIR}/${PROJECT_NAME}"

  if [[ -d "$PROJECT_DIR" ]]; then
    log_error "『${PROJECT_NAME}』というプロジェクトは既に存在しています。別名を使用してください。"
    continue
  fi
  break
done

# 2) Projects ディレクトリ直下に一度だけ作成
BASE_DIR="${DEVSETUP_ROOT}/.."
PROJECT_DIR="${BASE_DIR}/${PROJECT_NAME}"
mkdir -p "${PROJECT_DIR}"
export PROJECT_DIR

# 3) ログ出力
log_info "modules/menu/init.sh：プロジェクトディレクトリを作成しましたよ！：${PROJECT_DIR}"

# 4) 構成メニュー表示
cat << 'EOF'
メニュー：
 [1] 8081 : docker(PHP + nginx + MySQL)
 [2] 8082 : docker(PHP + nginx + MySQL) + Laravel
 [3] 8083 : docker(PHP + nginx + MySQL) + Laravel + Breeze
 [4] 8080 : docker(PHP + nginx + MySQL) + Laravel + Breeze + OAuth
 [5] 8085 : docker(PHP + nginx + MySQL) + Symfony
EOF
read -rp "番号を選択してね。: " SELECTED

# 5) 有効化フラグ設定
case "${SELECTED}" in
  1) ENABLED[docker]=true ;;
  2) ENABLED[docker]=true; ENABLED[laravel]=true ;;
  3) ENABLED[docker]=true; ENABLED[laravel]=true; ENABLED[breeze]=true ;;
  4) ENABLED[docker]=true; ENABLED[laravel]=true; ENABLED[breeze]=true; ENABLED[oauth]=true ;;
  5) ENABLED[docker]=true; ENABLED[symfony]=true ;;
  *) log_error "無効な選択です"; exit 1 ;;
esac

# 6) 配列に追加
for mod in docker laravel symfony breeze oauth; do
  [[ "${ENABLED[$mod]:-false}" == true ]] && ENABLED_MODULES+=("$mod")
done


# 7) 優先順位に基づく並び替え
declare -a priority_order=(docker laravel symfony breeze oauth)
mapfile -t ENABLED_MODULES < <(
  for name in "${priority_order[@]}"; do
    [[ " ${ENABLED_MODULES[*]} " == *" ${name} "* ]] && printf "%s\n" "$name"
  done
)

# 有効化される構成をログに表示
function show_actives() {
  log_info "modules/menu/init.sh：有効化される構成: ${ENABLED_MODULES[*]}"
}
show_actives
