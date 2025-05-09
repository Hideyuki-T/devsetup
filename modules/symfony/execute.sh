#!/usr/bin/env bash
set -euo pipefail
source "${DEVSETUP_ROOT}/framework/logger.sh"

log_info "必要な composer パッケージを確認中…"

# MakerBundle（コード生成支援）
if ! grep -q '"symfony/maker-bundle"' composer.json; then
  log_info "symfony/maker-bundle を導入します"
  docker compose exec -T app bash -lc "cd /var/www/html && composer require symfony/maker-bundle --dev"
fi

# Fixtures（Seeder相当）
if ! grep -q '"doctrine/doctrine-fixtures-bundle"' composer.json; then
  log_info "doctrine-fixtures-bundle を導入します"
  docker compose exec -T app bash -lc "cd /var/www/html && composer require doctrine/doctrine-fixtures-bundle --dev"
fi

log_info "modules/symfony/execute.sh：bin/console コマンドをコンテナ内で実行します"

cd "${PROJECT_DIR}"

# MySQL 起動待ち
for i in {1..15}; do
  if docker compose exec -T db mysqladmin ping -h db --silent; then
    log_info "MySQL が応答しました（${i}秒）"
    break
  fi
  sleep 1
done

# DB削除 → 作成
docker compose exec -T app bash -lc "cd /var/www/html && php bin/console doctrine:database:drop --force"
log_info "DB削除 完了"

docker compose exec -T db bash -lc "cd /var/www/html && php bin/console doctrine:database:create"
log_info "DB作成 完了"

# マイグレーション実行
docker compose exec -T app bash -lc "cd /var/www/html && php bin/console doctrine:migrations:migrate --no-interaction"
log_info "マイグレーション 完了"

# フィクスチャ投入（Seeder相当）
docker compose exec -T app bash -lc "cd /var/www/html && php bin/console doctrine:fixtures:load --no-interaction"
log_info "Fixtures投入 完了"

