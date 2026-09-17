select product_id , product_name, price
from products
where products = (
    select AVG(price) from products
)

SELECT product_id, product_name, price
FROM products
WHERE price > (
    SELECT AVG(price) FROM products
);


SELECT transaction_id, customer_id, amount
FROM transactions t1
WHERE amount > (
    SELECT AVG(amount)
    FROM transactions t2
    WHERE t2.customer_id = t1.customer_id
);


WITH KeyboardPurchases AS (
    SELECT 
        customer_id,
        product,
        quantity,
        price_per_unit,
        (quantity * price_per_unit) AS total_price
    FROM sales2
    WHERE product = 'Mouse'
)

SELECT 
    customer_id,
    product,
    quantity,
    total_price
FROM KeyboardPurchases
WHERE total_price > 30;


WITH ProductSummary AS (
    SELECT 
        customer_id,
        product,
        SUM(quantity) AS total_product,
        SUM(quantity * price_per_unit) AS total_price
    FROM sales2
    GROUP BY customer_id, product
)
SELECT 
    customer_id,
    product,
    total_product,
    total_price
FROM ProductSummary
WHERE product = 'Mouse' 
  AND total_price > 30;


WITH SingleSoldProducts AS (
    SELECT product
    FROM sales2
    GROUP BY product
    HAVING COUNT(*) = 1
)

SELECT 
    s.sale_id,
    s.customer_id,
    s.product,
    s.quantity,
    s.sale_date
FROM sales2 s
JOIN SingleSoldProducts p ON s.product = p.product;



WITH ProductSales AS (
    SELECT 
        p.name AS product_name,
        SUM(s.quantity) AS total_quantity
    FROM products p
    JOIN sales s ON p.id = s.product_id
    GROUP BY p.id, p.name
)
SELECT 
    product_name,
    total_quantity
FROM ProductSales
WHERE total_quantity >= 7;



SELECT 
    product_name,
    total_quantity
FROM (
    SELECT 
        p.name AS product_name,
        SUM(s.quantity) AS total_quantity
    FROM products p
    total_penjualan
    JOIN sales s ON p.id = s.product_id
    GROUP BY p.id, p.name
) AS ProductSales
WHERE total_quantity >= 7;


WITH ProductSales AS ( 
    SELECT 
        p.name AS product_name, 
        SUM(s.quantity) as total_quantity, 
        SUM(s.quantity * p.price) as total_penjualan 
    FROM productsHabib p 
    JOIN salesHabib s ON p.id = s.product_id 
    GROUP BY p.id, p.name
) 
SELECT 
    product_name, 
    total_quantity, 
    total_penjualan 
FROM ProductSales 
WHERE total_quantity >= 7;


select 
    product_name,
    total_quantity,
    total_penjualan
FROM (
    SELECT 
        p.name AS product_name,
        SUM(s.quantity) as total_quantity,
        SUM(s.quantity * p.price) as total_penjualan
    FROM productsHabib p
    JOIN salesHabib s ON p.id = s.product_id 
    GROUP BY p.id, p.name 
) AS ProductSales
WHERE total_quantity >= 7;