#!/usr/bin/env bash
# Laravel モジュール：初期化フェーズ

log_info "modules/laravel/init.sh：Laravel プロジェクトを作成中…"
composer create-project laravel/laravel src
log_info "modules/laravel/init.sh：プロジェクト生成完了（src ディレクトリ）"
