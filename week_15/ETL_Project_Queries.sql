--Query 1
--Top 5 reactions
 select  reaction,count(*) as count
 from report_reaction
 group by reaction
 order by count desc
 limit 5;

/*
-- To get the required result:
1. reactions to reported are available in report_reaction table.
2. get the count of records grouped by reaction
3. sort by count descending
4. limit  to only 5 records
*/


--Query 2
--Top 5 industry
SELECT industry_name, count(*) as count
FROM report_product 
GROUP BY industry_name
ORDER BY count desc
limit 5

/*
-- To get the required result:
1. industries that are reported for an event are available in report_product table.
2. get the count of records grouped by industry_name
3. sort by count descending
4. limit  to only 5 records
*/


--Query 3
--Top 5 outcomes
SELECT outcome,count(*) as count
FROM report_outcome
GROUP BY outcome
ORDER BY count DESC
limit 5

/*
-- To get the required result:
1. Outcomes that are reported for an event are available in report_outcome table.
2. get the count of records grouped by outcome
3. sort by count descending
4. limit  to only 5 records
*/



--Query 4
-- Industry-Reaction count
 select industry_name,reaction ,count(*) as count
 FROM report_product p
 INNER JOIN report_reaction r
 ON p.report_number =  r.report_number
 GROUP BY industry_name,reaction
ORDER BY count DESC,industry_name DESC,reaction DESC

/*
-- To get the required result:
1. Industry name are available in report_product table.
2.reactions for an event are available in report_reaction table
3.Join report_product table and report_reaction table on report_number
4. get the industry name, reaction and count  grouped by industry_name and reaction
5. sort by count descending, industry_name descending, reaction descending order
*/

--Query 5
-- Ovarian reaction age wise count
select 
	CASE WHEN consumer_age_unit = 'Decade(s)' THEN consumer_age * 10
	WHEN consumer_age_unit='month(s)' THEN consumer_age/12
     	WHEN consumer_age_unit='week(s)' THEN consumer_age/52
    	WHEN consumer_age_unit='day(s)' THEN consumer_age/365
    	ELSE consumer_age
	END age_years , count(*) as count
FROM event_report r
JOIN report_reaction p
ON r.report_number =  p.report_number
WHERE reaction LIKE '%Ovarian Cancer%'
and consumer_age is not null
GROUP BY age_years
order by age_years desc

/*
-- To get the required result:
1. consumer age , consumer age unit  are available in event_report table.
2. reactions are available in report_reaction table. 
3. join on above table on report_number 
4. ages are reported in Decades, Months, Weeks, Years and Days. Get all ages in years
5. consider records where age is reported and not null
6. take only reports where reaction is Ovarian Cancer
7. group by age in years 
8. sort by age in years in descending order
*/




--Query 6
-- Get minimum, average and maximum year for ovarian reaction
-- Min year 4 is acutally reported in months as 57, hence converted to years it is 4.
-- I wonder if it was reported as Months by mistake instead of reporting as years
SELECT ROUND(AVG(age_in_years)) as average_year,MIN(age_in_years) as min_year,MAX(age_in_years) as max_year 
FROM (
SELECT 
CASE WHEN consumer_age_unit='Decade(s)' THEN consumer_age*10
     WHEN consumer_age_unit='month(s)' THEN consumer_age/12
     WHEN consumer_age_unit='week(s)' THEN consumer_age/52
     WHEN consumer_age_unit='day(s)' THEN consumer_age/365
     ELSE consumer_age
     END age_in_years
FROM event_report t1
JOIN report_reaction t2
ON t1.report_number =  t2.report_number
WHERE reaction LIKE '%Ovarian Cancer%'
and consumer_age is not null
) as event_ages

/*
-- To get the required result:
1. Get minimum, average and maximum age from age in years column from the result of below subquery
These steps are for subquery
1. consumer age , consumer age unit  are available in event_report table.
2. reactions are available in report_reaction table. 
3. join on above table on report_number 
4. ages are reported in Decades, Months, Weeks, Years and Days. Get all ages in years
5. consider records where age is reported and not null
6. take only reports where reaction is Ovarian Cancer
7. group by age in years 
8. sort by age in years in descending order
*/


--Query 7
--Anaphylactic reaction industry count
SELECT industry_name, count(*) as count
FROM report_reaction r
JOIN report_product p
ON r.report_number = p.report_number
WHERE reaction  LIKE 'Anaphylactic%'
GROUP BY industry_name
ORDER BY count desc
/*
-- To get the required result:
1. industry name is available in report_product table.
2. reactions are available in report_reaction table.
3. join on above table on report_number 
3. take only reports where reaction that starts with 'Anaphylactic'
4. get the count of records for matching condition
6. group by industry name 
7. sort by count in descending order
*/


--Query 8
--outcome count for Anaphylactic reaction
SELECT outcome,count(*) as count
FROM report_reaction r
JOIN report_outcome o
ON r.report_number = o.report_number
WHERE reaction LIKE 'Anaphylactic%'
GROUP BY outcome
ORDER BY count desc

/*
-- To get the required result:
1. outcome is available in report_outcome table.
2. reactions are available in report_reaction table.
3. join on above table on report_number 
3. take only reports where reaction that starts with 'Anaphylactic'
4. get the count of records for matching condition
6. group by outcome
7. sort by count in descending order
*/



--Query 9
-- Reports between Jan 1,2019 and Jan 1,2020 report with reaction that starts with 'Chest'
-- name brand, role and industry involved
SELECT 
e.report_number, name_brand,role,industry_name
FROM event_report e
JOIN report_reaction r
ON e.report_number = r.report_number
JOIN report_product p
ON e.report_number = p.report_number
WHERE date_created BETWEEN '2019-01-01' AND '2020-01-01'
AND reaction LIKE 'Chest%'
ORDER BY industry_name


/*
-- To get the required result:
1. report number, date created for event are available in event_report table.
2. reactions are available in report_reaction table
3. name brand, role and industry name are available in report_product table
4. join these tables on report_number
4. consider records for date created is between date Jan 1,2019 and Jan 1,2020 and reaction that starts with 'Chest'
5. sort by industry_name 
*/

--Query 10
--Count of Reports Filed by Gender for events reported
SELECT consumer_gender,count(*) as count
FROM event_report
WHERE consumer_gender is NOT NULL
GROUP BY consumer_gender

/*
-- To get the required result:
1. consumer gender is available in event_report table.
3. consider records where consumer gender is not null
4. group by consumer gender 
5. sort by consumer gender in descending order
*/



--Query 11
-- Year wise count
SELECT EXTRACT(year FROM date_created) AS year,count(*) AS count
FROM event_report
GROUP BY year
ORDER BY year desc

/*
-- To get the required result:
1. date created is available in event_report table.
3. get only year part of the date and count 
4. group by year 
5. sort by year in descending order
*/



