#!/bin/bash

# boot script for https://github.com/karlicoss/grasp
# the script take a path as an argument
set -e

# Start Flask Server only if it is not running
if [ "$(ps -ef | ag python | ag grasp | wc -l)" -le -0 ]
then
 echo "Grasp started"
  /Users/iacutone/grasp/server/grasp_server.py --path $1
else
 echo "Grasp already running"
fi

