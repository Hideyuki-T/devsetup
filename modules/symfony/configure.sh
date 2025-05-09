#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "modules/symfony/configure.sh：Laravel 設定フェーズ（.env は docker モジュール側で管理）"

log_info "modules/symfony/configure.sh：完了（.env はスキップ）"