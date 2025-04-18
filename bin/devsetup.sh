#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/../framework/core.sh"

run_phase init
run_phase configure
run_phase execute
run_phase cleanup
