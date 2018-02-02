USE sakila;
# Problem 1a:
SELECT first_name, last_name
FROM actor;
# Problem 1b
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS 'Actor Name'
FROM actor;
# Problem 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';
# Problem 2b
SELECT * FROM actor
WHERE last_name like '%GEN%';
# Problem 2c
SELECT * FROM actor
WHERE last_name LIKE '%GEN%'
ORDER BY last_name, first_name;
# Problem 2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');
# Problem 3a
ALTER TABLE `actor` 
ADD COLUMN `middle_name` VARCHAR(45) NULL AFTER `first_name`;
# Problem 3b
ALTER TABLE actor
MODIFY middle_name BLOB;
# Problem 3c
ALTER TABLE actor DROP COLUMN middle_name;
# Problem 4a
SELECT last_name, COUNT(last_name) AS name_count
FROM actor
GROUP BY last_name;
# Problem 4b
SELECT last_name, COUNT(last_name) AS name_count
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>1;
# Problem 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE last_name = 'Williams' AND first_name = 'Groucho';
# Problem 4d
# This activity dropped per Dylan's slack posting; problem statement ambiguous.
#
# Problem 5a
SHOW CREATE TABLE address;
# Problem 6a
SELECT first_name, last_name, address
FROM staff s
JOIN address a
WHERE s.address_id=a.address_id;
# Problem 6b
SELECT CONCAT('$', FORMAT(SUM(amount),2))
FROM payment p
JOIN staff s
WHERE p.staff_id=s.staff_id AND p.payment_date LIKE '2005-08%'
GROUP BY p.staff_id;
# Problem 6c
SELECT title, COUNT(actor_id)
FROM film_actor a
JOIN film f ON a.film_id=f.film_id
GROUP BY f.film_id;
# Problem 6d
SELECT COUNT(DISTINCT inventory_id)
FROM inventory
WHERE film_id IN
(SELECT film_id
  FROM film
  WHERE title='Hunchback Impossible'
);
# Problem 6e
SELECT first_name, last_name, CONCAT('$', FORMAT(SUM(amount),2))
FROM customer c
JOIN payment p
WHERE c.customer_id=p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;
# Problem 7a
SELECT title
FROM film
WHERE language_id=1 AND (title LIKE 'K%' OR title LIKE 'Q%');
# Problem 7b
SELECT first_name, last_name
FROM actor WHERE actor_id IN
(SELECT actor_id FROM film_actor 
 WHERE film_id IN
 (SELECT film_id FROM film WHERE title='Alone Trip')
);
# Problem 7c
SELECT first_name, last_name, email FROM customer
JOIN (address cross join city cross join country)
ON (customer.address_id=address.address_id AND address.city_id=city.city_id AND city.country_id=country.country_id)
WHERE country.country='Canada';
# Problem 7d
SELECT film_id, title
FROM film
WHERE rating in ('G','PG','PG-13');
# Problem 7e
SELECT COUNT(*) AS 'Rental Count', film.title
FROM payment JOIN (rental CROSS JOIN inventory CROSS JOIN film)
ON (payment.rental_id=rental.rental_id AND rental.inventory_id=inventory.inventory_id AND inventory.film_id=film.film_id)
GROUP BY film.title
ORDER BY(COUNT(*)) DESC;
# Problem 7f
SELECT inventory.store_id, CONCAT('$', FORMAT(SUM(payment.amount),2))
FROM payment JOIN (rental CROSS JOIN inventory)
ON (payment.rental_id=rental.rental_id AND rental.inventory_id=inventory.inventory_id)
GROUP BY inventory.store_id;
# Problem 7g
SELECT store_id, city, country
FROM store JOIN (address CROSS JOIN city CROSS JOIN country)
ON (store.address_id=address.address_id AND address.city_id=city.city_id AND city.country_id=country.country_id);
# Problem 7h
SELECT category.name, CONCAT('$', FORMAT(SUM(payment.amount),2))
FROM category JOIN (film_category CROSS JOIN inventory CROSS JOIN rental CROSS JOIN payment)
ON (category.category_id=film_category.category_id AND film_category.film_id=inventory.film_id
    AND inventory.inventory_id=rental.inventory_id AND rental.rental_id=payment.rental_id)
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 0,5;
# Problem 8a
CREATE VIEW top5_genres AS
  SELECT category.name, CONCAT('$', FORMAT(SUM(payment.amount),2))
  FROM category JOIN (film_category CROSS JOIN inventory CROSS JOIN rental CROSS JOIN payment)
  ON (category.category_id=film_category.category_id AND film_category.film_id=inventory.film_id
      AND inventory.inventory_id=rental.inventory_id AND rental.rental_id=payment.rental_id)
  GROUP BY category.name
  ORDER BY SUM(payment.amount) DESC
  LIMIT 0,5;
#Problem 8b
SELECT * FROM top5_genres;
# Problem 8c
DROP VIEW IF EXISTS top5_genres;
