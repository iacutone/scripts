#!/bin/bash

set -e

# query the FINNHUB API for stock quotes
# example response: 
# {"c":231.41,"d":0.84,"dp":0.3643,"h":233.22,"l":229.57,"o":229.74,"pc":230.57,"t":1729972800}

RESPONSE=$(curl "https://finnhub.io/api/v1/quote?symbol=$1&token=$FINNHUB")

CURRENT_PRICE=$(echo "$RESPONSE" | jq .c)

echo "$CURRENT_PRICE"
