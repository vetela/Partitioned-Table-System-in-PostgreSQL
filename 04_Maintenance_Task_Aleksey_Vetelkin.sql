-- 4
-- Create the procedure for maintenance tasks
CREATE OR REPLACE PROCEDURE manage_partitions() LANGUAGE plpgsql AS $$
DECLARE
    partition_name TEXT;
    old_partition_name TEXT;
    new_partition_name TEXT;
    new_partition_start DATE;
    new_partition_end DATE;
BEGIN
    old_partition_name := format('sales_data_%s', to_char(current_date - interval '13 months', 'YYYY_MM'));
    
    EXECUTE format('DROP TABLE IF EXISTS %I;', old_partition_name);

    new_partition_start := date_trunc('month', current_date + interval '1 month');
    new_partition_end := date_trunc('month', current_date + interval '2 months');
    new_partition_name := format('sales_data_%s', to_char(new_partition_start, 'YYYY_MM'));

    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS %I PARTITION OF sales_data FOR VALUES FROM (''%s'') TO (''%s'');',
        new_partition_name,
        new_partition_start,
        new_partition_end
    );
END $$;

CALL manage_partitions();