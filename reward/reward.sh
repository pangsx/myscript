#!/bin/bash
#自己寫一個對大樂透和威透彩的對獎腳本，雖然有app，但是太笨了，如果有加碼，還要輸入二次，不好用。
#1101103完成了初版的對獎程式了，把程式分成幾個部分來處理，避免全部寫在一個腳本內，要除錯會很痛苦，這是看書的好處，另外加碼的部分，我放棄放在這個腳本內解決，一來加碼的網頁不固定，要解析出數字來，也是必需要另外想辦法，二來是加碼對獎的方式又是另外的，所以，如果有加碼出來後，再來增加腳本的功能會是比較好的方式，以上先行紀錄一下。
#說明一下各個腳本的功能：
#1.makedb:這個腳本主要是幫忙下載資料做成資料檔用的，他的功能很簡單，只初步判斷有沒有先前的資料檔，如果有就會增加新的資料，不會把舊的刪掉。
#2.readdb:這個腳本會讀入我買的獎卷的輸入檔，分解後再呼叫對獎的腳本，主要工作都在這個腳本內執行。
#3.happyreward&bigreward:這是對獎的核心功能，因為不同獎項的遊戲方式不同，所以沒辦法寫在一起。
#最後，我承認別人的程式可能真的很蠢，但是寫一個程式來處理真的很困難，我這個對獎程式寫了要一週，除錯和功能真的要先想好才是。
#1130110因為運彩承辦銀行轉換，網站更新了，所以更新來源資料庫的部分
#1130302修改程式對獎的模式，原先在對前才判斷期數的部分，改到一開始就來判斷有沒有未對的，所以在此新增了一個函數select.sh來做判斷的功能，今天測試可以運行，先這樣吧
clear
cd /
cd /media/Data/workspace/reward
wget -q --no-check-certificate "https://drive.google.com/u/0/uc?id=1ZYwMUj_SRo245-wdZ_q8YbXSgl20L5xU&export=download" -O "big2.txt"
wget -q --no-check-certificate "https://drive.google.com/u/0/uc?id=1VGKxhGw9U9Qaes-o0JWDd3vLLguOxwy9&export=download" -O "happy2.txt"
#1130302因為改了新網站，對獎資料期數太多，以前只有十期，反正都對一次獎沒差，但現在都有，都對那累積下來太多訊息，沒有提醒的功用了，所以要改一下方式
#echo -e "\n" >> big1.txt
#cat big2.txt > big1.txt
#sed -i '/^$/d' big1.txt
#echo -e "\n" >> happy1.txt
#cat happy2.txt > happy1.txt
#sed -i '/^$/d' happy1.txt
./select.sh big2.txt
./select.sh happy2.txt
#echo "你想對什麼獎呢?輸入1是對威力彩,輸入2是對大樂透."
#read sel
#依選擇來決定參數，會判斷有沒有先前下載的資料。
#case $sel in
#	1)
		sel=1
		#curl -s -o happy.db https://www.taiwanlottery.com.tw/lotto/superlotto638/history.aspx
		#1130103因為第四屆臺灣彩卷換銀行，網址換了，所以更換不是官方的網址
		curl -s -o happy.db http://www.9800.com.tw/html/a2/
		if [  -e happyf.txt ]
		then
			ss=1;
		else
			ss=2;
		fi
		#呼叫makedb腳本來建立資料庫
		#./makedb.sh happy.db SuperLotto638Control_history1_dlQuery_DrawTerm SuperLotto638Control_history1_dlQuery_Date SuperLotto638Control_history1_dlQuery_SNo $ss $sel
		#1130103因為第四屆臺灣彩卷換銀行，網址換了，所以更換不是官方的網址
		./makedb2.sh happy.db 'height=32' 'align="center"' 'class=ball_yellow' $ss $sel
		cat tempp.txt >> happyf.txt
		rm tempp.txt 1>&2 >>/dev/null
		#判斷有沒有要對獎的文字檔
		if [  -e happy1.txt ]
		then
			#呼叫readdb來讀資料庫和對獎
			./readdb.sh happy1.txt $sel
		else
		echo "no input file"
		fi
#		;;
#	2)
		sel=2
		#curl -s -o big.db https://www.taiwanlottery.com.tw/lotto/Lotto649/history.aspx
		#1130103因為第四屆臺灣彩卷換銀行，網址換了，所以更換不是官方的網址
		curl -s -o big.db http://www.9800.com.tw/html/a1/
		if [  -e bigf.txt ]
		then
			ss=1;
		else
			ss=2;
		fi
		#./makedb.sh big.db Lotto649Control_history_dlQuery_L649_DrawTerm Lotto649Control_history_dlQuery_L649_DDate Lotto649Control_history_dlQuery_SNo $ss $sel
		#1130103因為第四屆臺灣彩卷換銀行，網址換了，所以更換不是官方的網址
		./makedb2.sh big.db 'height=32' 'align="center"' 'class=ball_yellow' $ss $sel
		cat tempp.txt >> bigf.txt
		rm tempp.txt
		if [  -e big1.txt ]
		then
		./readdb.sh big1.txt $sel
		else
		echo "no input file"
		fi
#		;;
#	*)
#		echo "i do not know that,bye!"
#		exit 0
#		;;
#esac
#touch $(date +%Y%m%d)

