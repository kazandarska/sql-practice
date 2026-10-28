#!/bin/bash 
		# conference 2 
			# creating a list of participants who forgot to provide their country of origin
			# cutting empty fields 
			# checking whether a field contains text or NULL
			# converting '' and NULL to the same [EMPTY] value
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


SELECT name AS name, country AS unknown_country, COUNT(*) AS participants 
FROM conference
WHERE (country IS NULL OR country = '')
AND name !=''
AND name IS NOT NULL
GROUP BY name, unknown_country
ORDER BY name ASC;

SELECT name AS name, TYPEOF(country) AS unknown_country, COUNT(*) AS participants
FROM conference
WHERE (country IS NULL OR country = '')
AND name != ''
AND name IS NOT NULL
GROUP BY name, unknown_country
ORDER BY name ASC;

SELECT name AS name, 
NULLIF(country, '') AS unknown_country, 
COUNT(*) AS participants
FROM conference
WHERE (country IS NULL OR country = '')
AND name IS NOT NULL
AND name != ''
GROUP BY name, unknown_country
ORDER BY name ASC;
EOF


