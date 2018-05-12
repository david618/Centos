# Maria DB

## Install

```
yum grouplist hidden ids | grep maria
yum groupinstall mariadb
systemctl enable mariadb.service
systemctl start mariadb.service
ss -ntlup | grep mysql
```

You'll see port 3306 is up.

## Help

From mysql prompt enter help (e.g. `help load data` or `help auto_increment`)

From mysqld settings.

```
rpm -qil mariadb-server | grep mysqld

Then

/usr/libexec/mysqld --help
/usr/libexec/mysqld --help --verbose | grep networking
```

## Configure


### Disable Network Access
```
vi /etc/my.cnf
```

Add line to the [mysqld] section: `skip-networking=1`

The ss command will not return nothing

## Run Secure Installation Script

```
mysql_secure_installation
```

Options
- Set root password
- Remove anonymous users
- Disallow root login remotely
- Remove test database
- Reload privilege tables now

## Login

```
mysql -u root -p<PASSWORD>
```

From MariaDB prompt:
- show databases;
- create database inventory;
- use inventory;
- use mysql;
- show tables;
- create table servers( id int(10) not null auto_increment, name varchar(100) not null, make varchar(100) not null, model varchar(100) not null, primary key(id));
- create table servers2( id int(10) not null, name varchar(100) not null, make varchar(100) not null, model varchar(100) not null);
- describe servers;
- create user dbuser1@localhost identified by 'dbuser1';
- create user dbuser2@'%' identified by 'dbuser2';
- create user dbuser3@'172.16.%' identified by 'dbuser3';
- grant insert,update,delete,select,drop,create,alter on inventory.* to dbuser1@localhost;
- grant select on inventory.* to dbuser2@'%';
- grant all privileges on *.* to dbuser3@localhost;
- revoke drop on inventory.* from dbuser1@localhost;
- flush privileges;
- exit

Login as dbuser1: `mysql -u dbuser1 -pdbuser1`
- show databases;
- use inventory;
- exit

## Create Tables From SQL

Create a file `create_inventory_tables.sql`
```
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
```

mysql -u dbuser1 -pdbuser1 -D inventory < create_inventory_tables.sql


## Load Data into Tables

Create category.csv
```
1,"kitchen"
2,"bath"
3,"bedroom"
4,"garage"
```

Create manufacturer.csv
```
1,"ABC Company"
2,"Just Things"
3,"More Stuff"
4,"Weird Lots"
5,"Ordinatry Junk"
```

Create product.csv
```
1,"TV",427.33,1,1,3
2,"Fridge",233.89,2,3,1
3,"Clothes Washer",445.88,7,1,4
4,"Computer",342.32,2,2,2
```


mysql -u dbuser1 -pdbuser1 inventory

From MariaSQL Prompt
- load data local infile 'category.csv' into table category fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 0 rows;
- load data local infile 'manufacturers.csv' into table manufacturer fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 0 rows;
- load data local infile 'product.csv' into table product fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 0 rows;
- select * from category;

Help Finding Format for Load Data Local.  From MariaDB prompt `help load data`.  

## Add Record using Insert

```
insert into product (id,name,price,stock,catId,manId) values (5,"Dish Washter",234.44,7,1,4);
```

## Dump Database

```
mysqldump -u root -p(PASSWORD) --all-database > maria.dump
mysqldump -u root -p(PASSWORD) inventory > inventory.dump
```

Dump Options
- Add Drop Tables: `--add-drop-tables`
- No Data: `--no-data`
- Lock All Tables: `--lock-all-tables`
- Add Drop Database: `--add-drop-databases`



## Restore from Dump

```
mysql -u root -p(PASSWORD) inventory < inventory.dump
```


## Execute Queries from Command Line

```
mysql -udbuser1 -pdbuser1 inventory -e "select * from product"
```

Remove headers and make output tab-delimited

```
mysql -udbuser1 -pdbuser1 inventory -e "select * from product" -sN
```

## Physical Backup

### Create Volume Group 

Needs to have enough space for data and backup 

```
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

```

### Create Mount

Locate the current data diretory: `mysqladmin-p(PASSWORD) variables | grep datadir`.  Default is /var/lib/mysql.

```
systemctl stop mariadb
mv /var/lib/mysql /var/lib/mysql.OLD
mkdir /var/lib/mysql
```

Create Mount entry in /etc/fstab
```
/dev/mapper/mariavg-inventory /var/lib/mysql xfs defaults 0 0
```

Mount and move data
```
mount -a
chown mysql. /var/lib/mysql
cp -ra /var/lib/mysql.OLD/* var/lib/mysql
restorecon -Rv /var/lib/mysql
systemctl start mariadb
```

### Backup 

```
mysql -uroot -p(PASSWORD)
flush tables with read lock;
```

From Another Window

```
lvcreate -n inventory-backup -L 500M -s /dev/mariavg/inventory
```

The -s option creates a backup of /dev/mariavg/inventory 

Now back at MariaDB prompt
- unlock tables;
- exit;

Now you can mount the backup and look at it's contents
```
mkdir /mnt/snapshot
mount -o nouuid /dev/mariavg/inventory-backup /mnt/snapshot/
cd /mnt/snapshot/
ls
```






