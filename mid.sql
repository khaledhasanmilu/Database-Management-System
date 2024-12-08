use mid;
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

-- Insert sample data into Products table

INSERT INTO Products (product_id, product_name, category, unit_price) VALUES
(101, 'Laptop', 'Electronics', 500.00),
(102, 'Smartphone', 'Electronics', 300.00),
(103, 'Headphones', 'Electronics', 30.00),
(104, 'Keyboard', 'Electronics', 20.00),
(105, 'Mouse', 'Electronics', 15.00);

-- Create Sales table

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    total_price DECIMAL(10, 2)
);

-- Insert sample data into Sales table

INSERT INTO Sales VALUES
(1, 101, 5, '2024-01-01', 2500.00),
(2, 102, 3, '2024-01-02', 900.00),
(3, 103, 2, '2024-01-02', 60.00),
(4, 104, 4, '2024-01-03', 80.00),
(5, 105, 6, '2024-01-03', 90.00);

-- foreign key constraint

ALTER TABLE Sales
ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id);

--add new colum quantity_in_stock

ALTER TABLE Products
ADD COLUMN quantity_in_stock INT DEFAULT 10;

--update the value of quantity 
UPDATE Products
SET quantity_in_stock = quantity_in_stock - (
    SELECT SUM(quantity_sold)
    FROM Sales
    WHERE Sales.product_id = Products.product_id
);

--Find the products that contains the substring 'phone'

SELECT *
FROM Products
WHERE product_name LIKE '%phone%';

--all sales where the total price is greater than the average total price

SELECT * FROM Sales WHERE total_price > (
    SELECT AVG(total_price)
    FROM Sales
);

--Retrive the product name and total sales revenue for each product
SELECT product_name, (SELECT SUM(total_price) FROM Sales 
WHERE Sales.product_id = Products.product_id) AS total_sales_revenue
FROM Products;

--lists the top 3 products based on the total quantity sold
SELECT product_name FROM Products WHERE product_id IN (
    SELECT product_id
    FROM Sales
    GROUP BY product_id
    ORDER BY SUM(quantity_sold) DESC
)
    LIMIT 3

;
--8
SELECT product_name,category,unit_price FROM Products JOIN Sales 
ON Products.product_id=Sales.product_id 
WHERE Sales.quantity_sold > (SELECT AVG(quantity_sold) FROM Products JOIN Sales 
ON Products.product_id=Sales.product_id )
;


