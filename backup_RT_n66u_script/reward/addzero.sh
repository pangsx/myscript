#!/bin/sh
#這是一個我自己寫的加零函數，簡單的幫小於十㿝數字，在前方加一個零，方便程式比對，但後來發現較簡單的方式，所以沒用了

addzero(){
	if [ $1 -lt 10 ] && [ ${#1} -eq 1 ]
	then
		a=0$1
		echo $a > az.db
	else
		echo $1 > az.db
	fi
}
addzero $1
