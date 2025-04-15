#!/bin/bash

compose_generator() {
  local template_file="$1"
  local output_file="$2"

  if [ ! -f "template_file" ]; then
    log_error "テンプレートファイルが見つからないよ。。: ${template_file}"
    exit 1
  fi

  envsubst < "${template_file}" > "${output_file}"
  log_info "docker-compose.yml ファイルを作成しました！: ${output_file}"
}
