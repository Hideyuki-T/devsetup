# modules/laravel/configure.sh
#!/usr/bin/env bash
# Laravel モジュール：設定フェーズ

log_info "modules/laravel/configure.sh：DB 接続設定を反映中…"

# サブシェルで作業ディレクトリを src に移動（元のディレクトリを保持）
(
  cd src
  # .env がなければコピー
  if [ ! -f .env ]; then
    cp .env.example .env
  fi

  # .env への DB 設定上書き
  log_info "modules/laravel/configure.sh：.env の DB 認証情報を更新…"
  # macOS の sed 互換性に配慮
  sed -i '' 's/^DB_CONNECTION=.*/DB_CONNECTION=mysql/' .env
  sed -i '' 's/^DB_HOST=.*/DB_HOST=mysql/' .env
  sed -i '' 's/^DB_PORT=.*/DB_PORT=3306/' .env
  sed -i '' 's/^DB_DATABASE=.*/DB_DATABASE=app/' .env
  sed -i '' 's/^DB_USERNAME=.*/DB_USERNAME=me/' .env
  sed -i '' 's/^DB_PASSWORD=.*/DB_PASSWORD=54321/' .env

  log_info "modules/laravel/configure.sh：.env への設定完了 (app/me:54321)"
)
