
/*
	BusData
*/
select * from dbo.BusDataOutput
--where [GeofenceId] is not null
order by [TimestampUTC] desc
go

/*
	BusData
*/
select * from dbo.BusDataOutput
where [GeofenceId] is not null
order by [TimestampUTC] desc
go

/*
	Calculate bus status with respect to defined GeoFence
*/
with cte as
(
	select 
		*,
		lag([GeofenceId], 1) over (partition by [RouteId], [VehicleId], [DirectionId] order by [TimestampUTC]) as PreGeofenceId
	from 
		dbo.BusDataOutput
)
select
	*,
	case 
		when PreGeofenceId is null and [cte].[GeofenceId] is null then 'OUT'
		when PreGeofenceId is not null and [cte].[GeofenceId] is not null then 'IN'
		when PreGeofenceId is null and [cte].[GeofenceId] is not null then 'ENTER'
		when PreGeofenceId is not null and [cte].[GeofenceId] is null then 'EXIT'
	end as GeoFenceAction
from
	cte
where
	RouteLongName like '%Capitol Hill%';
go