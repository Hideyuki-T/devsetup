#!/bin/bash

# 基本環境の処理を引き継ぎ、その後、src ディレクトリ内に Laravel フレームワークをインストール

TARGET_PROJECT_DIR="$1"
project_name="$2"

if [ -z "$TARGET_PROJECT_DIR" ] || [ -z "$project_name" ]; then
  echo "[ERROR] ターゲットプロジェクトディレクトリまたはプロジェクト名が指定されていません。"
  exit 1
fi

read -p "Laravel のバージョン指定（例: 12.*）： " laravel_version
if [ -z "$laravel_version" ]; then
  laravel_version="12.*"
fi

echo "[INFO] Laravel を src ディレクトリにインストールします： バージョン ${laravel_version}"


cd "${TARGET_PROJECT_DIR}/src" || { echo "[ERROR] src ディレクトリに移動できませんでした。。。"; exit 1; }
composer create-project laravel/laravel . "${laravel_version}"

# インストール後、元のディレクトリに戻る
cd "${TARGET_PROJECT_DIR}" || { echo "[ERROR] プロジェクトディレクトリに戻れませんでした。。。"; exit 1; }

echo "[INFO] build_laravel.sh：Laravel のインストールが完了しました！"

exit 0
