--1.Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time. 
    SELECT r.rental_id,f.title, CASE
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) > 0
           THEN 'Late'
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) < 0
           THEN 'Early'
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) = 0 
	   THEN 'On Time'
        END status
    FROM rental AS r
      INNER JOIN inventory i 
        USING (inventory_id) 
      INNER JOIN film f 
        USING (film_id)
    WHERE return_date is NOT NULL



--2.Show the total payment amounts for people who live in Kansas City or Saint Louis. 
SELECT sum(amount)
FROM payment p
 INNER JOIN customer c1
  ON p.customer_id = c1.customer_id 
 INNER JOIN address a
  ON c1.address_id = a.address_id
 INNER JOIN city c2
  ON a.city_id = c2.city_id 
WHERE c2.city in ('Kansas City','Saint Louis')



--3.How many film categories are in each category? Why do you think there is a table for category and a table for film category?
SELECT c1.name, count(*)
FROM film f1
 INNER JOIN film_category f2
  ON f1.film_id = f2.film_id
 INNER JOIN category c1
  ON f2.category_id = c1.category_id
GROUP BY c1.name
ORDER BY c1.name

/*
Category table lists the id and name for the categories irrespective of the film. These are the categories the films are made in
To identify the film catgeory we need to associate the film to its category. 1 Film is in one category so film table as category_id from the category table
*/


--4.Show a roster for the staff that includes their email, address, city, and country (not ids)
SELECT first_name,email, address , city, country
FROM staff s
 INNER JOIN address a
  ON s.address_id = a.address_id
 INNER JOIN city c1
  ON a.city_id = c1.city_id
 INNER JOIN country c2
  ON c1.country_id = c2.country_id



--5.Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005
SELECT film_id, title, length
FROM film
where film_id in 
( select i.film_id from rental r
 INNER JOIN  inventory i
  ON r.inventory_id = i.inventory_id
  WHERE r.return_date BETWEEN '2005-05-15' AND '2005-05-31')


--6.Write a subquery to show which movies are rented below the average price for all movies. 
SELECT distinct title,rental_rate
from FILM f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE rental_rate < (SELECT avg(rental_rate) FROM film)


--7.Write a join statement to show which moves are rented below the average price for all movies.

SELECT  distinct title,rental_rate
from FILM f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN  (SELECT avg(rental_rate) avg_price FROM film) as f2
ON rental_rate < f2.avg_price


--8.Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.
EXPLAIN ANALYZE SELECT distinct title,rental_rate
from FILM f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE rental_rate < (SELECT avg(rental_rate) FROM film)

/*
"HashAggregate  (cost=689.85..693.18 rows=333 width=21) (actual time=6.542..6.571 rows=326 loops=1)"
"  Group Key: f.title, f.rental_rate"
"  Batches: 1  Memory Usage: 61kB"
"  InitPlan 1 (returns $0)"
"    ->  Aggregate  (cost=66.50..66.51 rows=1 width=32) (actual time=0.253..0.254 rows=1 loops=1)"
"          ->  Seq Scan on film  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.002..0.086 rows=1000 loops=1)"
"  ->  Hash Join  (cost=172.62..596.63 rows=5341 width=21) (actual time=1.413..4.633 rows=5652 loops=1)"
"        Hash Cond: (r.inventory_id = i.inventory_id)"
"        ->  Seq Scan on rental r  (cost=0.00..310.44 rows=16044 width=4) (actual time=0.008..1.005 rows=16044 loops=1)"
"        ->  Hash  (cost=153.55..153.55 rows=1525 width=25) (actual time=1.396..1.398 rows=1595 loops=1)"
"              Buckets: 2048  Batches: 1  Memory Usage: 107kB"
"              ->  Hash Join  (cost=70.66..153.55 rows=1525 width=25) (actual time=0.521..1.160 rows=1595 loops=1)"
"                    Hash Cond: (i.film_id = f.film_id)"
"                    ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.004..0.204 rows=4581 loops=1)"
"                    ->  Hash  (cost=66.50..66.50 rows=333 width=25) (actual time=0.510..0.510 rows=341 loops=1)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 28kB"
"                          ->  Seq Scan on film f  (cost=0.00..66.50 rows=333 width=25) (actual time=0.261..0.460 rows=341 loops=1)"
"                                Filter: (rental_rate < $0)"
"                                Rows Removed by Filter: 659"
"Planning Time: 0.413 ms"
"Execution Time: 6.654 ms"
*/

EXPLAIN ANALYZE SELECT  distinct title,rental_rate
from FILM f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN  (SELECT avg(rental_rate) avg_price FROM film) as f2
ON rental_rate < f2.avg_price

/*
Execution time : 6.654 ms vs 7.452 ms i.e in this case, subquery results were little faster than the query with join
Planning time :  0.413 ms vs   0.469 ms i.e planning times are almost the same in both the queries.


"HashAggregate  (cost=720.34..730.34 rows=1000 width=21) (actual time=7.269..7.312 rows=326 loops=1)"
"  Group Key: f.title, f.rental_rate"
"  Batches: 1  Memory Usage: 97kB"
"  ->  Hash Join  (cost=269.51..693.60 rows=5348 width=21) (actual time=1.625..5.221 rows=5652 loops=1)"
"        Hash Cond: (r.inventory_id = i.inventory_id)"
"        ->  Seq Scan on rental r  (cost=0.00..310.44 rows=16044 width=4) (actual time=0.013..0.925 rows=16044 loops=1)"
"        ->  Hash  (cost=250.42..250.42 rows=1527 width=25) (actual time=1.603..1.607 rows=1595 loops=1)"
"              Buckets: 2048  Batches: 1  Memory Usage: 107kB"
"              ->  Hash Join  (cost=147.19..250.42 rows=1527 width=25) (actual time=0.541..1.295 rows=1595 loops=1)"
"                    Hash Cond: (i.film_id = f.film_id)"
"                    ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.005..0.202 rows=4581 loops=1)"
"                    ->  Hash  (cost=143.02..143.02 rows=333 width=25) (actual time=0.527..0.529 rows=341 loops=1)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 28kB"
"                          ->  Nested Loop  (cost=66.50..143.02 rows=333 width=25) (actual time=0.275..0.481 rows=341 loops=1)"
"                                Join Filter: (f.rental_rate < (avg(film.rental_rate)))"
"                                Rows Removed by Join Filter: 659"
"                                ->  Aggregate  (cost=66.50..66.51 rows=1 width=32) (actual time=0.268..0.268 rows=1 loops=1)"
"                                      ->  Seq Scan on film  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.005..0.124 rows=1000 loops=1)"
"                                ->  Seq Scan on film f  (cost=0.00..64.00 rows=1000 width=25) (actual time=0.005..0.072 rows=1000 loops=1)"
"Planning Time: 0.469 ms"
"Execution Time: 7.452 ms"
*/


--9.With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. 
--This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank 
select title,length,
(PERCENT_RANK() OVER (ORDER BY length))::DEC(8,2) -- to determine the relative standing of a value within a set or rows
FROM film



--10.In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are. 
/*
Procedural approach - to tell the system "what to do" along with "how to do" it. We query the database to obtain a result set and we write the data operational and manipulation logic using loops, conditions,and processing statements to produce the final result. 

Set based approach - is an approach which lets you specify "what to do", but doesn't specify "how to do". That is, you just specify your requirement for a processed result that has to be obtained from a "set of data" (be it a simple table/view, or joins of tables/views,  complex joins/subqueries/conditional case statements), filtered by optional condition(s). There is a set of data from which the resultant set has to be obtained.The database engine determines the best possible algorithms or processing logic to do these.

Python is Object Oriented Programming languages which supports procedural programming (i.e produce results using a sequence of operations or procedures)
SQL - SQL is set based.
*/


--Bonus: Find the relationship that is wrong in the data model. Explain why its wrong. 
/*
- Address to store relationship needs to be 1 to 1. There can be only one unique address for a particular store.
- There is no relationship shown between customer and store. One customer can be going to multiple stores.
*/


