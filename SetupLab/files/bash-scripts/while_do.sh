#!/bin/bash

while true; do
	/usr/bin/clear
	echo "-----"
	echo "[1] Display date/time"
	echo "[2] Display system info"
	echo "[3] Display local time"
	echo "[4] Display mounted filesystems"
	echo "[5] Exit"
	echo
	echo -e "Enter Choice [1-5]: \c "
	read CHOICE
	case ${CHOICE} in
		1)
			echo "date/time"
			/usr/bin/timedatectl
			;;
		2)
			echo "system info"
			/usr/bin/hostnamectl
			;;
		3)
			echo "local time"
			/usr/bin/localectl
			;;
		4)
			echo "mounted filesystems"
			/usr/bin/df -h
			;;

		5)
			exit 0
			;;
		*)
			echo "Invalid Choice"
			;;
	esac
	echo "Press Enter to go back to Menu...."
	read
done
