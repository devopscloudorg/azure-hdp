#!/bin/bash
#This script reads the hosts file and merges its content with /etc/hosts

#check to make sure hosts file exists
echo "hosts file name is /root/hosts.txt"

if [ -e /root/hosts.txt ]
then
	while read line;do
        	echo "$line"

		if grep -Fxq "$line" /etc/hosts
		then
    			printf "$line already exists in hosts file\n"
		else
			echo $line >> /etc/hosts
    			# code if not found
		fi
	done < /root/hosts.txt
else
	printf "File hosts.txt does not exist\n"
	exit 1
fi
