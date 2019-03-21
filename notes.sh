#!/bin/bash
set -e

fpath=$HOME/Dropbox/notes.md

if [ "$1" == "cat" ]; then
  cat "$fpath"
  exit 0
elif [ "$1" == "ag" ]; then
  ag "$2" "$fpath"
elif [ "$1" == "nvim" ]; then
  nvim "$fpath"
elif [ "$1" == "--help" ]; then
  printf 'Commands: \n-----------------------------------------------\n
  $ notes \n
  $ notes --help\t--\tdisplay this help\n
  $ notes date\t\t--\tadd date row to notes\n
  $ notes <text>\t--\tadd new entry \n
  $ notes cat\t\t--\tprint notes using cat\n
  $ notes ag <pattern>\t--\grep notes\n'
elif [ "$1" == "date" ]; then
  {
    echo ''
    echo '# '"$(date +"%m-%d-%Y-%T")"
    echo '-'
  } >> "$fpath"
else
  {
    echo ''
    echo "$@"
    echo ''
  } >> "$fpath"
fi
