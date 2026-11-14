#!/usr/bin/env bash
# Build the site, check internal links, and render the Resume page to /files/resume.pdf.
# This is the single source of truth for the build: CI runs exactly this script.
#
#   scripts/build.sh            # output in public/
#   OUT=dir scripts/build.sh    # custom output directory
#
# Zola: $ZOLA, else `zola` on PATH.
# uv (https://docs.astral.sh/uv/): the Resume PDF is rendered by WeasyPrint via scripts/resume-pdf.py.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ZOLA="${ZOLA:-zola}"
OUT="${OUT:-$ROOT/public}"
PDF_PATH="files/resume.pdf"   # stable URL: https://www.idrokin.com/files/resume.pdf
RESUME_PATH="resume/"

command -v "$ZOLA" >/dev/null 2>&1 || { echo "zola not found; set \$ZOLA or install it (docs/development.md)" >&2; exit 2; }
command -v uv >/dev/null 2>&1 || { echo "uv not found; install it (docs/development.md)" >&2; exit 2; }

cd "$ROOT"

echo "==> check series"
scripts/check-series.sh content

echo "==> build"
"$ZOLA" build --output-dir "$OUT" --force

echo "==> check internal links"
"$ZOLA" check --skip-external-links

echo "==> generate PDF"
# Render from a throwaway build whose base_url is a local server, so the page loads
# its own fresh CSS instead of the live site's; the published build keeps the real base_url.
WORK="$(mktemp -d)"
SERVER_PID=""
cleanup() { [ -n "$SERVER_PID" ] && kill "$SERVER_PID" 2>/dev/null || true; rm -rf "${WORK:?}"; }
trap cleanup EXIT
# Ask the OS for a free port (PDF_PORT overrides), so a stale server cannot be hit.
PORT="${PDF_PORT:-$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')}"
"$ZOLA" build --output-dir "$WORK/site" --base-url "http://127.0.0.1:$PORT" --force >/dev/null
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$WORK/site" >"$WORK/server.log" 2>&1 &
SERVER_PID=$!
up=""
for _ in $(seq 1 50); do
  kill -0 "$SERVER_PID" 2>/dev/null || { cat "$WORK/server.log" >&2; echo "PDF server exited (port $PORT busy?)" >&2; exit 1; }
  python3 -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:$PORT/', timeout=1)" 2>/dev/null && { up=1; break; }
  sleep 0.1
done
[ -n "$up" ] || { echo "PDF server did not come up on port $PORT" >&2; exit 1; }
# The page WeasyPrint will render must be the Resume (its <h1> comes from the built page).
EXPECTED=$(grep -oE '<h1[^>]*>[^<]+' "$OUT/${RESUME_PATH}index.html" | head -1 | sed -E 's/<[^>]*>//')
[ -n "$EXPECTED" ] || { echo "no <h1> in built Resume page" >&2; exit 1; }
python3 -c "import urllib.request,sys; sys.exit(0 if sys.argv[1] in urllib.request.urlopen('http://127.0.0.1:$PORT/$RESUME_PATH', timeout=5).read().decode() else 1)" "$EXPECTED" \
  || { echo "served Resume page does not contain '$EXPECTED'" >&2; exit 1; }
mkdir -p "$OUT/$(dirname "$PDF_PATH")"
uv run --quiet scripts/resume-pdf.py "http://127.0.0.1:$PORT/$RESUME_PATH" "$OUT/$PDF_PATH" >"$WORK/pdf.log" 2>&1 \
  || { cat "$WORK/pdf.log" >&2; echo "WeasyPrint failed to render the PDF" >&2; exit 1; }

[ -s "$OUT/$PDF_PATH" ] && head -c 4 "$OUT/$PDF_PATH" | grep -q '%PDF' \
  || { echo "PDF was not generated at $OUT/$PDF_PATH" >&2; exit 1; }
# Where pdftotext exists, also confirm the PDF text contains the Resume heading.
if command -v pdftotext >/dev/null 2>&1; then
  pdftotext "$OUT/$PDF_PATH" - 2>/dev/null | grep -qF "$EXPECTED" \
    || { echo "PDF does not contain Resume text ('$EXPECTED')" >&2; exit 1; }
fi
# Local copy for `zola serve`, which does not serve public/ (static/files/ is gitignored).
mkdir -p "static/$(dirname "$PDF_PATH")" && cp "$OUT/$PDF_PATH" "static/$PDF_PATH"
echo "ok: $OUT/$PDF_PATH ($(wc -c <"$OUT/$PDF_PATH") bytes)"
