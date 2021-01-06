SELECT Distinct cust_id, MAX(days_count) OVER (PARTITION BY cust_id) AS max_cosecutive_days
FROM (
        SELECT t2.*, COUNT(*) OVER (PARTITION BY cust_id,comparing_date) AS days_count
        FROM (
                SELECT t1.*, calendar_dt-ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY calendar_dt) AS comparing_date
                FROM CASE3 t1) t2
)
ORDER BY cust_id;