# Sweet Layers data sources

```mermaid
flowchart LR
    subgraph Sources["Data sources"]
        web["Web shop<br/>Owner: Web / e-commerce team<br/>Update: continuous, per order<br/>Raw: orders.csv, order_items.csv, customers.csv"]
        app["Mobile app<br/>Launched June 2025<br/>Owner: Mobile product team<br/>Update: continuous, per order<br/>Raw: orders.csv, order_items.csv, customers.csv"]
        phone["Phone orders<br/>Owner: Customer service<br/>Update: per call, daily batch<br/>Raw: orders.csv, order_items.csv, customers.csv"]
        courier["Courier delivery tracking<br/>Owner: Courier / logistics partner<br/>Update: status events, hourly<br/>Raw: orders.csv (status, promised_at, delivered_at)"]
        catalogue["Product and price lists<br/>Owner: Merchandising / Product owner<br/>Update: on change, weekly review<br/>Raw: products.csv, order_items.csv (unit_price)"]
        reviews["Customer reviews<br/>Owner: Customer experience<br/>Update: per submission, daily batch<br/>Raw: reviews.csv"]
    end

    subgraph Raw["../data/raw/"]
        customers["customers.csv"]
        orders["orders.csv"]
        items["order_items.csv"]
        products["products.csv"]
        reviewfile["reviews.csv"]
    end

    web --> orders
    web --> items
    web --> customers
    app --> orders
    app --> items
    app --> customers
    phone --> orders
    phone --> items
    phone --> customers
    courier --> orders
    catalogue --> products
    catalogue --> items
    reviews --> reviewfile
```

Owners and update cadences are stated from the system/team responsible for each source. In this repository the same CSVs are stored under `Assignment 01/` and `Assignment 02/`; the diagram uses the requested `../data/raw/` labels.
