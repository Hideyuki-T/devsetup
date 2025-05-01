#!/usr/bin/env bash
set -euo pipefail

# modules/menu/init.sh：プロジェクト作成フェーズ

source "$(dirname "${BASH_SOURCE[0]}")/../../framework/logger.sh"

# 有効化フラグおよび順序付きモジュール配列
ENABLED_MODULES=()
declare -A ENABLED
export ENABLED_MODULES

# 1) 対話式でプロジェクト名を取得
read -rp "プロジェクト名はどうしますか？: " PROJECT_NAME

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
 [1] PHP + nginx + MySQL
 [2] PHP + nginx + MySQL + Laravel
 [3] PHP + nginx + MySQL + Laravel + Breeze
 [4] PHP + nginx + MySQL + Laravel + Breeze + OAuth
EOF
read -rp "番号を選択してね。: " SELECTED

# 5) 有効化フラグ設定
case "${SELECTED}" in
  1) ENABLED[docker]=true ;;
  2) ENABLED[docker]=true; ENABLED[laravel]=true ;;
  3) ENABLED[docker]=true; ENABLED[laravel]=true; ENABLED[breeze]=true ;;
  4) ENABLED[docker]=true; ENABLED[laravel]=true; ENABLED[breeze]=true; ENABLED[oauth]=true ;;
  *) log_error "無効な選択です"; exit 1 ;;
esac

# 有効化される構成をログに表示
function show_actives() {
  local a=()
  for m in "${!ENABLED[@]}"; do
    [[ "${ENABLED[$m]}" == true ]] && a+=("$m")
  done
  log_info "modules/menu/init.sh：有効化される構成: ${a[*]}"
}
show_actives

# 6) 配列に追加
for mod in "${!ENABLED[@]}"; do
  if [[ "${ENABLED[$mod]}" == true ]] && [[ ! " ${ENABLED_MODULES[*]} " =~ " ${mod} " ]]; then
    ENABLED_MODULES+=("$mod")
  fi
done

# 7) 優先順位に基づく並び替え
declare -a priority_order=(docker laravel breeze oauth)
declare -a ordered_modules=()
for name in "${priority_order[@]}"; do
  for m in "${ENABLED_MODULES[@]}"; do
    [[ "$m" == "$name" ]] && ordered_modules+=("$m")
  done
done
ENABLED_MODULES=("${ordered_modules[@]}")
export ENABLED_MODULES
