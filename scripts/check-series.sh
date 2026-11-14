#!/usr/bin/env bash
# Validate Series front matter of Posts. Usage: scripts/check-series.sh [content-dir]
#   - a Post in more than one Series: warning (only the first is used), exit status unaffected
#   - a Post in a Series without an integer extra.part: error, exit status 1
dir="${1:-content}"
status=0
while IFS= read -r f; do
  # front matter only (between the +++ fences); join the `series = [...]` array, even over several lines
  fm=$(awk '/^\+\+\+[[:space:]]*$/{n++; next} n==1' "$f")
  series=$(printf '%s\n' "$fm" | awk '
    /^series[[:space:]]*=/ {on=1}
    on {print}
    on && /\]/ {exit}')
  [ -n "$series" ] || continue
  n=$(printf '%s' "$series" | grep -o '"[^"]*"' | wc -l)
  if [ "$n" -gt 1 ]; then
    echo "WARNING: $f is in $n Series; only the first is used" >&2
  fi
  if ! printf '%s\n' "$fm" | grep -Eq '^part[[:space:]]*=[[:space:]]*[0-9]+[[:space:]]*$'; then
    echo "ERROR: $f is in a Series but has no integer extra.part" >&2
    status=1
  fi
done < <(find "$dir" -name '*.md' -path '*posts*')
exit $status
