#!/bin/bash

echo "devsetup起動"
echo ""

# スクリプトがあるディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 親ディレクトリを取得
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# プロジェクト名を入力
read -p "プロジェクト名は？: " PROJECT_NAME

# プロジェクトパスは devsetup 同じディレクトリに
PROJECT_PATH="${BASE_DIR}/${PROJECT_NAME}"

# 存在チェック
if [ -d "$PROJECT_PATH" ]; then
  echo "${PROJECT_PATH} は既にあるので他の名前で。"
  exit 1
fi

# 作成処理
mkdir -p "$PROJECT_PATH"
echo "${PROJECT_PATH} を作成しました！！"
# -------------------------------------------------
# ディレクトリ・ファイル構成を作成する
echo "プロジェクト構成作成中"

mkdir -p "${PROJECT_PATH}/src"
mkdir -p "${PROJECT_PATH}/docker"

# .env が存在しない場合のみ作成（重複防止のためのもの）
if [ ! -f "${PROJECT_PATH}/.env" ]; then
  touch "${PROJECT_PATH}/.env"
  echo "# .env ファイル（自動生成）" >> "${PROJECT_PATH}/.env"
  echo "APP_NAME=${PROJECT_NAME}" >> "${PROJECT_PATH}/.env"
  echo "APP_PORT=${PORT}" >> "${PROJECT_PATH}/.env"
  echo "DB_TYPE=${DB}" >> "${PROJECT_PATH}/.env"
  echo "FW=${FW}" >> "${PROJECT_PATH}/.env"
  echo "FW_VERSION=${VERSION:-latest}" >> "${PROJECT_PATH}/.env"
fi

echo "初期構造："
echo " - ${PROJECT_NAME}/src/"
echo " - ${PROJECT_NAME}/docker/"
echo " - ${PROJECT_NAME}/.env"
# -------------------------------------------------
echo "Docker設定"

TEMPLATE_DOCKER_DIR="${SCRIPT_DIR}/templates/docker"

if [ -d "$TEMPLATE_DOCKER_DIR" ]; then
    if [ -f "${TEMPLATE_DOCKER_DIR}/docker-compose.yml" ]; then
         cp "${TEMPLATE_DOCKER_DIR}/docker-compose.yml" "${PROJECT_PATH}/docker-compose.yml"
         echo "docker-compose.yml を ${PROJECT_PATH} にコピー！"
    else
         echo "docker-compose.yml がテンプレートにないよ。"
    fi
else
    echo "テンプレート用 docker/ ディレクトリがないよ。"
fi



# -------------------------------------------------
read -p "使用したいポート番号はどうしますか？: " PORT

# ポート競合チェック
if lsof -iTCP:${PORT} -sTCP:LISTEN -nP > /dev/null; then
  echo "ポート ${PORT} は既に使用中です。別の番号にを選択してください。"
  exit 1
fi

# DB選択
echo "使用するデータベースを選んでください："
select DB in "MySQL" "PostgreSQL" "SQLite"; do
  echo "${DB} を使用しますね！"
  break
done

# FW選択
echo "使用したいフレームワークを選択してください："
select FW in "Laravel" "Symfony" "Django" "Express" "NestJS" "Flask" "Rails"; do
  echo "${FW} を使用します！"
  break
done

read -p "${FW} のバージョンを入力してくださいね（空欄で最新版になります。）: " VERSION


# -------------------------------------------------

echo ""
echo "開発の準備が整いましたよ！"
echo "${PROJECT_PATH} に環境を作ります。"
echo "ポート番号：${PORT}"
echo "DB：${DB}"
echo "フレームワーク：${FW}（バージョン：${VERSION:-latest}）"

# -------------------------------------------------
export PROJECT_NAME
export PORT
export DB
export FW
export VERSION

# 移動先：プロジェクトルートディレクトリ
cd "${PROJECT_PATH}" || { echo "ディレクトリ移動に失敗"; exit 1; }


echo "build..."
docker-compose -f docker-compose.yml build

echo "up..."
docker-compose -f docker-compose.yml up -d

echo "成功"

# -------------------------------------------------

# 保存場所の作成
mkdir -p "${SAVE_DIR}/${PROJECT_NAME}"

echo ""
echo "開発の準備が整いましたよ！"
echo "${SAVE_DIR}/${PROJECT_NAME} に環境を作ります。"
echo "ポート番号：${PORT}"
echo "DB：${DB}"
echo "フレームワーク：${FW}（バージョン：${VERSION:-latest}）"
