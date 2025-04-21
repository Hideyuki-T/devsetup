#!/usr/bin/env bash
# framework/loader.sh

source "$(dirname "${BASH_SOURCE[0]}")/core.sh"

declare -A ENABLED
declare -a ENABLED_MODULES=()

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../config" && pwd)"

# default + user.conf を読込
source "${CONFIG_DIR}/default.conf" || true
[[ -f "${CONFIG_DIR}/user.conf" ]] && source "${CONFIG_DIR}/user.conf"

ENABLED_MODULES+=("menu")

# 実行順に並べる
for name in docker laravel breeze; do
  if [[ "${ENABLED[$name]:-false}" == "true" ]]; then
    ENABLED_MODULES+=("$name")
  fi
done

# 以降フェーズごとに
for phase in init configure execute cleanup; do
  for module in "${ENABLED_MODULES[@]}"; do
    loader_call "$module" "$phase"
  done
done
