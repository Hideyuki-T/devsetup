#!/usr/bin/env bash
# functions/env_generator.sh：.env 追記・更新用ユーティリティ

add_env_var(){
  local key="$1" val="$2" file="${PROJECT_DIR}/.env"

  if [ ! -f "$file" ]; then
    log_error "env_generator: .env が見つかりません：${file}"
    return 1
  fi

  if grep -q "^${key}=" "$file"; then
    sed -i '' -e "s/^${key}=.*$/${key}=${val}/" "$file"
  else
    echo "${key}=${val}" >> "$file"
  fi
}
