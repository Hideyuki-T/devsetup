#!/usr/bin/env bash
set -e
# modules/oauth/execute.sh：OAuthモジュール実行フェーズ
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "OAuthモジュールの実行を開始します"

docker-compose exec php bash -lc 'composer require laravel/socialite'

log_info "Socialite インストールが完了しました"

