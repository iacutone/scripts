echo "`date +%Y-%m-%d:%H:%M:%S` SD card removed" >> /home/pi/sdcard/output.log
python /home/iacutone/sdcard/remove.py
# rm /home/pi/SD_CARD/DCIM/100MSDCF/*
sudo /bin/umount /home/iacutone/SD_CARD/
