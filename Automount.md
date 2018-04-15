# Automount

## Create Shares

On the server (s1) create [NFS shares](./NFS.md).

<pre>
showmount -e s1
Export list for s1:
/nfsshare   *.example.com
/share/docs *.example.com
/share/pics *.example.com
/share/tmp  *.example.com
</pre>

## Install

<pre>
yum -y install autofs
</pre>


## Create Automount (Indirect Mount)

### Create Shares Folder
<pre>
mkdir /shares
</pre>

## Configure

Edit `/etc/autofs.conf`

<pre>
Change timeout from 300 to 60 for test purposes.
</pre>

### Create autofs file
In `/etc/auto.master.d/shares.autofs`.

<pre>
/shares /etc/auto.shares
</pre>

This tells us the /shares folder is associated with the configuration file /etc/auto.shares.

### Create auto.shares

Create `/etc/auto.shares`

<pre>
nfsshare -rw,sync s1:/nfsshare
</pre>

This says that when someone tries to access /share/nfsshare it will auto mount from s1:/nfsshare.

### Start and Test

<pre>
systemctl enable autofs
systemctl start autofs
</pre>

Navigate to the /shares folder.  The ls shows no contents.

<pre>
cd nfsshare
</pre>

The nfsshare is mounted automatically.

Navigate out of the folder and after a minute it will disappear again. 

## Create Automount (Direct Mount)

Modify `/etc/auto.master.d/shares.autofs`

<pre>
/~ /etc/auto.shares
</pre>

Modify `/etc/auto.shares`

<pre>
/shares/nfsshare -rw,sync s1:/nfsshare
</pre>

<pre>
systemctl restart autofs
</pre>

The share is automounted from the start.

## Create Automount (Indirect Wildcard)

Modify `/etc/auto.master.d/shares.autofs`

<pre>
/shares /etc/auto.shares
</pre>

Modify `/etc/auto.shares`

<pre>
* -rw,sync s1:/share/&
</pre>

<pre>
systemctl restart autofs
</pre>

As soon as you ls or cd into one of the shares (e.g. cd /shares/pics); automount, mounts the share.








