#!/usr/bin/env bash

echo "メニュー："
echo " [1] PHP + nginx + MySQL"
echo " [2] PHP + nginx + MySQL + Laravel"
echo " [3] PHP + nginx + MySQL + Laravel + Breeze"
echo ""

read -rp "番号を選択してください。：" choice

case "$choice" in
    1)
      ENABLED_DECL='declare -A ENABLED=(["docker"]=true)'
      ;;
    2)
      ENABLED_DECL='declare -A ENABLED=(["docker"]=true ["laravel"]=true)'
      ;;
    3)
      ENABLED_DECL='declare -A ENABLED=(["docker"]=true ["laravel"]=true ["breeze"]=true)'
      ;;
    *)
      echo "無効な選択肢です。。"
      exit 1
      ;;
  esac

# 設定ファイルへの出力
echo "$ENABLED_DECL" > config/user.conf
echo "選択内容を config/user.conf に保存したよ！"
