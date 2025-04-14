#!/bin/bash

echo "devsetup起動"
echo ""

# -------------------------------------------------
read -p "プロジェクト名はどうしますか？: " PROJECT_NAME
# -------------------------------------------------
read -p "保存先ディレクトリはどうしますか？: " SAVE_DIR
SAVE_DIR=$(eval echo "${SAVE_DIR}")
# ディレクトリno存在確認
if [ ! -d "$SAVE_DIR" ]; then
  echo "${SAVE_DIR} はないですよ。作ります？ (Y/n) "
    read -r CREATE
    if [[ "$CREATE" == "Y" || "$CREATE" == "y" ]]; then
      mkdir -p "$SAVE_DIR"
      echo "${SAVE_DIR} を作りました！"
    else
      echo "OK!"
      exit 1
    fi
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
