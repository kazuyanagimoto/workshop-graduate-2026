#!/usr/bin/env sh
# Pre-render hook: refresh `quarto-version` in _variables.yml with the latest
# stable Quarto release, so the install instructions in index.qmd never go
# stale. The feed is the same JSON that https://quarto.org/docs/download/ uses.
#
# If the fetch fails (offline, feed unreachable), the value committed in
# _variables.yml is kept and the render continues.

set -u

VARS_FILE="_variables.yml"
FEED="https://quarto.org/docs/download/_download.json"

latest=$(curl -fsSL --max-time 10 "$FEED" 2>/dev/null |
  grep -m1 '"version"' |
  sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')

if ! printf '%s' "$latest" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "update-quarto-version: fetch failed; keeping the value in $VARS_FILE" >&2
  exit 0
fi

if [ -f "$VARS_FILE" ] && grep -q '^quarto-version:' "$VARS_FILE"; then
  # In-place edit, so any other variable in the file is left untouched.
  sed -i.bak -E "s/^quarto-version:.*/quarto-version: $latest/" "$VARS_FILE"
  rm -f "$VARS_FILE.bak"
else
  printf 'quarto-version: %s\n' "$latest" >>"$VARS_FILE"
fi

echo "update-quarto-version: quarto-version = $latest"
