# Maria DB

## Install

<pre>
yum grouplist hidden ids | grep maria
yum groupinstall mariadb
systemctl enable mariadb.service
systemctl start mariadb.service
ss -ntlup | grep mysql
</pre>

You'll see port 3306 is up.

## Configure


### Disable Network Access
<pre>
vi /etc/my.nf
</pre>

Add line to the [mysqld] section: `skip-networking=1`

The ss command will not return nothing

## Run Secure Installation Script

<pre>
mysql_secure_installation
</pre>

- Set root password
- Remove anonymous users
- Disallow root login remotely
- Remove test database
- Reload privilege tables now

## Login

<pre>
mysql -u root -p<PASSWORD>
</pre>
From MariaDB prompt:
- show databases;
- create database inventory;
- use inventory;
- use mysql;
- show tables;
- describe servers;
- create user dbuser1@localhost identified by 'dbuser1';
- create user dbuser2@'%' identified by 'dbuser2';
- create user dbuser3@'172.16.%' identified by 'dbuser3';
- grant insert,update,delete,select,drop,create,alter on inventory.* to dbuser1@localhost;
- grant select on inventory.* to dbuser2@'%';
- grant all privileges on *.* to dbuser3@localhost;
- revoke drop on inventory.* from dbuser1@localhost;
- flush priviledges;
- exit

Login as dbuser1: `mysql -u dbuser1 -pdbuser1`
- show databases;
- use inventory;
- exit

## Create Tables From SQL

Create a file `create_inventory_tables.sql`
<pre>
drop table if exists product;

create table product(
	id	int(10)		not null	auto_increment,
	name	varchar(100)	not null,
	price	double		not null,
	stock	int(10)		not null,
	catId	int(10)		not null,
	manId   int(10)		not null,
	primary key(id)
);

drop table if exists category;

create table category(
	id	int(10)		not null,
	name  	varchar(100)	not null
);

drop table if exists manufacturer;

create table manufacturer(
	id	int(10)		not null,
	name  	varchar(100)	not null
);
</pre>

mysql -u dbuser1 -pdbuser1 -D inventory < create_inventory_tables.sql


## Load Data into Tables

Create categories.csv
<pre>
1,"kitchen"
2,"bath"
3,"bedroom"
4,"garage"
</pre>

Create manufacturer.csv
<pre>
1,"ABC Company"
2,"Just Things"
3,"More Stuff"
4,"Weird Lots"
5,"Ordinatry Junk"
</pre>

Create product.csv
<pre>
1,"TV",427.33,1,1,3
2,"Fridge",233.89,2,3,1
3,"Clothes Washer",445.88,7,1,4
4,"Computer",342.32,2,2,2
</pre>


mysql -u dbuser1 -pdbuser1 inventory

From MariaSQL Prompt
- load data local infile 'category.csv' into table category fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 0 rows;
- load data local infile 'manufacturers.csv' into table manufacturer fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 0 rows;
- load data local infile 'product.csv' into table product fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 0 rows;
- select * from category;


## Dump Database

<pre>
mysqldump -u root -p(PASSWORD) --all-database > maria.dump
mysqldump -u root -p(PASSWORD) inventory > inventory.dump
</pre>

Dump Options
- Add Drop Tables: `--add-drop-tables`
- No Data: `--no-data`
- Lock All Tables: `--lock-all-tables`
- Add Drop Database: `--add-drop-databases`



## Restore from Dump

<pre>
mysql -u root -p(PASSWORD) in inventory < inventory.dump
</pre>


## Execute Queries from Command Line

<pre>
mysql -udbuser1 -pdbuser1 inventory -e "select * from product"
</pre>

Remove headers and make output tab-delimited

<pre>
mysql -udbuser1 -pdbuser1 inventory -e "select * from product" -sN
</pre>


## Physical Backup

### Create Volume Group 

Needs to have enough space for data and backup 

<pre>
Created a LVM partition 2G (/dev/sda1) using fdisk.

pvcreate /dev/sda1
  Physical volume "/dev/sda1" successfully created.

vgcreate mariavg /dev/sda1
  Volume group "mariavg" successfully created

lvcreate -n inventory -L 500M /dev/mariavg
WARNING: xfs signature detected on /dev/mariavg/inventory at offset 0. Wipe it? [y/n]: y
  Wiping xfs signature on /dev/mariavg/inventory.
  Logical volume "inventory" created.

mkfs -t xfs /dev/mapper/mariavg-inventory

</pre>

### Create Mount

Locate the current data diretory: `mysqladmin-p(PASSWORD) variables | grep datadir`.  Default is /var/lib/mysql.

<pre>
systemctl stop mariadb
mv /var/lib/mysql /var/lib/mysql.OLD
mkdir /var/lib/mysql
</pre>

Create Mount entry in /etc/fstab
<pre>
/dev/mapper/mariavg-inventory /var/lib/mysql xfs defaults 0 0
</pre>

Mount and move data
<pre>
mount -a
chown mysql. /var/lib/mysql
cp -ra /var/lib/mysql.OLD/* var/lib/mysql
restorecon -Rv /var/lib/mysql
systemctl start mariadb
</pre>

### Backup 

<pre>
mysql -uroot -p(PASSWORD)
flush tables with read lock;
</pre>

From Another Window

<pre>
lvcreate -n inventory-backup -L 500M -s /dev/mariavg/inventory
</pre>

The -s option creates a backup of /dev/mariavg/inventory 

Now back at MariaDB prompt
- unlock tables;
- exit;

Now you can mount the backup and look at it's contents
<pre>
mkdir /mnt/snapshot
mount -o nouuid /dev/mariavg/inventory-backup /mnt/snapshot/
cd /mnt/snapshot/
ls
</pre>






