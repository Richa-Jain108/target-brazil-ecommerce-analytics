
/* ============================================================
Question 1A
Data type of all columns in the customers table
============================================================ */

SELECT
    column_name,
    data_type
FROM `target
.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'customers';


/* ============================================================
Question 1B
Get the time range between which the orders were placed
============================================================ */

SELECT
    MIN(order_purchase_timestamp) AS first_order_placed,
    MAX(order_purchase_timestamp) AS last_order_placed
FROM `target
.orders`;


/* ============================================================
Question 1C
Count the Cities & States of customers who ordered during
the given period
============================================================ */

SELECT
    COUNT(DISTINCT c.customer_city) AS Cities_of_customer,
    COUNT(DISTINCT c.customer_state) AS States_of_customer
FROM `target
.customers` AS c;


/* ============================================================
Question 1C (Alternative)
Count the Cities & States of customers who placed orders
between the first and last order dates
============================================================ */

SELECT
    COUNT(DISTINCT c.customer_city) AS Cities_of_customer,
    COUNT(DISTINCT c.customer_state) AS States_of_customer
FROM `target
.customers` AS c
LEFT JOIN `target.orders` AS o
    ON c.customer_id = o.customer_id
WHERE o.order_purchase_timestamp BETWEEN
      '2016-09-04 21:15:19 UTC'
  AND '2018-10-17 17:30:18 UTC';


/* ============================================================
Additional Analysis
States to focus on for acquiring new customers
============================================================ */

SELECT
    c.customer_state,
    COUNT(*) AS No_orders_placed_from_state
FROM `target
.customers` AS c
GROUP BY 1
ORDER BY 2 DESC;

/* ============================================================
Question 2A
Is there a growing trend in the number of orders placed
over the past years?
============================================================ */

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS Year_,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS Month_,
    COUNT(order_id) AS No_of_orders_placed
FROM `target
.orders`
GROUP BY 1,2
ORDER BY 1,2;


/* ============================================================
Question 2B
Can we see some kind of monthly seasonality in terms of
the number of orders being placed?
============================================================ */

SELECT
    EXTRACT(MONTH FROM order_purchase_timestamp) AS Month_,
    COUNT(order_id) AS No_of_orders
FROM `target
.orders`
GROUP BY 1
ORDER BY 1;


/* ============================================================
Question 2C
During what time of the day do the Brazilian customers
mostly place their orders?
(Dawn, Morning, Afternoon or Night)
============================================================ */

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp)
             BETWEEN 0 AND 6
            THEN '0-6 hrs : Dawn'

        WHEN EXTRACT(HOUR FROM order_purchase_timestamp)
             BETWEEN 7 AND 12
            THEN '7-12 hrs : Mornings'

        WHEN EXTRACT(HOUR FROM order_purchase_timestamp)
             BETWEEN 13 AND 18
            THEN '13-18 hrs : Afternoon'

        WHEN EXTRACT(HOUR FROM order_purchase_timestamp)
             BETWEEN 19 AND 23
            THEN '19-23 hrs : Night'

        ELSE 'Unknown'
    END AS order_time_of_day,

    COUNT(order_id) AS total_orders_at_that_time

FROM `target
.orders`
GROUP BY 1
ORDER BY COUNT
(order_id) DESC;

/* ============================================================
Question 3A
Get the month-on-month number of orders placed in each state
(Year-wise)
============================================================ */

SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS Year_,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month_,
    c.customer_state,
    COUNT(order_id) AS no_of_orders
FROM `target
.orders` AS o
LEFT JOIN `target.customers` AS c
    ON o.customer_id = c.customer_id
GROUP BY 1,2,3
ORDER BY 1,2 ASC;


/* ============================================================
Question 3A (Alternative)
Get the month-on-month number of orders placed in each state
(Not Year-wise)
============================================================ */

SELECT
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month_,
    c.customer_state,
    COUNT(order_id) AS no_of_orders
FROM `target
.orders` AS o
LEFT JOIN `target.customers` AS c
    ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 1,3 DESC;


/* ============================================================
Question 3B
How are the customers distributed across all the states?
============================================================ */

SELECT
    customer_state,
    COUNT(DISTINCT customer_id) AS customer_count
FROM `target
.customers`
GROUP BY 1
ORDER BY 2 DESC;

/* ============================================================
Question 4A
Get the % increase in the cost of orders from year 2017
to 2018 (include months between Jan to Aug only)
============================================================ */

SELECT
    T.cost_2017,
    T.cost_2018,
    ROUND((T.cost_2018 - T.cost_2017) / T.cost_2017 * 100)
        AS percentage_increase
FROM
    (
    SELECT
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017
            AND EXTRACT(MONTH FROM o.order_purchase_timestamp)
                     BETWEEN 1 AND 8
                THEN p.payment_value
                ELSE 0
            END
        ) AS cost_2017,

        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018
            AND EXTRACT(MONTH FROM o.order_purchase_timestamp)
                     BETWEEN 1 AND 8
                THEN p.payment_value
                ELSE 0
            END
        ) AS cost_2018

    FROM `target.orders
` o
    JOIN `target.payments` p
        ON o.order_id = p.order_id

    WHERE EXTRACT
(YEAR FROM o.order_purchase_timestamp)
              IN
(2017, 2018)
      AND EXTRACT
(MONTH FROM o.order_purchase_timestamp)
              BETWEEN 1 AND 8
) T;


/* ============================================================
Question 4B
Calculate the Total & Average value of order price
for each state
============================================================ */

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value), 2) AS total_order_price,
    ROUND(AVG(p.payment_value), 2) AS average_order_price
FROM `target.customers` AS c
    LEFT JOIN `target      .orders
` AS o
    ON c.customer_id = o.customer_id
LEFT JOIN `target.payments` AS p
    ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 2 DESC;


/* ============================================================
Question 4C
Calculate the Total & Average value of order freight
for each state
============================================================ */

SELECT
    c.customer_state,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(AVG(oi.freight_value), 2) AS average_freight
FROM `target.orders` o
    JOIN `target      .customers
` c
    ON o.customer_id = c.customer_id
JOIN `target.order_items` oi
    ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY 2 DESC;

/* ============================================================
Question 5A
Find the no. of days taken to deliver each order from the
order’s purchase date as delivery time.

Also calculate the difference (in days) between the
estimated & actual delivery date of an order.

Do this in a single query.
============================================================ */

SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    TIMESTAMP_DIFF(
        order_delivered_customer_date,
        order_purchase_timestamp,
        DAY
    ) AS delivery_time_in_days,

    TIMESTAMP_DIFF(
        order_estimated_delivery_date,
        order_delivered_customer_date,
        DAY
    ) AS diff_estimated_delivery

FROM `target
.orders`
ORDER BY 2;


/* ============================================================
Question 5B
Find out the top 5 states with the highest & lowest
average freight value
============================================================ */

SELECT
    states,
    avg_freight_value
FROM
    (
    (
        SELECT
        c.customer_state AS states,
        AVG(oi.freight_value) AS avg_freight_value
    FROM `target.customers` AS c
    JOIN `target     .orders` AS o
            ON o.customer_id = c.customer_id
    JOIN `target     .order_items
` AS oi
            ON o.order_id = oi.order_id
        GROUP BY c.customer_state
        ORDER BY avg_freight_value ASC
        LIMIT 5
    )

    UNION ALL

(
        SELECT
    c.customer_state AS states,
    AVG(oi.freight_value) AS avg_freight_value
FROM `target.customers` AS c
    JOIN `target     .orders` AS o
            ON o.customer_id = c.customer_id
    JOIN `target     .order_items
` AS oi
            ON o.order_id = oi.order_id
        GROUP BY c.customer_state
        ORDER BY avg_freight_value DESC
        LIMIT 5
    )
)
ORDER BY avg_freight_value ASC;


/* ============================================================
Question 5C
Find out the top 5 states with the highest & lowest
average delivery time
============================================================ */

SELECT
    state,
    delivery_time_in_days
FROM
    (
    SELECT
        c.customer_state AS state,

        AVG(
            TIMESTAMP_DIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp,
                DAY
            )
        ) AS delivery_time_in_days,

        DENSE_RANK() OVER (
            ORDER BY AVG(
                TIMESTAMP_DIFF(
                    o.order_delivered_customer_date,
                    o.order_purchase_timestamp,
                    DAY
                )
            ) ASC
        ) AS ascending_ranking,

        DENSE_RANK() OVER (
            ORDER BY AVG(
                TIMESTAMP_DIFF(
                    o.order_delivered_customer_date,
                    o.order_purchase_timestamp,
                    DAY
                )
            ) DESC
        ) AS descending_ranking

    FROM `target.customers` AS c
    JOIN `target     .orders
` AS o
        ON o.customer_id = c.customer_id

    GROUP BY state
)
WHERE ascending_ranking BETWEEN 1 AND 5
   OR descending_ranking BETWEEN 1 AND 5
ORDER BY delivery_time_in_days ASC;


/* ============================================================
Question 5D
Find out the top 5 states where the order delivery is
really fast as compared to the estimated date of delivery.

Use the difference between the averages of actual &
estimated delivery date to figure out how fast the
delivery was for each state.
============================================================ */

SELECT
    c.customer_state AS state,

    AVG(
        TIMESTAMP_DIFF(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp,
            DAY
        )
    ) AS avg_actual_delivery_days,

    AVG(
        TIMESTAMP_DIFF(
            o.order_estimated_delivery_date,
            o.order_purchase_timestamp,
            DAY
        )
    ) AS avg_estimated_delivery_days,

    (
        AVG(
            TIMESTAMP_DIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp,
                DAY
            )
        )
        -
        AVG(
            TIMESTAMP_DIFF(
                o.order_estimated_delivery_date,
                o.order_purchase_timestamp,
                DAY
            )
        )
    ) AS delivery_time_difference

FROM `target
.customers` AS c
JOIN `target.orders` AS o
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'

GROUP BY state

ORDER BY delivery_time_difference ASC
LIMIT 5;

/* ============================================================
Question 6A
Find the month-on-month number of orders placed using
different payment types
============================================================ */

SELECT
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS Month_,
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS no_of_orders
FROM `target
.orders` AS o
LEFT JOIN `target.payments` AS p
    ON o.order_id = p.order_id
GROUP BY Month_, payment_type
ORDER BY 1, 3 DESC;


/* ============================================================
Question 6A (Year-wise)
Find the month-on-month number of orders placed using
different payment types (Year-wise)
============================================================ */

SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS Year_,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS Month_,
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS no_of_orders
FROM `target.orders` AS o
    LEFT JOIN `target    .payments
` AS p
    ON o.order_id = p.order_id
GROUP BY 1, 2, 3
ORDER BY 1, 2 ASC, 4 DESC;


/* ============================================================
Question 6B
Find the number of orders placed on the basis of the
payment installments that have been paid
============================================================ */

SELECT
    COUNT(DISTINCT order_id) AS no_of_orders
FROM `target
.payments`
WHERE payment_installments >= 1;


/* ============================================================
Question 6B (Alternative)
Exclude orders where payment value is zero
============================================================ */

SELECT
    COUNT(DISTINCT order_id) AS no_of_orders
FROM `target
.payments`
WHERE payment_installments >= 1
  AND payment_value > 0;
