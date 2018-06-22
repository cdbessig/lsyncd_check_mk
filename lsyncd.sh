#!/bin/bash
#
# Nagios plugin to monitor the status of lsyncd.
#
# Modified by bessig@creatingdigital.com for check_mk
# Credit to: https://github.com/ohitz/check_lsyncd for initial version.
# Copyright (C) 2017 Oliver Hitz <oliver@net-track.ch>

usage()
{
	cat <<EOF
$0 [-h] [-w N] [-c N] [-s PATH]
-h
	Show help.
-w N
	Warning if more than N delays (default: 10).
-c N
	Critical if more then N delays (default: 100).
-s PATH
	Set status file path (default: /var/run/lsyncd.status).
EOF
}

processname=lsyncd
warn_delays=10
crit_delays=100
statusfile=/var/run/lsyncd.status

while getopts "ha:w:c:s:" opt; do
	case "$opt" in
	h)
		usage
		exit 0
		;;
	w)
		warn_delays=$OPTARG
		;;
	c)
		crit_delays=$OPTARG
		;;
	s)
		statusfile=$OPTARG
		;;
	*)
		usage
		exit 1
	esac
done

# Check if lsyncd is running.
result=$(pgrep -x $processname)
if [ -z "$result" ]; then
	echo "2 lsyncd - CRITICAL - LSYNCD not running"
	exit 2
fi

# Check if the statusfile exists.
if [ ! -f "$statusfile" ]; then
	echo "2 lsyncd - CRITICAL - Status File not found"
	exit 2
fi

# Get number of delays from statusfile
delays=$(awk '/^There are [0-9] delays/ { count += $3; } END { print count; }' "$statusfile")
if [ "$delays" -ge $crit_delays ]; then
	echo "2 lsyncd - CRITICAL - there are $delays delays"
	exit 2
elif [ "$delays" -ge $warn_delays ]; then
	echo "1 lsyncd - WARNING - there are $delays delays"
	exit 1
fi

# Everything all right!
echo "0 lsyncd - OK - LSYNCD Running"
exit 0