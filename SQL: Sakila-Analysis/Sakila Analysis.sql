use Sakila;
SHOW TABLES;

# 1a. Display the first and last names of all actors from the table `actor`.

SELECT first_name, last_name FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(first_name, ' ', last_name) as "ACTOR NAME" from Actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name from actor WHERE first_name ='joe';

# 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name FROM actor WHERE last_name like "%GEN%"; 

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name , first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id FROM country WHERE country IN ("Afghanistan" , "Bangladesh" , "China");

# 3a You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD COLUMN description BLOB; 

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;
SHOW COLUMNS in actor;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT >=2; 

# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'Williams'; 

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
# SHOW TABLES;
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'Williams';
        
        SELECT * FROM actor WHERE first_name ='HARPO';

# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
#SELECT * FROM staff;
#SELECT staff.first_name, staff.last_name, staff.address FROM staff; JOIN address on staff.address_id

SELECT 
    first_name, last_name, address
FROM
    staff
        JOIN
    address ON address_id = address_id;
    # SHOW TABLES;

# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT * FROM payment; 
SELECT staff.first_name, staff.last_name, SUM(payment.amount), payment_date
FROM staff INNER JOIN payment ON staff.staff_id=payment.staff_id AND payment_date LIKE '%2005-08%';

SELECT 
    film.title, COUNT(film_actor.actor_id) 'Number of Actors'
FROM
    film
        INNER JOIN
    film_actor ON film_actor.film_id = film.film_id
GROUP BY film.title;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id) AS 'Number of Copies' FROM film WHERE title ="Hunchback Impossible";

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) 'Total Amount Paid'
FROM
    sakila.customer
        JOIN
    sakila.payment ON customer.customer_id = payment.customer_id
GROUP BY customer.last_name
ORDER BY customer.last_name ASC; 

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT 
    title
FROM
    film
WHERE
    tile LIKE '%K%'
        OR title LIKE '%Q%'
        AND language_id = 'English';

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip')); 

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT 
    customer.first_name, customer.last_name, customer_email
FROM
    customer c
        JOIN
    address a ON customer.address_id = a.address_id
        JOIN
    city c ON city_id = c.city_id
        JOIN
    country c ON c.country_id = c.country_id
WHERE
    c.country = 'Canada';

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT 
    title
FROM
    film
        JOIN
    film_category ON film_category.film_id = film.film_id
        JOIN
    category ON film_category.category_id = category.category_id
WHERE
    category.name = 'Family';

# 7e. Display the most frequently rented movies in descending order.
SELECT 
    film.title, COUNT(rental.inventory_id) 'Rent Frequency'
FROM
    film
        JOIN
    Inventory ON inventory.film_id = film.film_id
        JOIN
    rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.inventory_id) DESC;


# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, city.city,country.country
FROM store INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city c ON c.city_id = a.city_id
INNER JOIN country c1 ON c.country_id = c1.country_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city,country.country
FROM store INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city c ON c.city_id = a.city_id
INNER JOIN country c1 ON c.country_id = c1.country_id;


# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
    category.name, SUM(payment.amount) 'Gross Revenue'
FROM
    payment
	INNER JOIN
    film ON inventory.film_id = film.film_id
	INNER JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
	INNER JOIN
    rental ON payment.rental_id = rental.rental_id
	INNER JOIN
    film_category ON film.film_id = film_category.film_id
	INNER JOIN
    category ON film_category.category_id = category.category_id
GROUP BY Genre
ORDER BY 'Gross Revenue' DESC
LIMIT 5; 

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Five_Genres AS
SELECT 
    category.name, SUM(payment.amount) 'Gross Revenue'
FROM
    payment
	INNER JOIN
    film ON inventory.film_id = film.film_id
	INNER JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
	INNER JOIN
    rental ON payment.rental_id = rental.rental_id
	INNER JOIN
    film_category ON film.film_id = film_category.film_id
	INNER JOIN
    category ON film_category.category_id = category.category_id
GROUP BY Genre
ORDER BY 'Gross Revenue' DESC
LIMIT 5; 

# 8b. How would you display the view that you created in 8a?
SELECT * FROM Top_Five_Genres; 

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW Top_Five_Genres;