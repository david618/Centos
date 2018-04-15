# File Servers

## Setup NFS Shares

### Install NFS Pacakges

<pre>
yum -y install nfs-utils
</pre>

### Create Share

<pre>
mkdir /nfsshare
chown nfsnobody /nfsshare
chgrp workers /nfsshare
vi /etc/exports
</pre>

### Confiure Access

<pre>
/nfsshare c1(rw) s1(rw)
</pre>


### Start Service

<pre>
systemctl start nfs-server
systemctl enable nfs-server

exportfs -r
</pre>


### Open Firewall

<pre>
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload
</pre>

### Test 

From c1

<pre>
yum -y install nfs-utils
showmount -e gw
mkdir /mnt/nfsshare
mount gw:/nfsshare /mnt/nfsshare
df -h
</pre>

You should see the mounted nfs share listed.

## Create Kerberos Secured NFS Share

Created from the IPA server which has Kerberos already running.

### Install NFS Pacakges

<pre>
yum -y install nfs-utils
</pre>

### Create Share

<pre>
mkdir /secnfsshare
chown nfsnobody /secnfsshare
kinit admin
chgrp editors /secnfsshare
vi /etc/exports
</pre>

### Confiure Access

<pre>
/secnfsshare c1(rw) s1(rw)
</pre>


### Start Service

<pre>
systemctl start nfs-server
systemctl enable nfs-server

exportfs -r
</pre>


### Test Connection

From c1

This client already has ipa-client installed.

Copy the krb5.keytab to c1 and replace the on on c1:/etc/krb5.keytab.

#### Mount NFS Share

From c1 as root

<pre>
mkdir /mnt/secnfsshare
mount -t nfs -o sec=krb5 ipa:/secnfsshare /mnt/secnfsshare
</pre>

Switch user to an IPA user

<pre>
su - ipauser1
kinit 
cd /mnt/secnfsshare
touch somefile
</pre>

You should be able to create a file. 





