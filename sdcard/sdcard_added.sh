#!/bin/bash

set -e

# set arg $1 to dir to read files
# set arg $2 to file extension to sync
# set arg $3 to file extension to exclude in dir

# Example: `sudo ./sdcard_added.sh /home/iacutone/sdcard/jpg/ .JPG .ARW`

python /home/iacutone/sdcard/insert.py

rename_files() {
  for f in *$1
  do
    prepend_date=$(date -r $f +%Y-%m-%d-%H-%M-%S)
    mv "$f" "../$prepend_date-$f"
  done
}

rsync_files() {
  rsync -av --exclude="*$1" $2 $PWD
}

log() {
  echo $1 >> /home/iacutone/sdcard/output.log
}

DATE=$(date +%Y-%m-%d-%H-%M-%S)
log "$DATE SD card inserted"
mkdir /home/iacutone/sdcard/tmp
cd /home/iacutone/sdcard/tmp
rsync_files $3 $1
rename_files $2
cd ..
rm -r /home/iacutone/sdcard/tmp
log "$DATE Finished importing SD Card"

# rsync -av /home/iacutone/SD_CARD/MP_ROOT/100ANV01/ /home/iacutone/external/videos/$DATE/

