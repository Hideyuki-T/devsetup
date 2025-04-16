#!/bin/bash
#PHP + nginx + MySQL 環境を構築するための処理を実行

TARGET_PROJECT_DIR="$1"
project_name="$2"

if [ -z "$TARGET_PROJECT_DIR" ] || [ -z "$project_name" ]; then
  echo "[ERROR] ターゲットプロジェクトディレクトリまたはプロジェクト名が指定されてないよ。"
  exit 1
fi

echo "[DEBUG] build_base.sh：基本環境の追加処理は特になし。"

exit 0
