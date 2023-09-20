-- Drop the existing purchases table if it exists
DROP TABLE IF EXISTS purchases;

-- Create a table named "purchases"
CREATE TABLE purchases (
    customer_id INT,
    product_id INT,
    purchase_date DATE
);

-- Generate sample data for a 3-month period with varying repeat rates
INSERT INTO purchases (customer_id, product_id, purchase_date)
VALUES
    (1, 101, '2023-07-01'),
    (2, 102, '2023-07-02'),
    (1, 103, '2023-07-03'),
    (3, 104, '2023-07-04'),
    (1, 105, '2023-07-05'),
    (2, 101, '2023-07-15'),
    (3, 104, '2023-07-25'),
    (1, 106, '2023-08-01'),
    (2, 102, '2023-08-02'),
    (1, 107, '2023-08-03'),
    (3, 108, '2023-08-04'),
    (1, 109, '2023-08-05'),
    (2, 106, '2023-08-10'),
    (3, 108, '2023-08-15'),
    (1, 101, '2023-08-20'),
    (2, 102, '2023-08-21'),
    (1, 103, '2023-08-22'),
    (3, 104, '2023-08-23'),
    (1, 105, '2023-08-24'),
    (2, 101, '2023-08-25'),
    (3, 104, '2023-08-26'),
    (1, 106, '2023-09-01'),
    (2, 102, '2023-09-02'),
    (1, 107, '2023-09-03'),
    (3, 108, '2023-09-04'),
    (1, 109, '2023-09-05'),
    (2, 106, '2023-09-10'),
    (3, 108, '2023-09-15'),
    (1, 101, '2023-09-20'),
    (2, 102, '2023-09-21'),
    (1, 103, '2023-09-22'),
    (3, 104, '2023-09-23'),
    (1, 105, '2023-09-24'),
    (2, 101, '2023-09-25'),
    (3, 104, '2023-09-26');

-- Add repeat purchases within 30 days
INSERT INTO purchases (customer_id, product_id, purchase_date)
VALUES
    (1, 101, '2023-07-10'), -- Repeat purchase within 30 days
    (2, 102, '2023-07-17'), -- Repeat purchase within 30 days
    (3, 104, '2023-07-27'), -- Repeat purchase within 30 days
    (1, 106, '2023-08-02'), -- Repeat purchase within 30 days
    (2, 102, '2023-08-12'), -- Repeat purchase within 30 days
    (3, 104, '2023-08-27'), -- Repeat purchase within 30 days
    (1, 101, '2023-09-10'), -- Repeat purchase within 30 days
    (2, 102, '2023-09-18'), -- Repeat purchase within 30 days
    (3, 104, '2023-09-28'); -- Repeat purchase within 30 days

SELECT * FROM purchases;

SELECT
    product_id,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(repeat_within_30) AS repeat_customers,
    (SUM(repeat_within_30) / COUNT(DISTINCT customer_id)) * 100.0 AS repeat_rate_percentage
FROM (
    SELECT
        p1.customer_id,
        p1.product_id,
        MAX(DATEDIFF(p2.purchase_date, p1.purchase_date) <= 30) AS repeat_within_30
    FROM
        purchases p1
    JOIN
        purchases p2
    ON
        p1.customer_id = p2.customer_id
        AND p1.product_id = p2.product_id
        AND p1.purchase_date < p2.purchase_date
    GROUP BY
        p1.customer_id, p1.product_id
) AS subquery
GROUP BY
    product_id;

