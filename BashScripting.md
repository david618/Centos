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
```
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
```



## filesize.sh

```
#!/bin/bash

DIR=/tmp
for FILE in $DIR/*; do
	echo "File ${FILE} is $(stat --print='%s' ${FILE}) bytes"
done
```

## filesize2.sh

List size of files in folder and it's subfolders.

```
#!/bin/bash

SEARCH_FOLDER=/usr

for f in ${SEARCH_FOLDER}/*; do
        if [ -d "${f}" ]; then
                echo "Processing Folder ${f}"
                if [ -z "$(ls -A ${f})" ]; then
                        echo "  Empty Directory"
                else
                        for ff in ${f}/*; do
                                echo "  File ${ff} is $(stat --print='%s' ${ff}) bytes"
                                #echo "  ${ff}"
                        done
                fi
        else
                echo "File ${f} is $(stat --print='%s' ${f}) bytes"
                #echo "${f}"
        fi

done

```

## hello.sh

```
#!/bin/bash
echo "Hello World"
exit 1
```

After exits you can check `$?`.

```
./echo $?
1
```


## get_kernel_info.sh

```
#!/bin/bash

PKG_TYPE=kernel
PKGS=$(rpm -qa | grep $PKG_TYPE)

for PKG in ${PKGS}; do
        #echo ${PKG}
        INSTALLED_EPOCH=$(rpm -q --qf "%{INSTALLTIME}\n" ${PKG})
        INSTALLED_DT=$(date -d @${INSTALLED_EPOCH})
        echo "${PKG} was installed on ${INSTALLED_DT}"
done

echo "or"

for PKG in ${PKGS}; do
        echo "${PKG} was installed on $(rpm -q --qf "%{INSTALLTIME:date}\n" ${PKG})"
done
```

The available rpm query tags can be listed with `rpm --querytags`.

Using an alternate output formate the date directly output as date `rpm -q --qf "%{INSTALLTIME:date}\n"`



## show_args.sh

```
#!/bin/bash


for ARG in "$@"; do
	echo ${ARG}
done
```


## show_users.sh

```
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
```

## cmd_line_args.sh

```
#!/bin/bash

echo "There are $# arguments specified."
echo "The arguements are: $*"
echo "The first argument is: $1"
echo "The process id of the script is: $$"

```

## if_elif.sh

```
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
```

## sys_info.sh
```
#!/bin/bash

echo hostnamectl
/usr/bin/hostnamectl

echo who
/usr/bin/who
```

## test_int.sh

```

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

```

## while_do_done.sh
```
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
```

For the input you could use `read -rsn1 CHOICE`.  This reads one key wihtout having to hit enter.


##  upyet.sh

This script uses a HaspMap nodes.  

```
#!/usr/bin/env bash

NUM_MASTERS=1
NUM_PRIVATE_AGENTS=6
NUM_PUBLIC_AGENTS=2

declare -A nodes
nodes=(["m"]="${NUM_MASTERS}" ["a"]="${NUM_PRIVATE_AGENTS}" ["p"]="${NUM_PUBLIC_AGENTS}")

allup="false"

while [ "${allup}" != "true" ]; do
        allup=true
        for nodename in "${!nodes[@]}"; do
                #echo "${nodename}  ${nodes[${nodename}]}"
                numnodes=${nodes[${nodename}]}
                i=1
                while [ $i -le ${numnodes} ]; do

                        hostup=$(getent hosts ${nodename}${i})
                        up=":yes"
                        if [[ -z "$hostup" ]]; then
                                up=":no"
                                allup=false
                                echo "${nodename}${i}${up}"
                        fi
                        #echo "${nodename}${i}${up}"
                        i=$((i+1))
                done
        done
        if [ "${allup}" == "true" ]; then
                break
        fi
        echo "$(date): Waiting on nodes to come up"
        sleep 5
done
```
