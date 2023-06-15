-- ###DATA AGGREGATION, ANALYSIS AND EXPLOITATION###

CREATE TABLE actor (
  actor_id integer NOT NULL,
  first_name character varying(45) NOT NULL,
  last_name character varying(45) NOT NULL,
  last_update timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE address (
  address_id integer NOT NULL,
  address character varying(50) NOT NULL,
  address2 character varying(50),
  district character varying(20) NOT NULL,
  city_id smallint NOT NULL,
  postal_code character varying(10),
  phone character varying(20) NOT NULL,
  last_update timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE city (
  city_id integer NOT NULL,
  city character varying(50) NOT NULL,
  country_id smallint NOT NULL,
  last_update timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE country (
    country_id integer NOT NULL,
    country character varying(50) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE customer (
  customer_id integer NOT NULL,
  store_id smallint NOT NULL,
  first_name character varying(45) NOT NULL,
  last_name character varying(45) NOT NULL,
  email character varying(50),
  address_id smallint NOT NULL,
  activebool boolean DEFAULT true NOT NULL,
  create_date date DEFAULT ('now'::text)::date NOT NULL,
  last_update timestamp without time zone DEFAULT now(),
  active integer
);

CREATE TABLE customer_list (
  id integer NOT NULL,
  name character varying(50) NOT NULL,
  address character varying(50) NOT NULL,
  zip_code character varying(10),
  phone character varying(20) NOT NULL,
  city character varying(50) NOT NULL,
  country character varying(50) NOT NULL,
  notes character varying(50) NOT NULL,
  sid integer NOT NULL
);

CREATE TABLE film (
  film_id integer NOT NULL,
  title character varying(255) NOT NULL,
  description text,
  release_year integer,
  language_id smallint NOT NULL,
  original_language_id smallint,
  rental_duration smallint DEFAULT 3 NOT NULL,
  rental_rate numeric(4,2) DEFAULT 4.99 NOT NULL,
  length smallint,
  replacement_cost numeric(5,2) DEFAULT 19.99 NOT NULL,
  rating TEXT,
  last_update timestamp without time zone DEFAULT now() NOT NULL,
  special_features text[],
  fulltext tsvector NOT NULL
);

SELECT * FROM film

CREATE TABLE film_actor (
  actor_id smallint NOT NULL,
  film_id smallint NOT NULL,
  last_update timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE inventory (
  inventory_id integer NOT NULL,
  film_id smallint NOT NULL,
  store_id smallint NOT NULL,
  last_update timestamp without time zone DEFAULT now() NOT NULL
);

SELECT * FROM film

CREATE TABLE payment (
  payment_id integer NOT NULL,
  customer_id smallint NOT NULL,
  staff_id smallint NOT NULL,
  rental_id integer NOT NULL,
  amount numeric(5,2) NOT NULL,
  payment_date timestamp without time zone NOT NULL
);

SELECT * FROM payment

CREATE TABLE rental (
  rental_id integer NOT NULL,
  rental_date timestamp without time zone NOT NULL,
  inventory_id integer NOT NULL,
  customer_id smallint NOT NULL,
  return_date timestamp without time zone,
  staff_id smallint NOT NULL,
  last_update timestamp without time zone DEFAULT now() NOT NULL
);

CREATE TABLE staff (
  staff_id integer NOT NULL,
  first_name character varying(45) NOT NULL,
  last_name character varying(45) NOT NULL,
  address_id smallint NOT NULL,
  email character varying(50),
  store_id smallint NOT NULL,
  active boolean DEFAULT true NOT NULL,
  username character varying(16) NOT NULL,
  password character varying(40),
  last_update timestamp without time zone DEFAULT now() NOT NULL,
  picture bytea
);

CREATE TABLE store (
    store_id integer NOT NULL,
    manager_staff_id smallint NOT NULL,
    address_id smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);

---##### Gregarious Aggregates: In this activity, you will practice writing queries with aggregate functions, with grouping, and with using aliases.
	---1. What is the average cost to rent a film in the stores?
SELECT AVG(rental_rate) AS "Average rental rate"
FROM film;

---2a. What is the average rental cost of films by rating? 
SELECT rating, AVG(rental_rate) AS "Average rental rate"
FROM film
GROUP BY rating;

---2b. On average, what is the cheapest rating of films to rent? 
SELECT rating, AVG(rental_rate) AS "Average rental rate"
FROM film
GROUP BY rating 
ORDER BY "Average rental rate" ASC;

---2c. What is the most expensive?
SELECT rating, AVG(rental_rate) AS "Average rental rate"
FROM film
GROUP BY rating 
ORDER BY "Average rental rate" DESC;

---3. How much would it cost to replace all films in the database?
SELECT SUM(rental_rate) AS "Total replacement cost"
FROM film;

---4. How much would it cost to replace all films in each ratings category?
SELECT rating, SUM(rental_rate) AS "Total replacement cost by rate"
FROM film
GROUP BY rating;

---5a. How long is the longest movie in the database? 
SELECT MAX(length)
FROM film;

---5b. How long is the shortest movie?
SELECT MIN(length)
FROM film;

-- 7. Select everything from film table
SELECT * FROM film;

-- 8. Count the amount of film_id's in film table
SELECT COUNT(film_id) FROM film;

-- 9. Create an alias
SELECT COUNT(film_id) AS "Total films"
FROM film;

-- 10. Group by rating and aggregate the film_id count
SELECT rating, COUNT(film_id) AS "Total films"
FROM film
GROUP BY rating;

-- 11. Select the average rental duration
SELECT AVG(rental_duration)
FROM film;

-- 12. Create an Alias
SELECT AVG(rental_duration) AS "Average rental period"
FROM film;

-- 13. Group by the rental duration, average the rental rate and give alias
SELECT rental_duration, AVG(rental_rate) AS "Average rental rate"
FROM film
GROUP BY rental_duration;

-- 14. Find the rows with the minimum rental rate
SELECT rental_duration, MIN(rental_rate) AS "Min rental rate"
FROM film
GROUP BY rental_duration;

-- 15. Find the rows with the maximum rental rate
SELECT rental_duration, MAX(rental_rate) AS "Max rental rate"
FROM film
GROUP BY rental_duration;

-- 16. Select average length of films and order by the average length
SELECT film_id, AVG(length)  AS "avg length" FROM film
GROUP BY film_id
ORDER BY "avg length";

-- 17. Round the results to use only two decimal places
SELECT film_id, ROUND(AVG(length), 2)  AS "avg length" FROM film
GROUP BY film_id
ORDER BY "avg length";

-- 18. Order by descending values
SELECT film_id, ROUND(AVG(length), 2)  AS "avg length" FROM film
GROUP BY film_id
ORDER BY "avg length" DESC;

-- 19. Limit results to 5
SELECT film_id, ROUND(AVG(length), 2)  AS "avg length" FROM film
GROUP BY film_id
ORDER BY "avg length" DESC
LIMIT 5;

-- 20. Determine the count of actor first names ordered in descending order.
SELECT first_name, COUNT (first_name)
FROM actor
GROUP BY first_name
ORDER BY first_name DESC;

-- 21. Determine the average rental duration for each rating rounded to two decimals. Order these in ascending order.
SELECT rating, ROUND (AVG (rental_duration),2) AS "Average rental duration"
FROM film
GROUP BY rating
ORDER BY "Average rental duration" ASC;

-- 22. Determine the top 10 average replace costs for movies by their length.
SELECT length, AVG (replacement_cost) AS "Average replacement cost"
FROM film
GROUP BY length
ORDER BY "Average replacement cost" DESC
LIMIT 10;

-- 23. Using the city and country tables, determine the count of countries in descending order.
SELECT * FROM city;
SELECT * FROM country;

SELECT country.country, COUNT (country.country) AS "Country count"
FROM city
INNER JOIN country
ON city.country_id = country.country_id
GROUP BY country.country
ORDER BY "Country count" DESC;

-- 23. List the names and ID numbers of cities that are in the following list: `Qalyub`, `Qinhuangdao`, `Qomsheh`, `Quilmes`.
SELECT city, city_id
FROM city
WHERE city ='Qalyub'
OR city = 'Qinhuangdao'
OR city = 'Qomsheh'
OR city = 'Quilmes';

-- 24. Display the districts in the above list of cities.**Hint:** Use the `address` and `city` tables.

SELECT district, city_id
FROM address
WHERE city_id IN
(SELECT city_id
FROM city
WHERE city ='Qalyub'
OR city = 'Qinhuangdao'
OR city = 'Qomsheh'
OR city = 'Quilmes');

-- 25. Subqueries w where
SELECT customer.first_name, customer.last_name,address_id
FROM customer
WHERE customer.address_id IN (
    SELECT address.address_id
    FROM address
    WHERE address.city_id IN (
        SELECT city.city_id
        FROM city
        WHERE city.city LIKE 'Q%'
    )
);

-- 26. Subqueries with JOIN
SELECT customer.first_name, customer.last_name
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE city.city LIKE 'Q%';

--
SELECT s.store_id, SUM(amount) AS Gross
FROM payment AS p
  JOIN rental AS r
  ON (p.rental_id = r.rental_id)
    JOIN inventory AS i
    ON (i.inventory_id = r.inventory_id)
      JOIN store AS s
      ON (s.store_id = i.store_id)
      GROUP BY s.store_id;


-- Create view from query
CREATE VIEW total_sales AS
SELECT s.store_id, SUM(amount) AS Gross
FROM payment AS p
JOIN rental AS r
ON (p.rental_id = r.rental_id)
  JOIN inventory AS i
  ON (i.inventory_id = r.inventory_id)
    JOIN store AS s
    ON (s.store_id = i.store_id)
    GROUP BY s.store_id;


-- Query the table view created
SELECT *
FROM total_sales;

-- Drop view
DROP VIEW total_sales;

-- Write a query to get the number of copies of a film title that exist in the inventory. 
SELECT title,
	(SELECT COUNT (inventory.film_id)
	 FROM inventory
	 WHERE inventory.film_id = film.film_id) AS "Number of copies"
FROM film;

-- Create a view named `title_count` from the above query.

CREATE VIEW title_count AS
SELECT title,
	(SELECT COUNT (inventory.film_id)
	 FROM inventory
	 WHERE inventory.film_id = film.film_id) AS "Number of copies"
FROM film;

-- Query the newly created view to find all the titles that have 7 copies.

SELECT *
FROM title_count
WHERE "Number of copies" = 7;


-- Using subqueries, identify all actors who appear in the film ALTER VICTORY in the `pagila` database.

SELECT * FROM film
WHERE title ='ALTER VICTORY';

-- Using INNER JOIN
SELECT *
FROM actor a
	INNER JOIN film_actor f
	ON a.actor_id = f.actor_id
	INNER JOIN film 
	ON f.film_id = film.film_id
	WHERE title ='ALTER VICTORY';
	
-- Using SELECT

SELECT * 
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
(
	SELECT film_id
	FROM film
	WHERE title ='ALTER VICTORY'));
	
-- Using subqueries, display the titles of films that the employee Jon Stephens rented to customers.
-- Using Join	
SELECT DISTINCT film.title
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN staff ON rental.staff_id = staff.staff_id
WHERE staff.first_name = 'Jon' AND staff.last_name = 'Stephens';

--Using SELECT
SELECT film.title
FROM film
WHERE film.film_id IN (
  SELECT inventory.film_id
  FROM inventory
  WHERE inventory.inventory_id IN (
    SELECT rental.inventory_id
    FROM rental
    WHERE rental.staff_id = (
      SELECT staff.staff_id
      FROM staff
      WHERE staff.first_name = 'Jon' AND staff.last_name = 'Stephens'
    )
  )
);


