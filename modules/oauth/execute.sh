#!/usr/bin/env bash
set -e
# modules/oauth/execute.sh
# modules/oauth/execute.sh：OAuthモジュール実行フェーズ
```bash

dialog_info "OAuthモジュールの実行を開始します"

docker-compose exec php bash -lc 'composer require laravel/socialite'

dialog_success "Socialite インストールが完了しました"
```
