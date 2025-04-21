#!/usr/bin/env bash

set -euo pipefail

DEVSETUP_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$DEVSETUP_ROOT/.."

source "$DEVSETUP_ROOT/framework/core.sh"

run_phase init
run_phase configure
run_phase execute
run_phase cleanup
