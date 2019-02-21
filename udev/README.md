Refer to [this](http://iacutone.github.io/post/2017/04/15/my-photo-storage-solution/) blog post for further details.

1. Check where device is located `ls -l /dev/disk/by-uuid`
1. `cd /etc/udev/rules.d`
1. `touch 50-sdcard.rules`
1. `chmod +x 50-sdcard.rules`
1. `touch /home/pi/sdcard/sdcard_added.sh`
1. `chmod +x /home/pi/sdcard/sdcard_added.sh`
1. `echo 'KERNEL=="sda1", ACTION=="add", RUN+="/home/pi/sdcard/sdcard_added.sh"' < 50-sdcard.rules`
