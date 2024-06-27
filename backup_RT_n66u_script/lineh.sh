#!/bin/sh
#這是一個用line Notify機制傳送訊息給我自己的腳本涵數，變數1是要傳的訊息，變數2是要傳的圖，但我想那圖只有最基本的圖，不過很好了。
#馬丰�發現能用的貼圖不只基礎的，上網找stickerPackageId就可以找到了。
linep(){
	ck=$#
	case $ck in
		1)	curl -X POST -H "Authorization: Bearer wMMzleg3kAOGsSKWJieV9Vu7fbl3XWawY6LMuqvhZvr" -F "message=$1" https://notify-api.line.me/api/notify


			;;
		2)	echo "need input message stickerPackageId and stickerId,look like "linep message 8525 16581303""

			;;
		3)	curl -X POST -H "Authorization: Bearer wMMzleg3kAOGsSKWJieV9Vu7fbl3XWawY6LMuqvhZvr" -F "message=$1" -F "stickerPackageId=$2" -F "stickerId=$3" https://notify-api.line.me/api/notify

			;;
		*)
			echo "need input message stickerPackageId and stickerId,look like "linep message 8525 16581303""
			;;
	esac
}

linep $1 $2 $3
