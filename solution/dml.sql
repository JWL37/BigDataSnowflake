INSERT INTO dim_regions (region_name)
SELECT DISTINCT store_state
FROM mock_data
WHERE store_state IS NOT NULL;

INSERT INTO dim_locations (city_name, region_id)
SELECT DISTINCT
    store_city,
    r.region_id
FROM mock_data md
JOIN dim_regions r ON r.region_name = md.store_state
WHERE store_city IS NOT NULL;

INSERT INTO dim_animals (animal_name, species, breed, gender, birth_date)
SELECT DISTINCT
    customer_pet_name,
    customer_pet_type,
    customer_pet_breed,
    NULL,
    NULL
FROM mock_data
WHERE customer_pet_name IS NOT NULL;

INSERT INTO dim_users (full_name, email, age, gender, location_id, favorite_animal_id)
SELECT DISTINCT
    md.customer_first_name || ' ' || md.customer_last_name,
    md.customer_email,
    md.customer_age,
    NULL,
    l.location_id,
    a.animal_id
FROM mock_data md
LEFT JOIN dim_locations l ON l.city_name = md.store_city
LEFT JOIN dim_animals a ON a.animal_name = md.customer_pet_name;


INSERT INTO dim_items (item_name, item_category, item_subcategory, item_brand, item_color, item_size, unit_price)
SELECT DISTINCT
    product_name,
    product_category,
    product_material,
    product_brand,
    product_color,
    product_size,
    product_price
FROM mock_data
WHERE product_name IS NOT NULL;

INSERT INTO dim_stores (store_name, location_id, contact_email, phone_number)
SELECT DISTINCT
    store_name,
    l.location_id,
    store_email,
    store_phone
FROM mock_data md
LEFT JOIN dim_locations l ON l.city_name = md.store_city
WHERE store_name IS NOT NULL;

INSERT INTO dim_suppliers (supplier_name, contact_person, email, location_id)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    l.location_id
FROM mock_data md
LEFT JOIN dim_locations l ON l.city_name = md.supplier_city
WHERE supplier_name IS NOT NULL;

INSERT INTO dim_dates (full_date, year, month, day, weekday)
SELECT DISTINCT
    TO_DATE(sale_date, 'YYYY-MM-DD'),
    EXTRACT(YEAR FROM TO_DATE(sale_date, 'YYYY-MM-DD')),
    EXTRACT(MONTH FROM TO_DATE(sale_date, 'YYYY-MM-DD')),
    EXTRACT(DAY FROM TO_DATE(sale_date, 'YYYY-MM-DD')),
    TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'), 'Day')
FROM mock_data
WHERE sale_date IS NOT NULL;

INSERT INTO fact_orders (
    user_id, item_id, date_id, quantity, total_amount,
    store_id, supplier_id, channel_id, device_id
)
SELECT
    u.user_id,
    i.item_id,
    d.date_id,
    md.sale_quantity,
    md.sale_total_price,
    s.store_id,
    sp.supplier_id,
    NULL,  
    NULL   
FROM mock_data md
LEFT JOIN dim_users u ON u.email = md.customer_email
LEFT JOIN dim_items i ON i.item_name = md.product_name
LEFT JOIN dim_dates d ON d.full_date = TO_DATE(md.sale_date, 'YYYY-MM-DD')
LEFT JOIN dim_stores s ON s.store_name = md.store_name
LEFT JOIN dim_suppliers sp ON sp.supplier_name = md.supplier_name
WHERE md.sale_date IS NOT NULL;
