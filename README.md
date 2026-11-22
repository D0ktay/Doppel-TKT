# Doppel + TKT

A Swiss personal-finance digital twin, built from a person's own data and bank
statement, that you can also control with your hand at a desk.

This repository holds no code of its own. It pins two projects as git submodules,
each still developed in its own repository:

| Folder | Project | What it does |
|---|---|---|
| [`doppel/`](https://github.com/Barlassen/Doppel) | Doppel | The twin: web app, plus a desktop app (`desktop/`) and an Expo shell for Android (`mobile/`). |
| [`tkt/`](https://github.com/D0ktay/TKT) | TKT | Hand control: one camera turns your hand into a pointer (cursor, click, drag, scroll, dictation). |

## What the twin does

- **Reads a bank statement** (CSV, camt.053, MT940, broker / pillar 3a) and shows what it
  learned: income, fixed costs, spending by category, saving rate, and inferred facts
  (tenant, car, child, debt) that the user confirms or rejects. Receipts, QR-bills,
  payslips and listings can be scanned as well.
- **Shows who the twin is and where the money goes:** a twin card with a financial
  health score in five labelled parts, "Where my money goes" per month or per year,
  recurring payments, this month against the usual, and next month's forecast.
- **Shows what a decision changes:** a child, a car (bought, financed, leased or a GA
  travelcard instead), a home, a partner, a move, further education, part-time work,
  self-employment, a job loss, an inheritance. Each comes with its own cost lines from
  sourced Swiss figures, the monthly budget before and after, net worth in 1, 5 and 10
  years, the lowest cash point, and the goal odds before and after.
- **Follows the economy:** five scenarios (baseline, high inflation, recession, low
  rates, climate transition) on one dated, sourced table of assumptions.
- **Answers questions** through a small language model that may only quote figures the
  engine computed; an answer with any other number is refused. No model does arithmetic.
- **Is a game too:** `/play` turns the same twin into a chess-review life game.

TKT sends ordinary mouse and keyboard input, so Doppel needs no special code to
be driven by hand. See [doppel/docs/TKT.md](https://github.com/Barlassen/Doppel/blob/main/docs/TKT.md)
for the gestures and a 30-second demo.

## Before you start

Install these once; everything else is fetched by the scripts.

| | macOS | Windows |
|---|---|---|
| Git | `xcode-select --install` | `winget install Git.Git` |
| Node.js 20 or newer | `brew install node` | `winget install OpenJS.NodeJS.LTS` |
| [uv](https://docs.astral.sh/uv/) (it fetches Python 3.11 itself) | `brew install uv` | `winget install astral-sh.uv` |

Open a new terminal afterwards so the commands are found. Hand control needs a
camera; Doppel alone does not.

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

The script checks that Git, Node.js and uv are installed, initialises the
submodules, installs Doppel (`npm ci`) and TKT (`uv sync`, hand model download)
on first run, builds and starts Doppel at `http://localhost:3000/play`, and
starts TKT in the foreground. Quit TKT with Esc or Ctrl+C; the script then stops
the Doppel server. The first run takes a few minutes.

If something does not start:

- **"Port 3000 is already in use":** `PORT=3001 ./demo.sh`, or `demo.ps1 -Port 3001`.
- **The pointer does not move (macOS):** System Settings → Privacy & Security →
  give the terminal Camera, Accessibility and Input Monitoring, then start again.
- **The wrong camera opens:** `cd tkt && uv run python -m tkt.vision.camera --list`,
  then set `name` or `index` under `[camera]` in `tkt/config/vision.toml`. With no
  saved calibration TKT starts with default values; calibrate in
  `uv run python -m tkt.vision.debug_view` if the pointer feels off.
- **No camera at hand:** run Doppel alone (next section).

- **macOS:** TKT starts in auto mode (desk camera = version A, camera facing you =
  version C). Give the terminal access to Camera, Accessibility and Input
  Monitoring, and allow Automation (System Events) when asked; dictation needs it.
  `TKT_MODE=a ./demo.sh` starts version A only.
- **Windows:** TKT starts in version A (desk camera) for now.

### Hand control on macOS: what to know before the demo

- **In C the hand mouse starts off**, so a hand passing in front of the camera does
  not move the pointer. Hold a **peace sign** (index and middle up, ring and little
  finger curled) for half a second to turn it on, and again to turn it off. Do this
  first, or the pointer will look dead.
- **Teach the peace sign once on the demo machine** (about 15 seconds): with TKT not
  running, `cd tkt && uv run python -m tkt.app.sign_calib`, make the sign, press Space,
  hold it, then Enter. Without it, fixed thresholds are used and may not match your hand.
- **Control window:** Ctrl+N (or "TKT" in the menu bar) shows it. It has the hand-mouse
  switch, distance zoom, the desk-area option for version A, and one row per
  calibration (desk area, hand, pinch, peace sign, normal distance) with a button to
  redo only that one. Calibrations are kept in `~/.tkt/`, nothing is redone on the next start.
- **Distance zoom** (off by default): Ctrl+M turns it on; lean back and the frontmost app
  zooms in by up to four steps, back at your normal distance it returns to normal. Ctrl+Shift+M
  takes your current distance as normal. Apps without a Zoom In / Zoom Out menu item
  (for example VS Code, Finder) are left alone.
- Esc quits from anywhere.

Camera setup and calibration: [tkt/README.md](https://github.com/D0ktay/TKT#readme).

## Run Doppel alone

```bash
cd doppel
npm ci
cp .env.example .env.local   # optional: a key for the assistant (OpenRouter or any OpenAI-compatible endpoint)
npm run build && npm start   # http://localhost:3000
```

Without a key everything except the assistant's wording works; all numbers are
computed on the device.

- **Desktop app** (starts with a double-click, runs the server inside the app):
  `npm run desktop:install && npm run desktop:build`, see [docs/DESKTOP.md](https://github.com/Barlassen/Doppel/blob/main/docs/DESKTOP.md).
- **Android, in Expo Go:** `cd mobile && npm install && npx expo start`, see
  [docs/MOBILE.md](https://github.com/Barlassen/Doppel/blob/main/docs/MOBILE.md). It is a shell around the running web app.

More: [doppel/README.md](https://github.com/Barlassen/Doppel/blob/main/README.md).

## For judges

Built at LauzHack 2026 for the UBS "AI Financial Twin" track and the AXA "Frugal use
of multimodal AI" track. All people, companies and documents are fictional.

| Question | Where to look |
|---|---|
| What is scored and where is the evidence? | [doppel/docs/JUDGING.md](https://github.com/Barlassen/Doppel/blob/main/docs/JUDGING.md): rubric table, the five judge questions, assumptions and limits |
| Three-minute demo | Same file, "Three-minute demo"; hand gestures in [doppel/docs/TKT.md](https://github.com/Barlassen/Doppel/blob/main/docs/TKT.md) |
| Token and cost evidence (AXA) | [doppel/docs/BENCHMARK.md](https://github.com/Barlassen/Doppel/blob/main/docs/BENCHMARK.md), and the Inspector in the app |
| Design decisions | [doppel/docs/DECISIONS.md](https://github.com/Barlassen/Doppel/blob/main/docs/DECISIONS.md) |

Reproduce the numbers without a camera or an API key:

```bash
cd doppel && npm ci
npm run engine:check        # finance engine on the built-in accounts
npm run engine:regression   # one check per fixed engine or parser bug
npm run ubs:check           # engine against the UBS starter kit's ledger
npm run api:check           # model gateway: guards, caps, answers refused when not grounded
npm run play:check          # the /play life game, incl. parity with the dashboard engine
cd ../tkt && uv sync && uv run pytest   # hand control, on recordings and synthetic input
```

Known and not verified:

- `npm run play:board` has one failing check: 208 of 250 simulated games open in the
  centre and the check asks for all of them. Its other checks pass (no illegal move,
  no king walk in the opening, the clicked piece is the piece that moves).
- The mobile shell was not run on a phone; the Windows desktop installer was built but
  not run; the two demo scripts were not run end to end with a camera, and `demo.ps1`
  was not run on Windows. Run the demo once on the demo machine first.
- With a live model about one answer in four is refused by the grounding check; the
  user then sees that it could not be answered from the engine's figures.

## Update the pinned versions

```bash
git submodule update --remote doppel tkt
git commit -am "Update Doppel and TKT"
```

Changes to either project go to its own repository first.

## License

The files in this repository are MIT licensed, see [LICENSE](LICENSE). `doppel/` and `tkt/` are separate repositories with their own licenses.
