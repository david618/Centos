# iSCSI


## Create iSCSI Block

### Install

```
yum -y install targetcli
systemctl enable target
systemctl start target

firewall-cmd --permanent --add-port=3260/tcp
firewall-cmd --reload
```

### Configure

#### Create Volume

Use fdisk to create a 2G LVM partition.  (e.g. type 8e)

```
pvcreate /dev/sda1
vgcreate iSCSIvg /dev/sda1
lvcreate -n disk1 -L 100M iSCSIvg
```

#### Configure Target
From targetcli

```
targetcli
/backstores/block create s1.disk1 /dev/mapper/iSCSIvg-disk1
/iscsi create iqn.2018-03.com.example:s1
/iscsi/iqn.2018-03.com.example:s1/tpg1/acls create iqn.2018-03.com.example:c1
/iscsi/iqn.2018-03.com.example:s1/tpg1/luns create /backstores/block/s1.disk1
/iscsi/iqn.2018-03.com.example:s1/tpg1/portals delete 0.0.0.0 3260
/iscsi/iqn.2018-03.com.example:s1/tpg1/portals create 172.16.1.1
saveconfig
exit
```

## Consume 

### Install

```
yum -y install iscsi-initiator-utils
vi /etc/iscsi/initiatorname.iscsi
```

Change to match iqn for c1: `InitiatorName=iqn.2018-03.com.example:c1`

```
systemctl enable iscsi
systemctl start iscsi
```

### Configure

Now see if you can connect.

```
iscsiadm -m discovery -t st -p 172.16.1.1
```

Should return the iqn for the server: `172.16.1.1:3260,1 iqn.2018-03.com.example:s1`

Login
```
iscsiadm -m node -T iqn.2018-03.com.example:s1 -p 172.16.1.1 -l
```

You should get back message Login successful.

```
lsblk
```

You should see the new block device (e.g. sdd).


Look at information
```
iscsiadm -m session -P 3
```

The persistent node is in `/var/lib/iscsi/nodes`

Logout

```
iscsiadm -m node -T iqn.2018-03.com.example:s1 -p 172.16.1.1 -u
```

The persistent files still remain in /var/lib/iscsi/nodes.

```
systemctl restart iscsi
lsblk
```

The device returns.

### Format

```
mkfs -t xfs /dev/sdd
blkid /dev/sdd

mkdir /iscsidisk1
vi /etc/fstab
```

Add line

```
UUID=6cdec9cb-37d1-4f44-b3de-3674c51a8d53 /iscsidisk1 xfs _netdev 0 0
```

### Delete

```
iscsiadm -m node -T iqn.2018-03.com.example:s1 -p 172.16.1.1 -u
iscsiadm -m node -T iqn.2018-03.com.example:s1 -p 172.16.1.1 -o delete
```






