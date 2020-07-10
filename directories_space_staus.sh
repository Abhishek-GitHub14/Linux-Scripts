#!/bin/bash

# find disk space in various directories.

CHECK_DIRECTORIES=" /home/server/scripts /var/log "


#############################################==> Main Script <==############################################


DATE=$(date +%d-%B-%Y)		# date for report file.

exec > Disk_space_$DATE.rpt	# make report file STDOUT.

echo " Top ten disk space usage : "
echo " for $CHECK_DIRECTORIES directories : "

for DIR_CHECK in $CHECK_DIRECTORIES
do
	echo ""
	echo " The $DIR_CHECK Directory : "

	# create a listing of top ten disk space users in this directory

	du -sh $DIR_CHECK 2>/dev/null | sort -rn | sed '{11,$D; =}' | sed 'N; s/\n/ /' | gawk '{printf $1 ":"  "\t" $2 "\t" $3 "\n"}'

done

exit
