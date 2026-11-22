#!/usr/bin/env bash
# Sets up and starts the demo (macOS / Linux): Doppel in the browser, TKT hand control in the foreground.
# Usage: ./demo.sh ; env as in doppel/scripts/demo-with-tkt.sh (PORT, TKT_BACKEND, TKT_MODE).
set -euo pipefail
root="$(cd "$(dirname "$0")" && pwd)"
cd "$root"

# What has to be installed first; see "Before you start" in README.md.
missing=""
for tool in git node npm uv curl; do command -v "$tool" >/dev/null 2>&1 || missing="$missing $tool"; done
if [ -n "$missing" ]; then
  echo "Missing:$missing. Install them first (README.md, \"Before you start\"), then run ./demo.sh again." >&2
  exit 1
fi
node_major="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$node_major" -lt 20 ]; then
  echo "Node.js $(node -v) is too old; Doppel needs Node.js 20 or newer." >&2
  exit 1
fi
port="${PORT:-3000}"
if curl -s -o /dev/null "http://localhost:$port/"; then
  echo "Port $port is already in use. Stop what runs there or choose another: PORT=3001 ./demo.sh" >&2
  exit 1
fi

# Only the two top-level submodules; doppel/tkt is not needed because tkt/ is used.
git submodule update --init doppel tkt

[ -d doppel/node_modules ] || (cd doppel && npm ci)
(cd tkt && uv sync && { [ -f models/hand_landmarker.task ] || uv run python -m tkt.vision.tracker --download; })

TKT_DIR="$root/tkt" exec doppel/scripts/demo-with-tkt.sh
