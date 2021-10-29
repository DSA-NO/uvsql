create database uvnet2
go

use uvnet2
go

if OBJECT_ID('dbo.guvfactor', 'U') is not null drop table guvfactor;
if OBJECT_ID('dbo.guvparam', 'U') is not null drop table guvparam;
if OBJECT_ID('dbo.measurement', 'U') is not null drop table measurement;
if OBJECT_ID('dbo.station', 'U') is not null drop table station;
if OBJECT_ID('dbo.instrument', 'U') is not null drop table instrument;
if OBJECT_ID('dbo.factortype', 'U') is not null drop table factortype;
go

/*=======================================================*/

create table factortype (
	id int identity(1,1) primary key,
	label nvarchar(32) not null
)
go

alter table factortype add constraint AK_factortype_label unique (label);
go

insert into factortype values('cie');
go

/*=======================================================*/

create table station(
	id int identity(1,1) primary key,
	label nvarchar(50) not null,	
	active bit default 1,
	latitude real not null,
	longitude real not null,
	ftp_host nvarchar(200) default null,
	ftp_user nvarchar(50) default null,
	ftp_password nvarchar(50) default null,
	ftp_remote_dir nvarchar(200) default null,
	ftp_local_dir nvarchar(200) default null,
	comment nvarchar(1000) default null
)
go

alter table station add constraint AK_station_label unique (label);
alter table station add constraint AK_station_ftp_host unique (ftp_host);
go  

/*=======================================================*/

create table instrument (
	id int primary key,	
	label nvarchar(50) default null,	
	station_id int default null,
	active bit default 1,
	principal bit default 0,
	model nvarchar(200) default null,
	channel_count int default null,
	last_calibrated datetime default null,
	fetch_module nvarchar(128),
	validate_module nvarchar(128),
	store_module nvarchar(128),	
	match_expression nvarchar(200),	
	comment nvarchar(1000) default null
)
go

alter table instrument add foreign key (station_id) references station(id);
alter table instrument add constraint AK_instrument_id unique (id);   
alter table instrument add constraint AK_instrument_label unique (label);
alter table instrument add constraint AK_instrument_match_expression unique (match_expression);
go  

/*=======================================================*/

create table guvfactor(
	id int identity(1,1) primary key,
	instrument_id int NOT NULL,
	factortype_id int NOT NULL,
	valid_from datetime NOT NULL,
	valid_to datetime NOT NULL,
	cie305 real NULL,
	cie313 real NULL,
	cie320 real NULL,
	cie340 real NULL,
	cie380 real NULL,
	cie395 real NULL,
	cie412 real NULL,
	cie443 real NULL,
	cie490 real NULL,
	cie532 real NULL,
	cie555 real NULL,
	cie665 real NULL,
	cie780 real NULL,
	cie875 real NULL,
	cie940 real NULL,
	cie1020 real NULL,
	cie1245 real NULL,
	cie1640 real NULL,
	par real NULL 
)
go

alter table guvfactor add foreign key (instrument_id) references instrument(id);
alter table guvfactor add foreign key (factortype_id) references factortype(id);
go

/*=======================================================*/

create table guvparam(
	station_id int NOT NULL,
	instrument_id int NOT NULL,
	measurement_date datetime NOT NULL,
	d305 real NULL,
	d313 real NULL,
	d320 real NULL,
	d340 real NULL,
	d380 real NULL,
	d395 real NULL,
	d412 real NULL,
	d443 real NULL,
	d490 real NULL,
	d532 real NULL,
	d555 real NULL,
	d665 real NULL,
	d780 real NULL,
	d875 real NULL,
	d940 real NULL,
	d1020 real NULL,
	d1245 real NULL,
	d1640 real NULL,
	dpar real NULL,
	o305 real NULL,
	o313 real NULL,
	o320 real NULL,
	o340 real NULL,
	o380 real NULL,
	o395 real NULL,
	o412 real NULL,
	o443 real NULL,
	o490 real NULL,
	o532 real NULL,
	o555 real NULL,
	o665 real NULL,
	o780 real NULL,
	o875 real NULL,
	o940 real NULL,
	o1020 real NULL,
	o1245 real NULL,
	o1640 real NULL,
	opar real NULL,
 CONSTRAINT [guvparam$pk_guvparam] PRIMARY KEY CLUSTERED 
(
	[station_id] ASC,
	[instrument_id] ASC,
	[measurement_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
go

alter table guvparam add foreign key (station_id) references station(id);
alter table guvparam add foreign key (instrument_id) references instrument(id);
go

/*=======================================================*/

create table measurement(
	station_id int NOT NULL,
	instrument_id int NOT NULL,
	principal bit default 0,
	measurement_date datetime NOT NULL,
	e305 real NULL,
	e313 real NULL,
	e320 real NULL,
	e340 real NULL,
	e380 real NULL,
	e395 real NULL,
	e412 real NULL,
	e443 real NULL,
	e490 real NULL,
	e532 real NULL,
	e555 real NULL,
	e665 real NULL,
	e780 real NULL,
	e875 real NULL,
	e940 real NULL,
	e1020 real NULL,
	e1245 real NULL,
	e1640 real NULL,
	par real NULL,
	dtemp real NULL,
	zenith real NULL,
	azimuth real NULL,
 CONSTRAINT [measurement$pk_measurement] PRIMARY KEY CLUSTERED 
(
	station_id ASC,
	instrument_id ASC,
	measurement_date ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
go

alter table measurement add foreign key (station_id) references station(id);
alter table measurement add foreign key (instrument_id) references instrument(id);
go

/*=======================================================*/
