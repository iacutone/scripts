#!/bin/bash

echo "`date +%Y-%m-%d:%H:%M:%S` SD card inserted" >> /home/pi/sdcard/output.log
mount /dev/sda1 /home/pi/SD_CARD
rsync -av --exclude="*.JPG" /home/pi/SD_CARD/DCIM/100MSDCF/ /home/pi/external_hd/raw_photos
rsync -av --exclude="*.ARW" /home/pi/SD_CARD/DCIM/100MSDCF/ /home/pi/external_hd/jpg_photos

cat /home/pi/sdcard/output.log | mail -s "RSync complete" eric.iacutone@gmail.com
