# Automount

## Create Shares

On the server (s1) create [NFS shares](./NFS.md).

```
showmount -e s1
Export list for s1:
/nfsshare   *.example.com
/share/docs *.example.com
/share/pics *.example.com
/share/tmp  *.example.com
```

## Install
```
yum -y install autofs
```


## Create Automount (Indirect Mount)

### Create Shares Folder
```
mkdir /shares
```

## Configure

Edit `/etc/autofs.conf`

```
Change timeout from 300 to 60 for test purposes.
```

### Create autofs file
In `/etc/auto.master.d/shares.autofs`.

```
/shares /etc/auto.shares
```

This tells us the /shares folder is associated with the configuration file /etc/auto.shares.

### Create auto.shares

Create `/etc/auto.shares`

```
nfsshare -rw,sync s1:/nfsshare
```

This says that when someone tries to access /share/nfsshare it will auto mount from s1:/nfsshare.

### Start and Test

```
systemctl enable autofs
systemctl start autofs
```

Navigate to the /shares folder.  The ls shows no contents.

```
cd nfsshare
```

The nfsshare is mounted automatically.

Navigate out of the folder and after a minute it will disappear again. 

## Create Automount (Direct Mount)

Modify `/etc/auto.master.d/shares.autofs`

```
/- /etc/auto.shares
```

Modify `/etc/auto.shares`

```
/shares/nfsshare -rw,sync s1:/nfsshare
```

```
systemctl restart autofs
```

The share is automounted from the start.

## Create Automount (Indirect Wildcard)

Modify `/etc/auto.master.d/shares.autofs`

```
/shares /etc/auto.shares
```

Modify `/etc/auto.shares`

```
* -rw,sync s1:/share/&
```

```
systemctl restart autofs
```

As soon as you ls or cd into one of the shares (e.g. cd /shares/pics); automount, mounts the share.








