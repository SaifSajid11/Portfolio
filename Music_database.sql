/* Q1 : Select all from artist table */

select * from artist;

/* Q2 : who is the senior most employee on job title ? */

select * from employee
order by levels desc
limit 1;

/* Q3 : Which country has the most Invoice ? */

select * from invoice;

select count(*)as A, billing_country
from invoice
group by billing_country
order by A desc;

/* Q4 : Find the Top 3 values of Invoice ? */

Select * from invoice;

Select total from invoice
order by total desc
limit 3;

/* Q5 : Which city has the best Customers ? Write a query that returns the  
city that has the highest sum of invoice total.*/

select * from Invoice;

select sum(total) as Invoice_total, Billing_city
from invoice
group by Billing_city
order by Invoice_total desc;

/* Q6 : Who is the best customer ? Write a query to find the customer 
who has spent the most money.*/

select * from customer;

select 
	c.customer_id,
	c.first_name,
	c.last_name,
	Sum(i.total) as Total
from 
	customer as c
Join 
	invoice as i
on
	c.customer_id = i.customer_id
Group by 
	c.customer_id
order by 
	total desc
Limit 1;

/*Q7 : Write a query to return the email, first name , last name & Genre
of all Rock Music listners. Return ordered alphabetically by email*/

SELECT DISTINCT c.email, c.first_name, c.last_name
FROM customer AS c
JOIN invoice AS i ON c.customer_id = i.customer_id
JOIN invoiceline AS il ON i.invoice_id = il.invoice_id
JOIN track AS t ON il.track_id = t.track_id
JOIN genre AS g ON t.genre_id = g.genre_id
WHERE g.name LIKE 'Rock'
ORDER BY c.email;

/*Q8 : Lets Invite the Artist who has written the most rock Music.
Write a query that returns the Artist names and total ttrack count of 
top 10 rock bands */

SELECT ar.artist_id, ar.name, COUNT(t.track_id) AS number_of_songs
FROM track AS t
JOIN album AS al ON al.album_id = t.album_id
JOIN artist AS ar ON ar.artist_id = al.artist_id
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY number_of_songs DESC
LIMIT 10;

/*Q9 : Return all the tracks that have a song lenght longer than average.
Return the name and Miliseconds for each track, Order by longest songs 
listed first*/

SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) AS avg_track_length
    FROM track
)
ORDER BY milliseconds DESC;

/*Q10 : Find how much amount is spend by each customers on artists. Write a query
to return customer nmae,artist name and total spent */

WITH best_selling_artist AS (
    SELECT ar.artist_id AS artist_id, ar.name AS artist_name,
           SUM(il.unit_price * il.quantity) AS total_sales
    FROM invoice_line AS il
    JOIN track AS t ON t.track_id = il.track_id
    JOIN album AS alb ON alb.album_id = t.album_id
    JOIN artist AS ar ON ar.artist_id = alb.artist_id
    GROUP BY ar.artist_id
    ORDER BY total_sales DESC
    LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
       SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice AS i
JOIN customer AS c ON c.customer_id = i.customer_id
JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
JOIN track AS t ON t.track_id = il.track_id
JOIN album AS alb ON alb.album_id = t.album_id
JOIN best_selling_artist AS bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;
