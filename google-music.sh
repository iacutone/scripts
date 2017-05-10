#!/usr/bin/env bash
#
# gpmdp-remote - get info from Google Play Music Desktop Player easily
# https://github.com/iandrewt/gpmdp-remote
#
# Created by Andrew Titmuss
# https://github.com/iandrewt/

# Speed up script by not using Unicode
export LC_ALL=C
export LANG=C

# Determine config file location from uname
case "$(uname)" in
    "Linux" | *"BSD") json_file="$HOME/.config/Google Play Music Desktop Player/json_store/playback.json" ;;
    "Darwin") json_file="$HOME/Library/Application Support/Google Play Music Desktop Player/json_store/playback.json" ;;
    "CYGWIN"*) json_file="$APPDATA/Google Play Music Desktop Player/json_store/playback.json" ;;
esac

title () {
    printf "%s\n" "$(awk -F '"|:' '/title/ {printf $5}' "$json_file")"
}

artist () {
    printf "%s\n" "$(awk -F '"|:' '/artist/ {printf $5}' "$json_file")"
}

album () {
    printf "%s\n" "$(awk -F '"|:' '!/albumArt/ && /album/ {printf $5}' "$json_file")"
}

album_art () {
    printf "%s\n" "$(awk -F '"|:' '/albumArt/ {printf $5":"$6}' "$json_file")"
}

time_current () {
    printf "%s\n" "$(awk -F ': |,' '/current/ {printf $2}' "$json_file")"
}

time_total () {
    printf "%s\n" "$(awk -F ': |,' '/total/ {printf $2}' "$json_file")"
}

gpmdp_status () {
    gpmdp_status=$(awk -F ': |,' '/playing/ {printf $2}' "$json_file")

    if [[ "$gpmdp_status" == *"true"* ]]; then
        printf "%s\n" "Playing"
    elif [[ "$gpmdp_status" == *"false"* ]]; then
        printf "%s\n" "Paused"
    fi
}

gpmdp_info () {
    if [ "$(gpmdp_status)" == "Playing" ]; then
        printf "%s\n" "Now Playing: $(title) by $(artist)"
    elif [ "$(gpmdp_status)" == "Paused" ]; then
        printf "%s\n" "Paused: $(title) by $(artist)"
    fi
}

current () {
    if [ $(osascript -e 'application "Google Play Music Desktop Player" is running') = "true" ]; then
      printf "♫ %s\n" "$(artist) - $(title)"
    fi
}

usage () { cat << EOF

    usage: gpmdp-remote <option>

    info            Print info about now playing song
    title           Print current song title
    artist          Print current song artist
    album           Print current song album
    album_art       Print current song album art URL
    time_current    Print current song time in milliseconds
    time_total      Print total song time in milliseconds
    status          Print whether GPMDP is paused or playing
    current         Print now playing song in "artist - song" format
    help            Print this help message

EOF
exit 1
}


case $1 in
    info) gpmdp_info ;;
    title) title ;;
    artist) artist ;;
    album) album ;;
    album_art) album_art ;;
    time_current) time_current ;;
    time_total) time_total ;;
    status) gpmdp_status ;;
    current) current ;;
    *) usage ;;
esac

