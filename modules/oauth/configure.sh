#!/usr/bin/env bash
set -euo pipefail
# modules/oauth/configure.sh：OAuth（Google）設定フェーズ

source "${DEVSETUP_ROOT}/framework/logger.sh"
source "${DEVSETUP_ROOT}/functions/env_generator.sh"

log_info "modules/oauth/configure.sh：OAuth 設定ファイルの構成を行います"

# ─────────────────────────────
# 0) Laravel が読む src/.env の存在チェック
ENV_FILE="${PROJECT_DIR}/src/.env"
if [ ! -f "${ENV_FILE}" ]; then
  log_error ".env が見つかりません：${ENV_FILE}。先に Docker モジュールで .env を生成してください"
  exit 1
fi
log_info "▶ 追記対象 .env ファイル: ${ENV_FILE}"
tail -n3 "${ENV_FILE}" | sed 's/^/   /'
# ─────────────────────────────

# ─────────────────────────────
# 1) .env へ OAuth 環境変数を追加
log_info "modules/oauth/configure.sh：.env に OAuth 用環境変数を設定します"
read -rp "Google Client ID を入力してください: " CLIENT_ID
add_env_var "GOOGLE_CLIENT_ID"     "${CLIENT_ID}"     "${ENV_FILE}"

read -rp "Google Client Secret を入力してください: " CLIENT_SECRET
add_env_var "GOOGLE_CLIENT_SECRET" "${CLIENT_SECRET}" "${ENV_FILE}"

read -rp "Google Redirect URI を入力してください (例 http://localhost:8080/login/google/callback): " REDIRECT_URI
add_env_var "GOOGLE_REDIRECT_URI"  "${REDIRECT_URI}"  "${ENV_FILE}"

log_info "modules/oauth/configure.sh：.env への OAuth 環境変数設定が完了"
# ─────────────────────────────

# ─────────────────────────────
# 2) Composer 依存追加（laravel/socialite）
log_info "modules/oauth/configure.sh：Composer 依存の追加（laravel/socialite）を実行"
(
  cd "${PROJECT_DIR}/src" || exit 1
  composer require laravel/socialite --quiet
)
log_info "modules/oauth/configure.sh：Composer 依存の追加が完了"
# ─────────────────────────────

# ─────────────────────────────
# 3) config/services.php への Google 設定挿入
TARGET_SERVICES="${PROJECT_DIR}/src/config/services.php"
if [ ! -f "${TARGET_SERVICES}" ]; then
  log_error "config/services.php が見つかりません：${TARGET_SERVICES}。スキップします"
else
  log_info "modules/oauth/configure.sh：config/services.php に Google 設定を挿入"
  ed -s "${TARGET_SERVICES}" << 'EDCMDS'
/return \[/
/^];/
i
    'google' => [
        'client_id'     => env('GOOGLE_CLIENT_ID'),
        'client_secret' => env('GOOGLE_CLIENT_SECRET'),
        'redirect'      => env('GOOGLE_REDIRECT_URI'),
    ],
.
w
q
EDCMDS
  log_info "modules/oauth/configure.sh：services.php への挿入が完了"
fi
# ─────────────────────────────

# ─────────────────────────────
# 4) OAuthController の生成
CONTROLLER="${PROJECT_DIR}/src/app/Http/Controllers/OAuthController.php"
log_info "modules/oauth/configure.sh：OAuthController を作成 → ${CONTROLLER}"
cat << 'EOF' > "${CONTROLLER}"
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use App\Models\User;

class OAuthController extends Controller
{
    /**
     * Google OAuth リダイレクト
     */
    public function redirect()
    {
        return Socialite::driver('google')->redirect();
    }

    /**
     * Google コールバック受け取り
     */
    public function callback()
    {
        $googleUser = Socialite::driver('google')->stateless()->user();

        $user = User::firstOrCreate(
            ['email' => $googleUser->getEmail()],
            [
                'name'     => $googleUser->getName(),
                'password' => bcrypt(Str::random(32)),
            ]
        );

        Auth::login($user);

        // ログイン後はダッシュボードへ
        return redirect()->intended('/dashboard');
    }
}
EOF
# ─────────────────────────────

# ─────────────────────────────
# 5) routes/web.php へルート追記
ROUTES="${PROJECT_DIR}/src/routes/web.php"
if [ ! -f "${ROUTES}" ]; then
  log_error "routes/web.php が見つかりません：${ROUTES}。スキップします"
else
  log_info "modules/oauth/configure.sh：routes/web.php に OAuth ルートを追記"
  cat << 'EOF' >> "${ROUTES}"

use App\Http\Controllers\OAuthController;

// Google OAuth
Route::get('/login/google', [OAuthController::class, 'redirect']);
Route::get('/login/google/callback', [OAuthController::class, 'callback']);
EOF
  log_info "modules/oauth/configure.sh：routes の追記が完了"
fi
# ─────────────────────────────

# ─────────────────────────────
# 6) ログインビューに「Googleでログイン」ボタンを生成
VIEW_DIR="${PROJECT_DIR}/src/resources/views/auth"
mkdir -p "${VIEW_DIR}"
LOGIN_VIEW="${VIEW_DIR}/login.blade.php"
log_info "modules/oauth/configure.sh：auth/login.blade.php を作成 → ${LOGIN_VIEW}"
cat << 'EOF' > "${LOGIN_VIEW}"
@extends('layouts.app')

@section('content')
<div class="container mx-auto px-4">
    <div class="max-w-md mx-auto bg-white p-6 rounded shadow">
        <h2 class="text-2xl font-semibold mb-4">ログイン</h2>

        {{-- Breeze の既存フォームここに残す --}}

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
# ─────────────────────────────

# ─────────────────────────────
# 7) layouts/navigation.blade.php を「ゲスト ⇔ 認証済み」で置き換え
NAV_FILE="${PROJECT_DIR}/src/resources/views/layouts/navigation.blade.php"
if [ -f "${NAV_FILE}" ]; then
  log_info "modules/oauth/configure.sh：navigation.blade.php をゲスト／認証済み分岐型に置き換え"
  cat << 'EOF' > "${NAV_FILE}"
<nav>
    {{-- 共通メニューがあればここに --}}
    @guest
    <div class="sm:flex sm:items-center sm:ms-6">
        <a href="{{ route('login') }}" class="text-sm text-gray-700 underline">ログイン</a>
        <a href="{{ route('register') }}" class="ml-4 text-sm text-gray-700 underline">登録</a>
    </div>
    @else
    <div class="hidden sm:flex sm:items-center sm:ms-6">
        <x-dropdown align="right" width="48">
            <x-slot name="trigger">
                <button class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-gray-500 bg-white hover:text-gray-700 focus:outline-none transition ease-in-out duration-150">
                    <div>{{ Auth::user()->name }}</div>
                    <div class="ms-1">
                        <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"/>
                        </svg>
                    </div>
                </button>
            </x-slot>
            <x-slot name="content">
                <x-dropdown-link :href="route('profile.edit')">プロフィール編集</x-dropdown-link>
                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <x-dropdown-link :href="route('logout')" onclick="event.preventDefault(); this.closest('form').submit();">
                        ログアウト
                    </x-dropdown-link>
                </form>
            </x-slot>
        </x-dropdown>
    </div>
    @endguest
</nav>
EOF
else
  log_warn "navigation.blade.php が見つかりません：${NAV_FILE}。スキップします"
fi
# ─────────────────────────────

# ─────────────────────────────
# 8) キャッシュクリア
log_info "modules/oauth/configure.sh：Artisan キャッシュクリアを実行"
docker compose exec -T app php artisan view:clear
docker compose exec -T app php artisan config:clear
log_info "modules/oauth/configure.sh：OAuth 設定が完了!"
# ─────────────────────────────
