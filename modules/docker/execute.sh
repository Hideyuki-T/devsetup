 #!/usr/bin/env bash
 # Docker モジュール：実行フェーズ

log_info "modules/docker/execute.sh：既存のコンテナとボリュームを破棄中…"
docker compose down -v --remove-orphans

 log_info "modules/docker/execute.sh：docker-compose を起動中…"
 docker compose up -d
