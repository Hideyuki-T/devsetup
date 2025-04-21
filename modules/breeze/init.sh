#!/usr/bin/env bash
# modules/breeze/init.sh：ホスト上で Breeze を require

log_info "modules/breeze/init.sh：ホスト上で Breeze を composer require --dev 中…"


composer require laravel/breeze --dev --working-dir ./src

log_info "modules/breeze/init.sh：完了"
