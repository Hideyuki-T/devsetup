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

# 有効モジュール用配列を初期化（menu フェーズのみ）
declare -A ENABLED
declare -a ENABLED_MODULES=(menu)

# INIT フェーズ実行
run_phase init

# メニューで立てられた ENABLED[...] を反映して、モジュールリストを再構築
# 実行順序を Laravel → Docker → Breeze → OAuth に設定
INIT_MODULES=()
for mod in "${ENABLED_MODULES[@]}"; do
  [[ "$mod" != "menu" ]] && INIT_MODULES+=("$mod")
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
