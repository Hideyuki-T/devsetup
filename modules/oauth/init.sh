#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"
# modules/oauth/init.sh は Init フェーズでは何もしません
# Configure フェーズで処理を行う
