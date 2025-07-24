-- Changing the data type from the DB
ALTER TABLE retail_sales
alter column transactions_id INT not null

ALTER TABLE  retail_sales
alter column sale_date date

ALTER Table retail_sales
alter column sale_time TIME

Alter table retail_sales
alter column customer_id INT

alter Table retail_sales
alter column gender varchar(15)

alter table retail_sales
alter column age int

alter table retail_sales
alter column category varchar(15)

alter table retail_sales
alter column quantiy INT

alter table retail_sales
alter column price_per_unit float

alter table retail_sales
alter column cogs float

alter table retail_sales
alter column total_sale float

ALTER TABLE retail_sales
add primary key (transactions_id)

-- Data Cleaning
select 
	count(*)
from retail_sales

-- Verifying if we have null's in the DB.
select *
from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- In case we have null's, we need to delete those rows.

delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- Data Exploration
-- It is a Retails Sales DB. We will be reviewing the information that contins the DB.

-- Startin with # of customers.

select count(distinct (customer_id)) as CustomerNumber
from retail_sales

-- 155 different customers we have.

-- How many categories do we have.

select distinct category as Categories
from retail_sales

-- Which category has the most sales.

select 
	category,
	count(category) as Trasnactions,
	sum(quantiy) as QTY_Of_Pieces_sold,
	sum(total_sale) as Total_Sales
from retail_sales
group by category
Order by Total_sales desc

--Which one is the biggest buyer.

select 
	customer_id, 
	count(customer_id) as NumberOfTransactions
from retail_sales
group by customer_id
order by NumberOfTransactions desc

--Which client purchased the most items.
select 
	customer_id, 
	sum(quantiy) as QTY
from retail_sales
group by customer_id
order by QTY desc

-- Or highest client is customer 3.

--Which client purchse the most in Total Sales.
select 
	customer_id, 
	count(customer_id) as Transactions, 
	sum(total_sale) as TotalAmmount
from retail_sales
group by customer_id
order by TotalAmmount desc

-- Customer 3 did purchase the most in total value.

--Which products did he bought.

select 
	category, 
	count(category) as Transactions, 
	sum(total_sale) as Total_Amount
from retail_sales
where customer_id = 3
group by category
order by Transactions desc 

-- The AVG age of customers who purchased items for each category.

select
	category,
	avg(age) as AVG_Age	
from retail_sales
group by category

-- Which date do we had the most sales.

select 
	sale_date, 
	sum(customer_id) as transactions
from retail_sales
group by sale_date
order by transactions desc

-- 2022-11-05 is the day with the most transactions.
select *
from retail_sales
where sale_date = '2022-11-05'

select 
	category, 
	count(*) as Transactions
from retail_sales
where 
	sale_date = '2022-11-05'
group by category
order by Transactions desc

-- Retrive all transactions where cateogry is 'Clothing' and the quantity sold is more or equal to 3 in the month of Nov-2022

select 
	*
from retail_sales
where 
	Year(sale_date) = 2022
	and month(sale_date) = 11
	and category = 'Clothing' 
	and quantiy >= 3
order by 2

-- All transactions where total_sale is greater than 1000

select
	*
from retail_sales
where
	total_sale > 1000

-- Total number of Transactions made by each gender in each category

select
	category,
	gender,
	count(*) as transactions
from retail_sales
group by 
	category, 
	gender
order by transactions

-- Calculate the avg sales for each month.
select
	YEAR(sale_date) as year,
	month(sale_date) as month,
	avg(total_sale) as Avg_sale
from retail_sales
group by YEAR(sale_date), month(sale_date)
order by year, month

-- Which month has the best AVG sale per year.

with monthly_avg_sale as(
	select
		YEAR(sale_date) as year,
		month(sale_date) as month,
		avg(total_sale) as Avg_sale
	from retail_sales
	group by YEAR(sale_date), month(sale_date)
), 
ranked_sales as (
	select
		*, RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS sales_rank
	from monthly_avg_sale
				)
	select *
	from ranked_sales
	where sales_rank = 1

--Top 5 customers based on the highest total sales

select top 5
	customer_id, 
	sum(total_sale) as TotalSale
from retail_sales
group by customer_id
order by TotalSale desc

-- Find the number of unique customers who purchased items from each category

select
	category,
	count(distinct customer_id) as UniqueCustomers
from retail_sales
group by category

-- Create shifts per hour 

-- Now we know when the sales starts and then it ends. -6:00 to 23:00
select sale_time
from retail_sales
order by sale_time asc

-- Creating Shifts

SELECT *,
  CASE
    WHEN sale_time BETWEEN '06:00:00' AND '12:00:00' THEN 'Morning Shift'
    WHEN sale_time BETWEEN '12:00:01' AND '20:00:00' THEN 'Afternoon Shift'
    ELSE 'Night Shift'
  END AS shift
FROM retail_sales;

-- Which shift has the most sales
with hourly_sales as (
	SELECT *,
	  CASE
		WHEN sale_time BETWEEN '06:00:00' AND '12:00:00' THEN 'Morning Shift'
		WHEN sale_time BETWEEN '12:00:01' AND '20:00:00' THEN 'Afternoon Shift'
		ELSE 'Night Shift'
	  END AS shift
	FROM retail_sales
)
select
	shift,
	count(*) as shifts,
	sum(total_sale) as TotalSale
from hourly_sales
group by shift
order by TotalSale desc