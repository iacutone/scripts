echo "`date +%Y-%m-%d:%H:%M:%S` SD card removed" >> /home/pi/sdcard/output.log
rm /home/pi/SD_CARD/DCIM/100MSDCF/*
umount /dev/sda1
