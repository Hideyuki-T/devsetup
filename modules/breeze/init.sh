#!/usr/bin/env bash
# breezeモジュール　初期化フェーズ

log_info "modules/breeze/init.sh:Breeze パッケージを composer でrequire 中だよ〜"

# composer require 実行中

docker compose exec app composer require laravel/breeze --dev

log_info "modules/breeze/init.sh:テンプレートファイルをコピー中だよ！"

log_info "modules/breeze/init.sh:初期化フェーズ完了！！"
