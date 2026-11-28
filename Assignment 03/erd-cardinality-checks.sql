SELECT 'customers_rows' AS check_name, COUNT(*) AS n FROM customers
UNION ALL SELECT 'orders_rows', COUNT(*) FROM orders
UNION ALL SELECT 'order_items_rows', COUNT(*) FROM order_items
UNION ALL SELECT 'products_rows', COUNT(*) FROM products
UNION ALL SELECT 'reviews_rows', COUNT(*) FROM reviews;

SELECT 'customers_duplicate_pks' AS check_name, COUNT(*) AS n FROM (SELECT customer_id FROM customers GROUP BY customer_id HAVING COUNT(*) > 1) AS d
UNION ALL SELECT 'orders_duplicate_pks', COUNT(*) FROM (SELECT order_id FROM orders GROUP BY order_id HAVING COUNT(*) > 1) AS d
UNION ALL SELECT 'order_items_duplicate_pks', COUNT(*) FROM (SELECT order_item_id FROM order_items GROUP BY order_item_id HAVING COUNT(*) > 1) AS d
UNION ALL SELECT 'products_duplicate_pks', COUNT(*) FROM (SELECT product_id FROM products GROUP BY product_id HAVING COUNT(*) > 1) AS d
UNION ALL SELECT 'reviews_duplicate_pks', COUNT(*) FROM (SELECT review_id FROM reviews GROUP BY review_id HAVING COUNT(*) > 1) AS d;

SELECT 'customers_null_pks' AS check_name, COUNT(*) AS n FROM customers WHERE customer_id IS NULL OR TRIM(COALESCE(CAST(customer_id AS TEXT), '')) = ''
UNION ALL SELECT 'orders_null_pks', COUNT(*) FROM orders WHERE order_id IS NULL OR TRIM(COALESCE(CAST(order_id AS TEXT), '')) = ''
UNION ALL SELECT 'order_items_null_pks', COUNT(*) FROM order_items WHERE order_item_id IS NULL OR TRIM(COALESCE(CAST(order_item_id AS TEXT), '')) = ''
UNION ALL SELECT 'products_null_pks', COUNT(*) FROM products WHERE product_id IS NULL OR TRIM(COALESCE(CAST(product_id AS TEXT), '')) = ''
UNION ALL SELECT 'reviews_null_pks', COUNT(*) FROM reviews WHERE review_id IS NULL OR TRIM(COALESCE(CAST(review_id AS TEXT), '')) = '';

SELECT 'orders_orphan_or_null_customer_fk' AS check_name, COUNT(*) AS n
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL OR o.customer_id IS NULL OR TRIM(COALESCE(CAST(o.customer_id AS TEXT), '')) = '';

SELECT 'orders_per_customer_minmax' AS check_name, MIN(n) AS min_n, MAX(n) AS max_n
FROM (SELECT customer_id, COUNT(*) AS n FROM orders GROUP BY customer_id) AS x;

SELECT 'customers_with_zero_orders' AS check_name, COUNT(*) AS n
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT 'order_items_orphan_or_null_order_fk' AS check_name, COUNT(*) AS n
FROM order_items i
LEFT JOIN orders o ON i.order_id = o.order_id
WHERE o.order_id IS NULL OR i.order_id IS NULL OR TRIM(COALESCE(CAST(i.order_id AS TEXT), '')) = '';

SELECT 'items_per_order_minmax' AS check_name, MIN(n) AS min_n, MAX(n) AS max_n
FROM (SELECT order_id, COUNT(*) AS n FROM order_items GROUP BY order_id) AS x;

SELECT 'orders_with_zero_items' AS check_name, COUNT(*) AS n
FROM orders o
LEFT JOIN order_items i ON o.order_id = i.order_id
WHERE i.order_item_id IS NULL;

SELECT 'order_items_orphan_or_null_product_fk' AS check_name, COUNT(*) AS n
FROM order_items i
LEFT JOIN products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL OR i.product_id IS NULL OR TRIM(COALESCE(CAST(i.product_id AS TEXT), '')) = '';

SELECT 'items_per_product_minmax' AS check_name, MIN(n) AS min_n, MAX(n) AS max_n
FROM (SELECT product_id, COUNT(*) AS n FROM order_items GROUP BY product_id) AS x;

SELECT 'products_with_zero_items' AS check_name, COUNT(*) AS n
FROM products p
LEFT JOIN order_items i ON p.product_id = i.product_id
WHERE i.order_item_id IS NULL;

SELECT 'reviews_orphan_or_null_order_fk' AS check_name, COUNT(*) AS n
FROM reviews r
LEFT JOIN orders o ON r.order_id = o.order_id
WHERE o.order_id IS NULL OR r.order_id IS NULL OR TRIM(COALESCE(CAST(r.order_id AS TEXT), '')) = '';

SELECT 'reviews_per_order_minmax' AS check_name, MIN(n) AS min_n, MAX(n) AS max_n, SUM(CASE WHEN n > 1 THEN 1 ELSE 0 END) AS orders_with_multiple_reviews
FROM (SELECT order_id, COUNT(*) AS n FROM reviews GROUP BY order_id) AS x;

SELECT 'orders_with_zero_reviews' AS check_name, COUNT(*) AS n
FROM orders o
LEFT JOIN reviews r ON o.order_id = r.order_id
WHERE r.review_id IS NULL;
