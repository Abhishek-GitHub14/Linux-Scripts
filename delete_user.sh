#!/bin/bash

# Delete user ==> Automate the 4 steps to remove an account


##############################################################################################################################


# Define dunctions

function get_answer {

		unset ANSWER
		ASK_COUNT=0
		
	while [ -z "$ANSWER" ]	#while no answer is given,keep asking because of "-z" option looks for zero string length.
	do
		ASK_COUNT=$[$ASK_COUNT+1]

		case $ASK_COUNT in	# If user gives no answer in time allotted

			2)
				echo
				echo " Please answer the question. "
				echo
				
				;;

			3)
				echo
				echo " One last try !!! Please answer the question."
				echo

				;;
			4)
				echo
				echo " Because you are not answering the question..."
				echo " exiting the program."
				echo

				exit

				;;
		esac

		echo

		if [ -n "$LINE2" ]	# "-n" option looks for non-zero length of string.
		then			# Print 2 lines
			echo $LINE1

			echo -e $LINE2 "\c"	# suppress further output.
		else			# Print 1 line
			echo -e $LINE1 "\c"
		fi


		read -t 60 ANSWER	# "-t" option is for time-out, here time-out is 60 sec.

	done

	# Do a little variable clean up.

	unset LINE1
	unset LINE2

}	# End of get_answer function.


##############################################################################################################################


function process_answer {

	case $ANSWER in

		y|Y|YES|yes|yes)
			# If user answers "yes", do nothing.

			;;

		*)
			# if user answers anything but "yes", exit script.

			echo
			echo $EXIT_LINE1
			echo $EXIT_LINE2
			echo
			
			exit
			;;

		esac

		# Do a little variable clean up.

		unset EXIT_LINE1
		unset EXIT_LINE2
}	# End of process_answer function.

# End of function definitions


################################################# =====> Main Script <===== ##################################################


# Get name of user account to check

echo " Step #1 - Determine User account name to delete "
echo
LINE1=" Please enter the username of the user "
LINE2=" account you wish to delete from system: "

get_answer	# calling get_answer function here.

USER_ACCOUNT=$ANSWER

# double check with script user that this is the correct user account

LINE1=" Is $USER_ACCOUNT the user account "
LINE2=" you wish to delete from the system? [y/n] "

get_answer	# calling get_answer function here.

# call process_answer function: If user answers any user account but not correct one with yes option, exit script.

EXIT_LINE1=" Because the account, $USER_ACCOUNT, is not "
EXIT_LINE2=" the one you wish to delete, we are leaving the script... "

process_answer		# calling process_answer function here.


##############################################################################################################################


# check the user account exists on the system or not ?

USER_ACCOUNT_RECORD=$(cat /etc/passwd | grep -w $USER_ACCOUNT)

if [ $? -eq 1 ]		# if the account is not found, exit script.
then
	echo
	echo " Account, $USER_ACCOUNT, not found. "
	echo " Leaving the script... "
	echo
	exit
fi

echo
echo " I found this record: "
echo $USER_ACCOUNT_RECORD

LINE1=" Is this the correct User Account? [y/n] "

get_answer 	# calling get_answer function.

EXIT_LINE1=" Because the account, $USER_ACCOUNT, is not "
EXIT_LINE2=" the one you wish to delete, we are leaving the script... "

process_answer 		# calling process_answer function, if user answers wrong but says yes, exit script.


#############################################################################################################################


# search for any running processes that belong to the user account

echo
echo " Step #2 - Find processes on system belonging to user account "
echo

ps -u $USER_ACCOUNT > /dev/null		# run command to find running processes with user account.

case $? in

	1)	# No processes are running for this user account.

		echo " There are no processes for this account currently running. "
		echo

		;;
	0)
		# Processes running for this user account.
		# Ask Script user if wants to kill the processes.

		LINE1=" Would you like me to kill the process(es)? [y/n] "

		get_answer 	# calling get_answer function.

		case $ANSWER in

		y|Y|YES|Yes|yes)	# if user answers "yes" Kill user account processes.


			echo
			echo " Killing off process(es)... "

			# List user processes running code in variable, with COMMAND_1
			COMMAND_1="ps -u $USER_ACCOUNT --no-heading"

			# crate command to kill processes in variable, COMMAND_3
			COMMAND_3="xargs -d \\n /usr/bin/sudo /bin/kill -9"

			# Kill processes via piping commands together
			$COMMAND_1 | gawk '{print $1}' | $COMMAND_3

			echo
			echo " Process(es) killed."
			
			;;

		*)	# if user answers anything but "yes", o not kill.
			echo
			echo " Will not kill the process(es). "
			echo

			;;
	esac

	;;
	esac


##############################################################################################################################


# create a report of all fields owned by user account.

echo

echo " Step #3 - Find files on system belonging to user account. "

echo " creating a report of all files owned by $USER_ACCOUNT. "

echo

echo " It is recomended that backup/archive these files."
echo " and then do one of two things : "
echo " 1) Delete the files "
echo " 2) change the files ownership to a current user account. "
echo
echo " Please wait his may take a while... "

REPORT_DATE=$(date +%y-%m-%d)
REPORT_FILE=$USER_ACCOUNT"_Files_"$REPORT_DATE".rpt"

find / -user $USER_ACCOUNT  > $REPORT_FILE 2>/dev/null

echo
echo " Report is complete."
echo " Name of the report	:	$REPORT_FILE"
echo " Location of report:	$(pwd)"
echo


##############################################################################################################################


# remove user account

echo

echo " Step #4 - Remove user account. "

echo

LINE1=" Remove $USER_ACCOUNT's account from system? [y/n] "

get_answer	# calling get_answer function.

# now call process answer function, if user answers anything but "yes", exit script

EXIT_LINE1=" Since you do not wish to remove the user account,"
EXIT_LINE2=" $USER_ACCOUNT at this time, exiting the script... "

process_answer		# calling process_answer function.

userdel $USER_ACCOUNT	# delete user account

echo
echo " User Account $USER_ACCOUNT, has been removed. "
echo

exit








