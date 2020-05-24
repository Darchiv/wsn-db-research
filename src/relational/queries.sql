-- Retrieve N last measurements (by date) done in cluster id X

SELECT m.id, m."time" AS "date", n.friendly_name AS "node_name", st.name AS "sensor_name", st.unit AS "unit",
(get_byte(m.value, 3) + get_byte(m.value, 2) + get_byte(m.value, 1) + get_byte(m.value, 0)) AS "value"
	FROM measurement AS m
	INNER JOIN sensor AS s ON m.sensor = s.id
	INNER JOIN node AS n ON s.node = n.id
	INNER JOIN cluster as c ON n.cluster = c.id
	INNER JOIN sensor_type as st ON s.sensor_type = st.id
WHERE c.id = X
ORDER BY m."time" DESC
LIMIT N;

-- Retrieve N last measurements (by date) of type name T done in cluster id X

SELECT m.id, m."time" AS "date", n.friendly_name AS "node_name", st.name AS "sensor_name", st.unit AS "unit",
(get_byte(m.value, 3) + get_byte(m.value, 2) + get_byte(m.value, 1) + get_byte(m.value, 0)) AS "value"
    FROM measurement AS m
    INNER JOIN sensor AS s ON m.sensor = s.id
    INNER JOIN node AS n ON s.node = n.id
    INNER JOIN cluster as c ON n.cluster = c.id
    INNER JOIN sensor_type as st ON s.sensor_type = st.id
WHERE c.id = X AND st.name = T
ORDER BY m."time" DESC
LIMIT N;

-- Retrieve measurements done in cluster id X between START_DATE and END_DATE

SELECT m.id, c.id AS "cluster", m."time" AS "date", n.friendly_name AS "node_name", st.name AS "sensor_name", st.unit AS "unit",
(get_byte(m.value, 3) + get_byte(m.value, 2) + get_byte(m.value, 1) + get_byte(m.value, 0)) AS "value"
	FROM measurement AS m
	INNER JOIN sensor AS s ON m.sensor = s.id
	INNER JOIN node AS n ON s.node = n.id
	INNER JOIN cluster as c ON n.cluster = c.id
	INNER JOIN sensor_type as st ON s.sensor_type = st.id
WHERE c.id = 1 AND m."time" >= START_DATE AND m."time" <= END_DATE
ORDER BY m."time" DESC;

-- Retrieve measurements of type name T done in cluster id X between START_DATE and END_DATE

SELECT m.id, c.id AS "cluster", m."time" AS "date", n.friendly_name AS "node_name", st.name AS "sensor_name", st.unit AS "unit",
(get_byte(m.value, 3) + get_byte(m.value, 2) + get_byte(m.value, 1) + get_byte(m.value, 0)) AS "value"
    FROM measurement AS m
    INNER JOIN sensor AS s ON m.sensor = s.id
    INNER JOIN node AS n ON s.node = n.id
    INNER JOIN cluster as c ON n.cluster = c.id
    INNER JOIN sensor_type as st ON s.sensor_type = st.id
WHERE c.id = X AND m."time" >= START_DATE AND m."time" <= END_DATE AND st.name = T
ORDER BY m."time" DESC;

-- Retrieve all nodes in cluster X

SELECT n.id, n.friendly_name FROM node AS n
WHERE n.cluster = X;

-- Retrieve all clusters

SELECT c.id, c.gateway_ip FROM cluster AS c;

-- Retrieve available sensor types (names, units) in cluster X and their cumulative counts

SELECT st.name AS "sens_type", st.unit, COUNT(*) AS count
    FROM sensor AS s
    INNER JOIN node AS n ON s.node = n.id
    INNER JOIN sensor_type as st ON s.sensor_type = st.id
WHERE n.cluster = X
GROUP BY st.name, st.unit
ORDER BY sens_type;
