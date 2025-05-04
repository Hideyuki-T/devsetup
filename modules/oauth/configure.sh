#!/usr/bin/env bash
set -euo pipefail
# modules/oauth/configure.sh：OAuth設定の構成適用フェーズ
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "OAuth設定ファイルの構成を行います"

# 0) .env の存在チェック
if [ ! -f "${PROJECT_DIR}/.env" ]; then
  log_info ".env が見つかりません…。先に Docker Configure を実行してください"
  exit 1
fi

# 1) .env へ OAuth 環境変数を追加
log_info "OAuth 用環境変数を .env に設定します"
source "${DEVSETUP_ROOT}/functions/env_generator.sh"

read -rp "Google Client ID を入力してください: " CLIENT_ID
add_env_var "GOOGLE_CLIENT_ID"     "${CLIENT_ID}"

read -rp "Google Client Secret を入力してください: " CLIENT_SECRET
add_env_var "GOOGLE_CLIENT_SECRET" "${CLIENT_SECRET}"

read -rp "Google Redirect URI を入力してください (例 http://localhost:8080/login/google/callback): " REDIRECT_URI
add_env_var "GOOGLE_REDIRECT_URI"  "${REDIRECT_URI}"

log_info ".env への OAuth 環境変数設定が完了しました"

# 2) Composer 依存追加（Laravel Socialite をインストール）
log_info "Composer 依存の追加（laravel/socialite）を開始します"
# プロジェクトの Laravel ディレクトリに移動して require 実行
(
  cd "${PROJECT_DIR}/src" || exit 1
  composer require laravel/socialite --quiet
)
log_info "Composer 依存の追加が完了しました"

# 3) services.php の配列末尾 ('];') の直前に google 設定を挿入
sed -i '' '/^];/i \
    '\''google'\'' => [\
        '\''client_id'\''     => env('\''GOOGLE_CLIENT_ID'\''),\
        '\''client_secret'\'' => env('\''GOOGLE_CLIENT_SECRET'\''),\
        '\''redirect'\''      => env('\''GOOGLE_REDIRECT_URI'\''),\
    ],' "${PROJECT_DIR}/src/config/services.php"
log_info "config/services.php に Google 設定を正しく挿入しました"


# 4) OAuthController を生成
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
log_info "OAuthController を作成しました"

# 5) ルート追記（パス修正版）
TARGET="${PROJECT_DIR}/src/routes/web.php"

# 存在チェック
if [ ! -f "$TARGET" ]; then
  log_info "routes/web.php が見つかりません：$TARGET。スキップします。"
else
  log_info "src/routes/web.php に OAuth 用の use 文とルートを追記中…"

  # 1) use 文の挿入
  # 「use Illuminate\Support\Facades\Route;」 の直後へ追加
  sed -i '' -e "/use Illuminate\\\\\\\\Support\\\\\\\\Facades\\\\\\\\Route;/a\\
use App\\\\Http\\\\Controllers\\\\OAuthController;
" "$TARGET"

  # 2) OAuth ルートブロックを挿入
  # 「require __DIR__.'/auth.php';」 の直後へ追加
  read -r -d '' OAUTH_ROUTES << 'EOS'

/*
|--------------------------------------------------------------------------
| OAuth Routes
|--------------------------------------------------------------------------
|
| Guest ミドルウェアを付与して、認証済みユーザーはアクセスさせないように。
| さらに route 名を付けてリンク生成やリダイレクト先で使いやすくする。
|
*/
Route::middleware('guest')->group(function () {
    // Google OAuth へリダイレクト
    Route::get('/login/google', [\App\Http\Controllers\OAuthController::class, 'redirect'])
         ->name('login.google');

    // Google からのコールバック受け取り
    Route::get('/login/google/callback', [\App\Http\Controllers\OAuthController::class, 'callback'])
         ->name('login.google.callback');
});
EOS

  sed -i '' -e "/require __DIR__'.\\/auth\\.php';/a\\
$OAUTH_ROUTES
" "$TARGET"

  log_info "src/routes/web.php への追記が完了"
fi


  log_info "src/routes/web.php への OAuth ルート追記が完了"
fi



# 6) ログインビュー生成
mkdir -p "${PROJECT_DIR}/resources/views/auth"
cat << 'EOF' > "${PROJECT_DIR}/resources/views/auth/login.blade.php"
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
log_info "auth/login.blade.php を生成しました"

# 7) ナビゲーションにログアウトボタン追加
NAV_DIR="${PROJECT_DIR}/resources/views/layouts"
NAV_FILE="${NAV_DIR}/navigation.blade.php"

# ディレクトリとファイルがなければスキップ or 作成
if [ ! -f "${NAV_FILE}" ]; then
  log_info "navigation.blade.php が見つかりません：${NAV_FILE}。スキップします"
else
  # </nav> の直前にフォームを挿入
  sed -i '' '/<\/nav>/i \
  <form method="POST" action="{{ route('\''logout'\'') }}" class="inline">\
    @csrf\
    <button type="submit" class="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">ログアウト</button>\
  </form>' "${NAV_FILE}"
  log_info "navigation.blade.php にログアウトボタンを追加しました"
fi

log_info "Laravel 側の OAuth 設定が完了"
