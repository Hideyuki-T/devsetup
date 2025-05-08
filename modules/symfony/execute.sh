#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/execute.sh：Symfony インストール＆初期化フェーズ

log_info "modules/symfony/execute.sh：Symfony プロジェクトを生成中…"

# 1) Docker コンテナ群を起動
log_info "modules/symfony/execute.sh：Docker コンテナを起動中…"
(
  cd "${PROJECT_DIR}"
  docker compose up -d
)
log_info "modules/symfony/execute.sh：コンテナが起動しました"

# 2) プロファイルに応じて Symfony を app 配下にインストール
log_info "modules/symfony/execute.sh：Symfony を app 配下へインストール中…"
(
  cd "${PROJECT_DIR}"
  if [ "${SYMFONY_PROFILE}" = "skeleton" ]; then
    log_info "modules/symfony/execute.sh：最小構成スケルトン（symfony/skeleton）をインストールします…"
    docker compose run --rm --no-deps -w /var/www/html app \
      composer create-project symfony/skeleton app "${SYMFONY_VERSION}" --no-interaction
  else
    log_info "modules/symfony/execute.sh：フルスタック（symfony/webapp-pack）をインストールします…"
    docker compose run --rm --no-deps -w /var/www/html app \
      composer create-project symfony/webapp-pack app --no-interaction
  fi
)
log_info "modules/symfony/execute.sh：依存パッケージをインストールしました"

# 3) 公開ルートをシンボリックリンクで app/public へ
rm -rf "${PROJECT_DIR}/public"
ln -s app/public "${PROJECT_DIR}/public"
log_info "modules/symfony/execute.sh：public → app/public へのシンボリックリンクを作成しました"

# 4) ブラウザアクセス先を表示
log_info "modules/symfony/execute.sh：ブラウザで http://localhost:${WEB_PORT} にアクセス可能です"

# 5) PHP ビルトインサーバーを起動（任意）
log_info "modules/symfony/execute.sh：PHP ビルトインサーバーを起動中…"
(
  # コンテナ内の /var/www/html を作業ディレクトリに設定
  docker compose exec -d -w /var/www/html app \
    sh -c "php -S 0.0.0.0:${WEB_PORT} -t app/public"
)
log_info "modules/symfony/execute.sh：ビルトインサーバーが稼働中 → http://localhost:${WEB_PORT}"
