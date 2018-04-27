#!/bin/bash

echo username userid groupid shell
while read line; do
	#echo ${line}
	if [ -z "$(echo ${line} | grep nologin)" ]; then
		#echo ${line}
		user=$(echo ${line} | cut -d ":" -f 1)
		uid=$(echo ${line} | cut -d ":" -f 3)
		gid=$(echo ${line} | cut -d ":" -f 4)
		sh=$(echo ${line} | cut -d ":" -f 7)
		
		
		echo ${user} ${uid} ${gid} ${sh}
	fi
done < /etc/passwd
