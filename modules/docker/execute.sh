 #!/usr/bin/env bash
 # Docker モジュール：実行フェーズ

log_info "modules/docker/execute.sh：既存のコンテナとボリュームを破棄中…"
docker compose down -v --remove-orphans

if ! command -v docker &> /dev/null; then
  log_error "Docker が見つかりませんわ…インストールしてね。"
  exit 1
fi

if [[ ! -f .env ]]; then
  log_warn ".env が見つからなかったということだけ伝えておきますね。"
fi

docker compose ps


 log_info "modules/docker/execute.sh：docker-compose を起動中…"
 docker compose up -d
