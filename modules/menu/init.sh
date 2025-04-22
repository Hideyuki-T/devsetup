#!/usr/bin/env bash
# modules/menu/init.sh：プロジェクト作成フェーズ

# 1) 対話式でプロジェクト名を取得
read -rp "プロジェクト名はどうします？: " PROJECT_NAME

# 2) Projects ディレクトリ直下に一度だけ作成
BASE_DIR="${DEVSETUP_ROOT}/.."
PROJECT_DIR="${BASE_DIR}/${PROJECT_NAME}"
mkdir -p "${PROJECT_DIR}"
export PROJECT_DIR

# 3) ログ出力
log_info "modules/menu/init.sh：プロジェクトディレクトリを作成しました：${PROJECT_DIR}"

# 4) 構成メニュー表示
cat << 'EOF'
メニュー：
 [1] PHP + nginx + MySQL
 [2] PHP + nginx + MySQL + Laravel
 [3] PHP + nginx + MySQL + Laravel + Breeze
EOF
read -rp "番号を選択してね。: " SELECTED

# 5) 有効化フラグ設定
case "$SELECTED" in
  1) ENABLED[docker]=true ;;
  2) ENABLED[docker]=true; ENABLED[laravel]=true ;;
  3) ENABLED[docker]=true; ENABLED[laravel]=true; ENABLED[breeze]=true ;;
  *) log_error "無効な選択です"; exit 1 ;;
esac

log_info "modules/menu/init.sh：有効化される構成: $(printf '%s ' "${!ENABLED[@]}")"
