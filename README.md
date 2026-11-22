# Doppel + TKT

A Swiss personal-finance twin you control with your hand at a desk.

This repository holds no code of its own. It pins two projects as git submodules,
each still developed in its own repository:

| Folder | Project | What it does |
|---|---|---|
| [`doppel/`](https://github.com/Barlassen/Doppel) | Doppel | Web app: scan receipts and bills, simulate your finances, play the chessboard life game at `/play`. |
| [`tkt/`](https://github.com/D0ktay/TKT) | TKT | Hand control: one camera turns your hand into a pointer (cursor, click, drag, scroll, dictation). |

TKT sends ordinary mouse and keyboard input, so Doppel needs no special code to
be driven by hand. See [doppel/docs/TKT.md](https://github.com/Barlassen/Doppel/blob/main/docs/TKT.md)
for the gestures and a 30-second demo.

## Get it

```bash
git clone https://github.com/D0ktay/Doppel-TKT.git
cd Doppel-TKT
git submodule update --init doppel tkt
```

`--recurse-submodules` also works; it additionally fetches the copy of TKT that
Doppel carries in `doppel/tkt/`, which the demo does not use.

## Run the demo

Needs Node.js 20+, Python 3.11 with [`uv`](https://docs.astral.sh/uv/), and the
LogiInsight camera (or any webcam) for hand control.

```bash
./demo.sh                                           # macOS / Linux
powershell -ExecutionPolicy Bypass -File demo.ps1   # Windows
```

The script initialises the submodules, installs Doppel (`npm ci`) and TKT
(`uv sync`, hand model download) on first run, builds and starts Doppel at
`http://localhost:3000/play`, and starts TKT in the foreground. Quit TKT with
Esc or Ctrl+C; the script then stops the Doppel server.

- **macOS:** TKT starts in auto mode (desk camera = version A, camera facing you =
  version C). Give the terminal access to Camera, Accessibility and Input
  Monitoring. `TKT_MODE=a ./demo.sh` starts version A only.
- **Windows:** TKT starts in version A (desk camera) for now.

Camera setup and calibration: [tkt/README.md](https://github.com/D0ktay/TKT#readme).
Doppel without hand control, API keys and the finance engine:
[doppel/README.md](https://github.com/Barlassen/Doppel#readme).

## Update the pinned versions

```bash
git submodule update --remote doppel tkt
git commit -am "Update Doppel and TKT"
```

Changes to either project go to its own repository first.
