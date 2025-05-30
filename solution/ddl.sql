
CREATE TABLE dim_regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(64)
);

CREATE TABLE dim_locations (
    location_id SERIAL PRIMARY KEY,
    city_name VARCHAR(64),
    region_id INTEGER REFERENCES dim_regions(region_id)
);

CREATE TABLE dim_dates (
    date_id SERIAL PRIMARY KEY,
    full_date DATE,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    weekday VARCHAR(16)
);

CREATE TABLE dim_animals (
    animal_id SERIAL PRIMARY KEY,
    animal_name VARCHAR(64),
    species VARCHAR(64),
    breed VARCHAR(64),
    gender VARCHAR(16),
    birth_date DATE
);

CREATE TABLE dim_users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(128),
    email VARCHAR(128),
    age INTEGER,
    gender VARCHAR(16),
    location_id INTEGER REFERENCES dim_locations(location_id),
    favorite_animal_id INTEGER REFERENCES dim_animals(animal_id)
);

CREATE TABLE dim_sales_channels (
    channel_id SERIAL PRIMARY KEY,
    channel_name VARCHAR(64)
);

CREATE TABLE dim_devices (
    device_id SERIAL PRIMARY KEY,
    device_type VARCHAR(64),
    os_name VARCHAR(64),
    browser VARCHAR(64)
);

CREATE TABLE dim_items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(128),
    item_category VARCHAR(64),
    item_subcategory VARCHAR(64),
    item_brand VARCHAR(64),
    item_color VARCHAR(32),
    item_size VARCHAR(32),
    unit_price DECIMAL(10, 2)
);

CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(64),
    location_id INTEGER REFERENCES dim_locations(location_id),
    contact_email VARCHAR(128),
    phone_number VARCHAR(32)
);

CREATE TABLE dim_suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(64),
    contact_person VARCHAR(64),
    email VARCHAR(128),
    location_id INTEGER REFERENCES dim_locations(location_id)
);


CREATE TABLE fact_orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES dim_users(user_id),
    item_id INTEGER REFERENCES dim_items(item_id),
    date_id INTEGER REFERENCES dim_dates(date_id),
    quantity INTEGER,
    total_amount DECIMAL(10, 2),
    store_id INTEGER REFERENCES dim_stores(store_id),
    supplier_id INTEGER REFERENCES dim_suppliers(supplier_id),
    channel_id INTEGER REFERENCES dim_sales_channels(channel_id),
    device_id INTEGER REFERENCES dim_devices(device_id)
);
