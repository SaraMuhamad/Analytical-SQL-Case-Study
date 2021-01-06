SELECT CUST_ID, MONTH_START_DT, MONTH_BASE_FLAG, case when rnk=1 then 'I'  
                                                      when rnk_diff=1  and MONTH_BASE_FLAG='YES' then'B'
                                                      when   MONTH_BASE_FLAG='YES' then 'R'
                                                      when flaglag='YES'  then 'O'
                                                 End AS IBRO_SEGMENT
                                                 
FROM (
            SELECT t3.*, rnk-lag as rnk_diff , lag(MONTH_BASE_FLAG,1)over (partition by CUST_ID order by MONTH_START_DT) as flaglag
            FROM (
                    SELECT t2.*, lag(rnk,1)over (partition by CUST_ID order by MONTH_START_DT) as lag
                    FROM(
                           SELECT t1.*, DENSE_RANK() over (partition by CUST_ID order by MONTH_BASE_FLAG , MONTH_START_DT) rnk
                           FROM CASE2 t1)t2
                
                )t3
        
 )ORDER BY CUST_ID, Month_Start_Dt;

 
