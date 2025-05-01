#!/usr/bin/env bash
set -e
# modules/oauth/configure.sh：OAuth設定の構成適用フェーズ

dialog_info "OAuth設定ファイルの構成を行います"

# 1) Composer依存追加
source "${DEVSETUP_ROOT}/functions/compose_generator.sh"
add_composer_package "laravel/socialite"
dialog_success "Composer依存の追加が完了しました"

# 2) config/services.php にGoogle設定をパッチ適用
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

# 3) OAuthController を生成
cat << 'EOF' > "${PROJECT_DIR}/src/app/Http/Controllers/OAuthController.php"
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class OAuthController extends Controller
{
    public function redirect()
    {
        return Socialite::driver('google')->redirect();
    }

    public function callback()
    {
        \$googleUser = Socialite::driver('google')->stateless()->user();

        \$user = User::firstOrCreate(
            ['email' => \$googleUser->getEmail()],
            ['name'  => \$googleUser->getName()]
        );

        Auth::login(\$user);
        return redirect()->intended('/welcome');
    }
}
EOF
dialog_success "OAuthController を作成しました"

# 4) ルート追記
cat << 'EOF' >> "${PROJECT_DIR}/src/routes/web.php"

use App\Http\Controllers\OAuthController;

// Google OAuth
Route::get('/login/google', [OAuthController::class, 'redirect']);
Route::get('/login/google/callback', [OAuthController::class, 'callback']);
EOF
dialog_success "routes/web.php に OAuth ルートを追記しました"

# 5) ログインビュー生成
cat << 'EOF' > "${PROJECT_DIR}/src/resources/views/auth/login.blade.php"
@extends('layouts.app')

@section('content')
<div class="container mx-auto px-4">
    <div class="max-w-md mx-auto bg-white p-6 rounded shadow">
        <h2 class="text-2xl font-semibold mb-4">ログイン</h2>

        <!-- Breeze 既存フォーム -->

        <div class="mt-6 text-center">
            <a href="{{ url('login/google') }}"
               class="inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
               Googleでログイン
            </a>
        </div>
    </div>
</div>
@endsection
EOF
dialog_success "auth/login.blade.php を生成しました"

# 6) ナビゲーションにログアウトボタン追加
NAV_FILE="${PROJECT_DIR}/src/resources/views/layouts/navigation.blade.php"
if ! grep -q "route('logout')" "$NAV_FILE"; then
  sed -i "/<\/nav>/i \
  <form method=\"POST\" action=\"{{ route('logout') }}\" class=\"inline\">\
  @csrf\
  <button type=\"submit\" class=\"px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600\">ログアウト</button>\
  </form>" "$NAV_FILE"
  dialog_success "navigation.blade.php にログアウトボタンを追加しました"
else
  dialog_info "navigation.blade.php にすでにログアウトボタンがあります"
fi

dialog_success "Laravel 側のOAuthファイル生成が完了"
