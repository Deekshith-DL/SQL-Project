# SQL-Project

**SQL Project Report: Online Store Management System**

**1. Introduction**
The Online Store Management System is a SQL-based database project designed to efficiently manage an online retail store. This project aims to create a well-organized and dynamic database system to handle various aspects of the online store, including customer details, product information, orders, and sales data. The system provides essential functionalities for store administrators to monitor sales, track customer behavior, manage inventory, and enhance overall business operations.

**2. Database Schema**
The database schema comprises four primary tables:

a. Customers Table:
   - CustomerID (Primary Key)
   - FirstName
   - LastName
   - Email
   - Address
   - State

b. Products Table:
   - ProductID (Primary Key)
   - ProductName
   - Description
   - Price
   - QuantityInStock

c. Orders Table:
   - OrderID (Primary Key)
   - CustomerID (Foreign Key referencing Customers table)
   - OrderDate
   - TotalAmount

d. OrderItems Table:
   - OrderItemID (Primary Key)
   - OrderID (Foreign Key referencing Orders table)
   - ProductID (Foreign Key referencing Products table)
   - Quantity
   - UnitPrice

**3. Data Generation**
To populate the database with sample data, we used the Mockaroo website. The data was randomly generated to simulate real-world scenarios, ensuring diverse and realistic datasets. Mockaroo allowed us to create customer information, product details, orders, and more, all while maintaining consistency and relationships among the tables.

**4. SQL Queries and Business Questions**
The project includes a series of SQL queries designed to answer complex business questions and provide valuable insights into the store's performance and customer behavior. These queries utilize various SQL functionalities such as joins, aggregate functions, common table expressions (CTEs), window functions, and date functions.

The business questions answered by these queries include:
- Identifying top revenue-generating products.
- Tracking monthly customer acquisitions.
- Calculating revenue growth rate over time.
- Recognizing consistent top-selling products.
- Analyzing products sold to customers from different cities.
- Identifying new customer growth by state and month.
- Recognizing top customers based on orders and spending.

**5. Conclusion**
The Online Store Management System SQL project provides a powerful and dynamic database solution for efficiently managing an online retail store. By utilizing SQL queries and database management, the system can offer valuable insights into customer behavior, product popularity, revenue trends, and customer acquisition.

The project demonstrates the capabilities of SQL in organizing and analyzing data, enabling data-driven decision-making for business growth and enhanced customer experience. With realistic sample data, this project serves as an effective tool for testing, development, and strategic planning.

**6. Future Enhancements**
For future enhancements, the project can be extended to include additional functionalities such as user authentication, order tracking, inventory management, and advanced analytics to further optimize store performance and customer satisfaction.

The system can also be integrated with web applications to provide a user-friendly interface for customers and administrators, facilitating seamless interactions and transactions.

In conclusion, the SQL project for the Online Store Management System is a robust and valuable resource for managing an online retail business effectively. The system's well-organized database schema, realistic sample data, and insightful SQL queries make it a valuable tool for gaining valuable business insights and making informed decisions.
