CREATE DATABASE ecommerce;

USE ecommerce;

 -- brand
CREATE TABLE brand (
  brand_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT
);

-- product_category
CREATE TABLE product_category (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT
);

-- product
CREATE TABLE product (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  brand_id INT,
  base_price DECIMAL(10,2),
  FOREIGN KEY (brand_id) REFERENCES brand(brand_id)
);

-- product_image
CREATE TABLE product_image (
  image_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  image_url VARCHAR(255),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
); 

-- color
CREATE TABLE color (
  color_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  hex_value VARCHAR(7)
); 

-- size_category
CREATE TABLE size_category (
  size_category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- size_option
CREATE TABLE size_option (
  size_option_id INT AUTO_INCREMENT PRIMARY KEY,
  size_category_id INT,
  label VARCHAR(20) NOT NULL,
  FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- product_variation
CREATE TABLE product_variation (
  variation_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  color_id INT,
  size_option_id INT,
  FOREIGN KEY (product_id) REFERENCES product(product_id),
  FOREIGN KEY (color_id) REFERENCES color(color_id),
  FOREIGN KEY (size_option_id) REFERENCES size_option(size_option_id)
);

-- product_item
CREATE TABLE product_item (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  variation_id INT,
  sku VARCHAR(50) NOT NULL,
  quantity_in_stock INT,
  price_override DECIMAL(10,2),
  FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
);

-- attribute_category
CREATE TABLE attribute_category (
  attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- attribute_type
CREATE TABLE attribute_type (
  attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- product_attribute
CREATE TABLE product_attribute (
  attribute_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  attribute_type_id INT,
  attribute_category_id INT,
  value TEXT,
  FOREIGN KEY (product_id) REFERENCES product(product_id),
  FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id),
  FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id)
);

-- inserting values to the tables

-- Insert into brand
INSERT INTO brand (name, description) VALUES
('Nike', 'Sportswear brand'),
('Apple', 'Electronics and devices'),
('Samsung', 'Technology and innovation'),
('Adidas', 'Global sportswear manufacturer'),
('Sony', 'Electronics and entertainment');

-- Insert into product_category
INSERT INTO product_category (name, description) VALUES
('Clothing', 'Wearable items'),
('Electronics', 'Gadgets and devices'),
('Accessories', 'Complementary items');

-- Insert into color
INSERT INTO color (name, hex_value) VALUES
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Black', '#000000'),
('White', '#FFFFFF'),
('Green', '#00FF00');

-- Insert into size_category
INSERT INTO size_category (name) VALUES
('Shirt Sizes'),
('Shoe Sizes'),
('Hat Sizes');

-- Insert into size_option
INSERT INTO size_option (size_category_id, label) VALUES
(1, 'S'),
(1, 'M'),
(1, 'L'),
(2, '42'),
(2, '44'),
(3, 'M'),
(3, 'L');

-- Insert into product
INSERT INTO product (name, description, brand_id, base_price) VALUES
('Air Max Sneakers', 'Running shoes from Nike', 1, 120.00),
('iPhone 14', 'Apple smartphone', 2, 999.99),
('Galaxy Watch', 'Smartwatch by Samsung', 3, 249.99),
('Adidas Hoodie', 'Warm hoodie from Adidas', 4, 75.50),
('Sony Headphones', 'Noise-cancelling headphones', 5, 199.99);

-- Insert into product_image
INSERT INTO product_image (product_id, image_url) VALUES
(1, 'images/airmax.jpg'),
(2, 'images/iphone14.jpg'),
(3, 'images/galaxywatch.jpg'),
(4, 'images/adidas_hoodie.jpg'),
(5, 'images/sony_headphones.jpg');

-- Insert into product_variation
INSERT INTO product_variation (product_id, color_id, size_option_id) VALUES
(1, 3, 4),  -- Black Air Max size 42
(2, 1, NULL),  -- Red iPhone
(3, 4, NULL),  -- White Galaxy Watch
(4, 2, 2),     -- Blue Hoodie size M
(5, 5, NULL);  -- Green Sony Headphones

-- Insert into product_item
INSERT INTO product_item (variation_id, sku, quantity_in_stock, price_override) VALUES
(1, 'AIRMAX-BLK-42', 50, NULL),
(2, 'IPH14-RED', 30, 949.99),
(3, 'GWATCH-WHT', 40, NULL),
(4, 'HOODIE-BLU-M', 25, 70.00),
(5, 'SONY-GRN', 60, NULL);

-- Insert into attribute_type
INSERT INTO attribute_type (name) VALUES
('Text'),
('Number'),
('Boolean');

-- Insert into attribute_category
INSERT INTO attribute_category (name) VALUES
('Physical'),
('Technical');

-- Insert into product_attribute
INSERT INTO product_attribute (product_id, attribute_type_id, attribute_category_id, value) VALUES
(1, 1, 1, 'Leather'),
(2, 2, 2, '128'),
(3, 1, 2, 'Bluetooth Enabled'),
(4, 1, 1, 'Cotton'),
(5, 2, 2, '40');

-- adding sample queries

-- Find all items for a product
SELECT p.name, pi.sku, pi.price_override
FROM product p
JOIN product_variation pv ON p.product_id = pv.product_id
JOIN product_item pi ON pv.variation_id = pi.variation_id
WHERE p.name = 'Air Max Sneakers';

-- adding category_id to product table
ALTER TABLE product 
ADD COLUMN category_id INT,
ADD FOREIGN KEY (category_id) REFERENCES product_category(category_id);

-- product with category and brand query
SELECT  
   p.product_id,
   p.name AS product_name,
   b.name AS brand_name,
   pc.name AS category_name
FROM  
   product p
JOIN brand b ON p.brand_id = b.brand_id
JOIN product_category pc ON pc.category_id = p.category_id
LIMIT 0, 1000;

-- adding column url on product image table
ALTER TABLE product_image
ADD COLUMN url VARCHAR(255);

-- product with images query
SELECT 
  p.name AS product_name,
  pi.url
FROM 
  product p
JOIN product_image pi ON p.product_id = pi.product_id;


-- full product listing query with variation, size, color, and stock
SELECT 
  p.name AS product_name,
  b.name AS brand_name,
  pc.name AS category_name,
  pi.sku,
  c.name AS color,
  so.label AS size,
  pi.quantity_in_stock,
  COALESCE(pi.price_override, p.base_price) AS price
FROM 
  product p
JOIN brand b ON p.brand_id = b.brand_id
JOIN product_category pc ON pc.category_id = p.category_id
JOIN product_variation pv ON p.product_id = pv.product_id
JOIN color c ON pv.color_id = c.color_id
JOIN size_option so ON pv.size_option_id = so.size_option_id
JOIN product_item pi ON pv.variation_id = pi.variation_id;

-- getting any products for the shop page
SELECT  
   p.product_id,
   p.name AS product_name,
   b.name AS brand,
   pc.name AS category,
   ANY_VALUE(pi.url) AS image,
   COALESCE(ANY_VALUE(pr.price_override), p.base_price) AS price
FROM product p
JOIN brand b ON p.brand_id = b.brand_id
JOIN product_category pc ON p.category_id = pc.category_id
LEFT JOIN product_image pi ON pi.product_id = p.product_id
LEFT JOIN product_variation pv ON pv.product_id = p.product_id
LEFT JOIN product_item pr ON pv.variation_id = pr.variation_id
GROUP BY p.product_id
LIMIT 20;

-- searching product's ID, name, and price by keyword: Adidas Hoodie & Apple smartphone

SELECT 
  p.product_id,
  p.name,
  COALESCE(pr.price_override, p.base_price) AS price
FROM product p
LEFT JOIN product_variation pv ON p.product_id = pv.product_id
LEFT JOIN product_item pr ON pv.variation_id = pr.variation_id
WHERE p.name LIKE '%Adidas Hoodie%' OR p.description LIKE '%Apple smartphone%';

-- showing product attributes
SELECT 
  a.value,
  at.name AS type,
  ac.name AS category
FROM product_attribute a
JOIN attribute_type at ON a.attribute_type_id = at.attribute_type_id
JOIN attribute_category ac ON a.attribute_category_id = ac.attribute_category_id
WHERE a.product_id = 1;