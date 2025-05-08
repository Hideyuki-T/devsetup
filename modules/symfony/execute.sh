#!/usr/bin/env bash
set -euo pipefail
# modules/symfony/execute.sh：Symfony インストール＆初期化フェーズ

log_info "modules/symfony/execute.sh：Symfony プロジェクトを生成中…"

log_info "modules/symfony/execute.sh：Docker コンテナを起動中…"
(
  cd "${PROJECT_DIR}"
  docker compose up -d
)
log_info "modules/symfony/execute.sh：コンテナが起動しました"

(
  cd "${PROJECT_DIR}"

  # ---------------------------------------------
  # 1) 最小構成スケルトン（symfony/skeleton）をインストール
  #    軽量API or マイクロサービス向け
  docker compose exec app \
    composer create-project symfony/skeleton symfony "7.2.*" --no-interaction

  # ---------------------------------------------
  # 2) フルスタック版をいつでも切り替え可能に：
  #    ウェブアプリ向け全機能を一括取得したい場合は、以下を有効化
  # docker compose exec app \
  #   composer create-project symfony/webapp-pack symfony --no-interaction

)

log_info "modules/symfony/execute.sh：依存パッケージをインストールしました"
log_info "modules/symfony/execute.sh：ブラウザで http://localhost:${WEB_PORT}/symfony/public/ にアクセス可能です"
