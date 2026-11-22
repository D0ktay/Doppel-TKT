# Sets up and starts the demo (Windows): Doppel in the browser, TKT hand control in the foreground.
# Usage: powershell -ExecutionPolicy Bypass -File demo.ps1 [-Port 3000] [-Backend pynput]
param(
  [int]$Port = 3000,
  [string]$Backend = "pynput"
)
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
Push-Location $root
try {
  # Only the two top-level submodules; doppel/tkt is not needed because tkt/ is used.
  git submodule update --init doppel tkt
  if ($LASTEXITCODE -ne 0) { throw "git submodule update failed" }

  if (-not (Test-Path "doppel\node_modules")) {
    Push-Location doppel; try { npm ci; if ($LASTEXITCODE -ne 0) { throw "npm ci failed" } } finally { Pop-Location }
  }
  Push-Location tkt
  try {
    uv sync
    if ($LASTEXITCODE -ne 0) { throw "uv sync failed" }
    if (-not (Test-Path "models\hand_landmarker.task")) { uv run python -m tkt.vision.tracker --download }
  } finally { Pop-Location }
} finally {
  Pop-Location
}

& (Join-Path $root "doppel\scripts\demo-with-tkt.ps1") -TktDir (Join-Path $root "tkt") -Port $Port -Backend $Backend
