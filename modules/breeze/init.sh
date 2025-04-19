#!/usr/bin/env bash
# breezeモジュール　初期化フェーズ

log_info "modules/breeze/init.sh:Breeze パッケージを composer でrequire 中だよ〜"

# ホスト側で composer require を実行
composer require laravel/breeze --dev

log_info "modules/breeze/init.sh:初期化フェーズ完了！！"
