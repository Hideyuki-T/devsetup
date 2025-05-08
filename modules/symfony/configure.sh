#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/configure.sh：Symfony 設定フェーズ

log_info "modules/symfony/configure.sh：Symfony のバージョンを指定してください。"
read -rp "使用する Symfony バージョン (例: 7.2.*): " SYMFONY_VERSION
SYMFONY_VERSION=${SYMFONY_VERSION:-7.2.*}
export SYMFONY_VERSION

echo
log_info "modules/symfony/configure.sh：インストールタイプを選択してください。"
cat << 'EOI'
[1] 最小構成スケルトン（API／マイクロサービス向け）
[2] フルスタック（Web アプリ向け全機能）
EOI
read -rp "番号を入力 (1 or 2): " PROFILE_SELECT
case "${PROFILE_SELECT}" in
  1) SYMFONY_PROFILE="skeleton" ;;
  2) SYMFONY_PROFILE="webapp-pack" ;;
  *) log_error "無効な選択です"; exit 1 ;;
esac
export SYMFONY_PROFILE

log_info "modules/symfony/configure.sh：インストールタイプ → ${SYMFONY_PROFILE}"
