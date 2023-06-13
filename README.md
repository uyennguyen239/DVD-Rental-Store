## DVD-Rental-Store

#**Business Task**
In this project, we have queried the Sakila DVD Rental database. The Sakila Database holds information about a company that rents movie DVDs. For this project, we have queried the database to gain an understanding of the customer base, such as what the patterns in movie watching are across different customer groups, how they compare on payment earnings, and how the stores compare in their performance.

#**ER Diagram**

![dvd-rental-sample-database-diagram](https://github.com/uyennguyen239/DVD-Rental-Store/assets/118790618/90254e25-b116-4733-b14f-b1fe200203ca)

#**Questions and Solutions**

1. -- Find the rows with the maximum rental rate

```SQL
SELECT rental_duration, MAX(rental_rate) AS "Max rental rate"
FROM film
GROUP BY rental_duration;```

Answer:

| "rental_duration" | 	"Max rental rate" |
|-----------------------------------------|
| 4	                |       4.99    |       
| 7	                |       4.99 |
| 6	                |       4.99 |
| 3	                |       4.99 |
| 5 	              |       4.99 |

| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
