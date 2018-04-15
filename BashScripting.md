# Bash Scripting

System wide user script: `/usr/local/bin`
System wide special user (root) scripts: `/usr/local/sbin`

## Overview

Notes
- ${10} returns argument in the 10 position
- ${0} returns the command 
- Numeric Comparisons: `-eq, -ne, -gt, -ge, -lt, -le`
- String Comparisons: `==, !=`
- Test zero length String: `-z`
- Test null Variable: `-n`
- Logical Operations: `&&, ||`

File Tests
<pre>
-b block special file exists
-c character special file exists
-d directory exists
-e file exists
-f regular file exists
-L symbolic link exists
-r file exists and is readable
-x file exists and has file size greater than zero
-w file exists and is writable
-x file exists and is executable
</pre>




## filesize.sh

<pre>
#!/bin/bash

DIR=/tmp
for FILE in $DIR/*; do
	echo "File ${FILE} is $(stat --print='%s' ${FILE}) bytes"
done
</pre>

## filesize2.sh

<pre>
#!/bin/bash

SEARCH_FOLDER=/tmp

for f in $SEARCH_FOLDER/*; do
	if [ -d "${f}" ]; then
		echo "Processing Folder ${ff}"
		for ff in ${f}/*; do
			echo "File ${ff} is $(stat --print='%s' ${ff}) bytes"
		done
	else
		echo "File ${f} is $(stat --print='%s' ${f}) bytes"
	fi
done

</pre>

## hello.sh

<pre>
#!/bin/bash
echo "Hello World"
exit 1
</pre>

After exits you can check `$?`.

<pre>
./echo $?
1
</pre>


## get_kernel_info.sh

<pre>
#!/bin/bash

PKG_TYPE=kernel
PKGS=$(rpm -qa | grep $PKG_TYPE)

for PKG in ${PKGS}; do
	#echo ${PKG}
	INSTALLED_EPOCH=$(rpm -q --qf "%{INSTALLTIME}\n" $PKG)
	#echo ${INSTALLED_EPOCH}
	INSTALLED_DT=$(date -d @${INSTALLED_EPOCH})
	echo "${PKG} was installed on ${INSTALLED_DT}"
done
</pre>

## show_args.sh

<pre>
#!/bin/bash


for ARG in "$@"; do
	echo ${ARG}
done
</pre>


## show_users.sh

<pre>
#!/bin/bash

while read line
do 
	#echo ${line}
	if [ -z "$(echo ${line} | grep nologin)" ]; then
		#echo ${line}
		user=$(echo $line | cut -d ":" -f 1)
		uid=$(echo $line | cut -d ":" -f 3)
		gid=$(echo $line | cut -d ":" -f 4)
		echo ${user} ${uid} ${gid}
	fi
done < /etc/passwd
</pre>

## com_line_args.sh

<pre>
#!/bin/bash

echo "There are $# arguments specified."
echo "The arguements are: $*"
echo "The first argument is: $1"
echo "The process id of the script is: $$"

</pre>

## if_elif.sh

<pre>
#!/bin/bash

## Double Square bracket with regex
if [[ $1 =~ ^-?[0-9]+$ ]]; then
        if [ $1 -gt 0 ]; then
                echo "$1 is a positive integer"
                exit 1
        elif [ $1 -eq 0 ]; then
                echo "$1 is zero"
                exit 2
        elif [ $1 -lt 0 ]; then
                echo "$1 is a negative integer"
                exit 3
        fi

else
        echo "$1 is not an integer"
        exit 4

fi
</pre>


## sys_info.sh
<pre>
#!/bin/bash

echo hostnamectl
/usr/bin/hostnamectl

echo who
/usr/bin/who
</pre>

## test_int.sh

<pre>

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
                echo "$1 is a positive integer"
                exit 1
        elif [ $1 -eq 0 ]; then
                echo "$1 is zero"
                exit 2
        elif [ $1 -lt 0 ]; then
                echo "$1 is a negative integer"
                exit 3
        fi
else
	echo "$1 is not an integer"
	exit 2
fi

</pre>

## while_do_done.sh
<pre>
#!/bin/bash

while true; do
	/usr/bin/clear
	echo "Menu"
	echo "-----"
	echo "[1] Display date/time"
	echo "[2] Display system info"
	echo "[3] Display local time"
	echo "[4] Display mounted filesystems"
	echo "[5] Exit"
	echo
	echo -e "Enter Choice [1-5]: \c "
	read CHOICE
	case $CHOICE in
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
			echo "Invalid choice"
			;;
	esac
	echo "Press Enter to go back to Menu...."
	read
done
</pre>
