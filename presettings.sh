#!/bin/bash

# Pre-settings
	basedir="/root"
	localhostname=`hostname`

# Create dattime file
	datenu=`date +%H`
	if [ "$datenu" -le "6" ]; then
		date --date='1 day ago' +%b' '%e  > "$basedir/dattime"
	else
		date +%b' '%e  > "$basedir/dattime"
	fi

	y="`cat $basedir/dattime`"


# Create messageslog file
	cat /var/log/messages | grep "$y" > "$basedir/messageslog"

# Customize uptime output
	timeset1=`uptime | grep day`
	timeset2=`uptime | grep min`
	if [ "$timeset1" == "" ]; then
		if [ "$timeset2" == "" ]; then
			UPtime=`uptime | awk '{print $3}'`
		else
			UPtime=`uptime | awk '{print $3 " " $4}'`
		fi
	else
		if [ "$timeset2" == "" ]; then
			UPtime=`uptime | awk '{print $3 " " $4 " " $5}'`
		else
			UPtime=`uptime | awk '{print $3 " " $4 " " $5 " " $6}'`
		fi
	fi


# Create securelog file
	log=`grep 'authpriv\.\*' /etc/rsyslog.conf | awk '{print $2}'| \
		head -n 1|tr -d '-'`
	if [ "$log" == "" ]; then
		echo "Sorry, You do not have the login logfile.... Stop $0"
	fi

	cat $log | grep "$y" > "$basedir/securelog"
