#!/bin/bash
set -e

fpath=$HOME/notes.md

if [ "$1" == "cat" ]; then
  cat "$fpath"
  exit 0
elif [ "$1" == "rg" ]; then
  rg "$2" "$fpath"
elif [ "$1" == "nano" ]; then
  nano "$fpath"
elif [ "$1" == "--help" ]; then
  printf 'Commands: \n-----------------------------------------------\n
  $ notes \n
  $ notes --help\t\t--\tdisplay this help\n
  $ notes date\t\t--\tadd date row to notes\n
  $ notes <text>\t\t--\tadd new entry \n
  $ notes cat\t\t--\tprint notes using cat\n
  $ notes rg <pattern>\t--\tripgrep notes\n
  Remember to use #tags (for easier grepping)!\n\n'
elif [ "$1" == "date" ]; then
  {
    echo ''
    echo '# '"$(date +"%m-%d-%Y-%T")"
    echo '-'
  } >> "$fpath"
elif [ "$1" == "" ]; then
  less +G "$fpath"
else
  {
    echo ''
    echo "$@"
    echo ''
  } >>"$fpath"
fi
