#!/bin/bash

# 感謝鳥哥的私房菜
# 此腳本參考以下 URL 做修改
# http://linux.vbird.org/linux_basic/0570syslog.php#syslogd_conf


# PATH settings
	PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# Load settings and functions
	source /root/presettings.sh
	source /root/ssh_logparser.sh

# Locale settings
	LANG=C
	LC_TIME=en_US.UTF-8
	export PATH LANG LC_TIME

# Check tools, daemon and basedir
	which awk > /dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo -e "沒有 awk 這個工具程序，本程序 $0 將停止工作！"
	fi

	which sed > /dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo -e "沒有 sed 這個工具程序，本程序 $0 將停止工作！"
	fi

	temp=`ps aux | grep syslog| grep -v grep`
	if [ "$temp" == "" ]; then
		echo -e "沒有 syslog 這個 daemon ，本程序 $0 將停止工作！"
	fi

	if [ ! -d "$basedir" ]; then
		echo -e "没有 $basedir 這個目錄，本程序 $0 將停止工作！"
		exit
	fi


# Print server information
	echo "================= $localhostname 主機的資訊彙整 ======================="
	echo "核心版本  : `cat /proc/version | \
		awk '{print $1 " " $2 " " $3 " " $4}'`"

	echo "CPU 資訊  : `cat /proc/cpuinfo | \
		 grep "model name" | \
		 awk '{print $4 " " $5 " " $6}'`"

	cat /proc/cpuinfo | grep "cpu MHz" | \
		awk '{print "          : " $4 " MHz"}'

	echo "主機名稱  : `hostname`"
	echo "統計日期  : `date +%Y/%B/%d' '%H:%M:%S' '\(' '%A' '\)`"
	echo "分析的日期: `cat $basedir/dattime`"
	echo "已開機期间: `echo $UPtime`" 
	echo "主機啟用的 port 有："
	netstat -tln|grep '\0.0.0.0:'|awk '{print $4}'|\
		cut -d':' -f2|sort -n| uniq| \
		awk '{print "          : " $1}'| \
		tee $basedir/netstat.tmp 

	temp=`grep ' 23$' $basedir/netstat.tmp`
	if [ "$temp" != "" ]; then
		echo '** 注意：您的主機有啟動 telnet 這個危險的服務，除非必要，否则請關閉他！ **'
	fi

funcssh
