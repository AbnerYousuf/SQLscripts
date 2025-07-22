SELECT *
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;

ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;
#this thing was named bad when i imported it so i renamed

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;
#identify if there are duplicates (there are)

SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS indices
FROM us_household_income;
#subquery for below so we can assign indexes to the duplicate rows

SELECT *
FROM (
	SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS indices
	FROM us_household_income
    ) AS duplicates_table
WHERE indices > 1
;
#finds all the duplicate ids

DELETE FROM us_household_income
WHERE row_id IN(
	SELECT row_id
	FROM (
		SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS indices
		FROM us_household_income
		) AS duplicates_table
	WHERE indices > 1
);
#delete all the duplicates using the two previous subqueries

SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;
#check for duplicates. at the time of writing, there arent any dupes

SELECT state_name, COUNT(state_name)
FROM us_household_income
GROUP BY state_name
;
#found a typo of georgia. unless georia became a state. let's fix that

UPDATE us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia';
#ok yay we fixed that! keeping for posterity though

SELECT *
FROM us_household_income
WHERE place = '' OR place = NULL;
#only one row where place is missing and it's an easy fix.
#there's only one row where the place isn't autaugaville

UPDATE us_household_income
SET place = 'Autaugaville'
WHERE place = '' AND county = 'Autauga County';
#fixed that!

SELECT type, COUNT(type)
FROM us_household_income
GROUP BY type;
#gotta fix boroughs to borough

UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';
#did that!