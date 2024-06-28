#!/bin/bash
#寫一個可以算獲利的腳本，再利用line來通知我獲利的情況，一個月一次，免得我也都沒有什麼在看，到底是賺是賠，還是統計一下，而且那個google的表單我算的越來越不懂，亂到我都記不下去了。
#1130217因為股市流行起ETF，所以我陸續買了一些（如00878、00929、00919），但原本臺銀的網站查不到這類基金型股價的現值，所以我只能找一下新的網站來查詢，在此做一個紀錄

#1140417更新一下由網上下載資料
rm my.txtc mydividend.txtc
wget -q --no-check-certificate "https://drive.google.com/u/0/uc?id=1Kve1iGaj1vevzgZD9QQzDMMjQ7UbbXxm&export=download" -O "mydividend.txtc"
#1140628有些剛買的股票沒有發股息，就不會算積效，所以改良一下
wget -q --no-check-certificate "https://drive.usercontent.google.com/u/0/uc?id=1GuoLxkyI6iJaISSAG68c-zUNipukWkZj&export=download" -O "mystock.txtc"
cat mydividend.txtc mystock.txtc| grep -v \#| cut -d "," -f 1|sort |uniq > my.txtc




file=my.txtc
while read line
do
	#下載現值
	#用臺銀網站 的部分留下來以後可能會用到
#	wget -q --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
#		Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line.html \
#		https://fund.bot.com.tw/Z/ZC/ZCA/ZCA_$line.DJHTM
#	iconv -f big5 -t utf8 $line.html > data1
#	price=$(cat data1| grep "td class="|head -n 9|tail -n 1|cut -d '>' -f 2|cut -d '<' -f 1)
#	name=$(cat data1| grep $line|tail -n 1|cut -d '(' -f 1|cut -d '>' -f 2)
#	echo $name > name.txt
#	sed -i "s/[[:space:]]//g" name.txt
#	name=$(cat name.txt)
#	rm name.txt
	#1130217找到一個網站可以用https://histock.tw/stock/
	wget -q --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
		Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line.html \
		https://histock.tw/stock/$line
	#因為這個網站不必轉換，所以這行可以不必轉了，但要把.html改成data1後來的程式碼就不必改太多
	#iconv -f big5 -t utf8 $line.html > data1
	mv $line.html data1
	price=$(cat data1| grep og:description | cut -d "," -f 2 | cut -d " " -f 3)
	name=$(cat data1| grep og:description | cut -d "(" -f 1 | cut -d "\"" -f 6)
	echo $name > name.txt
	sed -i "s/[[:space:]]//g" name.txt
	name=$(cat name.txt)
	rm name.txt
	#下載股利資料，但是沒有寫到自己算股利這個部分，所以先註釋掉，等我想一下怎麼寫這個部分再開放
	#wget -q --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
	#	Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line-d.html \
	#	https://fund.bot.com.tw/Z/ZC/ZCC/ZCC_$line.DJHTM
	#iconv -f big5 -t utf8 $line-d.html > data2
	#(cat data2 |grep t3n1 |cut -d '>' -f 2|cut -d '<' -f 1) > $line-di.txt
	#./summe.sh $line

	./counto.sh $line mystock.txtc b
	./counts.sh $line mydividend.txtc s
	#買入張數
	buyp=$(cat solution.txt|cut -d ',' -f 1)
	#買入成本
	cost=$(cat solution.txt|cut -d ',' -f 2)
	#賣出張數
	salep=$(cat solution.txt|cut -d ',' -f 3)
	#賣出所得，包含股息ds和股利dc
	get=$(cat solution.txt|cut -d ',' -f 4)
	ds=$(echo $(cat sola.txt|cut -d ',' -f 1)*$price |bc -l)
	dc=$(cat sola.txt|cut -d ',' -f 2)
	get=$(echo 'scale=2;'$get+$dc+$ds| bc -l)
	#echo $name,$get,$cost
	#計算現值是多少
	now=$(echo 'scale=2;'$buyp-$salep|bc -l)
	nowprice=$(echo 'scale=2;'${now#-}*1000*$price|bc -l)
	#計算獲利及獲利率，這邊可能和實際值用有些誤差，但是我覺得是可接受的誤差。
	#p1和p2是稅和手續費，pt是在算獲利，perf是獲利率
	p1=$(echo 'scale=2;'$nowprice*3/1000| bc -l)
	p2=$(echo 'scale=2;'$nowprice*0.1425/100| bc -l)
	pt=$(echo 'scale=2;'$nowprice-$cost+$get-$p1-$p2|bc -l)
	perf=$(echo 'scale=2;'$pt/$cost*100|bc -l)
	#算成本價
	#ct=$(echo 'scale=2;'$cost-$dc-$ds| bc -l )
	#1121218原本的算法把賣出所得的獲利排除了，這樣試看看
	ct=$(echo 'scale=2;'$cost-$get| bc -l )
	costp=$(echo 'scale=2;'$ct/${buyp#-}/1000| bc -l)
	#用別人寫的腳本美化輸出的數字。
	nowprice=$(./nicenumber.sh ${nowprice#-})
	pt=$(./nicenumber.sh ${pt#-})
	perf=$(./nicenumber.sh ${perf#-})
	cost=$(./nicenumber.sh ${cost#-})
	costp=$(./nicenumber.sh ${costp#-})
	#用我寫的line發送腳本把結果送回給我自己看
	./linep.sh "$line,$name,現值$nowprice,獲利$pt,獲利率$perf%,成本價$costp"
	#留個紀錄檔
	echo $line,$name,現值$nowprice,獲利$pt,獲利率$perf%,花費$cost,成本價$costp >> $(date '+%Y%m%d').log
	#清除暫存檔
	rm data* *.txt *.html
done < $file
