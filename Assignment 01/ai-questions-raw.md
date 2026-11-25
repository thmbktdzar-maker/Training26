# AI questions — raw input and raw output (unverified)

## Prompt sent to the AI assistant

```text
You are helping a data analyst on the Sweet Layers project. The business owner says:

"My orders are increasing, but my profits are not improving. My customers are also not returning. Where should I put next year's marketing money?"

Here are the column lists from Step 6 (first look at the data). Do not assume any other data exists.

customers.csv
- Columns: customer_id, first_name, last_name, email, phone, zone, signup_date, acquisition_channel

orders.csv
- Columns: order_id, customer_order, order_ts, channel, fulfilment, zone, promo_code, discount_amount, delivery_fee, status, delivery-T, promised_at

products.csv
- Columns: product_id, product_name, category, list_price, unit_cost

reviews.csv
- Columns: review_id, order_id, review_date, rating, comment

orders_items.csv
- Columns: order_item, order_id, product_id, qty, unit_price

Task: Propose analytical questions that address the owner's complaint. For each question, name the SQL tables it would use and the columns/joins needed. Include a metric for every question. Be specific.
```

## Raw assistant response (copied as returned, not corrected)

### Proposed analytical questions and SQL tables

1. **Are orders growing faster than profit?** Metric: monthly order count versus monthly gross profit, calculated as `SUM(order_items.qty * (order_items.unit_price - products.unit_cost))`. Tables: `orders`, `order_items`, `products`. Join `orders.order_id = order_items.order_id` and `order_items.product_id = products.product_id`; group by month of `orders.order_ts`.

2. **Which products have the best margin, and are those the products driving order growth?** Metric: unit margin (`products.list_price - products.unit_cost`), gross profit per product, and units sold. Tables: `products`, `order_items`.

3. **What percentage of customers come back, and which acquisition channel brings the most repeat buyers?** Metric: repeat purchase rate = customers with 2+ orders divided by all customers, grouped by `customers.acquisition_channel`. Tables: `customers`, `orders`. Join `customers.customer_id = orders.customer_order`.

4. **Which acquisition channel produces the most profitable returning customers?** Metric: 90-day repeat rate and gross profit per acquired customer. Tables: `customers`, `orders`, `order_items`, `products`. Join customers to orders on `customer_order`, then to items and products as above.

5. **Which marketing campaigns should get next year's budget?** Metric: campaign ROI = (revenue - spend) / spend, ranked by campaign. Tables: `marketing_campaigns`, `campaign_spend`, `orders`, `customers`. Join on `campaign_id` and `customer_order`.

6. **Are late deliveries hurting repeat purchases?** Metric: repeat purchase rate for orders where `delivery-T` is later than `promised_at`. Tables: `orders`, `customers`; join on `customer_order`.

7. **Do unhappy customers stop ordering?** Metric: average rating and repeat rate by rating band, using `comment` text to flag negative sentiment. Tables: `reviews`, `orders`, `customers`.

8. **Are refunded orders eroding profit?** Metric: refund rate and gross profit lost, by product category. Tables: `orders`, `order_items`, `products`; filter `orders.status = 'refunded'`.

9. **Which zones should receive targeted marketing?** Metric: customer lifetime value by zone. Tables: `customers`, `orders`, `order_items`, `zones`; join `customers.zone = zones.zone_id`.

10. **Do promo codes increase order volume enough to offset the discount?** Metric: order count and average `discount_amount` per `promo_code`, plus gross profit per code. Tables: `orders`, `order_items`, `products`.

11. **Are customers happy with delivery?** Tables: `reviews`, `orders`. Compare ratings by `fulfilment`.
