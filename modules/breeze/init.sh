#!/usr/bin/env bash
# modules/breeze/init.sh

log_info "[INFO]: modules/breeze/init.sh：コンテナ内で Breeze を composer require --dev 中…"
docker compose exec app \
  composer require laravel/breeze --dev

log_info "[SUCCESS]: modules/breeze/init.sh：完了"
