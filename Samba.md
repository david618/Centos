# Samba

## Install

<pre>
yum -y install samba
yum -y install samba-client
yum -y install policycoreutils-python.x86_64
</pre>

## Documentation

<pre>
man semanage-fcontext
</pre>


## Configure Share

<pre>
mkdir /smbshare
grgrp workers /smbshare
chmod 3775 /smbshare
semanage fcontext -a -t samba_share_t "/smbshare(/.*)?"
restorecon -vR /smbshare
vi /etc/samba/smb.conf
</pre>

Modify or Add the following lines
<pre>
workgroup = EXAMPLE

[smbshare]
        path = /smbshare
        write list = @workers
        create mask = 0775
        directory mask = 0775

</pre>

## Test configuration and Start Service

<pre>
testparm
systemctl enable smb nmb
systemctl start smb nmb
systemctl status smb
systemctl status nmb
</pre>


## Open Firewall

<pre>
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
</pre>

## Create SMB Users

The users worker1 and worker2 may already be created; however, the smbpassword is not the same as the os password.

<pre>
smbpasswd -a worker1
Enter the desired passowrd twice (e.g. worker1)
smbpasswd -a worker2
Enter the desired passowrd twice (e.g. worker2)
</pre>

Now create a third user that is smbuser only.

<pre>
useradd -s /sbin/nologin worker3
usermod -aG workers worker3
smbpasswd -a worker3
Enter the desired passowrd twice (e.g. worker3)
</pre>


## Test Share

<pre>
smbclient -U worker1 -L //localhost
After entering password for worker1 you should get a list of share. For example:

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

</pre>

</pre>


## Consume the Share

From a client.

<pre>
yum -y install samba-client
yum -y install cifs-utils
mkdir /mnt/smbshare
mount -o username=worker1,password=worker1,multiuser //s1/smbshare /mnt/smbshare
The share is mounted.
</pre>

Now we can verify that smbusers can write to the new share.

<pre>
su - worker1
cd /mnt/smbshare
echo "File created by worker1" > worker1file
exit
su - worker2
cifscreds add s1 
cd /mnt/smbshare
echo "File created by worker2" > worker2file
cat worker1file
rm worker1file 
Note: Because sgid is set the group for any file created is 'workers' and workers have rw access. Because sticky bit is set worker2 cannot remove worker1 owned files.
useradd worker3
usermod -aG workers worker3
su - worker3
cifscreds add s1
cd /mnt/smbsahre
touch worker3file
ls -l 
</pre>

## Mount on Boot 

Create password file `/root/smbpassword.txt`

<pre>
username=worker1
password=worker1
</pre>


Edit /etc/fstab and add entry.

<pre>
//s1/smbshare /mnt/smbshare cifs credentials=/root/smbpassword.txt,multiuser 0 0
</pre>

Now mount and test.

<pre>
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
</pre>


## Allow Guest Read-only Access

Edit /etc/samba/smb.conf

Add line to global section
<pre>
map to guest = Bad Password
</pre>

Add to smbshare section
<pre>
	browseable = yes
	read only = yes
	public = yes

</pre>

Now test from another server with a user not authoeized.
<pre>
su - user1
smbclient -L //s1
Note: Leave password blank; you should see the shares including smbshare
smbclient //s1/smbshare
</pre>

At smb promnpt
<pre>
ls
get worker1file
exit
</pre>

You now have a local copy of worker1file in user1's home.








