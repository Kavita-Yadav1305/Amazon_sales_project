# Amazon_sales_project
## PROJECT OVERVIEW
''I have worked on analyzing a dataset of over 1400 sales records from an Amazon-like e-commerce platform. This project involves extensive querying of customer behavior, product performance, and sales trends using PostgreSQL. Through this project, I have tackled various SQL problems, including revenue analysis, customer segmentation, and inventory management.
The project also focuses on data cleaning, handling null values, and solving real-world business problems using structured queries.
An ERD diagram is included to visually represent the database schema and relationships between tables.''
## DATABASE SETUP AND DESIGN
### Schema structure
''' sql -- AMAZON PROJECT-ADVANCED SQL
-- CATEGORY TABLE

-- CATEGORY TABLE
CREATE TABLE category
(
category_id INT PRIMARY KEY,
category_name VARCHAR(20)
);

-- CUSTOMERS TABLE
CREATE TABLE customers
(
customer_id INT PRIMARY KEY,
first_name VARCHAR(20),
last_name VARCHAR(20),
state VARCHAR(20),
address VARCHAR(30) DEFAULT ('XXXX')
);

-- SELLERS TABLE
CREATE TABLE sellers
(
seller_id INT PRIMARY KEY,
seller_name VARCHAR(30),
origin VARCHAR(30)
);

-- PRODUCTS TABLE 
drop table if exists products;
CREATE TABLE products
(
product_id INT PRIMARY KEY,
product_name VARCHAR(20),
price FLOAT,
cogs FLOAT,
category_id INT,-- fk
constraint product_fk_category FOREIGN KEY (category_id) references category(category_id)
);

-- ORDERS TABLE
CREATE TABLE if not exists orders
(
order_id INT PRIMARY KEY,
order_date DATE,
customer_id INT, --FK
seller_id INT, --FK
order_status VARCHAR(25),
constraint orders_fk_customers foreign key(customer_id) references customers(customer_id),
constraint orders_fk_sellers foreign key(seller_id) references sellers(seller_id)
);

-- order_items table
drop table if exists order_items;
CREATE TABLE if not exists order_items
(
order_item_id INT PRIMARY KEY,
order_id INT, -- FK
product_id INT, --FK
quantity INT,
price_per_unit FLOAT,
constraint order_itmes_fk_orders foreign key(order_id) references orders(order_id),
constraint order_itmes_fk_products foreign key(product_id) references products(product_id)
);

-- PAYMENT TABLE
CREATE TABLE payments
(
payment_id INT PRIMARY KEY,
order_id INT, --FK
payment_date DATE,
payment_status VARCHAR(30),
constraint payments_fk_orders foreign key(order_id) references orders(order_id)
);

-- shipping table
CREATE TABLE shippings
(
shipping_id INT PRIMARY KEY,
order_id INT, --FK
shipping_date DATE, 
return_date DATE,
shipping_providers VARCHAR(20),
delivery_status VARCHAR(20),
constraint shippings_fk_orders foreign key(order_id) references orders(order_id)
);

-- INVENTORY TABLE
CREATE TABLE inventory
(
inventory_id INT PRIMARY KEY,
product_id INT, --FK
stock INT,
warehouse_id INT, 
last_stock_date DATE,
constraint inventory_fk_products foreign key(product_id) references products(product_id)
);
'''

![image](https://github.com/user-attachments/assets/4d4d3783-be6b-4098-a9dd-012d3e95b9b5)

