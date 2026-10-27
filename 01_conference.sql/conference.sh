#!/bin/bash 
		# conference 
			# creating a list of adult participants
			# counting the total number of participants by country
			# calculating the avg.age of male and female participants (inc.minors)
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


SELECT name, country
FROM conference
WHERE age >= 18 
ORDER BY country ASC;

SELECT country, COUNT(*) AS participants
FROM conference
WHERE country IS NOT NULL AND country !=''
GROUP BY country
ORDER BY participants DESC;

SELECT LOWER(gender) AS gender, ROUND(AVG(age), 1) AS average_age
FROM conference
WHERE gender COLLATE NOCASE IN ('female', 'male')
GROUP BY gender COLLATE NOCASE
ORDER BY average_age DESC;
EOF

