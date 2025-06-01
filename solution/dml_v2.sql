INSERT INTO dim_countries (country_name)
SELECT DISTINCT customer_country FROM mock_data WHERE customer_country IS NOT NULL AND customer_country != ''
UNION
SELECT DISTINCT seller_country FROM mock_data WHERE seller_country IS NOT NULL AND seller_country != ''
UNION
SELECT DISTINCT store_country FROM mock_data WHERE store_country IS NOT NULL AND store_country != ''
UNION
SELECT DISTINCT supplier_country FROM mock_data WHERE supplier_country IS NOT NULL AND supplier_country != '';

INSERT INTO dim_pet_categories (pet_category_name)
SELECT DISTINCT pet_category FROM mock_data WHERE pet_category IS NOT NULL AND pet_category != '';

INSERT INTO dim_pet_breeds (pet_breed_name, pet_category_id)
SELECT DISTINCT 
    m.customer_pet_breed, 
    pc.pet_category_id
FROM mock_data m
JOIN dim_pet_categories pc ON LOWER(m.customer_pet_type) = LOWER(pc.pet_category_name)
WHERE m.customer_pet_breed IS NOT NULL AND m.customer_pet_breed != '';

INSERT INTO dim_product_categories (product_category_name)
SELECT DISTINCT product_category FROM mock_data WHERE product_category IS NOT NULL AND product_category != '';

INSERT INTO dim_cities (city_name, state_name, country_id)
SELECT DISTINCT 
    m.store_city, 
    m.store_state, 
    c.country_id
FROM mock_data m
JOIN dim_countries c ON m.store_country = c.country_name
WHERE m.store_city IS NOT NULL AND m.store_city != '';

INSERT INTO dim_cities (city_name, country_id)
SELECT DISTINCT 
    m.supplier_city, 
    c.country_id
FROM mock_data m
JOIN dim_countries c ON m.supplier_country = c.country_name
WHERE m.supplier_city IS NOT NULL 
  AND m.supplier_city != ''
  AND NOT EXISTS (
    SELECT 1 FROM dim_cities dc 
    WHERE dc.city_name = m.supplier_city 
    AND dc.country_id = c.country_id
  );

INSERT INTO dim_customers (
    source_customer_id,
    customer_first_name, 
    customer_last_name, 
    customer_age, 
    customer_email, 
    country_id, 
    customer_postal_code, 
    customer_pet_type, 
    customer_pet_name, 
    pet_breed_id
)
SELECT DISTINCT 
    m.sale_customer_id,
    m.customer_first_name, 
    m.customer_last_name, 
    m.customer_age, 
    m.customer_email, 
    c.country_id, 
    m.customer_postal_code, 
    m.customer_pet_type, 
    m.customer_pet_name, 
    pb.pet_breed_id
FROM mock_data m
LEFT JOIN dim_countries c ON m.customer_country = c.country_name
LEFT JOIN dim_pet_breeds pb ON m.customer_pet_breed = pb.pet_breed_name
WHERE m.customer_first_name IS NOT NULL 
  AND m.customer_last_name IS NOT NULL;

INSERT INTO dim_sellers (
    source_seller_id,
    seller_first_name, 
    seller_last_name, 
    seller_email, 
    country_id, 
    seller_postal_code
)
SELECT DISTINCT 
    m.sale_seller_id,
    m.seller_first_name, 
    m.seller_last_name, 
    m.seller_email, 
    c.country_id, 
    m.seller_postal_code
FROM mock_data m
LEFT JOIN dim_countries c ON m.seller_country = c.country_name
WHERE m.seller_first_name IS NOT NULL 
  AND m.seller_last_name IS NOT NULL;

INSERT INTO dim_suppliers (
    supplier_name, 
    supplier_contact, 
    supplier_email, 
    supplier_phone, 
    supplier_address, 
    city_id, 
    country_id
)
SELECT DISTINCT 
    m.supplier_name, 
    m.supplier_contact, 
    m.supplier_email, 
    m.supplier_phone, 
    m.supplier_address, 
    ci.city_id, 
    c.country_id
FROM mock_data m
LEFT JOIN dim_countries c ON m.supplier_country = c.country_name
LEFT JOIN dim_cities ci ON m.supplier_city = ci.city_name AND c.country_id = ci.country_id
WHERE m.supplier_name IS NOT NULL 
  AND m.supplier_name != '';

INSERT INTO dim_stores (
    store_name, 
    store_location, 
    city_id, 
    store_phone, 
    store_email
)
SELECT DISTINCT 
    m.store_name, 
    m.store_location, 
    ci.city_id, 
    m.store_phone, 
    m.store_email
FROM mock_data m
LEFT JOIN dim_countries c ON m.store_country = c.country_name
LEFT JOIN dim_cities ci ON m.store_city = ci.city_name AND c.country_id = ci.country_id
WHERE m.store_name IS NOT NULL 
  AND m.store_name != '';

INSERT INTO dim_products (
    source_product_id,
    product_name, 
    product_category_id, 
    product_price, 
    product_quantity, 
    pet_category_id, 
    product_weight, 
    product_color, 
    product_size, 
    product_brand, 
    product_material, 
    product_description, 
    product_rating, 
    product_reviews, 
    product_release_date, 
    product_expiry_date, 
    supplier_id
)
SELECT DISTINCT 
    m.sale_product_id,
    m.product_name, 
    pc.product_category_id, 
    m.product_price, 
    m.product_quantity, 
    petc.pet_category_id, 
    m.product_weight, 
    m.product_color, 
    m.product_size, 
    m.product_brand, 
    m.product_material, 
    m.product_description, 
    m.product_rating, 
    m.product_reviews, 
    TO_DATE(m.product_release_date, 'MM/DD/YYYY'), 
    TO_DATE(m.product_expiry_date, 'MM/DD/YYYY'), 
    s.supplier_id
FROM mock_data m
LEFT JOIN dim_product_categories pc ON m.product_category = pc.product_category_name
LEFT JOIN dim_pet_categories petc ON m.pet_category = petc.pet_category_name
LEFT JOIN dim_suppliers s ON m.supplier_name = s.supplier_name AND m.supplier_contact = s.supplier_contact
WHERE m.product_name IS NOT NULL 
  AND m.product_name != '';

INSERT INTO fact_sales (
    sale_date, 
    customer_id, 
    seller_id, 
    product_id, 
    store_id, 
    sale_quantity, 
    sale_total_price
)
SELECT 
    TO_DATE(m.sale_date, 'MM/DD/YYYY'), 
    c.customer_id, 
    s.seller_id, 
    p.product_id, 
    st.store_id, 
    m.sale_quantity, 
    m.sale_total_price
FROM mock_data m
JOIN dim_customers c ON m.sale_customer_id = c.source_customer_id
JOIN dim_sellers s ON m.sale_seller_id = s.source_seller_id
JOIN dim_products p ON m.sale_product_id = p.source_product_id
JOIN dim_stores st ON m.store_name = st.store_name
WHERE m.sale_date IS NOT NULL 
  AND m.sale_quantity IS NOT NULL 
  AND m.sale_total_price IS NOT NULL;