#!/bin/bash
clear
find /media/Data/xizomi/1130129/ftp/xiaomi_camera_videos/94f827ad4d5b/ -type f -mtime +30 > /media/Data/xizomi/mylog/$(date +%Y%m%d)kl.log
find /media/Data/xizomi/1130129/ftp/xiaomi_camera_videos/94f827ad4d5b/ -type f -mtime +30 -exec rm -rf {} \;
find /media/Data/xizomi/1130129/ftp/xiaomi_camera_videos/94f827ad4d5b/ -type d -mtime +30 >> /media/Data/xizomi/mylog/$(date +%Y%m%d)kl.log
find /media/Data/xizomi/1130129/ftp/xiaomi_camera_videos/94f827ad4d5b/ -type d -mtime +30 -exec rm -rf {} \;

