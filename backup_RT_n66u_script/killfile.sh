#!/bin/sh
clear
cd /
cd /tmp/mnt/1110809/script/

find /tmp/mnt/sdb/mi/xiaomi_camera_videos/94f827ad4d5b/ -type f -mtime +29 > ./mylog/$(date +%Y%m%d)kl.log 

find /tmp/mnt/sdb/mi/xiaomi_camera_videos/94f827ad4d5b/ -type f -mtime +29 -exec rm -rf {} \;
