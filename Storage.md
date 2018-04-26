# Storage

## Create Partitions

Verify disk has free space: `fdisk -l`

Create 256MB LVM partition
```
fdisk /dev/sda
Command: n
Partition type: p
Parition Number: 1
First Sector: Use Default 
Last Sector: +256M
Command: t
Hex code: 8e
Command: w
partprobe
lsblk
```

The new partition will be sda1.

Repeat creating second partition.  It will be sda2

## Using LVM

#### Create Physical Volumes

```
pvcreate /dev/sda1 /dev/sda2
```

#### Create Volume Group

```
vgcreate datavg /dev/sda1 /dev/sda2
```

#### Create Logical Volume

```
lvcreate -n engdata -L 300M datavg
```

To create a volume using all available space: `lvcreate -n engdata --extents 100%FREE datavg`

#### Format Volume

```
mkfs -t xfs /dev/datavg/engdata
```

#### Mount 

Make Directory: `mkdir /engdata`

Add line to /etc/fstab: `/dev/datavg/engdata /engdata xfs defaults 0 0`

Test: `mount -a`

#### Commands

- List Physical Volumes: `pvdisplay /dev/sda1`
- List Volume Groups: `vgdisplay datavg`
- List Logical Volumes: `lvdisplay /dev/datavg/engdata`

### Replace Physcial Volume 

Create another 512MB LVM parition (/dev/sda3).

```
pvcreate /dev/sda3
vgextend datavg /dev/sda3
xfs_growfs /engdata
```

Move data off /dev/sda1
```
pvmove /dev/sda1
vgreduce datavg /dev/sda1
pvremove /dev/sda1
```

### Create SWAP

Create partition for type use 82.  Linux swap.  (e.g. /dev/sdc1)

```
partprobe
lsblk
mkswap /dev/sdc1
free
swapon /dev/sdc1
free
```

You should see increase in Swap.

Setup to mount on boot

```
swapoff /dev/sdc1
blkid
```

Identify and copy the UUID for the /dev/sd1 swap partition.

Add entry to /etc/fstab: `UUID=40dc7a2f-3296-46f7-811b-7fc1a4be34c8 swap swap defaults 0 0`

```
swapon -a
free
swapoff -a
```


Reboot and verify the new SWAP is on.  `free -h`


## Remove Storage

```
Remove entries from /etc/fstab

lvremove /dev/datavg/scidata
lvremove /dev/datavg/engdata
vgremove datavg

pvremove /dev/sda2
pvremove /dev/sda3
```

From fdisk delete partitions









