log_info "modules/docker/configure.sh：ポート番号を選択してね。"
read -p "使用したいポート番号を入力してね。：" port

log_info "modules/docker/configure.sh：.env を生成中…"
cat > .env <<EOL
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:$port
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=app
DB_USERNAME=root
DB_PASSWORD=
EOL

log_info "modules/docker/configure.sh：設定完了 (.env にポート $port を反映しました)"
