#!/bin/bash

set -e

RESPONSE=$(~/scripts/ticker/ticker.sh $(cat ~/scripts/ticker/tmux_ticker.conf))
echo "$RESPONSE" > ~/Dropbox/ticker.txt
echo "$RESPONSE"
