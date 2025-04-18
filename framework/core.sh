#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/loader.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

function run_phase() {
  local phase="$1"
  log_info "=== ${phase^^} フェーズ開始 ==="

  for module in "${ENABLED_MODULES[@]}"; do
    local script="modules/${module}/${phase}.sh"
    if [[ -f "$script" && -x "$script" ]]; then
      log_info "-> ${module} : ${phase} 実行"
      bash "$script"
    else
      log_debug "-> ${module} : ${phase} スキップ (${script}が見つからないよ。。。)"
    fi
  done

  log_info "=== ${phase^^} フェーズ終了 ==="
}
