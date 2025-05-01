#!/usr/bin/env bash
set -euo pipefail
# modules/oauth/execute.sh：OAuthモジュール実行フェーズ
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "OAuthモジュールの実行を開始します"

# 1) プロジェクトディレクトリへ移動して Docker Compose 起動
(
  cd "${PROJECT_DIR}" || exit 1
  log_info "Docker コンテナをバックグラウンドで起動します"
  docker-compose up -d
)

# 2) PHP(App) コンテナ内で Socialite をインストール
log_info "App コンテナ内で laravel/socialite をインストールします"
(
  cd "${PROJECT_DIR}" || exit 1
  docker-compose exec app bash -lc 'composer require laravel/socialite --quiet'
)

log_info "Socialite のインストールが完了しました"
