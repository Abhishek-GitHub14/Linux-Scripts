#!/bin/bash

#count no. of files in directory.
echo

read -p " Enter path of directory to list : " PATHS

MYPATH=$(echo $PATHS | sed 's/:/ /g')

count=0

for dir in $MYPATH
do
	check=$(ls $dir)
	for item in $check
	do
		count=$[$count+1]
	done
	echo " No. of items in $dir	: $count "
	count=0
done

echo
