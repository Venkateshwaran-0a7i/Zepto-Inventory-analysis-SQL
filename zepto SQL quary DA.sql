drop table if exists Zepto;

create table zepto(
Serial_id SERIAL PRIMARY KEY,
catagory VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discount_percent NUMERIC(5,2),
availabile_Quantity INTEGER,
discounted_Selling_price NUMERIC(8,2),
weightInGms INTEGER,
OutOfStock BOOLEAN,
Quantity INTEGER
);

--1.DATA EXPLORATION

--Count data
SELECT COUNT(*) From zepto;

--sample data 
select * from zepto
limit 10;

--null values 
select * from zepto
where name is null 
or 
catagory is null 
or 
mrp is null
or  
discount_percent is null
or 
availabile_Quantity is null
or 
discounted_Selling_price is null 
or
weightInGms is null 
or  
OutOfStock is null
or 
Quantity is null

--NO nulls 

-- if i found a null value i can drop it using 
delete from zepto
where name is null 
or 
catagory is null 
or 
mrp is null
or  
discount_percent is null
or 
availabile_Quantity is null
or 
discounted_Selling_price is null 
or
weightInGms is null 
or  
OutOfStock is null
or 
Quantity is null


--Catagory from zepto

select distinct catagory
from zepto
order by catagory;

--Stock check IN or OUT
select OutOfStock, Count(serial_id)
from zepto
group by OutOfStock;

--Prodrct names presant in multiple time 
select name, count(serial_id) as "Numer of Orders"
from zepto
group by name
having count(serial_id)>1
order by count(serial_id) desc;

--2.DATA CLEANING

--product with prise zero
select * from zepto
where mrp=0 or Discounted_Selling_Price =0;

delete from zepto where mrp = 0;

--Convert paise to rupee
update zepto
set mrp=mrp/100.0,
Discounted_Selling_Price = Discounted_Selling_Price/100.0

Select mrp, Discounted_Selling_Price from zepto

--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discount_percent from zepto
order by discount_percent desc
limit 10 ;


--Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp from zepto 
where OutOfStock = True and mrp > 300
order by mrp desc;


--Q3.Ca1cu1ate Estimated Revenue for each category
select distinct catagory,
SUM(Discounted_Selling_Price * availabile_Quantity) as total_revenue from zepto 
group by catagory
order by total_revenue desc ;

--Q4.Find all products whereis greater than 500 and discount is less than 10%.
select distinct name, mrp, discount_percent
from zepto 
where mrp > 500 and discount_percent < 10
order by mrp desc , discount_percent desc;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
select distinct catagory, 
round(avg(discount_percent),2) as avg_dis from zepto
group by catagory
order by avg_dis desc
limit(5);

--Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightInGms,Discounted_Selling_Price,
round(Discounted_Selling_Price/weightInGms,2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

--Q7.Group the products into categories like Low, medium, Bulk.
select distinct name,weightInGms,
case when weightInGms <= 500 then 'Low'
     when weightInGms <=1000 then 'Medium'
	 else 'Bulk'
	 end
	 as weightCatagory

from zepto ;


--Q8 . What is the Total Inventory Weight Per Category
select catagory,
sum(weightIngms*availabile_Quantity) as total_weight from zepto
group by catagory
order by total_weight;
