CREATE TABLE dim_countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE dim_pet_categories (
    pet_category_id SERIAL PRIMARY KEY,
    pet_category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_pet_breeds (
    pet_breed_id SERIAL PRIMARY KEY,
    pet_breed_name VARCHAR(100) UNIQUE NOT NULL,
    pet_category_id INT REFERENCES dim_pet_categories(pet_category_id)
);

CREATE TABLE dim_product_categories (
    product_category_id SERIAL PRIMARY KEY,
    product_category_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE dim_cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state_name VARCHAR(100),
    country_id INT REFERENCES dim_countries(country_id),
    UNIQUE(city_name, state_name, country_id)
);

CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    source_customer_id INT UNIQUE,
    customer_first_name VARCHAR(100) NOT NULL,
    customer_last_name VARCHAR(100) NOT NULL,
    customer_age INT,
    customer_email VARCHAR(255),
    country_id INT REFERENCES dim_countries(country_id),
    customer_postal_code VARCHAR(20),
    customer_pet_type VARCHAR(50),
    customer_pet_name VARCHAR(100),
    pet_breed_id INT REFERENCES dim_pet_breeds(pet_breed_id)
);

CREATE TABLE dim_sellers (
    seller_id SERIAL PRIMARY KEY,
    source_seller_id INT UNIQUE,
    seller_first_name VARCHAR(100) NOT NULL,
    seller_last_name VARCHAR(100) NOT NULL,
    seller_email VARCHAR(255),
    country_id INT REFERENCES dim_countries(country_id),
    seller_postal_code VARCHAR(20)
);

CREATE TABLE dim_suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_contact VARCHAR(200),
    supplier_email VARCHAR(255),
    supplier_phone VARCHAR(20),
    supplier_address VARCHAR(255),
    city_id INT REFERENCES dim_cities(city_id),
    country_id INT REFERENCES dim_countries(country_id),
    UNIQUE(supplier_name, supplier_contact)
);

CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_location VARCHAR(255),
    city_id INT REFERENCES dim_cities(city_id),
    store_phone VARCHAR(20),
    store_email VARCHAR(255),
    UNIQUE(store_name, store_location, city_id)
);

CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    source_product_id INT UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    product_category_id INT REFERENCES dim_product_categories(product_category_id),
    product_price DECIMAL(10, 2),
    product_quantity INT,
    pet_category_id INT REFERENCES dim_pet_categories(pet_category_id),
    product_weight DECIMAL(10, 2),
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    product_brand VARCHAR(100),
    product_material VARCHAR(100),
    product_description TEXT,
    product_rating DECIMAL(3, 1),
    product_reviews INT,
    product_release_date DATE,
    product_expiry_date DATE,
    supplier_id INT REFERENCES dim_suppliers(supplier_id)
);

CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    customer_id INT REFERENCES dim_customers(customer_id),
    seller_id INT REFERENCES dim_sellers(seller_id),
    product_id INT REFERENCES dim_products(product_id),
    store_id INT REFERENCES dim_stores(store_id),
    sale_quantity INT NOT NULL,
    sale_total_price DECIMAL(10, 2) NOT NULL
);