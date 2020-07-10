#!/bin/bash

# Description : This script will pull error messages from /var/log/messages.

echo

DATE=$(date +%d-%m-%Y)
echo $DATE >> /home/server/imp_scripts/file_for_pulled_data_script_$DATE
cat /var/log/messages | grep -i error >> /home/server/imp_scripts/file_for_pulled_data_script_$DATE

echo
