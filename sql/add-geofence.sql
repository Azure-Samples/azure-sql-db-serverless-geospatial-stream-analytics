/*
	database: catch_the_bus@dmmssqlsrv
*/

select Id, ShortName, [Description] from [dbo].[Routes]

select Id, [Name], [GeoFence] as GeoFence from dbo.[GeoFences]

insert into dbo.[GeoFences] ([Name], [GeoFence]) values
('Capitol Hill', geography::Parse('POLYGON((-122.33174064639763 47.6155744069689,-122.30074809841618 47.61483950497026,-122.29989150982155 47.63530797132438,-122.331429153921 47.63509807874925,-122.33174064639763 47.6155744069689))'))

select * from dbo.[GeoFences]


