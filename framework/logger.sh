#!/user/bin/env bash

function log_info() {
  echo -e "\e[36m[$(date +%H:%M:%S)] [INFO] $1\e[0m"
}

function log_debug() {
  echo -e "\e[90m[$(date +%H:%M:%S)] [DEBUG] $1\e[0m"
}

function log_error() {
  echo -e "\e[31m[$(date +%H:%M:%S)] [ERROR] $1\e[0m" >&2
}
