#!/usr/bin/env bash
# modules/menu/init.sh：選択メニュー＋プロジェクト作成

log_info "modules/menu/init.sh：メニューを表示"

read -rp "プロジェクト名はどうします？: " PROJECT_NAME

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_PATH="${ROOT_DIR}/${PROJECT_NAME}"

# プロジェクト作成
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

log_info "プロジェクトディレクトリを作成しました：$PROJECT_PATH"

# 構成選択
echo "メニュー："
echo " [1] PHP + nginx + MySQL"
echo " [2] PHP + nginx + MySQL + Laravel"
echo " [3] PHP + nginx + MySQL + Laravel + Breeze"
read -p "番号を選択してね。: " choice

if ! [[ "$choice" =~ ^[1-3]$ ]]; then
  log_error "無効な選択肢ですよ。１〜３を選んでね。"
  exit 1
fi

cat > "${SCRIPT_DIR}/config/user.conf" <<EOF
# 自動生成されたユーザ設定
declare -A ENABLED=(
  [menu]=true
  [docker]=true
$( if [[ "$choice" -ge 2 ]]; then echo "  [laravel]=true"; else echo "  [laravel]=false"; fi )
$( if [[ "$choice" -eq 3 ]]; then echo "  [breeze]=true";  else echo "  [breeze]=false";  fi )
)
EOF

log_info "有効化される構成: docker$( [[ "$choice" -ge 2 ]] && echo ", laravel" )$( [[ "$choice" -eq 3 ]] && echo ", breeze" )"
