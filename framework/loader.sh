#!/usr/bin/env bash
set -euo pipefail

# pop_var_context の未定義エラー無害化
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

# INIT フェーズ実行 → menu/init.sh が走り、PROJECT_DIR などを設定
run_phase init

# メニューで立てられた ENABLED[...] を反映して、モジュールリストを再構築
MODULES=(docker laravel breeze oauth)
INIT_MODULES=(menu)
for mod in "${MODULES[@]}"; do
  [[ "${ENABLED[$mod]:-false}" == "true" ]] && INIT_MODULES+=("$mod")
done

# 各モジュールの init フェーズ（menu は不要）
log_info "=== MODULE INIT フェーズ開始 ==="
for mod in "${INIT_MODULES[@]}"; do
  [[ "$mod" == "menu" ]] && continue
  log_info "→ ${mod}：init 実行"
  source "${DEVSETUP_ROOT}/modules/${mod}/init.sh"
done
log_info "=== MODULE INIT フェーズ終了 ==="

# configure → execute → cleanup フェーズを一度ずつ実行
for phase in configure execute cleanup; do
  run_phase "$phase"
done
