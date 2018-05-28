# Automount

## Create Shares

On the server (s1) create [NFS shares](./NFS.md).

```
showmount -e s1
Export list for s1:
/nfsshare   *.example.com
/shares/docs *.example.com
/shares/pics *.example.com
/shares/reports  *.example.com
```

## Install
```
yum -y install autofs
```

## Create Automount (Indirect Mount)

### Create Shares Folder
```
mkdir /share
mkdir /shares
mkdir /shares-direct
```

## Configure

Edit `/etc/autofs.conf`

```
Change timeout from 300 to 60 for test purposes.
```

### Create autofs file (e.g. nfsshare.autofs)
In `/etc/auto.master.d/nfsshare.autofs`.

```
/share /etc/auto.nfsshare
```

This tells us the /local folder is associated with the configuration file /etc/auto.local

### Create auto file (e.g. auto.nfsshare)

Create `/etc/auto.nfsshare`

```
nfsshare -rw,sync s1:/nfsshare
```

This says that when someone tries to access /local/autoshare it will auto mount from s1:/nfsshare.

### Start and Test

```
systemctl enable autofs
systemctl start autofs
```

Navigate to the /shares folder.  The ls shows no contents.

```
cd /share/nfsshare
```

The nfsshare is mounted automatically.

Navigate out of the folder and after a minute it will disappear again. 

## Create Automount (Direct Mount)

Create `/etc/auto.master.d/shares-direct.autofs`

```
/- /etc/auto.shares-direct
```

Create `/etc/auto.shares-direct`

```
/shares-direct/docs -rw,sync s1:/shares/docs
/shares-direct/pics -rw,sync s1:/shares/pics
/shares-direct/reports -rw,sync s1:/shares/reports
```

Restart autofs service

```
systemctl restart autofs
```

The share is automounted from the start.   The command `ls /shares` will show all three folders (docs,pics,reports). They are not mounted until someone enters a folder. 

## Create Automount (Indirect Wildcard)

Create `/etc/auto.master.d/shares.autofs`

```
/shares /etc/auto.shares```

Create `/etc/auto.shares`

```
* -rw,sync s1:/shares/&
```

```
systemctl restart autofs
```

None of the folders appear when you `ls /userdata`; however, as soon as you ls or cd into one of the shares (e.g. cd /shares/pics); automount, mounts the share.





