#!/bin/bash
funcssh () {
	echo " "
	echo "================= SSH 的登錄文件資訊彙整 ======================="

	
	# Parse successful logins
	sshright=`cat $basedir/securelog |grep 'sshd.*Accept' | \
		wc -l | awk '{print $1}'`

	if [ "$sshright" != "0" ]; then
		
		echo "成功登入總次数： $sshright" | \
			awk '{printf("%-26s %3d\n",$1,$2)}'		
		echo "次數 帳號 來源IP" | \
			awk '{printf("%-10s %-15s %s\n", $1, $2, $3)}'
		cat $basedir/securelog | grep 'sshd.*Accept' | \
			sed 's/^.*for//g' |awk '{print $1}' > "$basedir/securelogssh-1"
		cat $basedir/securelog | grep 'sshd.*Accept' | \
			sed 's/^.*from//g' |awk '{print $1}' > "$basedir/securelogssh-2"
		paste $basedir/securelogssh-1 $basedir/securelogssh-2 \
			 > $basedir/securelogssh		
		cat $basedir/securelogssh | sort -n | uniq -c | sort -r | \
			awk '{printf("%-10s %-15s %s\n", $1, $2, $3)}'
		echo " "
	fi


	# Parse failed logins
	ssherror=`cat $basedir/securelog | grep "sshd.*Fail" | wc -l | \
		awk '{print $1}'`
	if [ "$ssherror" != "0" ]; then
		echo "錯誤登入總次數: $ssherror" | \
			awk '{printf( "%-26s %3d\n", $1, $2)}'
		echo "次數 帳號 來源IP"| \
			awk '{printf("%-10s %-15s %s\n", $1, $2, $3)}'
		cat $basedir/securelog | grep "sshd.*Fail" | \
			sed 's/^.*for//g' |awk '{print $1}' \
			>  "$basedir/securelogsshno-1"
		cat $basedir/securelog | grep "sshd.*Fail" | \
			sed 's/^.*from//g' |awk '{print $1}' \
			>  "$basedir/securelogsshno-2"
		paste $basedir/securelogsshno-1 $basedir/securelogsshno-2 \
			> $basedir/securelogsshno

		cat $basedir/securelogsshno | sort -n | uniq -c | sort -r | \
			awk '{printf("%-10s %-15s %s\n", $1, $2, $3)}'

		echo " "
	fi


	# Parse sudo information
	cat /var/log/auth.log | grep "su"|grep "open"|grep "root"| \
		sed 's/^.*by//g' |awk '{print $1}'|sort   >  $basedir/messagessu

	sshsu=`wc -l $basedir/messagessu | awk '{print $1}'`
	if [ "$sshsu" != "0" ]; then
		echo "以 su 轉換成 root 的使用者及次數"
		echo "次數	帳號"| \
			awk '{printf("%-10s %-15s\n", $1, $2)}'
			cat $basedir/messagessu | sort -n | uniq -c | sort -r | \
			awk '{printf("%-10s %-15s\n", $1, $2)}'
		echo " "
	fi

	if [ "$sshright" == "0" ] && [ "$ssherror" == "0" ]; then
		echo "今日没有使用 SSH 的紀錄"
		echo " "
	fi
}
