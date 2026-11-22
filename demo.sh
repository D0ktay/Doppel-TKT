#!/usr/bin/env bash
# Sets up and starts the demo (macOS / Linux): Doppel in the browser, TKT hand control in the foreground.
# Usage: ./demo.sh ; env as in doppel/scripts/demo-with-tkt.sh (PORT, TKT_BACKEND, TKT_MODE).
set -euo pipefail
root="$(cd "$(dirname "$0")" && pwd)"
cd "$root"

# Only the two top-level submodules; doppel/tkt is not needed because tkt/ is used.
git submodule update --init doppel tkt

[ -d doppel/node_modules ] || (cd doppel && npm ci)
(cd tkt && uv sync && { [ -f models/hand_landmarker.task ] || uv run python -m tkt.vision.tracker --download; })

TKT_DIR="$root/tkt" exec doppel/scripts/demo-with-tkt.sh
