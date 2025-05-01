#!/usr/bin/env bash
# modules/oauth/init.sh
```bash
# modules/oauth/init.sh：OAuthモジュール初期化フェーズ

dialog_info "OAuth連携の設定を開始します"

# 1) クライアントID入力
read -rp "Google Client IDを入力してください: " CLIENT_ID

# 2) クライアントシークレット入力
read -rp "Google Client Secretを入力してください: " CLIENT_SECRET

# 3) リダイレクトURI入力
read -rp "Google Redirect URIを入力してください (例 http://localhost:8000/login/google/callback): " REDIRECT_URI

# 4) .envへ追加
source "${DEVSETUP_ROOT}/functions/env_generator.sh"
add_env_var "GOOGLE_CLIENT_ID" "$CLIENT_ID"
add_env_var "GOOGLE_CLIENT_SECRET" "$CLIENT_SECRET"
add_env_var "GOOGLE_REDIRECT_URI" "$REDIRECT_URI"

dialog_success ".envへの設定が完了しました"
```

# modules/oauth/configure.sh
```bash
#!/usr/bin/env bash
# modules/oauth/configure.sh：OAuth設定の構成適用フェーズ

dialog_info "OAuth設定ファイルの構成を行います"

# composerパッケージの追加
source "${DEVSETUP_ROOT}/functions/compose_generator.sh"
add_composer_package "laravel/socialite"

dialog_success "Composer依存の追加が完了しました"

# config/services.php にGoogle設定をパッチ適用
patch -p0 << 'EOF'
*** Begin Patch
*** Update File: src/config/services.php
@@
     // 既存の設定...
+
+    'google' => [
+        'client_id' => env('GOOGLE_CLIENT_ID'),
+        'client_secret' => env('GOOGLE_CLIENT_SECRET'),
+        'redirect' => env('GOOGLE_REDIRECT_URI'),
+    ],
*** End Patch
EOF

dialog_success "config/services.php の更新が完了しました"
```

# modules/oauth/execute.sh
```bash
#!/usr/bin/env bash
# modules/oauth/execute.sh：OAuthモジュール実行フェーズ

dialog_info "OAuthモジュールの実行を開始します"

docker-compose exec php bash -lc 'composer require laravel/socialite'

dialog_success "Socialite インストールが完了しました"
```

# modules/oauth/cleanup.sh
```bash
#!/usr/bin/env bash
# modules/oauth/cleanup.sh：OAuthモジュール後片付けフェーズ


# dialog_success "OAuthモジュールのクリーンアップが完了しましたわ"
