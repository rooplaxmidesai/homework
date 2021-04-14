--1. Show all customers whose last names start with T. Order them by first name from A-Z
    SELECT * FROM customer WHERE last_name LIKE 'T%' ORDER BY first_name;

/*
-- To get the required result:
1. Customer data is available in customer table.
2. customer table has column anem last_name
3. Get all the customers from customer table where last_name starts with letter T
4. sort them by first name
*/



--2.Show all rentals returned from 5/28/2005 to 6/1/2005
    SELECT * FROM rental WHERE return_date BETWEEN '2005-05-28' AND '2005-06-01';

/*
-- To get the required result:
1. rental data is available in rental table
2. rental table has return_date, use this column to filter the records in the given date range , both dates inclusive
*/



--3. How would you determine which movies are rented the most
    SELECT f.title, COUNT(*) AS rent_count FROM rental AS r
      INNER JOIN inventory i 
        USING (inventory_id) 
      INNER JOIN film f 
        USING (film_id)
      GROUP BY f.title
      ORDER BY rent_count DESC
      LIMIT 5

/*
-- To get the required result:
1. Rental table has the inventory_id from inventory table 
2. inventory table has film_id. 
3. Join rental table with inventory table on inventory_id to get the inventory details.
4. Join inventory table with film table on film_id to get the film title.
5. group by film title to get the aggregate count
6. sort by rent count in descending order to get which movies are rented most.
*/



--4. Show how much each customer spent on movies (for all time) . Order them from least to most.
     SELECT c.first_name , sum(amount) FROM payment p
       INNER JOIN customer c
         USING(customer_id)
       GROUP BY c.first_name

-- Please see question 6 answer to read explain plan for this query.

--5. Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias the actor name and count as a more descriptive name. Order the results from most to least.
     select a.first_name as Actor_Name, count(a.first_name) as Film_Count from film f
       INNER JOIN film_actor fa
         USING(film_id)
       INNER JOIN actor a
         USING(actor_id)
       WHERE f.release_year = 2006
       GROUP BY a.first_name
       ORDER BY film_count desc
       LIMIT 1
-- Please see question 6 answer to read explain plan for this query.



--6. Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. Use the following link to understand how this works 
   --4 The generic form of Explain
        EXPLAIN select c.first_name , sum(amount) from payment p
            INNER JOIN customer c
              USING(customer_id)
             GROUP BY c.first_name

/*
-- To get the required result:
1. customer payments data is available in payment table 
2. customer data in customer table. 
3. Join payment and customer table on customer_id to get customer name. 
4. to get the amount spent we use, SUM function and GROUP BY customer first name
--Explain plan shows the join and group condition

*/

    --5 Analyze form of Explain
       EXPLAIN ANALYZE select a.first_name as Actor_Name, count(a.first_name) as Film_Count 
        FROM film f
        INNER JOIN film_actor fa
          USING(film_id)
        INNER JOIN actor a
          USING(actor_id)
        WHERE f.release_year = 2006
        GROUP BY a.first_name
        ORDER BY film_count desc
        LIMIT 1

/*
-- To get the required result:
1. we have film details in film table 
2. actor details in actor table, alias actor first name as Actor_Name
3. which actor acted in which film details in film_actor table. 
4. Join the film and film_actor table in film_id
5. Join film_actor table actor able on actor_id
6. filter clause WHERE =  film release year = 2006
7. GROUP BY actor first name and SORT it in descending order.LIMIT record result to 1 , to get the most count
--EXPLAIN ANALYZE above get the estimated time of execution and actual time taken to execute the query.
*/



--7. What is the average rental rate per genre?
    SELECT c.name as genre , ROUND(avg(rental_rate),2)
     FROM film_category fc 
      INNER JOIN film f
        USING(film_id)
      INNER JOIN category c
        USING(category_id)
      GROUP BY genre

/*
1. Genre/category of the films is available in film_category table
2. rental rate for the film is available in film table.
3. category name is available in category table
4. join film_category table with film on film id
5. join film_category and category table in category_id
6. group by category/genre to get the average of rental rate
*/



--8. How many films were returned late? Early? On time?
     SELECT CASE
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) > 0
           THEN 'Late'
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) < 0
           THEN 'Early'
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) = 0 
	   THEN 'On Time'
        END return_status,count(*)
    FROM rental AS r
      INNER JOIN inventory i 
        USING (inventory_id) 
      INNER JOIN film f 
        USING (film_id)
    WHERE return_date is NOT NULL
    GROUP BY return_status

/*
1. rental data is available in rental table.
2. film data is available in film table
3. inventory data is available in inventory table.
4. join rental table and inventory table on inventory_id to get film_id, rental_date
5. join inventory table and film table on film_id to get film rental duration
6. use the CASE statement to find out late, early or on time field - alias this field as return_status
7. group by return_status to get the count
*/



--9. What categories are the most rented and what are their total sales?
     SELECT category_id,sum(amount) sales
     FROM rental r
      INNER JOIN payment p
       ON r.rental_id = p.rental_id
      INNER JOIN inventory i
       ON r.inventory_id = i.inventory_id
      INNER JOIN film_category fc
       ON i.film_id = fc.film_id
     GROUP BY category_id
     ORDER BY sales desc
     LIMIT 1

/*
1. film category data is available in film_category 
2. rental data is available in rental 
3. payment data is available in payment 
4. inventory data is available in inventory 
5. join rental table and payment table on rental _id to get the amount
6. join rental table and inventory table on inventory_id to get film_id
7. join inventory table and film_category table on film_id to get the category_id for that film
8. group by category_id to get the sum of amount field 
9. sort by sales  -  This field is aliased as sales in SELECT 
*/



--10 Create a view for 8 and a view for 9. Be sure to name them appropriately. 
--Create view for query no. 8

    CREATE VIEW returnstatus_view AS
      SELECT CASE
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) > 0
          THEN 'Late'
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) < 0
          THEN 'Early'
        WHEN (f.rental_duration - (return_date::DATE - rental_date::DATE)) = 0 
	  THEN 'On Time'
        END return_status,count(*)
     FROM rental AS r
      INNER JOIN inventory i 
       USING (inventory_id) 
      INNER JOIN film f 
       USING (film_id)
     WHERE return_date is NOT NULL
     group by return_status


--Create view for query no. 9
    CREATE VIEW category_rentsales_view AS
      select category_id,sum(amount) sales
      from rental r
       INNER JOIN payment p
         ON r.rental_id = p.rental_id
       INNER JOIN inventory i
	 ON r.inventory_id = i.inventory_id
       INNER JOIN film_category fc
	 ON i.film_id = fc.film_id
      group by category_id
      order by sales desc
      limit 1


-- Bonus: Write a query that shows how many films were rented each month. Group them by category and month. 
	SELECT category_id,TO_CHAR(rental_date, 'Month')  AS rental_month, count(*) 
	FROM rental r
	 INNER JOIN inventory i
	  USING(inventory_id)
	 INNER JOIN film_category
	  USING(film_id)
	GROUP BY category_id, rental_month
	ORDER BY rental_month
/*
1. rental data is available in rental table. select rental_date in Month format alias as rental_month
2. inventory data is available in inventory table.
3. film category data is available in film_category table
4. join rental table and inventory table on inventory_id to get film_id records
5. join inventory table and film_category table on film_id to get film category
6. group by category_id and rental_month
7. order by rental_month
*/

