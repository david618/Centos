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
