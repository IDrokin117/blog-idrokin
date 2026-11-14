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
has resume/index.html 'href="?mailto:fixture@example.com[" >]' "resume shows email from front matter"
has resume/index.html 'href="?https://github.com/fixture[" >]' "resume shows GitHub from front matter"
has resume/index.html 'href="?https://www.linkedin.com/in/fixture/[" >]' "resume shows LinkedIn from front matter"
has resume/index.html 'Fixtureland' "resume shows location from front matter"
for h in Summary Experience Skills Education; do
  has resume/index.html "<h2[^>]*>$h</h2>" "resume renders $h section from markdown"
done
# Real resume: single markdown source with contacts in front matter and the four sections
REAL="$ROOT/content/resume/_index.md"
for h in Summary Experience Skills Education; do
  grep -Eq "^## $h\s*$" "$REAL" && pass "real resume has $h heading" || fail "real resume has $h heading"
done
for k in email github linkedin location; do
  awk '/^\+\+\+/{n++} n==1' "$REAL" | grep -Eq "^$k *=" && pass "real resume front matter has $k" || fail "real resume front matter has $k"
done
{ ! grep -Eq '<(a|div|ul|section) ' "$REAL" 2>/dev/null; } && pass "real resume has no HTML markup" || fail "real resume has no HTML markup"

# Home page (links must be in the page body, not only in the header or footer)
home_main=$(tr -d '\n' <"$OUT/index.html" | grep -oE '<main[^>]*>.*</main>')
in_home() { printf '%s' "$home_main" | grep -Eq -- "$1" && pass "$2" || fail "$2"; }
has index.html '<h1[^>]*>Igor Drokin</h1>' "home shows the author name"
in_home '<img[^>]*avatar' "home shows an avatar"
in_home 'href="?[^" >]*/resume/?[" >]' "home links to Resume"
in_home 'href="?https://github\.com/[^" >]+' "home links to GitHub"
in_home 'href="?https://www\.linkedin\.com/[^" >]+' "home links to LinkedIn"
in_home 'href="?mailto:[^" >]+' "home links to Email"
home_posts=$(grep -oE 'href="?[^" >]*/posts/[a-z-]+/' "$OUT/index.html" | sed -E 's#.*/posts/([a-z-]+)/#\1#' | paste -sd,)
[ "$home_posts" = "latest-four,latest-three,standalone" ] && pass "home lists exactly the three latest posts, newest first" || fail "home lists exactly the three latest posts, newest first (got: $home_posts)"
avatar_file=$(ls "$ROOT"/static/images/avatar.* 2>/dev/null | head -1)
avatar_kb=$(( $(stat -c %s "$avatar_file") / 1024 ))
[ "$avatar_kb" -lt 200 ] && pass "avatar under 200 KB" || fail "avatar under 200 KB (${avatar_kb} KB)"

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

# Projects hidden
absent projects/index.html "no Projects page in built output"
absent projects/hidden/index.html "draft Project page not built"
lacks index.html 'projects' "no Projects link on home"
lacks posts/index.html 'projects' "no Projects link on posts list"
lacks rss.xml 'Hidden Project' "Projects not in feed"

# Per-page scripts
has posts/with-script/index.html '<script src="?[^" >]*/js/demo\.js' "page declaring a script loads it"
[ "$(grep -o '<script' "$OUT/posts/with-script/index.html" | wc -l)" -eq 1 ] && pass "scripted page loads only its own script" || fail "scripted page loads only its own script"
lacks posts/hello-world/index.html '<script' "page without script loads no scripts"
lacks index.html '<script' "home loads no scripts"

# Domain, theme, language
[ "$(cat "$ROOT/static/CNAME")" = "www.idrokin.com" ] && pass "CNAME unchanged" || fail "CNAME unchanged"
grep -q 'base_url = "https://www.idrokin.com/"' "$ROOT/config.toml" && pass "base_url unchanged" || fail "base_url unchanged"
{ ! grep -q pico "$ROOT/config.toml" && [ ! -e "$ROOT/.gitmodules" ] && [ ! -e "$ROOT/themes/pico" ]; } && pass "no pico theme, no submodule" || fail "no pico theme, no submodule"
exists style.css "single stylesheet compiled from sass"
absent css/responsive.css "no leftover pico css"
{ ! grep -rPq '[\x{0400}-\x{04FF}]' "$ROOT/templates" "$ROOT/config.toml" "$ROOT/tests/fixture/content"; } && pass "no Cyrillic in templates/config/fixture" || fail "no Cyrillic in templates/config/fixture"

echo
[ "$FAILS" -eq 0 ] && echo "all passed" || { echo "$FAILS failed"; exit 1; }
