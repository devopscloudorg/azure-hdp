#!/bin/bash
#This file taking a hosts.txt file as input and merges its content with /etc/hosts

while read line;do
        echo "$line"

	if grep -Fxq "$line" /etc/hosts
	then
    		printf "$line already exists in hosts file\n"
	else
		echo $line >> /etc/hosts
    		# code if not found
	fi

done < $1
