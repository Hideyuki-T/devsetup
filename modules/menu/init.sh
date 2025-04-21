#!/usr/bin/env bash
# modules/menu/init.sh：選択メニュー

log_info "modules/menu/init.sh：メニューを表示"

echo "メニュー："
echo " [1] PHP + nginx + MySQL"
echo " [2] PHP + nginx + MySQL + Laravel"
echo " [3] PHP + nginx + MySQL + Laravel + Breeze"
read -p "番号を選択してね。: " choice

# user.conf に書き出し
cat > "${CONFIG_DIR}/user.conf" <<EOF
# 自動生成されたユーザ設定
declare -A ENABLED=(
  [menu]=true
  [docker]=true
$( if [[ "$choice" -ge 2 ]]; then echo "  [laravel]=true"; else echo "  [laravel]=false"; fi )
$( if [[ "$choice" -eq 3 ]]; then echo "  [breeze]=true";  else echo "  [breeze]=false";  fi )
)
EOF

log_info "modules/menu/init.sh：選択 ($choice) を config/user.conf に保存しました！"
