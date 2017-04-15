#!/bin/sh
/usr/sbin/rclone sync /home/pi/external_hd/raw_photos/ amazon:raw_photos --config /home/pi/.rclone.conf -v
/usr/sbin/rclone sync /home/pi/external_hd/jpg_photos/ amazon:jpg_photos --config /home/pi/.rclone.conf -v
