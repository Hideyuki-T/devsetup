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

# 有効モジュールを自動検出
for dir in "$MODULE_DIR"/*; do
  name="$(basename "$dir")"
  if [[ "${ENABLED[$name]:-false}" == "true" ]]; then
    # menu は既に先頭登録しているのでスキップ
    [[ "$name" == "menu" ]] && continue
    ENABLED_MODULES+=("$name")
  fi
done
