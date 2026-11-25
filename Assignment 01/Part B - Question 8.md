# Part B – Question 8: AI suggestions, verified

Prompt and unedited AI response: [ai-questions-raw.md](ai-questions-raw.md). I checked every suggestion against the actual CSV headers and values, not only the Step 6 list.

## Verification of each suggestion

| # | Suggestion (short) | Decision | Reason |
|---|---|---|---|
| 1 | Orders vs gross profit by month | **Accepted** | `orders.order_ts`, `order_items.qty`, `order_items.unit_price`, `products.unit_cost` all exist. Metric is explicitly gross profit; net profit is not answerable. |
| 2 | Best product margins and growth | **Changed** | Tables/columns exist, but `list_price` is not the transaction price. Use `order_items.unit_price` for gross profit; keep `list_price` only as a reference margin. |
| 3 | Repeat-purchase rate by acquisition channel | **Changed** | Valid metric, but AI used `customer_order` from Step 6. Actual header is `customer_id` in both `customers.csv` and `orders.csv`. Fix join before SQL. |
| 4 | Profitable repeat customers by channel | **Changed** | Same `customer_order` → `customer_id` fix. Define the 90-day window from `signup_date` and "return" as a second purchase, not a refund. |
| 5 | Marketing campaign ROI | **Rejected** | `marketing_campaigns`, `campaign_spend` and `campaign_id` are invented; no spend or campaign data exists. ROI cannot be calculated. Replace with #10. |
| 6 | Late deliveries and repeat rate | **Changed** | `delivery-T` is not a real column; actual is `delivered_at`. Limit to `fulfilment = 'delivery'` and non-blank `delivered_at` (259 delivery rows are blank). |
| 7 | Ratings, comments and repeat orders | **Changed** | `rating` (1–5) is usable, but `comment` is free text with no sentiment score; SQL cannot aggregate it. Reviews link by `order_id`, so multi-item orders cannot be tied to one category without a rule. |
| 8 | Refunded orders eroding profit | **Accepted** | `status` includes `refunded`; refund rate and gross profit by category are computable. Must state whether refunded rows are excluded from profit totals. |
| 9 | Zone lifetime value | **Changed** | `zones` table and `zone_id` are invented; `zone` is a text column in `customers`/`orders`. Replace "lifetime value" with historical gross profit per customer by zone; future value is not in the data. |
| 10 | Promo codes vs discount | **Accepted** | `promo_code` and `discount_amount` exist (SWEET20, WELCOME10). Order count and gross profit per code are measurable; ROI is not. |
| 11 | Customers happy with delivery | **Rejected (as written)** | No metric or threshold — "happy" and "compare ratings" are vague. Rewrite: "What is the average rating and % of ratings ≤ 2 by `fulfilment` for completed orders in the last 6 months?" |

Additional schema fixes found in Step 6 that the AI did not use: the file is `order_items.csv`, not `orders_items.csv`, and its key is `order_item_id`, not `order_item`.

## Reflection (½ page)

AI was genuinely useful at turning one vague complaint into eleven candidate questions in seconds. It suggested angles I had not written down yet — refund status, promo codes, delivery timing, and review ratings — and it proposed plausible joins and a gross-profit formula that gave me a SQL starting point. That is the right role for it: fast option generation before I commit to a query.

It was also confidently wrong. It invented `marketing_campaigns`, `campaign_spend`, `campaign_id` and a `zones` table, and answered the "where should I spend money?" question with an ROI that no file can support. It carried over two bad Step 6 names (`customer_order`, `delivery-T`) without checking the CSV headers, assumed free-text `comment` could be scored as sentiment, and finished with a question that had no metric at all. Nothing in its tone signalled lower confidence.

The decisions that must stay with me are the definitions: gross versus net profit, what "returning" means, whether refunded rows count, what counts as late, the time window, and whether an observed pattern is strong enough to justify a budget recommendation. The model can draft SQL; I own the metric, the validity check, and the recommendation.

If this were real customer data, I could not paste the actual rows into a public AI tool: `first_name`, `last_name`, `email` and `phone` in `customers.csv` are personal data, and `customer_id` linked to order history is identifying too. Here I pasted only column names, which was safe. For real work I would use a private/approved tool or anonymised or synthetic rows.
