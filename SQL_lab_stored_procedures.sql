/*Lab | Stored procedures
In this lab, we will continue working on the Sakila database of movie rentals.

1) In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
Convert the query into a simple stored procedure. 

2) Now keep working on the previous stored procedure to make it more dynamic.
 Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers,
 that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

3) Write a query to check the number of movies released in each movie category. 
Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
Pass that number as an argument in the stored procedure.*/

use sakila_copy_lab;

-- 1) In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure.

DELIMITER $$
create procedure client_info_spec_cat()
Begin
select first_name, last_name, email 
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;
END 
$$ 
delimiter ;

call client_info_spec_cat();

-- 2) Now keep working on the previous stored procedure to make it more dynamic.
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers,
-- that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

DELIMITER $$
create procedure client_info(in param1 varchar(10))
Begin
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name COLLATE utf8mb4_general_ci = param1
group by first_name, last_name, email;
END
$$
delimiter ;

call client_info("Comedy");

-- 3) Write a query to check the number of movies released in each movie category. 
-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.*/
select category.name, count(film_id) as num_released
from category
join film_category on category.category_id = film_category.category_id
group by category.name
having num_released > 60;     -- an example of the query

DELIMITER $$
create procedure film_counter_by_categories(in num tinyint)
Begin
select category.name, count(film_id) as num_released
from category
join film_category on category.category_id = film_category.category_id
group by category.name
having num_released > num;
END 
$$
delimiter ;

call film_counter_by_categories(60)