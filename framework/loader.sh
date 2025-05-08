#!/usr/bin/env bash
set -euo pipefail

# pop_var_context の未定義エラーを無害化
pop_var_context(){ :; }

# プロジェクトルート定義
DEVSETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 共通ロジック読み込み（run_phase, log_*）
source "${DEVSETUP_ROOT}/framework/core.sh"

# 設定ファイル読み込み
CONFIG_DIR="${DEVSETUP_ROOT}/config"
[[ -f "${CONFIG_DIR}/default.conf" ]] || {
  echo "必須: default.conf が見つかりません (${CONFIG_DIR})"
  exit 1
}
source "${CONFIG_DIR}/default.conf"
[[ -f "${CONFIG_DIR}/user.conf" ]] && source "${CONFIG_DIR}/user.conf"

 # 初期フェーズとして必ず menu モジュールを実行させる
declare -A ENABLED            # メニュー選択用フラグ
declare -a ENABLED_MODULES=(menu)  # 最初は menu モジュールのみ
export ENABLED_MODULES

# INIT フェーズ実行
run_phase init

 # メニューで立てられた ENABLED[...] を優先順位順に並べ替え
 INIT_MODULES=()
 declare -a priority_order=(docker laravel breeze oauth symfony)
 for name in "${priority_order[@]}"; do
   if [[ " ${ENABLED_MODULES[*]} " == *" ${name} "* ]]; then
     INIT_MODULES+=("$name")
   fi
 done

# 各モジュールのフルライフサイクル実行
 log_info "=== MODULE フルライフサイクル実行 開始 ==="
 for mod in "${INIT_MODULES[@]}"; do
   log_info "=== ${mod} モジュール開始 ==="
   for phase in init configure execute cleanup; do
     log_info "→ ${mod}：${phase} フェーズ実行"
     source "${DEVSETUP_ROOT}/modules/${mod}/${phase}.sh"
   done
   log_info "=== ${mod} モジュール終了 ==="
 done
 log_info "=== 全 MODULE ライフサイクル実行 終了 ==="
