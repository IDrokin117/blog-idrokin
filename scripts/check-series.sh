#!/usr/bin/env bash
# Warn about Posts assigned to more than one Series. Usage: scripts/check-series.sh [content-dir]
dir="${1:-content}"
while IFS= read -r f; do
  line=$(grep -E '^series[[:space:]]*=' "$f" | head -1)
  n=$(printf '%s' "$line" | grep -o '"[^"]*"' | wc -l)
  if [ "$n" -gt 1 ]; then
    echo "WARNING: $f is in $n Series; only the first is used" >&2
  fi
done < <(find "$dir" -name '*.md' -path '*posts*')
exit 0
