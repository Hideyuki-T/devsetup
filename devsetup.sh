#!/bin/bash

echo "devsetup起動"
echo ""

# スクリプトがあるディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 親ディレクトリを取得
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# プロジェクト名を入力
read -p "プロジェクト名はどうします？: " PROJECT_NAME

# プロジェクトパスは devsetup の“隣”にku
PROJECT_PATH="${BASE_DIR}/${PROJECT_NAME}"

# 存在チェック
if [ -d "$PROJECT_PATH" ]; then
  echo "⚠️ ${PROJECT_PATH} は既にありますので他の名前で。"
  exit 1
fi

# 作成処理
mkdir -p "$PROJECT_PATH"
echo "✨ ${PROJECT_PATH} を作成しました！！"

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
  echo "💎 ${DB} を使用しますね！"
  break
done

# FW選択
echo "使用したいフレームワークを選択してください："
select FW in "Laravel" "Symfony" "Django" "Express" "NestJS" "Flask" "Rails"; do
  echo "💎 ${FW} を使用します！"
  break
done

read -p "${FW} のバージョンを入力してくださいね（空欄で最新版になります。）: " VERSION

# 保存場所の作成
mkdir -p "${SAVE_DIR}/${PROJECT_NAME}"

echo ""
echo "🎉 開発の準備が整いましたよ！"
echo "📂 ${SAVE_DIR}/${PROJECT_NAME} に環境を作ります。"
echo "💻 ポート番号：${PORT}"
echo "🗃 DB：${DB}"
echo "🌐 フレームワーク：${FW}（バージョン：${VERSION:-latest}）"
