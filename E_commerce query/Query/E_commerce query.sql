create database e_commerce
use e_commerce
 
 create table customers1(
 id int, name varchar (50),city varchar (50), spend int,signup_date date);

 insert into customers1(Id,Name,City,Spend,signup_date)

 values
 (1,'Elizabeth','Abuja',15000,'12-05-2025'),
 (2,'Lucy','Lagos',6000,'2-05-2025'),
 (3,'Anna','Lagos',7000,'2-05-2025'),
 (4,'Lucky','Abuja',4000,'4-05-2025'),
 (5,'Keith','Edo',2000,'7-05-2025'),
 (6,'Luna','Lagos',6000,'2-05-2025'),
 (7,'Anna','Lagos',17000,'2-05-2025'),
 (8,'Ade','Abuja',4000,'4-05-2025'),
 (9,'Mofe','Edo',4000,'4-05-2025'),
 (10,'Lucy','Lagos',6000,'2-05-2025'),
 (11,'Emeka','Lagos',7000,'2-05-2025'),
 (12,'Lucky','Abuja',4000,'4-05-2025'),
 (13,'Keith','Edo','','7-05-2025'),
 (14,'Gabriel','Lagos',15000,'2-05-2025'),
 (15,'Shina','Benin',20000,'2-05-2025'),
 (16,'Adeola','Abuja',1000,'4-05-2025'),
 (17,'Enitan','Edo',2000,'4-05-2025'),
 (18,'Mary','Edo',78000,'5-05-2025');

 select * from customers1

-- 1 total spend per city
select city, sum (spend) [Total spend by City] from customers1
group by city 

--2. average spend per city descending
select city, avg (spend) [Average spend by City] from customers1
group by city 
order by [Average spend by City] desc

--3. Cities with more than 1 customers
select city, count (*) [Number of customers] from customers1
group by city
having count (*) >1

--4. Highest spend in each city
select city, max(spend) [highest spend per city] from customers1
group by city

--5. Total customers and total spend
select count (name) [Total customers],  sum (spend) [Total Spend] from customers1

-- 6. categorize customers by city
select name, city,
case
when city = 'Lagos'  then 'Tier 1'
when city = 'abuja' then 'Tier 2'
else 'Tier 3'
end [category]
from customers1

--7. count customers per category
select  category, count (*) [Total Count] from (
select name, city,
case
when city = 'Lagos'  then 'Tier 1'
when city = 'abuja' then 'Tier 2'
else 'Tier 3'
end [category]
from customers1)  category
group by category

--8. Show High value customers
select name, spend,
case when spend > 10000 then 'Yes'
else 'No'
end [Valued Customers]
from customers1

--9. Show customers with spends above average
select * from  customers1
where spend >  (select avg (spend) from customers1)

-- 10. Customer with max spend
select * from customers1
where spend = (select max (spend) from customers1)

--11. City with highest average spend
select city from customers1
group by city
having avg(spend) = (select max(average_spend) from (
select avg (spend) [average_spend] from customers1
group by city) Average_city)

--12. Customers from cities with greater than average spend
select * from customers1
where city in (select city from customers1
group by city
having avg (spend) > (select avg (spend) from customers1))

--13. Customer(s) in  City with highest average spend
select name, city from customers1
where spend = (select max(average_spend) from (
select avg (spend) [average_spend] from customers1
group by city) Average_city)

-- 14.Customer with Second highest spend
select * from (select *, DENSE_RANK () over (order by spend desc) [Spend_rank]
from customers1) spend_rank
where spend_rank =2

--15. Rank customers by spend in descending order
select *, DENSE_RANK () over (order by spend desc) [Spend_rank]
from customers1

--16. Row number per city
select *, row_number () over (partition by city order by spend desc) [Row_Num]
from customers1

--17. Show customers with total sales per day
select name, spend, signup_date,
sum (spend) over (order by signup_date) [running_total]
from customers1

--18. Show average spend per city
select city,spend,
avg (spend) over (partition by city) [Average city spend]
from customers1

-- 19. Show high spenders with CTE
with High_spenders as ( 
select * from customers1
where spend > 10000)
select * from High_spenders 

-- 20. Total spend per category with CTE
with total_category_spend as 
(select name, spend,
case when spend > 10000 then 'Yes'
else 'No'
end [Valued_Customers]
from customers1) 
select valued_customers, sum (spend) [Total spend]
from total_category_spend
group by valued_customers

--21. Top spender by city with CTE
with top_spender as (
select * from (select *, DENSE_RANK () over (partition by city order by spend desc) [Spend_rank]
from customers1) spend_rank
where spend_rank =1)
select * from top_spender 





