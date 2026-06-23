---
title: Dataset Documentation
created: '2026-06-23T18:29:22.692Z'
modified: '2026-06-23T18:31:37.853Z'
---

# Dataset Documentation

## Dataset Source

Target E-Commerce Public Dataset

https://drive.google.com/drive/folders/1TGEc66YKbD443nslRi1bWgVd238gJCnb

---

## Dataset Schema

![Database Schema](../images/Target%20Database%20Schema.png)

---

## Dataset Structure

The dataset consists of the following 8 CSV files:

| File            | Description                               |
| --------------- | ----------------------------------------- |
| customers.csv   | Customer information and location details |
| sellers.csv     | Seller information and seller locations   |
| orders.csv      | Order lifecycle and delivery information  |
| order_items.csv | Product-level order information           |
| payments.csv    | Payment transactions                      |
| reviews.csv     | Customer reviews and ratings              |
| products.csv    | Product information and attributes        |
| geolocation.csv | Geographic location information           |

---

# Data Dictionary

## customers.csv

| Features                 | Description                                              |
| ------------------------ | -------------------------------------------------------- |
| customer_id              | ID of the consumer who made the purchase                 |
| customer_unique_id       | Unique ID of the consumer                                |
| customer_zip_code_prefix | Zip Code of consumer’s location                          |
| customer_city            | Name of the City from where order is made                |
| customer_state           | State Code from where order is made (Eg. são paulo - SP) |

---

## sellers.csv

| Features               | Description                        |
| ---------------------- | ---------------------------------- |
| seller_id              | Unique ID of the seller registered |
| seller_zip_code_prefix | Zip Code of the seller’s location  |
| seller_city            | Name of the City of the seller     |
| seller_state           | State Code (Eg. são paulo - SP)    |

---

## order_items.csv

| Features            | Description                                                          |
| ------------------- | -------------------------------------------------------------------- |
| order_id            | A Unique ID of order made by the consumers                           |
| order_item_id       | A Unique ID given to each item ordered in the order                  |
| product_id          | A Unique ID given to each product available on the site              |
| seller_id           | Unique ID of the seller registered in Target                         |
| shipping_limit_date | The date before which the ordered product must be shipped            |
| price               | Actual price of the products ordered                                 |
| freight_value       | Price rate at which a product is delivered from one point to another |

---

## geolocation.csv

| Features                    | Description                |
| --------------------------- | -------------------------- |
| geolocation_zip_code_prefix | First 5 digits of Zip Code |
| geolocation_lat             | Latitude                   |
| geolocation_lng             | Longitude                  |
| geolocation_city            | City                       |
| geolocation_state           | State                      |

---

## payments.csv

| Features             | Description                                    |
| -------------------- | ---------------------------------------------- |
| order_id             | A Unique ID of order made by the consumers     |
| payment_sequential   | Sequences of the payments made in case of EMI  |
| payment_type         | Mode of payment used (Eg. Credit Card)         |
| payment_installments | Number of installments in case of EMI purchase |
| payment_value        | Total amount paid for the purchase order       |

---

## orders.csv

| Features                      | Description                                            |
| ----------------------------- | ------------------------------------------------------ |
| order_id                      | A Unique ID of order made by the consumers             |
| customer_id                   | ID of the consumer who made the purchase               |
| order_status                  | Status of the order made i.e. delivered, shipped, etc. |
| order_purchase_timestamp      | Timestamp of the purchase                              |
| order_delivered_carrier_date  | Delivery date at which carrier made the delivery       |
| order_delivered_customer_date | Date at which customer got the product                 |
| order_estimated_delivery_date | Estimated delivery date of the products                |

---

## reviews.csv

| Features                | Description                                                         |
| ----------------------- | ------------------------------------------------------------------- |
| review_id               | ID of the review given on the product ordered by the order id       |
| order_id                | A Unique ID of order made by the consumers                          |
| review_score            | Review score given by the customer for each order on a scale of 1-5 |
| review_comment_title    | Title of the review                                                 |
| review_comment_message  | Review comments posted by the consumer for each order               |
| review_creation_date    | Timestamp of the review when it is created                          |
| review_answer_timestamp | Timestamp of the review answered                                    |

---

## products.csv

| Features                   | Description                                                                 |
| -------------------------- | --------------------------------------------------------------------------- |
| product_id                 | A Unique identifier for the proposed project.                               |
| product_category_name      | Name of the product category                                                |
| product_name_lenght        | Length of the string which specifies the name given to the products ordered |
| product_description_lenght | Length of the description written for each product ordered on the site      |
| product_photos_qty         | Number of photos of each product ordered available on the shopping portal   |
| product_weight_g           | Weight of the products ordered in grams                                     |
| product_length_cm          | Length of the products ordered in centimeters                               |
| product_height_cm          | Height of the products ordered in centimeters                               |
| product_width_cm           | Width of the product ordered in centimeters                                 |

---

## Database Schema

The relationships between all tables are illustrated in:

📁 `../images/Target Database Schema.png`

---

## Key Relationships

The analysis combines multiple tables using:

* customer_id
* order_id
* product_id
* seller_id
* geolocation_zip_code_prefix


