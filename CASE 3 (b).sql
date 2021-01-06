SELECT Distinct cust_id, CEIL(AVG(days_count) OVER (PARTITION BY cust_id )) as AVG_days_to_spend_250LE
FROM (
        SELECT t4.*, ROW_NUMBER() OVER (PARTITION BY cust_id,days_count,twohundfifties ORDER BY calendar_dt) AS rnk
        FROM(
               SELECT t3.*, SUM(AMT_LE) OVER(PARTITION BY cust_id,twohundfifties ORDER BY calendar_dt,cust_id) AS Result, 
                                                                                                                          CASE 
                                                                                                                             WHEN AMT_LE>250 THEN 1
                                                                                                                          ELSE
                                                                                                                            COUNT(*) OVER (PARTITION BY cust_id,twohundfifties) 
                                                                                                                         END as days_count
                 FROM(
                        SELECT t2.*,FLOOR(RunningSum/250) AS twohundfifties
                        FROM(
                               SELECT t1.*, SUM(AMT_LE) OVER(PARTITION BY  cust_id ORDER BY calendar_dt,cust_id) AS RunningSum
                               FROM CASE3 t1) t2
                     ) t3
             )t4
     )
 WHERE rnk=1        
ORDER BY cust_id;