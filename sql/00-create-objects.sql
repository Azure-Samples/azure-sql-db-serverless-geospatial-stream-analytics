/*
	BusData
*/
drop table if exists dbo.BusDataOutput;
create table dbo.BusDataOutput
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
	[GeofenceId] int
)
go

/*
	GeoFences
*/
drop table if exists dbo.GeoFences;
create table [dbo].[GeoFences]
(
	[Id] [int] identity(1,1) not null primary key clustered,
	[Name] [nvarchar](100) not null,
	[GeoFence] [geography] not null,
)
go

/*
	Routes
*/
drop table if exists [dbo].[Routes];
create table [dbo].[Routes](
	[Id] [int] not null primary key clustered,
	[AgencyId] [varchar](100) null,
	[ShortName] [varchar](100) null,
	[Description] [varchar](1000) null,
	[Type] [int] null,
) 
go
alter table [dbo].[MonitoredRoutes] 
add constraint [FK__MonitoredRoutes__Router] foreign key ([RouteId]) references [dbo].[Routes] ([Id])
go

/*
	Add a sample GeoFence
*/
insert into dbo.[GeoFences] ([Name], [GeoFence]) values
('Capitol Hill', geography::Parse('POLYGON((-122.33174064639763 47.6155744069689,-122.30074809841618 47.61483950497026,-122.29989150982155 47.63530797132438,-122.331429153921 47.63509807874925,-122.33174064639763 47.6155744069689))'))
