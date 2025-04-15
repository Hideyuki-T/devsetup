#!/bin/bash

env_generator() {
  local template_file="$1"
  local output_file="$2"

  if [ ! -f "$template_file" ]; then
    log_error "テンプレートファイルが見つかりません。。: ${template_file}"
    exit 1
  fi

  # envsubst:gettextパッケージに含まれるコマンド
  envsubst < "${template_file}" > "${output_file}"
  log_info ".env ファイル出来たよ。: ${output_file}"
}
