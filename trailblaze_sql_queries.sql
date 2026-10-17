-- TrailBlaze Outdoors: 2024 Sales Analysis (23 SQL Queries)

--Q1: All products with ProductName, Category and ListPrice, from most to least expensive.

SELECT 
	ProductName,
	Category,
	ListPrice
FROM products
ORDER BY ListPrice DESC;

--	Q2: All orders with OrderTotal greater than $100 through "Online" sales channel.

SELECT *
FROM orders
WHERE
	SalesChannel = 'Online' AND
	OrderTotal > 100;

--Q3: All Gold Tier Customers from West Africa Region.

SELECT *
FROM customers
WHERE
	Region = 'West Africa' AND 
	LoyaltyTier = 'Gold';
	
--Q4: All Returned Orders.

SELECT *
FROM orders
WHERE Returned = 'Yes';


--Q5: Distinct Product Category.

SELECT DISTINCT Category
FROM orders;


--Q6: All Orders in July, 2024.

SELECT *
FROM orders
WHERE 
	OrderDate >= '2024-07-01' AND
	OrderDate <= '2024-07-31';

--Q7: Total Revenue 

SELECT
	SUM (OrderTotal) AS "Total Revenue"
FROM orders;

--Q8: Total Revenue by Product Category, from Highest to Lowest.

SELECT Category, SUM(OrderTotal) AS "Total Revenue"
FROM orders
GROUP BY Category
ORDER BY "Total Revenue" DESC;

--Q9: Total Orders by Sales Channel, including NULL.

SELECT 
	COALESCE(SalesChannel, 'Missing') AS "Sales Channel",
	COUNT (OrderID) AS TotalOrder
FROM orders
GROUP BY COALESCE(SalesChannel, 'Missing')
ORDER BY TotalOrder DESC;


--Q10: Product Categories that generated more than 3000.

SELECT 
	Category AS "Product Category",
	SUM (OrderTotal) AS "TotalRevenue"
FROM orders
GROUP BY "Product Category"
HAVING SUM (OrderTotal) > 3000
ORDER BY "TotalRevenue" DESC;

--Q11: Average Order Value & Average Discount Percentage

SELECT
	ROUND(AVG (OrderTotal),2) AS "Average Order Value",
	ROUND(AVG (DiscountPct),4) AS "Average Discount Percentage"
FROM orders;


--Q12: Percentage of Returned Orders.

SELECT
	ROUND(
		(COUNT(CASE WHEN Returned = 'Yes' THEN 1 END) * 100.0) / COUNT(*), 2) AS ReturnPercentage
FROM orders;


--Q13: Highest Total Revenue by Month.

SELECT
	SUM (OrderTotal) AS "Total Revenue",
	TO_CHAR(OrderDate, 'YYYY-MM') AS "Month"
FROM orders
WHERE EXTRACT(YEAR FROM OrderDate)=2024
GROUP BY TO_CHAR(OrderDate,'YYYY-MM')
ORDER BY "Total Revenue" DESC
LIMIT 1;


--Q14: All Orders Showing Customer Name, Region, and OrderTotal.

SELECT
	orders.OrderID,
	customers.CustomerName,
	customers.Region,
	orders.OrderTotal AS "Total Revenue"
FROM orders orders
JOIN customers customers ON orders.CustomerID = customers.CustomerID;

--Q15: Total amount spent by each customer, top 10 Spenders.

SELECT
		customers.CustomerID,
		customers.CustomerName,
		SUM (orders.OrderTotal) AS "Total Amount"
FROM orders orders
JOIN customers customers ON orders.CustomerID = customers.CustomerID
GROUP BY
	customers.CustomerID,
	customers.CustomerName
ORDER BY "Total Amount" DESC
LIMIT 10;


--Q16: What is the Total Revenue generated per Region?

SELECT
	customers.Region,
	SUM (orders.OrderTotal) AS "Total Revenue"
FROM orders orders
JOIN customers customers ON orders.CustomerID = customers.CustomerID
GROUP BY customers.Region
ORDER BY "Total Revenue" DESC;	


--Q17: Gold Tier customers, Products Purchased and Dates Purchased.

SELECT
	customers.CustomerName,
	orders.OrderDate,
	orders.ProductName
FROM orders orders
JOIN customers customers ON orders.CustomerID = customers.CustomerID
WHERE LoyaltyTier = 'Gold'
ORDER BY
	customers.CustomerName,
	orders.OrderDate;

--Q18: Dormant Customers

SELECT 
	customers.CustomerID,
	customers.CustomerName
FROM customers customers
LEFT JOIN orders orders ON customers.CustomerID = orders.CustomerID
WHERE orders.OrderID IS NULL;


--Q19: Profit Margin

SELECT
	products.ProductID,
	products.ProductName,
	(products.ListPrice - products.UnitCost) AS "Profit Margin",
	COALESCE(SUM(orders.Quantity), 0) AS "Total Units Sold"
FROM products products
LEFT JOIN orders orders ON products.ProductID = orders.ProductID
GROUP BY
	products.ProductID,
	products.ProductName,
	products.ListPrice,
	products.UnitCost
ORDER BY "Total Units Sold" DESC;

--	Q20: Customers with Total Spend is above the Average Total Spend
WITH CustomerSpending AS (
    SELECT CustomerID, SUM(OrderTotal) AS TotalSpend
    FROM orders
    GROUP BY CustomerID
)
SELECT CustomerID, TotalSpend
FROM CustomerSpending
WHERE TotalSpend > (SELECT AVG(TotalSpend) FROM CustomerSpending);


--Q21: Ranking of Products within each Category by Total Revenue

SELECT 
    Category,
    ProductName,
    SUM(OrderTotal) AS TotalRevenue,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(OrderTotal) DESC) AS RevenueRank
FROM orders
GROUP BY Category, ProductName
ORDER BY Category, RevenueRank;


--Q22: Running Total of Customers and Order Date

SELECT 
    CustomerID, 
    OrderDate, 
    OrderTotal,
    SUM(OrderTotal) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
FROM orders
ORDER BY CustomerID, OrderDate;


--Q23: Single Best Selling Products by units sold in each Channel.
WITH ProductSales AS (
    SELECT 
        COALESCE(SalesChannel, 'Missing/Unknown') AS SalesChannel,
        ProductName,
        SUM(Quantity) AS TotalUnitsSold,
        ROW_NUMBER() OVER (
            PARTITION BY COALESCE(SalesChannel, 'Missing/Unknown') 
            ORDER BY SUM(Quantity) DESC
        ) AS rn
    FROM orders
    GROUP BY COALESCE(SalesChannel, 'Missing/Unknown'), ProductName
)
SELECT SalesChannel, ProductName, TotalUnitsSold
FROM ProductSales
WHERE rn = 1;