#!/usr/bin/env bash

log_info() {
  echo "[INFO] $1"
}

log_warn() {
  echo "[WARN] $1"　>$2
}

log_error() {
  echo "[ERROR] $1"
}

log_success() {
  echo "[SUCCESS] $1"
}
