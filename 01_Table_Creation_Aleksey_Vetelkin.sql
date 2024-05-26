-- 1
-- Create the partitioned table sales_data with sale_date as part of the primary key
DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data (
    sale_id SERIAL,
    product_id INT,
    region_id INT,
    salesperson_id INT,
    sale_amount NUMERIC,
    sale_date DATE NOT NULL,
    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE (sale_date);

-- Create partitions for the past 12 months
DO $$
DECLARE
    start_date DATE;
    end_date DATE;
BEGIN
    FOR i IN 0..11 LOOP
        start_date := date_trunc('month', current_date) - interval '1 month' * i;
        end_date := date_trunc('month', current_date) - interval '1 month' * (i - 1);

        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS sales_data_%s PARTITION OF sales_data FOR VALUES FROM (''%s'') TO (''%s'');',
            to_char(start_date, 'YYYY_MM'),
            start_date,
            end_date
        );
    END LOOP;
END $$;









