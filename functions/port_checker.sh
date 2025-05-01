#!/usr/bin/env bash
set -e

source "${DEVSETUP_ROOT}/framework/logger.sh"

check_port_availability() {
 local port="$1"
  while lsof -i TCP:"${port}" -sTCP:LISTEN >/dev/null 2>&1; do
    log_warn "ポート　${port} は使用中なので +1して設定します。"
    port=$((port + 1))
    done
    echo "$port"
}
