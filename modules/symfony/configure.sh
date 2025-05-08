#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/configure.sh：Symfony 設定フェーズ

log_info "modules/symfony/configure.sh：Symfony のバージョンを指定してください。"

read -rp "使用する Symfony バージョン (例: 6.4): " SYMFONY_VERSION
# デフォルト設定
SYMFONY_VERSION=${SYMFONY_VERSION:-6.4}
export SYMFONY_VERSION

log_info "modules/symfony/configure.sh：Symfony バージョン -> ${SYMFONY_VERSION}"
