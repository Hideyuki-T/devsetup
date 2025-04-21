#!/usr/bin/env bash
# Laravel モジュール：実行フェーズ

# .env を読み込んでプロジェクト名を取得
source .env

docker compose up -d

# DB起動まで待機
until docker compose exec db mysqladmin ping -h mysql --silent; do
  sleep 1
done

# プロジェクトディレクトリにマインとしている app コンテナへ移動
docker compose exec app bash -lc "cd /var/www/html/${PROJECT_NAME} && \
  composer install --no-interaction --prefer-dist && \
  php artisan key:generate && \
  php artisan migrate:fresh --force"
