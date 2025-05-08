#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

function run_phase() {
  local phase="$1"
  log_info "=== ${phase^^} フェーズ開始 ==="

  # フェーズごとのモジュール順序を決める
  local mods=()
  if [[ "$phase" == "execute" ]]; then
    # Docker を先頭に固定
    mods=( docker "${ENABLED_MODULES[@]/docker}" )
  else
    # init/configure/cleanup はメニュー選択のまま
    mods=( "${ENABLED_MODULES[@]}" )
  fi

  # 各モジュールのスクリプト実行
  for module in "${mods[@]}"; do
    local script="$DEVSETUP_ROOT/modules/${module}/${phase}.sh"
    if [[ -f "$script" && -x "$script" ]]; then
      log_info "→ ${module}：${phase} 実行"
      source "$script"
    else
      log_debug "→ ${module}：${phase} スキップ（${script} が見つからないよ）"
    fi
  done

  log_info "=== ${phase^^} フェーズ終了 ==="
}
