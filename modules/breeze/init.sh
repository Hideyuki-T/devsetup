#!/usr/bin/env bash
# modules/breeze/init.sh：Laravel BreezeをDockerコンテナ内で導入

log_info "[INFO]: modules/breeze/init.sh:Dockerコンテナ内で Breeze を Composer require 中..."

APP="${APP_CONTAINER_NAME:-app}"
WORKDIR="/var/www/html"

docker compose exec -T -w "$WORKDIR" "$APP" composer require laravel/breeze --dev

log_info "[INFO]: modules/breeze/init.sh: 完了"
