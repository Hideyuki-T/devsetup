#!/usr/bin/env bash

echo "メニュー："
echo " [1] PHP + nginx + MySQL"
echo " [2] PHP + nginx + MySQL + Laravel"
echo " [3] PHP + nginx + MySQL + Laravel + Breeze"
echo ""

read -rp "番号を選択してください。: " choice

#　config/user.conf を空に（既存設定のリセット）
: > config/user.conf

case "$choice" in
  1)
    echo 'ENABLED["docker"]=true'      >> config/user.conf
    ;;
  2)
    echo 'ENABLED["docker"]=true'      >> config/user.conf
    echo 'ENABLED["laravel"]=true'     >> config/user.conf
    ;;
  3)
    echo 'ENABLED["docker"]=true'      >> config/user.conf
    echo 'ENABLED["laravel"]=true'     >> config/user.conf
    echo 'ENABLED["breeze"]=true'      >> config/user.conf
    ;;
  *)
    echo "無効な選択です…"
    exit 1
    ;;
esac

echo "選択内容を config/user.conf に保存しました！"
