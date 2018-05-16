# Samba

## Install

```
yum -y install samba
yum -y install samba-client
yum -y install policycoreutils-python.x86_64
```

## Documentation

```
man semanage-fcontext
```

There is also an example: /etc/samba/smb.conf.example.

## Configure Share

```
mkdir /smbshare
chgrp workers /smbshare
chmod 3775 /smbshare
semanage fcontext -a -t samba_share_t "/smbshare(/.*)?"
restorecon -vR /smbshare
vi /etc/samba/smb.conf
```

Modify or Add the following lines
```
workgroup = EXAMPLE

[smbshare]
        path = /smbshare
        write list = @workers
        create mask = 0775
        directory mask = 0775

```

## Test configuration and Start Service

```
testparm
systemctl enable smb nmb
systemctl start smb nmb
systemctl status smb
systemctl status nmb
```


## Open Firewall

```
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
```

## Create SMB Users

The users worker1 and worker2 may already be created; however, the smbpassword is not the same as the os password.

```
smbpasswd -a worker1
Enter the desired passowrd twice (e.g. worker1)
smbpasswd -a worker2
Enter the desired passowrd twice (e.g. worker2)
```

Now create a third user that is smbuser only.

```
useradd -s /sbin/nologin worker3
usermod -aG workers worker3
smbpasswd -a worker3
Enter the desired passowrd twice (e.g. worker3)
```


## Test Share

```
smbclient -U worker1 -L //localhost
```
After entering password for worker1 you should get a list of share. For example:

```
Domain=[S1] OS=[Windows 6.1] Server=[Samba 4.6.2]

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        smbshare        Disk      
        IPC$            IPC       IPC Service (Samba 4.6.2)
        worker1         Disk      Home Directories
Domain=[S1] OS=[Windows 6.1] Server=[Samba 4.6.2]

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
        EXAMPLE              S1

```


## Consume the Share

From a client.

```
yum -y install samba-client
yum -y install cifs-utils
mkdir /mnt/smbshare
mount -o username=worker1,password=worker1,multiuser //s1/smbshare /mnt/smbshare
The share is mounted.
```

Now we can verify that smbusers can write to the new share.

```
su - worker1
cd /mnt/smbshare
```

You'll get an error.  Since the share was mounted with multiuser option. Users must authenticate.

```
cifscreds add s1
echo "File created by worker1" > worker1file
exit
su - worker2
cifscreds add s1 
cd /mnt/smbshare
echo "File created by worker2" > worker2file
cat worker1file
rm worker1file
```

Because sgid is set the group for any file created is 'workers' and workers have rw access. 
Because sticky bit is set worker2 cannot remove worker1 owned files.

```
useradd worker3
usermod -aG workers worker3
su - worker3
cifscreds add s1
cd /mnt/smbsahre
touch worker3file
ls -l 
```
## Mount on Boot 

Create password file `/root/smbpassword.txt`

```
username=worker1
password=worker1
```


Edit /etc/fstab and add entry.

```
//s1/smbshare /mnt/smbshare cifs credentials=/root/smbpassword.txt,multiuser 0 0
```

Now mount and test.

```
mount -a
cd /mnt/smbshare
touch somefile
Note: Owner of the file is worker1
su - worker2
cd /mnt
ls -l
Note: The file ownership and permissions are unknown (lots of question marks)
cifscreds add s1
touch worker2file2
exit
```


## Allow Guest Read-only Access

Edit /etc/samba/smb.conf


Find man page `man -K "map to guest"`

Add line to global section
```
map to guest = Bad Password
```

Add to smbshare section
```
browseable = yes
read only = yes
public = yes
```


Now test from another server with a user not authorized.
```
su - user1
smbclient -L //s1
Note: Leave password blank; you should see the shares including smbshare
smbclient //s1/smbshare
```

At smb promnpt
```
ls
get worker1file
exit
```

You now have a local copy of worker1file in user1's home.








