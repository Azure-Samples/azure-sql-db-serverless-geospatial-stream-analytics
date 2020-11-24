/*
	database: dmhs@dmmssqlsrv
*/
drop table if exists dbo.ASAOutput;
create table dbo.ASAOutput
(
	[Id] varchar(100),
	[RouteId] int,
	[VehicleId] int,
	[DirectionId] int,
	[Latitude] decimal(9,6),
	[Longitude] decimal(9,6),
	[TimestampUTC] datetime2(7),
	[RouteShortName] nvarchar(100),
	[RouteLongName] nvarchar(1000),
	GeofenceId int
)
go

select * from dbo.[ASAOutput] 
where [GeofenceId] is not null
order by [TimestampUTC] desc

with cte as
(
select * from dbo.[ASAOutput] where [RouteShortName] = '550'
)
select * from cte order by Id desc


