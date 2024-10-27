#!/bin/bash

set -e

COUNTER=$(cat ~/scripts/ticker/counter.txt)
UPDATED_COUNT=$($COUNTER + 1)
SYMBOLS=$(cat ~/scripts/ticker/ticker.conf)
SYMBOL_COUNT=$(wc -w < ~/scripts/ticker/ticker.conf)
SYBMOL_ARR=($SYMBOLS)

if (($UPDATED_COUNT == $SYMBOL_COUNT)); then
  RESPONSE=$(~/scripts/ticker/ticker.sh ${SYBMOL_ARR[0]})
  echo "$RESPONSE" > ~/Dropbox/ticker.txt
  echo "$RESPONSE"
  echo "0" > ~/scripts/ticker/counter.txt
else
  RESPONSE=$(~/scripts/ticker/ticker.sh ${SYBMOL_ARR[$UPDATED_COUNT]})
  echo "$RESPONSE" > ~/Dropbox/ticker.txt
  echo "$RESPONSE"
fi
