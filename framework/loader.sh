#!/usr/bin/env bash

# ∞フレームワーク用ローダー：モジュール検出 & 設定読み込み

declare -A ENABLED
declare -a ENABLED_MODULES=()

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../config" && pwd)"
MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../modules" && pwd)"

# デフォルト設定読み込み
source "${CONFIG_DIR}/default.conf" || true
# ユーザー設定があれば上書き
[[ -f "${CONFIG_DIR}/user.conf" ]] && source "${CONFIG_DIR}/user.conf"

# --- menu は常に最優先で実行 ---
if [[ "${ENABLED[menu]:-false}" == "true" ]]; then
  ENABLED_MODULES+=("menu")
fi

# --- docker → laravel を順番に ---
for name in docker laravel; do
  if [[ "${ENABLED[$name]:-false}" == "true" ]]; then
    ENABLED_MODULES+=("$name")
  fi
done

# --- breeze は最後に実行 ---
if [[ "${ENABLED[breeze]:-false}" == "true" ]]; then
  ENABLED_MODULES+=("breeze")
fi
