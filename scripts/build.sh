#!/usr/bin/env bash
# Build the site, check internal links, and render the Resume page to /files/resume.pdf.
# This is the single source of truth for the build: CI runs exactly this script.
#
#   scripts/build.sh            # output in public/
#   OUT=dir scripts/build.sh    # custom output directory
#
# Zola: $ZOLA, else `zola` on PATH.
# Chrome/Chromium (any headless-capable build): $CHROME, else google-chrome, chromium,
# chromium-browser or chrome-headless-shell on PATH.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ZOLA="${ZOLA:-zola}"
OUT="${OUT:-$ROOT/public}"
PDF_PATH="files/resume.pdf"   # stable URL: https://www.idrokin.com/files/resume.pdf
RESUME_PATH="resume/"

command -v "$ZOLA" >/dev/null 2>&1 || { echo "zola not found; set \$ZOLA or install it (docs/development.md)" >&2; exit 2; }
CHROME_BIN="${CHROME:-}"
if [ -z "$CHROME_BIN" ]; then
  for c in google-chrome google-chrome-stable chromium chromium-browser chrome-headless-shell; do
    command -v "$c" >/dev/null 2>&1 && { CHROME_BIN="$c"; break; }
  done
fi
[ -n "$CHROME_BIN" ] || { echo "Chrome/Chromium not found; set \$CHROME or install it (docs/development.md)" >&2; exit 2; }

cd "$ROOT"

echo "==> build"
"$ZOLA" build --output-dir "$OUT" --force

echo "==> check internal links"
"$ZOLA" check --skip-external-links

echo "==> generate PDF"
# Render from a throwaway build whose base_url is a local server, so the page loads
# its own fresh CSS instead of the live site's; the published build keeps the real base_url.
WORK="$(mktemp -d)"
SERVER_PID=""
cleanup() { [ -n "$SERVER_PID" ] && kill "$SERVER_PID" 2>/dev/null || true; rm -rf "$WORK"; }
trap cleanup EXIT
PORT="${PDF_PORT:-8765}"
"$ZOLA" build --output-dir "$WORK/site" --base-url "http://127.0.0.1:$PORT" --force >/dev/null
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$WORK/site" >/dev/null 2>&1 &
SERVER_PID=$!
for _ in $(seq 1 50); do
  python3 -c "import urllib.request,sys; urllib.request.urlopen('http://127.0.0.1:$PORT/', timeout=1)" 2>/dev/null && break
  sleep 0.1
done
mkdir -p "$OUT/$(dirname "$PDF_PATH")"
"$CHROME_BIN" --headless --no-sandbox --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/$PDF_PATH" "http://127.0.0.1:$PORT/$RESUME_PATH" >/dev/null 2>&1 || true

[ -s "$OUT/$PDF_PATH" ] && head -c 4 "$OUT/$PDF_PATH" | grep -q '%PDF' \
  || { echo "PDF was not generated at $OUT/$PDF_PATH" >&2; exit 1; }
echo "ok: $OUT/$PDF_PATH ($(wc -c <"$OUT/$PDF_PATH") bytes)"
