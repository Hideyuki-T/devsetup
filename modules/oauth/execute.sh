#!/usr/bin/env bash
set -euo pipefail
# modules/oauth/execute.sh：OAuthモジュール実行フェーズ
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "OAuthモジュールの実行を開始"

# 1) プロジェクトディレクトリへ移動して Docker Compose 起動
(
  cd "${PROJECT_DIR}" || exit 1
  log_info "Docker コンテナをバックグラウンドで起動"
  docker compose up -d
)

# 2) PHP(app) コンテナ内で Socialite をインストール
log_info "App コンテナ内で laravel/socialite をインストールします"
(
  cd "${PROJECT_DIR}" || exit 1
  docker compose exec -T app bash -lc 'composer require laravel/socialite --quiet'
)

log_info "Socialite のインストールが完了しました"

# 3) app コンテナを再起動して .env をリロード
log_info "app コンテナを再起動して .env をリロードします"
(
  cd "${PROJECT_DIR}" || exit 1
  docker compose restart app
)

# 4) Artisan キャッシュクリアを実行
log_info "Artisan キャッシュクリアを実行します"
docker compose exec -T app bash -lc "\
  cd /var/www/html && \
  php artisan config:clear && \
  php artisan cache:clear && \
  php artisan view:clear \
"
log_info "キャッシュクリア完了！"

log_info "OAuthモジュールの実行フェーズ完了"
