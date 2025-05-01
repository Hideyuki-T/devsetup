#!/usr/bin/env bash
set -euo pipefail
# modules/oauth/init.sh：OAuthモジュール初期化フェーズ

log_info "OAuth連携の設定を開始します"

 # 1) クライアントID入力
read -rp "Google Client IDを入力してください: " CLIENT_ID

 # 2) クライアントシークレット入力
read -rp "Google Client Secretを入力してください: " CLIENT_SECRET

 # 3) リダイレクトURI入力
read -rp "Google Redirect URIを入力してください (例 http://localhost:8000/login/google/callback): " REDIRECT_URI

 # 4) .envへ追加
source "${DEVSETUP_ROOT}/functions/env_generator.sh"
add_env_var "GOOGLE_CLIENT_ID"     "$CLIENT_ID"
add_env_var "GOOGLE_CLIENT_SECRET" "$CLIENT_SECRET"
add_env_var "GOOGLE_REDIRECT_URI"  "$REDIRECT_URI"

log_info ".envへの設定が完了しました"

# 正常終了
exit 0
