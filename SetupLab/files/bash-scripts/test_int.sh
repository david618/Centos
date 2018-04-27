#!/bin/bash

function isInt() {
	printf "%d" $1 > /dev/null 2>&1
	return $?
}

if [ -z $1 ]; then
	echo "Use $0 <Integer>"
	exit 1
elif isInt $1; then
	if [ $1 -gt 0 ]; then
		echo "$1 is positive"
		exit 1
	elif [ $1 -eq 0 ]; then
		echo "$1 is zero"
		exit 2
	elif [ $1 -lt 0 ]; then
		echo "$1 is negative"
		exit 3
	fi
else
	echo "$1 is not an integer"
	exit 4
fi
