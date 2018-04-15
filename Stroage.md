# Storage




## Create Partitions

Verify disk has free space: `fdisk -l`

Create 256MB LVM partition
<pre>
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
</pre>

The new partition will be sda1.

Repeat creating second partition.  It will be sda2

## Using LVM

### Create Logical Volume

#### Create Physical Volumes

<pre>
pvcreate /dev/sda1 /dev/sda2
</pre>

#### Create Volume Group

<pre>
vgcreate datavg /dev/sda1 /dev/sda2
</pre>

#### Create Logical Volume

<pre>
lvcreate -n engdata -L 300M datavg
</pre>

To create a volume using all available space: `lvcreate -n engdata --extents 100%FREE datavg`

#### Format Volume

<pre>
mkfs -t xfs /dev/datavg/engdata
</pre>

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

<pre>
pvcreate /dev/sda3
vgextend datavg /dev/sda3
xfs_growfs /engdata
</pre>

Move data off /dev/sda1
<pre>
pvmove /dev/sda1
vgreduce datavg /dev/sda1
pvremove /dev/sda1
</pre>

### Create SWAP

Create partition for type use 82.  Linux swap.  (e.g. /dev/sdc1)

<pre>
partprobe
lsblk
mkswap /dev/sdc1
free
swapon /dev/sdc1
free
</pre>

You should see increase in Swap.

Setup to mount on boot

<pre>
swapoff /dev/sdc1
blkid
</pre>

Identify and copy the UUID for the /dev/sd1 swap partition.

Add entry to /etc/fstab: `UUID=40dc7a2f-3296-46f7-811b-7fc1a4be34c8 swap swap defaults 0 0`

<pre>
swapon -a
free
swapoff -a
</pre


Reboot and verify the new SWAP is on.  `free -h`


## Remove Storage

<pre>
Remove entries from /etc/fstab

lvremove /dev/datavg/scidata
lvremove /dev/datavg/engdata
vgremove datavg

pvremove /dev/sda2
pvremove /dev/sda3
</pre>

From fdisk and delte partitions









