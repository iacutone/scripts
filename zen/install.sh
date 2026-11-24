#!/bin/sh
# Install the zen check LaunchAgent, filling in this machine's paths.
set -eu

REPO=$(cd "$(dirname "$0")/.." && pwd)
# check_zen.py is stdlib-only. Prefer a fixed interpreter path over version-manager
# shims (asdf/pyenv), which often break under launchd. Override with PYTHON=/path.
if [ -z "${PYTHON:-}" ]; then
  for p in /opt/homebrew/bin/python3 /usr/local/bin/python3 /usr/bin/python3; do
    [ -x "$p" ] && PYTHON=$p && break
  done
fi
[ -n "${PYTHON:-}" ] || { echo "no python3 found; set PYTHON=/path/to/python3" >&2; exit 1; }
LABEL=com.zen.check
DEST="$HOME/Library/LaunchAgents/$LABEL.plist"

mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
sed -e "s|__PYTHON__|$PYTHON|g" -e "s|__REPO__|$REPO|g" -e "s|__HOME__|$HOME|g" \
  "$REPO/plist/$LABEL.plist" > "$DEST"
plutil -lint "$DEST" >/dev/null

# Reload if already installed.
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$DEST"

echo "Installed $DEST"
echo "  python: $PYTHON"
echo "  script: $REPO/zen/check_zen.py"
