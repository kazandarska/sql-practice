#!/bin/bash 
		# conference 3
			# counting the total number of participants by a given gender within a country (incl. "EMPTY")
			# counting the total number of participants by a given gender within a country
rm -f conference.db

sqlite3 conference.db << 'EOF'

CREATE TABLE conference (
	name TEXT,
	age INTEGER,
	gender TEXT,
	country TEXT
);

.mode csv
.separator ";"
.import --skip 1 conference.data conference
	
.mode box
.headers on
.nullvalue "[EMPTY]"


SELECT UPPER(country) AS country, LOWER(gender) AS gender, COUNT(*) AS participants
FROM conference
WHERE LOWER(gender) IN ('female', 'male')
GROUP BY UPPER(country), LOWER(gender)
ORDER BY country, gender ASC;

SELECT UPPER(country) AS country, LOWER(gender) AS gender, COUNT(*) AS participants
FROM conference
WHERE LOWER(gender) IN ('female', 'male')
AND country IS NOT NULL
AND country !=''
GROUP BY UPPER(country), LOWER(gender)
ORDER BY country, gender ASC;
EOF



