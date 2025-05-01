#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

function run_phase() {
  local phase="$1"
  log_info "=== ${phase^^} フェーズ開始 ==="

      # フェーズごとに適切な順序を再構築
      local mods=("${ENABLED_MODULES[@]}")

      if [[ "$phase" == "execute" ]]; then
        # Execute フェーズは docker を先頭に
        mods=(docker "${mods[@]/docker}")
      elif [[ "$phase" == "init" ]]; then
        # Init フェーズは laravel を先頭に（既に並んでいる場合は不要だけど保険）
        mods=(laravel "${mods[@]/laravel}")
      fi

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
