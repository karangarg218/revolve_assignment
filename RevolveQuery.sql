-- Used MS SQL SERVER for solving this
-- QUS1. Which manufacturer's planes had most no of flights? And how many flights?
-- ** This approach does not account for flights that have missing or incorrect tail number information, and may give different results than counting the actual number of flights operated by each manufacturer.

select top 1 pl.manufacturer,count(*) as total_flights from 
flights as fl join planes as pl on fl.tailnum=pl.tailnum
group by pl.manufacturer order by 2 desc;


-- QUS2.Which manufacturer's planes had most no of flying hours? And how many hours?
-- ** does not count record which have null and text to int

select top 1  pl.manufacturer,sum(cast(fl.air_time as int)) as total_flying_hours
from flights fl JOIN  planes pl  on fl.tailnum = pl.tailnum 
where fl.air_time  <> 'na' 
group by pl.manufacturer order by 2 desc;

-- QUS3.Which plane flew the most number of hours? And how many hours?
-- 1 approach
select top 1 tailnum,sum(cast(air_time as int)) as 
total_flying_hours from flights
where air_time<>'na' group by tailnum order by 2 desc;

-- 2 approach
SELECT top 1 tailnum, SUM(CASE WHEN ISNUMERIC(air_time) = 1 THEN CAST(air_time AS FLOAT) ELSE 0 END) AS total_flying_hours
FROM flights
GROUP BY tailnum
ORDER BY 2 DESC


-- QUS 4.Which destination had most delay in flights?
-- ** 1 -> only considering postive value -> delayed flight not early flights.
with cte as (
select top 1 dest,count(*) as most_delay from flights 
where arr_delay <> 'na' and arr_delay>0
group by dest order by 2 desc
)

select cte.*,airports.city,airports.airport from cte join airports on cte.dest=airports.iata_code;


-- QUS5.Which manufactures planes had covered most distance? And how much distance?
select top 1 pl.manufacturer,sum(fl.distance) as total_distance_covered 
from flights as fl 
join 
planes as pl on fl.tailnum=pl.tailnum
group by pl.manufacturer order by 2 desc;


-- QUS6. Which airport had most flights on weekends?
with cte as(
select *,DATEname(dw,DATEFROMPARTS(year,month,day)) as day_name from flights
),
ct2 as (
select origin,count(*) as week_end_flights from 
cte where day_name in ('saturday','sunday') 
group by
origin 
)
select top 1 * from ct2 join airports ap on ct2.origin=ap.iata_code order by week_end_flights desc;
