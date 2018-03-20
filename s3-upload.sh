#!/bin/bash
set -e

cp -R css/ build/css
cp -R photos/ build/photos
cp style.css build/style.css
cp app.js build/app.js
cp index.html build/index.html

s3cmd sync --recursive build/ s3://<bucket-name>
echo -e "\t Successfully deployed to S3"

