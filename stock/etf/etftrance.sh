#!/bin/bash
#1130706因為想投資 ETF型的股票，採用紅綠鐙法沒有用，所以為了能在近期相對底點買入，寫了這個腳本，主要是看要追踨連續下跌幾天，如果達成條件了，就會通知，以利考慮買進
#1130712這個版本的比較方式不正確，是今天的值和前n天分別比，不是連跌n天，雖然還是可能找到相對低點，但是卻不是n天最低，我想要調整一下
#1130713寫了一個沒有值就往前找的function，好像還可以，試看看先
clear
cd /
cd /media/Data/workspace/stock/etf/
rm db.txt
cp dbetf.back db.txt

# Function to check if a file exists
function check_file_exists() {
  if [[ ! -f "$1" ]]; then
    echo "Error: File '$1' does not exist!"
    exit 1
  fi
  
}
#Function to check if a number null
function check_Null(){
	if [[ ! -n "$1" ]];then
		echo "Error:'$1' is null!"
		exit 1
	fi
}


#Function to check if a number null then change date
#1130713新增這個部分，因為變數沒有特別定義，和主程式是共用的，所以在這邊做完j,dx,px就可以回到主程式去
function check_Null_day(){
if [[ ! -n "$1" ]];then
	j=1
	until [ $j == 500 ]
	do
		dx=$(echo $todayDate-$i-$j| bc -l)
		px=$(cat record.tx|grep "$dx"|grep "$line"|cut -d "," -f 4|uniq)
		#echo "in function"$dx,$px,$j
		if [[ ! -n "$px" ]];then
			((j++))
		else
			return 1
		fi
	done
	exit 1
fi
}





e(){
	check_file_exists db.txt
	check_file_exists record.tx
	# Get today's date
	#todayDate=$(date +%Y%m%d)
	todayDate=20240712
	s1=$(cat record.tx|grep $todayDate)
	check_Null $s1
	check_Null $1
	file=db.txt
	while read line
	do
		i=$1
		count=0
		j=0
		#讀出今天的價格
		p1=$(cat record.tx|grep "$todayDate"|grep "$line"|cut -d "," -f 4|uniq)
		until [ $i == 0 ]
		do
			#dx是指幾天前，px是幾天前的價格，要確認一下px有沒有值，這部分我先用function來處理一下，但是目前我想國定節日是沒有值的，但先這樣，以後再改
			#1130712修改了比較方式，這邊先把三天的值讀出來，並把他存入暫存檔temp.txt
			dx=$(echo $todayDate-$i-$j| bc -l)
			px=$(cat record.tx|grep "$dx"|grep "$line"|cut -d "," -f 4|uniq)
			#echo $dx,$px,$p1
			check_Null_day $px
			#echo "out function"$dx,$px,$j
			echo "$px," >> temp.txt
			((i--))
			#echo "one",$i,$j
		done
		ps=$(echo "$p1-$px"|bc -l)
		i=1
		until [ $i == $1 ]
		do
			#因為股票是二個小數，一般的邏輯方式沒辦法處理，所以這邊用了gemini建議的方式來處理。
			#1130712temp.txt的值是由日期近的往下是遠的，所以這邊i是由1開始
			px=$(cat temp.txt | head -n $i | tail -n 1 |cut -d "," -f 1 )
			if [[ $(echo "$p1>$px" | bc -l) -eq 1 ]]
			then
				count=$(echo "$count+1"|bc -l)
			else
				:
			fi
			#1130712這要加上去
			((i++))
			#p1要變成px，這樣才能完成連續n天的比較
			p1=$(echo $px)
			#echo "two",$i
		done
		rm temp.txt
		name=$(cat record.tx|grep "$todayDate"|grep "$line"|cut -d "," -f 3|uniq)
		if [ $count == $1 ]
		then
			echo $todayDate,$line,$count,$ps
			./linep.sh $todayDate,$line,$name,"連跌$count天","跌價$ps"
			./lineh.sh $todayDate,$line,$name,"連跌$count天","跌價$ps"
		else
			:
		fi
		
	done < $file
	touch "$todayDate".log
}
e $1

