#!/bin/bash
set -e

curl \
  "https://www.googleapis.com/youtube/v3/search?part=snippet&q=talking%20heads&key=${YOUTUBE_API_KEY}" \
  --header 'Accept: application/json' \
  --compressed
