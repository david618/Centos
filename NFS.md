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

<pre>
ipa-getkeytab -s ipa.example.com -p host/s1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p nfs/s1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p host/c1.example.com -k /etc/krb5.keytab
ipa-getkeytab -s ipa.example.com -p nfs/c1.example.com -k /etc/krb5.keytab
</pre>

Replaced the keytab file on both c1 and s1.  

Created a share as before
<pre>
mkdir /secnfsshare
chown nfsnobody /secnfsshare
chgrp workers /secnfsshare
chmod 3775 /secnfsshare
vi /etc/exports
</pre>

Add nfs configuration for share

<pre>
/nfsshare *.example.com(rw,sec=krb5)
</pre>

Apply configuration

<pre>
exportfs -rv
showmount -e
</pre>

Test

<pre>
mkdir /secnfsshare
mount -o sec=krb5 s1:/secnfsshare /secnfsshare
</pre>

At first I was getting errors. Added -vvv to /etc/sysconfig/nfs.  

The solution was to restart both c1 and s1.  Then I was able to mount.


