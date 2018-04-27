#!/bin/bash

# Double Square Backet to use regex expression
if [[ $1 =~ ^-?[0-9]+$ ]]; then
	# It's an integer
	if [ $1 -gt 0 ]; then
		echo "$1 is a positive integer"
		exit 1
	elif [ $1 -eq 0 ]; then
		echo "$1 is zero"
		exit 2
	elif [ $1 -lt 0 ]; then
		echo "$1 is a negative integer"
	fi
else
	echo "$1 is not an integer"
	exit 4
fi

