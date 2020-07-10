#/bin/bash

# counting and printing numbers from 1 to 10.

for i in {1..10}
 do
 	echo $i
	sleep 1
 done

#********************************************************************************************************************

# create multiple files at one time

read -p " How many files you want to create : " t

if [ $t -eq 0 ]
then
	echo " No file will be created. "
else
	read -p " File name start with : " n
	
	for i in $(seq 1 $t)
	do
		touch $n\_$i\.txt
	done
fi

#*********************************************************************************************************************

# Assign permissions on created file

echo " Assigning permissions to files ....."
total=$(ls -l *.txt | wc -l)
echo
echo " It will take $total sec. to assign permission on files. " 

for i in *.txt
do

	echo " Assigning permission to $i file..."
	chmod a-x $i
	sleep 1
done

echo
