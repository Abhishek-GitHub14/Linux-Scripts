#!/bin/bash

# Description : This script will ping multiple hosts and notify.

echo

HOSTS="/home/server/imp_scripts/ip_list.txt"

for IP in $(cat $HOSTS)
do
	ping -c 2 $IP &> /dev/null
	if [ $? -eq 0 ]
	then
		echo " $IP is pinging and connectivity is OK. "
	else
		echo " $IP is not pinginging. "
	fi
done

echo

