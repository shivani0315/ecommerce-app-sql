-- Create the database
CREATE DATABASE ecommerce;

-- Create the customers table
CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL
);

-- Create the products table
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  description TEXT
);

-- Create the orders table
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);


-- Create order_items table for normalization
CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);


-- Insert sample customers
INSERT INTO customers(name, email, address) VALUES 
("Rohan Malav", "rohan@gmail.com", "123 main street"),
("Ajay Suman", "ajaysuman@gmail.com", "244 city mall main street"),
("Deepak Kumar", "deepak@gmail.com", "444 akshay nagar main street");

-- Insert sample products
INSERT INTO products(name, price, description) VALUES
("Product A", 30.00, "Description of Product A"),
("Product B", 20.00, "Description of Product B"),
("Product C", 50.00, "Description of Product C");

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, "2024-07-11 10:00:00", 100.00),
(2, "2024-08-12 11:00:00", 200.00),
(3, "2024-09-14 12:00:00", 300.00),
(1, "2024-09-15 10:00:00", 50.00);

-- Insert into order_items
INSERT INTO order_items (order_id, product_id) VALUES
(1, 1),  
(1, 2),  
(2, 3); 


-- Retrieve all customers who have placed an order in the last 30 days
SELECT *
FROM customers
WHERE id IN (
  SELECT DISTINCT customer_id
  FROM orders
  WHERE order_date >= CURDATE() - INTERVAL 30 DAY
);


-- Get the total amount of all orders placed by each customer
SELECT name,
  (SELECT SUM(orders.total_amount)
   FROM orders
   WHERE orders.customer_id = customers.id) AS total_amount_each 
FROM customers;


-- Update the price of Product C to 45.00
UPDATE products 
SET price = 45.00
WHERE name = "Product C";


-- Add a new column discount to the products table
ALTER TABLE products 
ADD COLUMN discount DECIMAL(10, 2) DEFAULT 0.00;


-- Retrieve the top 3 products with the highest price
SELECT * FROM products ORDER BY price DESC LIMIT 3;


-- Get the names of customers who have ordered Product A
SELECT DISTINCT customers.name
FROM customers
JOIN orders ON customers.id = orders.customer_id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE products.name = 'Product A';


-- Join the orders and customers tables to retrieve the customer's name and order date for each order
SELECT customers.name, orders.order_date
FROM customers
JOIN orders ON customers.id = orders.customer_id;


-- Retrieve the orders with a total amount greater than 150.00
SELECT * FROM orders WHERE total_amount > 150;


-- Retrieve the average total of all orders
SELECT AVG(total_amount) AS average_order_total FROM orders;
