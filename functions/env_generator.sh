#!/usr/bin/env bash
set -euo pipefail
# functions/env_generator.sh：.env 追記・更新用ユーティリティ
source "${DEVSETUP_ROOT}/framework/logger.sh"

add_env_var(){
  local key="$1" val="$2"
  # 第三引数が指定されればそれを.envファイルとして使用
  # なければデフォルトでPROJECT_DIR/.env
  local file="${3:-${PROJECT_DIR}/.env}"

  if [ ! -f "$file" ]; then
    log_info "env_generator: .env が見つかりません：${file}"
    return 1
  fi

  if grep -q "^${key}=" "$file"; then
    # すでにキーが存在すれば置き換え
    sed -i '' -e "s/^${key}=.*$/${key}=${val}/" "$file"
  else
    # なければ末尾に追記
    echo "${key}=${val}" >> "$file"
  fi
}
