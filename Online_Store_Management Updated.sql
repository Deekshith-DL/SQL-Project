SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERITEMS;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;



--1. Which customer has made the highest total purchase amount? Provide their name, email, and the total amount spent.

SELECT TOP 1 c.FirstName, c.LastName, c.Email, SUM(o.TotalAmount)
AS TotalSpent 
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName, c.Email
ORDER BY TotalSpent DESC;


--2.What is the average price of products in stock?
SELECT AVG(Price) AS AveragePrice
FROM Products;

--3.Which product has the highest quantity in stock?
SELECT TOP 1 ProductName, QuantityInStock
FROM Products 
ORDER BY QuantityInStock DESC;

--4.How many orders were placed in a specific month? Provide the month and the count of orders.
SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month, COUNT(*) AS OrderCount
FROM Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM');

--5.What is the total revenue genera year and the total revenue.
SELECT YEAR(OrderDate) AS Year
FROM Orders 
GROUP BY YEAR(OrderDate);


--6.Which customers have placed orders for products with a price higher than a specified  amount? Provide their names and email addresses.
SELECT top 5 c.FirstName, c.LastName, c.Email
FROM CUSTOMERS c 
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID
WHERE p.Price > 99.9;


--7.How many customers have placed orders within a specific date range? Provide the count  of customers.
SELECT COUNT(DISTINCT c.CustomerID) AS CustomerCount
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '2020-07-15' AND '2022-07-15';


--8.Which products have never been ordered? Provide their names.
SELECT p.ProductName 
FROM Products p 
LEFT JOIN OrderItems oi ON  p.ProductID = oi.ProductID 
WHERE oi.OrderID IS NULL; 


--9.What is the average quantity of products ordered per order?
SELECT AVG(oi.Quantity) AS AverageQuantity
FROM OrderItems oi;


--10.How many orders were placed by customers from each state? Provide the state and the count of orders.
SELECT c.States, COUNT(*) AS OrderCount
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.States; 


--11. Business Question: What are the top 5 products that generate the highest revenue for each year?

WITH RevenueByYear AS (
    SELECT YEAR(OrderDate) AS OrderYear, ProductID, SUM(TotalAmount) AS TotalRevenue
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY YEAR(OrderDate), ProductID
),
RankedRevenueByYear AS (
    SELECT OrderYear, ProductID, TotalRevenue,
           ROW_NUMBER() OVER (PARTITION BY OrderYear ORDER BY TotalRevenue DESC) AS Ranking
    FROM RevenueByYear
)
SELECT r.OrderYear, p.ProductName, r.TotalRevenue
FROM RankedRevenueByYear r
JOIN Products p ON r.ProductID = p.ProductID
WHERE r.Ranking <= 5;


--12. Business Question: How many new customers were acquired each month? (New customers are those who made their first purchase during that month.)


WITH FirstPurchaseByCustomer AS (
    SELECT c.CustomerID, MIN(o.OrderDate) AS FirstPurchaseDate
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID
)
SELECT FORMAT(fp.FirstPurchaseDate, '%Y-%m') AS Month, COUNT(*) AS NewCustomers
FROM FirstPurchaseByCustomer fp
GROUP BY FORMAT(fp.FirstPurchaseDate, '%Y-%m');


--13. Business Question: What is the monthly growth rate of revenue for the past 6 months?


WITH RevenueByMonth AS (
    SELECT FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth, SUM(TotalAmount) AS TotalRevenue
    FROM Orders
    GROUP BY FORMAT(OrderDate, 'yyyy-MM')
),
RevenueGrowth AS (
    SELECT OrderMonth, TotalRevenue,
           LAG(TotalRevenue) OVER (ORDER BY OrderMonth) AS PreviousRevenue
    FROM RevenueByMonth
)
SELECT TOP 6  OrderMonth, TotalRevenue,
       ((TotalRevenue - PreviousRevenue) / PreviousRevenue) * 100 AS GrowthRate
FROM RevenueGrowth
WHERE PreviousRevenue IS NOT NULL
ORDER BY OrderMonth DESC;



--14. Business Question: Which products have consistently been top sellers for the last 3 months?

WITH TopSellingProducts AS (
    SELECT ProductID, COUNT(*) AS SalesCount
    FROM OrderItems
    WHERE OrderID IN (
        SELECT OrderID
        FROM Orders
        WHERE OrderDate >= DATEADD(MONTH, -3, GETDATE())
    )
    GROUP BY ProductID
)
SELECT p.ProductName, SUM(t.SalesCount) AS TotalSalesCount
FROM TopSellingProducts t
JOIN Products p ON t.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSalesCount DESC;


--15.Business Question: What are the customer details, along with their last purchase date and total spend, for customers who made purchases in the last 6 months?


SELECT c.CustomerID, c.FirstName, c.LastName, c.Email,
       MAX(o.OrderDate) AS LastPurchaseDate,
       SUM(oi.UnitPrice * oi.Quantity) AS TotalSpend
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderDate >= DATEADD(MONTH, -6 ,GETDATE())
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email;


--16. Business Question: Which products have been sold to customers from different states, and how many times each product was purchased?


SELECT p.ProductID, p.ProductName, COUNT(*) AS PurchaseCount
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
JOIN Orders o ON oi.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.States IN (
    SELECT States
    FROM Customers
    GROUP BY States
    HAVING COUNT(DISTINCT CustomerID) > 1
)
GROUP BY p.ProductID, p.ProductName;


--17. Business Question: How many new customers were acquired from each states each month in the last year?


WITH NewCustomersByMonth AS (
    SELECT c.States, CONVERT(varchar(7), MIN(o.OrderDate), 120) AS Month
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.States, CONVERT(varchar(7), o.OrderDate, 120)
)
SELECT States, Month, COUNT(*) AS NewCustomers
FROM NewCustomersByMonth
WHERE Month >= CONVERT(varchar(7), DATEADD(YEAR, -1, GETDATE()), 120)
GROUP BY States, Month;



--18. Business Question: What are the top 3 customers who have made the highest number of orders, along with their total spending?


SELECT  TOP 3 c.CustomerID, c.FirstName, c.LastName,
       COUNT(DISTINCT o.OrderID) AS OrderCount,
       SUM(oi.UnitPrice * oi.Quantity) AS TotalSpend
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY OrderCount DESC
;




/*Conclusion:

The complex and advanced SQL queries employed in the Online Store Management System provided valuable insights that have a profound impact on the efficiency and strategic decision-making within the business. By leveraging SQL's capabilities, we gained a deeper understanding of customer behavior, product performance, regional dynamics, and revenue growth.

Complex Query Insights:
1. Top Revenue-Generating Products: Identifying the top products with the highest revenue allowed us to focus on these key items, potentially increasing their visibility and optimizing pricing strategies for higher profitability.

2. Monthly Customer Acquisition: Analyzing new customer acquisitions on a monthly basis helped us track the store's popularity and effectiveness of marketing efforts, providing valuable information for strategic planning.

3. Revenue Growth Rate: The calculation of revenue growth rate over the past six months allowed us to assess the store's overall performance and identify potential areas for improvement or expansion.

4. Consistent Top Sellers: Recognizing products that have consistently been top sellers over the last three months enabled us to prioritize and allocate resources for the most in-demand items, ensuring customer satisfaction and increasing sales.

Advanced Query Insights:
1. Customer Insights and Spending: By examining customer details alongside their last purchase date and total spending, we gained valuable knowledge about customer loyalty and engagement. This information can be utilized to tailor personalized marketing initiatives and enhance customer retention strategies.

2. Products Appeal Across Diverse Customers: Identifying products sold to customers from different cities provided essential insights into the store's geographic reach and the popularity of products among various customer segments.

3. New Customer Growth by State and Month: Tracking new customer acquisitions by state and month allowed us to spot trends in customer growth and focus on expanding the customer base in specific regions.

4. Recognizing Top Customers: Identifying the top customers with the highest number of orders and total spending highlighted the store's most valuable customers. Acknowledging and engaging these loyal customers can foster brand advocacy and drive long-term customer relationships.

In conclusion, the combination of complex and advanced SQL queries has empowered us with valuable data-driven insights, enabling us to make informed decisions, optimize operations, and strategize for future growth in the highly competitive online retail industry. The project showcases the power of SQL in efficiently managing an online store and leveraging data analysis to drive success and profitability.






*/
