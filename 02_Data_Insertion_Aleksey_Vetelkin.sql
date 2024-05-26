-- 2
-- Generate and insert synthetic data into the sales_data table
DO $$
DECLARE
    sale_date DATE;
BEGIN
    FOR i IN 1..1000 LOOP
        sale_date := current_date - interval '1 day' * (random() * 360)::int;
        INSERT INTO sales_data (product_id, region_id, salesperson_id, sale_amount, sale_date)
        VALUES (
            (random() * 100)::int,
            (random() * 10)::int,
            (random() * 50)::int,
            (random() * 1000)::numeric,
            sale_date
        );
    END LOOP;
END $$;

-- Analyze the partitioned tables to update statistics
ANALYZE sales_data;

-- Query to count rows in each partition
SELECT table_name, row_count 
FROM (
    SELECT inhrelid::regclass AS table_name, reltuples::bigint AS row_count
    FROM pg_class c 
    JOIN pg_inherits i 
    ON c.oid = i.inhrelid 
    WHERE inhparent = 'sales_data'::regclass
) sub
ORDER BY table_name;
