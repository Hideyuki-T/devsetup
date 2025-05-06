#!/usr/bin/env bash
set -euo pipefail

# pop_var_context の未定義エラーを無害化
pop_var_context(){ :; }

# プロジェクトルート定義
DEVSETUP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

source "$DEVSETUP_ROOT/framework/loader.sh"
