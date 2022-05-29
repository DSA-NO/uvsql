use uvnet2
go

/*========== CREATE PROCEDURES ==========*/

DROP PROCEDURE IF EXISTS insert_factortype;
GO  

create proc insert_factortype
    @label nvarchar(32)	
as 
	insert into factortype values (@label);
go

DROP PROCEDURE IF EXISTS update_factortype;
GO  

create proc update_factortype	
	@id int,
    @label nvarchar(32)
as 
	update factortype set 
		label = @label		
	where id = @id
go

DROP PROCEDURE IF EXISTS insert_station;
GO  

create proc insert_station	
    @label nvarchar(50),	
	@active bit,
    @latitude real,
    @longitude real,	
	@ftp_host nvarchar(200),
	@ftp_user nvarchar(50),
	@ftp_password nvarchar(50),
	@ftp_remote_dir nvarchar(200),
	@ftp_local_dir nvarchar(200),
	@comment nvarchar(1000),
	@ftp_passive_mode bit
as 
	insert into station values (
		@label,
		@active,
		@latitude,
		@longitude,	
		@ftp_host,
		@ftp_user,
		@ftp_password,
		@ftp_remote_dir,
		@ftp_local_dir,
		@comment,
		@ftp_passive_mode
	);
go

DROP PROCEDURE IF EXISTS update_station;
GO  

create proc update_station
	@id int,
    @label nvarchar(50),
	@active bit,
    @latitude real,
    @longitude real,	
	@ftp_host nvarchar(200),
	@ftp_user nvarchar(50),
	@ftp_password nvarchar(50),
	@ftp_remote_dir nvarchar(200),
	@ftp_local_dir nvarchar(200),
	@comment nvarchar(1000),
	@ftp_passive_mode bit
as 
	update station set 
		label = @label,				
		active = @active,
		latitude = @latitude,
		longitude = @longitude,	
		ftp_host = @ftp_host,
		ftp_user = @ftp_user,
		ftp_password = @ftp_password,
		ftp_remote_dir = @ftp_remote_dir,
		ftp_local_dir = @ftp_local_dir,
		comment = @comment,
		ftp_passive_mode = @ftp_passive_mode
	where id = @id
go

DROP PROCEDURE IF EXISTS select_stations;
GO  

create proc select_stations
as 
	select *
	from station	
go

DROP PROCEDURE IF EXISTS select_station_infos;
GO  

create proc select_station_infos
as 
	select 
		id, 		
		label,		
		ftp_host,
		ftp_user,
		ftp_password,
		ftp_remote_dir,
		ftp_local_dir,
		ftp_passive_mode
	from station
	where active = 1
go

DROP PROCEDURE IF EXISTS insert_instrument;
GO  

create proc insert_instrument
	@id int,
	@label nvarchar(50),
	@station_id int,
	@active bit,
	@principal bit,
	@model nvarchar(200),
	@channel_count int,
	@last_calibrated datetime,
	@fetch_module nvarchar(128),
	@validate_module nvarchar(128),
	@store_module nvarchar(128),
	@match_expression nvarchar(200),
	@comment nvarchar(1000)    
as 
	insert into instrument values (					
		@id,	
		@label,		
		@station_id,
		@active,
		@principal,
		@model,
		@channel_count,
		@last_calibrated,
		@fetch_module,
		@validate_module,
		@store_module,	
		@match_expression,
		@comment
	);
go

DROP PROCEDURE IF EXISTS update_instrument;
GO  

create proc update_instrument
	@id int,    
	@label nvarchar(50),		
	@station_id int,
	@active bit,
	@principal bit,
	@model nvarchar(200),
	@channel_count int,
	@last_calibrated datetime,
	@fetch_module nvarchar(128),
	@validate_module nvarchar(128),
	@store_module nvarchar(128),	
	@match_expression nvarchar(200),
	@comment nvarchar(1000) 
as 
	update instrument set 	
		label = @label,		
		station_id = @station_id,
		active = @active,
		principal = @principal,
		model = @model,
		channel_count = @channel_count,
		last_calibrated = @last_calibrated,
		fetch_module = @fetch_module,
		validate_module = @validate_module,
		store_module = @store_module,		
		match_expression = @match_expression,
		comment = @comment
	where id = @id
go

DROP PROCEDURE IF EXISTS select_instruments;
GO  

create proc select_instruments
as 
	select *
	from instrument
go

DROP PROCEDURE IF EXISTS select_instrument_contexts;
GO  

create proc select_instrument_contexts
as 
	select 
		i.id as 'instrument_id', 
		i.label as 'instrument_name', 
		i.station_id as 'station_id', 
		i.principal, 
		i.fetch_module, 
		i.validate_module, 
		i.store_module, 
		i.match_expression,
		s.label as 'station_name'
	from instrument i inner join station s on i.station_id = s.id
	where i.active = 1
go

DROP PROCEDURE IF EXISTS insert_measurement2;
GO  

create proc insert_measurement2
	@station_id int,
	@instrument_id int,
	@principal bit,
	@measurement_date datetime,
    @e305 real,
    @e313 real,
    @e320 real,
    @e340 real,
    @e380 real,
    @e395 real,
    @e412 real,
    @e443 real,
    @e490 real,
    @e532 real,
    @e555 real,
    @e665 real,
    @e780 real,
    @e875 real,
    @e940 real,
    @e1020 real,
    @e1245 real,
    @e1640 real,
    @par real,
    @dtemp real,
	@zenith real,
	@azimuth real
as 
	if not exists(select 1 from measurement where instrument_id = @instrument_id and measurement_date = @measurement_date)
		begin
			insert into measurement values (
				@station_id,
				@instrument_id,
				@principal,
				@measurement_date,
				@e305,
				@e313,
				@e320,
				@e340,
				@e380,
				@e395,
				@e412,
				@e443,
				@e490,
				@e532,
				@e555,
				@e665,
				@e780,
				@e875,
				@e940,
				@e1020,
				@e1245,
				@e1640,
				@par,
				@dtemp,
				@zenith,
				@azimuth
			);
			
			declare @dt datetime
			set @dt = CAST(@measurement_date AS date)

			if not exists(select 1 from guvparam where station_id = @station_id and instrument_id = @instrument_id and measurement_date = @dt)
				exec insert_guvparam2 @station_id, @instrument_id, @dt, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
		end
	else
		begin
			update measurement set
				e305 = @e305,
				e313 = @e313,
				e320 = @e320,
				e340 = @e340,
				e380 = @e380,
				e395 = @e395,
				e412 = @e412,
				e443 = @e443,
				e490 = @e490,
				e532 = @e532,
				e555 = @e555,
				e665 = @e665,
				e780 = @e780,
				e875 = @e875,
				e940 = @e940,
				e1020 = @e1020,
				e1245 = @e1245,
				e1640 = @e1640,
				par = @par,
				dtemp = @dtemp,
				zenith = @zenith,
				azimuth = @azimuth
			where instrument_id = @instrument_id and measurement_date = @measurement_date;
		end
go

DROP PROCEDURE IF EXISTS insert_guvparam2;
GO  

create proc insert_guvparam2
	@station_id int,
    @instrument_id int,
    @measurement_date datetime,
    @d305 real,
    @d313 real,
    @d320 real,
    @d340 real,
    @d380 real,
    @d395 real,
    @d412 real,
    @d443 real,
    @d490 real,
    @d532 real,
    @d555 real,
    @d665 real,
    @d780 real,
    @d875 real,
    @d940 real,
    @d1020 real,
    @d1245 real,
    @d1640 real,
    @dpar real,
    @o305 real,
    @o313 real,
    @o320 real,
    @o340 real,
    @o380 real,
    @o395 real,
    @o412 real,
    @o443 real,
    @o490 real,
    @o532 real,
    @o555 real,
    @o665 real,
    @o780 real,
    @o875 real,
    @o940 real,
    @o1020 real,
    @o1245 real,
    @o1640 real,
    @opar real
as 
declare @dt datetime
set @dt = CAST(@measurement_date AS date)

if not exists(select 1 from guvparam where station_id = @station_id and instrument_id = @instrument_id and measurement_date = @dt)
	insert into guvparam values (
		@station_id,
		@instrument_id,
		@dt,
		@d305,
		@d313,
		@d320,
		@d340,
		@d380,
		@d395,
		@d412,
		@d443,
		@d490,
		@d532,
		@d555,
		@d665,
		@d780,
		@d875,
		@d940,
		@d1020,
		@d1245,
		@d1640,
		@dpar,
		@o305,
		@o313,
		@o320,
		@o340,
		@o380,
		@o395,
		@o412,
		@o443,
		@o490,
		@o532,
		@o555,
		@o665,
		@o780,
		@o875,
		@o940,
		@o1020,
		@o1245,
		@o1640,
		@opar
	);
else
	update guvparam set
		d305 = @d305,
		d313 = @d313,
		d320 = @d320,
		d340 = @d340,
		d380 = @d380,
		d395 = @d395,
		d412 = @d412,
		d443 = @d443,
		d490 = @d490,
		d532 = @d532,
		d555 = @d555,
		d665 = @d665,
		d780 = @d780,
		d875 = @d875,
		d940 = @d940,
		d1020 = @d1020,
		d1245 = @d1245,
		d1640 = @d1640,
		dpar = @dpar,
		o305 = @o305,
		o313 = @o313,
		o320 = @o320,
		o340 = @o340,
		o380 = @o380,
		o395 = @o395,
		o412 = @o412,
		o443 = @o443,
		o490 = @o490,
		o532 = @o532,
		o555 = @o555,
		o665 = @o665,
		o780 = @o780,
		o875 = @o875,
		o940 = @o940,
		o1020 = @o1020,
		o1245 = @o1245,
		o1640 = @o1640,
		opar = @opar
	where station_id = @station_id and instrument_id = @instrument_id and measurement_date = @dt;
go

DROP PROCEDURE IF EXISTS insert_guvfactor2;
GO  

create proc insert_guvfactor2
	@instrument_id int,
    @factortype_id int,
	@valid_from datetime,
	@valid_to datetime,
    @cie305 real,
    @cie313 real,
    @cie320 real,
    @cie340 real,
    @cie380 real,
    @cie395 real,
    @cie412 real,
    @cie443 real,
    @cie490 real,
    @cie532 real,
    @cie555 real,
    @cie665 real,
    @cie780 real,
    @cie875 real,
    @cie940 real,
    @cie1020 real,
    @cie1245 real,
    @cie1640 real,
    @par real
as 
	insert into guvfactor values (
		@instrument_id,
		@factortype_id,
		@valid_from,
		@valid_to,
		@cie305,
		@cie313,
		@cie320,
		@cie340,
		@cie380,
		@cie395,
		@cie412,
		@cie443,
		@cie490,
		@cie532,
		@cie555,
		@cie665,
		@cie780,
		@cie875,
		@cie940,
		@cie1020,
		@cie1245,
		@cie1640,
		@par
	);
go

DROP PROCEDURE IF EXISTS cie_min2;
GO  

create  PROCEDURE cie_min2
   @stasjon varchar(15),
   @fra_datotid datetime,
   @til_datotid datetime
AS       
	DECLARE @station_id int
	SELECT @station_id = id FROM station WHERE label = @station_name
			 
	DECLARE @factortype_id int
	SELECT @factortype_id = id FROM dbo.factortype WHERE label = @factortype

	SELECT 
		@station_name AS 'Stasjon', 
		CONVERT(varchar, m.measurement_date, 120) AS 'Datotid', 
		m.instrument_id AS 'Inst_id', 
		((m.e305 - p.o305) / p.d305) * f.cie305 + 
		((m.e313 - p.o313) / p.d313) * f.cie313 + 
		((m.e320 - p.o320) / p.d320) * f.cie320 + 
		((m.e340 - p.o340) / p.d340) * f.cie340 + 
		((m.e380 - p.o380) / p.d380) * f.cie380 +
		((m.e395 - p.o395) / p.d395) * f.cie395 +
		((m.e412 - p.o412) / p.d412) * f.cie412 +
		((m.e443 - p.o443) / p.d443) * f.cie443 +
		((m.e490 - p.o490) / p.d490) * f.cie490 +
		((m.e532 - p.o532) / p.d532) * f.cie532 +
		((m.e555 - p.o555) / p.d555) * f.cie555 +
		((m.e665 - p.o665) / p.d665) * f.cie665 +
		((m.e780 - p.o780) / p.d780) * f.cie780 +
		((m.e875 - p.o875) / p.d875) * f.cie875 +
		((m.e940 - p.o940) / p.d940) * f.cie940 +
		((m.e1020 - p.o1020) / p.d1020) * f.cie1020 +
		((m.e1245 - p.o1245) / p.d1245) * f.cie1245 +
		((m.e1640 - p.o1640) / p.d1640) * f.cie1640 +
		((m.par - p.opar) / p.dpar) * f.par AS 'Cie', 
		(m.e305 - p.o305) / p.d305 AS 'e305', 
		(m.e313 - p.o313) / p.d313 AS 'e313', 
		(m.e320 - p.o320) / p.d320 AS 'e320', 
		(m.e340 - p.o340) / p.d340 AS 'e340', 
		(m.e380 - p.o380) / p.d380 AS 'e380',
		(m.e395 - p.o395) / p.d395 AS 'e395',
		(m.e412 - p.o412) / p.d412 AS 'e412',
		(m.e443 - p.o443) / p.d443 AS 'e443',
		(m.e490 - p.o490) / p.d490 AS 'e490',
		(m.e532 - p.o532) / p.d532 AS 'e532',
		(m.e555 - p.o555) / p.d555 AS 'e555',
		(m.e665 - p.o665) / p.d665 AS 'e665',
		(m.e780 - p.o780) / p.d780 AS 'e780',
		(m.e875 - p.o875) / p.d875 AS 'e875',
		(m.e940 - p.o940) / p.d940 AS 'e940',
		(m.e1020 - p.o1020) / p.d1020 AS 'e1020',
		(m.e1245 - p.o1245) / p.d1245 AS 'e1245',
		(m.e1640 - p.o1640) / p.d1640 AS 'e1640',
		(m.par - p.opar) / p.dpar AS 'par',
		p.measurement_date AS 'ParamDato'	
	FROM
		dbo.measurement as m, 
		dbo.guvfactor as f, 
		dbo.guvparam as p
	WHERE 
		m.measurement_date >= @date_from AND 
		m.measurement_date < @date_to AND
		CAST(m.measurement_date AS date) = CAST(p.measurement_date AS date) AND
		m.station_id = @station_id AND 
		m.principal = 1 AND
		p.station_id = @station_id AND
		f.instrument_id = m.instrument_id AND
		f.factortype_id = @factortype_id AND f.valid_from <= m.measurement_date and f.valid_to > m.measurement_date and
		p.instrument_id = m.instrument_id
	order by m.measurement_date asc
