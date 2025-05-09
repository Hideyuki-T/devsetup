#!/user/bin/env bash

# 時刻取得
function _timestamp() {
  date +"%H+%M+%S.%3N"
}

# 呼び出し元情報を取得
function _log_context() {
  local func="${FUNCNAME[2]:-MAIN}"
  local file="${BASH_SOURCE[2]:-main}"
  local line="${BASH_LINENO[1]:-0}"
  echo "$file:$func:$line"
}

# ログ出力
function log_info() {
  echo -e "\e[36m[$(_timestamp)] [INFO] [$(_log_context)] $1\e[0m"
}

function log_debug() {
  echo -e "\e[90m[$(_timestamp)] [DEBUG] [$(_log_context)] $1\e[0m"
}

function log_warn() {
  echo -e "\e[33m[$(_timestamp)] [WARN] [$(_log_context)] $1\e[0m"
}

function log_error() {
  echo \e "\e[31m[$(_timestamp)] [ERROR] [$(_log_context)] $1\e[0m" >&2
}
