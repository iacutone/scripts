#!/usr/bin/env python3
"""Check zendumplings.com to see if the Downtown Orlando location has opened.

Looks at the text right after "2915 E Colonial Dr" on the homepage. While it says
"Coming Soon!", nothing happens. When that text changes or disappears, it prints
what it found and pops up a macOS notification (once per change).

Exit codes: 0 = still "Coming Soon!", 1 = changed (likely open), 2 = fetch/parse error.
Usage: python3 check_zen.py [--quiet]
"""
import html
import re
import subprocess
import sys
import urllib.request
from pathlib import Path

URL = "https://www.zendumplings.com/"
ADDRESS = "2915 E Colonial Dr"
PLACEHOLDER = "Coming Soon!"
STATE_FILE = Path(__file__).with_name(".zen_state")


def fetch(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read().decode("utf-8", errors="replace")


def visible_lines(page: str) -> list[str]:
    page = re.sub(r"(?is)<(script|style)[^>]*>.*?</\1>", " ", page)
    page = re.sub(r"(?i)<br\s*/?>|</p>|</div>|</h\d>|</li>", "\n", page)
    text = html.unescape(re.sub(r"<[^>]+>", "", page))
    text = text.replace("​", "").replace("\xa0", " ")  # Wix inserts zero-width spaces
    return [ln.strip() for ln in text.splitlines() if ln.strip()]


def status_text(lines: list[str]) -> str | None:
    """Return the line after the address ('' if it's the last line), or None if address missing."""
    for i, ln in enumerate(lines):
        if ADDRESS in ln:
            return lines[i + 1] if i + 1 < len(lines) else ""
    return None


def notify(title: str, msg: str) -> None:
    safe = lambda s: s.replace("\\", "\\\\").replace('"', '\\"')
    subprocess.run(
        ["osascript", "-e", f'display notification "{safe(msg)}" with title "{safe(title)}" sound name "Glass"'],
        check=False,
    )


def main() -> int:
    quiet = "--quiet" in sys.argv
    try:
        lines = visible_lines(fetch(URL))
    except Exception as e:
        print(f"Error fetching {URL}: {e}", file=sys.stderr)
        return 2

    after = status_text(lines)
    if after is None:
        state, msg = "missing", f"Address '{ADDRESS}' no longer found on the page - check the site."
    elif after == PLACEHOLDER:
        state, msg = "coming_soon", f"Still '{PLACEHOLDER}'"
    else:
        # The next line might be another location's heading if "Coming Soon!" was simply removed.
        state, msg = f"changed:{after}", f"'{PLACEHOLDER}' is gone! Text after address now: {after!r}"

    previous = STATE_FILE.read_text().strip() if STATE_FILE.exists() else None
    if state != "coming_soon" and state != previous:
        notify("Zen Dumplings Downtown Orlando", msg)
    STATE_FILE.write_text(state)

    if not quiet or state != "coming_soon":
        print(msg)
    return 0 if state == "coming_soon" else 1


if __name__ == "__main__":
    sys.exit(main())
