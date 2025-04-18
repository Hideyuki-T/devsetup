#!/user/bin/env bash

declare -A ENABLED
dealare -a ENABLED_MODULES=()

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../config" && pwd)"
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../modules" && pwd)"

source "${CONFIG_DIR}/default.conf" || true
[[ -f "${CONFIG_DIR}/user.conf" ]] && source "${CONFIG_DIR}/user.conf"

for dir in "$MODULE_DIR"/*; do
  name="$(basename "$dir")"
  if [[ "${ENABLED[$name]:-false}" == "true" ]]; then
    ENABLED_MODULES+=("$name")
  fi
done

