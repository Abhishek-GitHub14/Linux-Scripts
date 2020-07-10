#!/bin/bash

# script take backup of files and directories on daily basis.

# To find current date, month and time.

DAY=$(date +%d)
MONTH=$(date +%B)
TIME=$(date +%H:%M)
BASE_DIR=/home/server/archive

# create archive destination directory.

mkdir -p $BASE_DIR/$MONTH/$DAY

# set archive file name

FILE=archive_$TIME.tar.gz

# set configuration file and destination file

CONFG_FILE=/home/server/archive/Files_to_Backup
DESTINATION=$BASE_DIR/$MONTH/$DAY/$FILE

########### Main script ###########

# check backup config file exists or not

if [ -f $CONFG_FILE ]	# make sure the confg file exists or not?
then
	echo		# then do nothing and continue on.
else
	echo		# if config file does not exist, print the message and exist.
	echo " $CONFG_FILE does not exist"
	echo " Backup not completed due to missing configuration file."
	echo
	exit
fi

# Build the name of all the files to backup.

FILE_NO=1	# start from line no.-1 in config file.

exec < $CONFG_FILE	# Redirrect name of files from config file as std input.

read FILE_NAME		# reads first record from config file and stores in var FILE_NAME.

while [ $? -eq 0 ]	# loop to create list of files to backup.
do

	# Make sure the file or directory exsits or not?

	if [ -f $FILE_NAME -o -d $FILE_NAME ]
	then
		FILE_LIST="$FILE_LIST $FILE_NAME"
	else
		# if file or directory doesn't exist, issue warning.
		echo
		echo " $FILE_NAME, does not exist. "
		echo " It is listed on line $FILE_NO of the config file. "
		echo " Continuing to build archive list... "
		echo
	fi

	FILE_NO=$[$FILE_NO+1]	# Increase Line/File number by one.
	read FILE_NAME		# Read next record.
done

# Backup the files and compress Archive.

echo " Start archiving..."
echo

tar -czf $DESTINATION $FILE_LIST 2> /dev/null

echo " Arcive completed. "

echo " Resulting archive file is : " $DESTINATION

echo

exit
