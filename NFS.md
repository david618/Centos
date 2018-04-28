# NFS

## Create NFS Share

### Install 

```
yum install nfs-utils
systemctl enable nfs-server.service
systemctl start nfs-server.service
mkdir /nfsshare
chown nfsnobody /nfsshare
chgrp workers /nfsshare
chmod 3775 /nfsshare
vi /etc/exports
```

Add nfs configuration for share

```
/nfsshare *.example.com(rw)
```

Apply configuration

```
exportfs -rv
showmount -e
```

Open Firewall
```
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload
```

## Consume NFS Share

```
yum -y install nfs-utils
mkdir /nfsshare
mount s1://nfsshare /nfsshare
su - worker1
touch /nfsshare/w1
exit
su - worker2
touch /nfsshare/w2
rm /nfsshare/w1 
Note: cannot delete w1
exit
umount /nfsshare
yum -y install lsof
lsof /nfsshare
```

Add entry to /etc/fstab
```
s1:/nfsshare /nfsshare nfs defaults 0 0
```

Mount and test 
```
mount -a
df -h
```

You should see the share is mounted.

reboot and verify the nfsshare is mounted.

## Secure NFS Share

Added both the server and client as IPA clients.

From IPA added nfs service for both server and client.

Created krb5.keytab with entries for both s1 and c1.

```
ipa-getkeytab -s ipa.example.com -p host/s1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p nfs/s1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p host/c1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p nfs/c1.example.com -k /etc/krb5.keytab
```

Replaced the keytab file on both c1 and s1.  

Created a share as before
```
mkdir /secnfsshare
chown nfsnobody /secnfsshare
kinit admin 
   Provide admin's password
chgrp editors /secnfsshare
chmod 3775 /secnfsshare
vi /etc/exports
```

Add nfs configuration for share

```
/nfsshare *.example.com(rw,sec=krb5)
```
Apply configuration

SEC Options
- sys: default trusts uid/gid sent by client
- krb5: authentication only
- krb5i: Communications integrity
- krb5p: Encryption (most secure option)

```
exportfs -rv
showmount -e
```

Test

```
mkdir /secnfsshare
mount -o sec=krb5 s1:/secnfsshare /secnfsshare
```

At first I was getting errors. Added -vvv to /etc/sysconfig/nfs.  

The solution was to restart both c1 and s1.  Then I was able to mount.

```
su - ipauser1
   You will get an error about home directory
cd /secnfsshare
touch ipa1file1
ls -l
    The file should exists with owner ipauser1 and group editors
```


