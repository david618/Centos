# File Permissions

## Default Linux File Permissions

Three categories user, group, and other.

Read, Write, Exectute

Permissions set with octal numbers for each category.

Read bit, Write bit, Execute bit 

|Octal|Binary |Read|Write|Execute|
|-----|-------|----|-----|-------|
|0    |000    |  no|   no|     no|
|1    |001    |  no|   no|    yes|
|2    |010    |  no|  yes|     no|
|3    |011    |  no|  yes|    yes|
|4    |100    | yes|   no|     no|
|5    |101    | yes|   no|    yes|
|6    |110    | yes|  yes|     no|
|7    |111    | yes|  yes|    yes|

Commands
- Change Owner: chown 
- Change Group: chgrp
- Change Mode: chmod

### Special Permissions


|Permissions              |Effect on Files                      |Effect on Directories|
|-------------------------|-------------------------------------|---------------------|
|u+s (suid)               |file executes as owner               |no effect            |
|g+s (sgid)               |file executes as group               |new files created in directory assigned group of directory|
|o+s (sticky)             |no effect                            |only owner can delete file in the directory|


Find all suid files owned by root.

`find / -user root -perm -4000 2>/dev/null`



### umask

Specifies default permissions for new files and directories.

Unmasked folder would be assigned 777 (binary 111 111 111) permissions.  

A umask of 027 (binary 000 010 111)

Resulting permission 750 (binary 111 101 000)

## Access Control Lists (ACL)

Create a directory /shares/workers; give workers rwx to the folder.
<pre>
mkdir -p /shares/workers
setfacl -Rm g:workers:rwX /shares/workers
ls -ld /shares/workers
</pre>

Notes
- The permission have an extra `+` on them
- The uppercase X can be used to indicate that execute permissions should only be set on directories not files
- Use --set or --set-file to completely replace ACL settings
- Help: man setfacl, man getfacl

Show group workers has rwx on the share.
<pre>
getfacl /shares/workers
</pre>

Recursively deny worker2 access even though he is in workers group.
<pre>
setfacl -Rm u:worker2:- /shares/workers
</pre>

Set default group for future entries.
<pre>
setfacl -m d:g:workers:rwx /shares/workers
</pre>

Set ACL based on ACL of existing file
<pre>
getfacl file2 |  setfacl --set-file=- file1
getfacl folder3 | setfacl --set-file=- folder2
</pre>

Mask to limit permission granted to any named user or group.
<pre>
setfacl -m m::r file1
</pre>

Remove ACL for single user.
<pre>
setfacl -x u:worker2 /shares/workers
</pre>

Mask must be deleted last.

Delete all the rules
<pre>
setfacl -b /shares/workers/file1
</pre>



