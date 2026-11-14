#!/usr/bin/env bash
# Site tests: build the site from tests/fixture/content and assert on the built output.
# Zola is located via $ZOLA, else `zola` on PATH. Run: tests/run.sh
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ZOLA="${ZOLA:-zola}"
command -v "$ZOLA" >/dev/null 2>&1 || { echo "zola not found; set \$ZOLA or install it (docs/development.md)"; exit 2; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cp -r "$ROOT/config.toml" "$ROOT/templates" "$WORK/"
[ -d "$ROOT/sass" ] && cp -r "$ROOT/sass" "$WORK/"
[ -d "$ROOT/static" ] && cp -r "$ROOT/static" "$WORK/"
cp -r "$ROOT/tests/fixture/content" "$WORK/content"
OUT="$WORK/public"
if ! "$ZOLA" --root "$WORK" build --output-dir "$OUT" >"$WORK/build.log" 2>&1; then
  cat "$WORK/build.log"; echo "FAIL: build"; exit 1
fi

FAILS=0
pass() { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; FAILS=$((FAILS+1)); }
has()    { grep -Eq -- "$2" "$OUT/$1" 2>/dev/null && pass "$3" || fail "$3"; }
lacks()  { grep -Eq -- "$2" "$OUT/$1" 2>/dev/null && fail "$3" || pass "$3"; }
exists() { [ -e "$OUT/$1" ] && pass "$2" || fail "$2"; }
absent() { [ -e "$OUT/$1" ] && fail "$2" || pass "$2"; }

# Menu: exactly Home, Posts, Resume
menu=$(tr -d '\n' <"$OUT/index.html" | grep -oE '<nav[^>]*>.*</nav>' | grep -oE '<a [^>]*>[^<]*</a>' | sed -E 's/<[^>]*>//g' | paste -sd,)
[ "$menu" = "Home,Posts,Resume" ] && pass "menu is Home,Posts,Resume" || fail "menu is Home,Posts,Resume (got: $menu)"

# Posts naming
has posts/index.html '<h1[^>]*>Posts</h1>' "posts section heading is Posts"
lacks index.html '>Notes<' "no Notes label on home"

# Post pages render; existing URL unchanged
has posts/hello-world/index.html '<h1[^>]*>Hello World</h1>' "existing post URL /posts/hello-world/ renders"
has posts/hello-world/index.html 'Hello body text' "post body rendered"
has posts/standalone/index.html '<h1[^>]*>Standalone Post</h1>' "post outside a series renders"
has posts/index.html 'href="?[^" >]*/posts/standalone/' "posts list links posts"

# Resume
has resume/index.html 'Fixture resume body' "resume page renders"

# Tags and feed
exists tags/about/index.html "tag page exists"
has tags/about/index.html 'Hello World' "tag page lists its post"
exists rss.xml "RSS feed generated"
has rss.xml '<rss' "feed is RSS"
has posts/hello-world/index.html 'href="?[^" >]*/tags/about/' "post links to its tag"

# Search and comments removed
absent elasticlunr.min.js "no elasticlunr asset"
absent search_index.en.js "no search index"
absent js/search.js "no search script"
lacks index.html 'search|giscus' "no search or giscus markup on home"
lacks posts/hello-world/index.html 'search|giscus' "no search or giscus markup on post"

# Domain, theme, language
[ "$(cat "$ROOT/static/CNAME")" = "www.idrokin.com" ] && pass "CNAME unchanged" || fail "CNAME unchanged"
grep -q 'base_url = "https://www.idrokin.com/"' "$ROOT/config.toml" && pass "base_url unchanged" || fail "base_url unchanged"
{ ! grep -q pico "$ROOT/config.toml" && [ ! -e "$ROOT/.gitmodules" ] && [ ! -e "$ROOT/themes/pico" ]; } && pass "no pico theme, no submodule" || fail "no pico theme, no submodule"
exists style.css "single stylesheet compiled from sass"
absent css/responsive.css "no leftover pico css"
{ ! grep -rPq '[\x{0400}-\x{04FF}]' "$ROOT/templates" "$ROOT/config.toml" "$ROOT/tests/fixture/content"; } && pass "no Cyrillic in templates/config/fixture" || fail "no Cyrillic in templates/config/fixture"

echo
[ "$FAILS" -eq 0 ] && echo "all passed" || { echo "$FAILS failed"; exit 1; }
