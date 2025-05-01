#!/usr/bin/env bash

set -euo pipefail
# modules/oauth/init.sh：OAuth モジュール初期化フェーズ

log_info "OAuth連携の設定を開始します"

# 共通ユーティリティ（add_env_var）を読み込む
source "${DEVSETUP_ROOT}/functions/env_generator.sh"

# 1) Google Client ID
read -rp "Google Client IDを入力してください: " CLIENT_ID
add_env_var "GOOGLE_CLIENT_ID" "${CLIENT_ID}"

# 2) Google Client Secret
read -rp "Google Client Secretを入力してください: " CLIENT_SECRET
add_env_var "GOOGLE_CLIENT_SECRET" "${CLIENT_SECRET}"

# 3) Google Redirect URI
read -rp "Google Redirect URIを入力してください (例 http://localhost:8080/login/google/callback): " REDIRECT_URI
add_env_var "GOOGLE_REDIRECT_URI" "${REDIRECT_URI}"

log_info ".env への設定が完了しました"

exit 0
