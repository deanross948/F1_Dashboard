SELECT 
CONCAT(drivers.forename, ' ', surname) as drivers_name,
constructors.name AS constructors_name,
grid,
position,
points,
races.name AS race_name,
races.year AS season
FROM results
JOIN races
	ON results.raceID = races.raceID
JOIN drivers
	ON results.driverID = drivers.driverId
JOIN constructors
	ON results.constructorID = constructors.constructorID
ORDER BY
	season asc, race_name asc, position asc;
	
WITH race_winners AS (
  SELECT 
    raceId,
    driverId,
    time AS base_time
  FROM results
  WHERE position = 1
),
parsed_results AS (
  SELECT 
    r.*,
    rw.base_time,
    CASE 
      WHEN r.position = 1 THEN r.time
      ELSE SEC_TO_TIME(TIME_TO_SEC(STR_TO_DATE(rw.base_time, '%H:%i:%s.%f')) + r.time)
    END AS final_time
  FROM results r
  JOIN race_winners rw ON r.raceId = rw.raceId
)
SELECT raceId, driverId, position, LEFT(final_time,12) as formatted_time
FROM parsed_results
ORDER BY raceId, position;
