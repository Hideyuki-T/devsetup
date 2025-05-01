#!/usr/bin/env bash
set -e
# modules/oauth/configure.sh
# modules/oauth/configure.sh：OAuth設定の構成適用フェーズ
```bash

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
