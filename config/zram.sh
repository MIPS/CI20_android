/system/bin/busybox echo $((256*1024*1024)) > /sys/block/zram0/disksize
/system/bin/busybox mkswap /dev/block/zram0
/system/bin/busybox swapon /dev/block/zram0

/system/bin/busybox sysctl -w vm.swappiness=100
