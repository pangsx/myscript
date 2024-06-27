#!/bin/sh
clear
cd /
cd tmp/mnt/1110809/script/reward/
wget -q --no-check-certificate "https://drive.google.com/u/0/uc?id=1ZYwMUj_SRo245-wdZ_q8YbXSgl20L5xU&export=download" -O "big2.txt"
wget -q --no-check-certificate "https://drive.google.com/u/0/uc?id=1VGKxhGw9U9Qaes-o0JWDd3vLLguOxwy9&export=download" -O "happy2.txt"
sh checkinput.sh happy2.txt
sh checkinput.sh big2.txt

rm -f big1.txt
rm -f happy1.txt
mv happy2.txt happy1.txt
mv big2.txt big1.txt
#echo -e "\n" >> big1.txt
#cat big2.txt >> big1.txt
#sed -i '/^$/d' big1.txt
#echo -e "\n" >> happy1.txt
#cat happy2.txt >> happy1.txt
#sed -i '/^$/d' happy1.txt

curl -s -o happy.db https://www.taiwanlottery.com.tw/lotto/superlotto638/history.aspx
curl -s -o big.db https://www.taiwanlottery.com.tw/lotto/Lotto649/history.aspx

sh makedb.sh happy.db
sh makedb.sh big.db

if [ -e solh.txt ]
then
	sh matchm.sh happy1.txt solh.txt

else
	echo "no solh.txt,but it is going on"
fi
if [ -e solb.txt ]
then
	sh matchm.sh big1.txt solb.txt
else
	echo "no solb.txt,but it is going on"
fi

sh reward.sh happy1.txt
sh reward.sh big1.txt


if [ -e solh.db ]
then 
	sh sol.sh solh.db
	cat solh.db >> solh.txt
else
	echo "no need working"
fi
if [ -e solb.db ]
then 
	sh sol.sh solb.db
	cat solb.db >> solb.txt
else
	echo "no need working"
fi

if [ -e notyeth.db ]
then
	rm happy1.txt
	mv notyeth.db happy1.txt
	echo "work done happy"
else
	echo "work done happy"
fi
if [ -e notyetb.db ]
then
	rm big1.txt
	mv notyetb.db big1.txt
	echo "work done big"
else
	echo "work done big"
fi
rm *.db
