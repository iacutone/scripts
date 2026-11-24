# zen

`check_zen.py` checks https://www.zendumplings.com/ to see whether the Downtown Orlando
location (2915 E Colonial Dr) has dropped its "Coming Soon!" text. If the text changes,
it shows a macOS notification and sends a push to your phone through ntfy.sh.

Exit codes: `0` still coming soon, `1` changed (or address missing), `2` fetch error.

## Requirements

- Python **3.10+**. The script uses `str | None` type hints, so the system
  `/usr/bin/python3` (3.9) will not work. Use Homebrew's `/opt/homebrew/bin/python3`.
- Optional: a `zen/.ntfy_topic` file containing your ntfy topic name (gitignored).

## Phone notifications (ntfy)

1. Install the **ntfy** app (iOS/Android) and subscribe to a hard-to-guess topic name,
   e.g. `zen-orlando-8f3k2q`. Anyone who knows the topic can read or post to it.
2. Save the topic name (only the name, not the URL):
   ```sh
   echo 'zen-orlando-8f3k2q' > zen/.ntfy_topic
   ```
3. Test it:
   ```sh
   curl -H "Title: test" -d "hello" https://ntfy.sh/$(cat zen/.ntfy_topic)
   ```

### How the script calls ntfy

`push_phone()` sends a plain HTTP **POST** to `https://ntfy.sh/<topic>`:

- **Body:** the message text (UTF-8)
- **Headers:** `Title: Zen Dumplings Downtown Orlando`, `Tags: dumpling` (shows a 🥟 emoji),
  `Click: https://www.zendumplings.com/` (tapping the notification opens the site)

The push only goes out when the state *changes* away from "Coming Soon!", so you get one
notification per change, not one every run. If the push fails, `.zen_state` is left as it was
so the next run tries again.

## Scheduling

### Option A: launchd (recommended on macOS, and what's installed now)

launchd runs the job inside your login session, so the macOS banner notifications work.
It also catches up on runs missed while the Mac was asleep. The agent lives in
`../plist/com.zen.check.plist` and runs every 30 minutes, plus once at load.

That plist is a template. `install.sh` fills in this machine's `python3`, repo path and
home directory, copies it to `~/Library/LaunchAgents/` and loads it (re-run it to reload):

```sh
zen/install.sh

# check that it's loaded
launchctl list | grep com.zen.check

# logs
tail -f ~/Library/Logs/zen-check.log

# remove it
launchctl bootout gui/$(id -u)/com.zen.check && rm ~/Library/LaunchAgents/com.zen.check.plist
```

### Option B: cron

1. Run `crontab -e` and add this line (every 30 minutes):
   ```cron
   */30 * * * * /opt/homebrew/bin/python3 /Users/ericiacutone/scripts/zen/check_zen.py --quiet >> $HOME/Library/Logs/zen-check.log 2>&1
   ```
2. Check it with `crontab -l`.

Notes on cron:
- cron runs with a minimal `PATH`, so use absolute paths. Don't use the asdf shim
  (`~/.asdf/shims/python3`), because it won't resolve under cron.
- On recent macOS versions, `/usr/sbin/cron` may need **Full Disk Access**
  (System Settings → Privacy & Security) before it can read files in your home folder.
- macOS banner notifications from cron are unreliable. The ntfy phone push works either way.
- Don't run cron and launchd together, or each change will notify you twice.

## Manual run

```sh
/opt/homebrew/bin/python3 zen/check_zen.py   # prints the current status
rm zen/.zen_state                            # reset so the next change notifies again
```
