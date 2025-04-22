#!/usr/bin/env bash
set -euo pipefail
pop_var_context(){ :; }

# 1) プロジェクトルート定義
DEVSETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 2) 共通ロジック読み込み（run_phase や log_* を提供）
source "${DEVSETUP_ROOT}/framework/core.sh"

# 3) 設定ファイルディレクトリ
CONFIG_DIR="${DEVSETUP_ROOT}/config"

# 4) default.conf の存在チェック＆読み込み
[[ -f "${CONFIG_DIR}/default.conf" ]] \
  || { echo "必須: default.conf が見つかりません (${CONFIG_DIR})"; exit 1; }
source "${CONFIG_DIR}/default.conf"

# 5) user.conf があれば読み込み
[[ -f "${CONFIG_DIR}/user.conf" ]] && source "${CONFIG_DIR}/user.conf"

# 6) 有効モジュール配列の初期化
declare -A ENABLED
declare -a ENABLED_MODULES=()
ENABLED_MODULES+=("menu")

# 7) default.conf／user.conf で有効フラグが立ったモジュールを追加
for name in docker laravel breeze; do
  [[ "${ENABLED[$name]:-false}" == "true" ]] && ENABLED_MODULES+=("$name")
done

# 8) モジュールが menu のみならお知らせ
if [[ "${#ENABLED_MODULES[@]}" -le 1 ]]; then
  log_info "有効モジュールは menu のみですよ。"
fi
