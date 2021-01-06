SELECT Distinct Calendar_Dt, Cust_Id, case when comparing_daily_charge between mean and mean+std then 'U'
                                                 when comparing_daily_charge between mean+std and mean+2*std OR comparing_daily_charge>mean+2*std then 'HU'
                                                 when comparing_daily_charge between mean-std and mean then 'R'
                                                 when comparing_daily_charge between mean-2*std and mean-std OR comparing_daily_charge<mean-2*std then 'HR'
                                                 when comparing_daily_charge =mean then'N'
                                            End as MVM_Status
                                                   
 FROM (
         SELECT t2.*, avg ( daily_charge) over (Partition by Cust_Id) as mean,  stddev(daily_charge) over (Partition by Cust_Id) as std
         FROM (
                 SELECT t1.*, Recharge_Amt_Num/no_of_charging_days as daily_charge, last_charge/last_days as comparing_daily_charge
                 FROM (
                         SELECT t.*, lead(Recharge_Dt,1) over (Partition by Cust_Id order by Recharge_Dt)-Recharge_Dt as no_of_charging_days,
                           last_value( Recharge_Amt_Num) over (Partition by Cust_Id order by Recharge_Dt rows between unbounded preceding and unbounded following) as last_charge,
                           Calendar_Dt - last_value( Recharge_Dt) over (Partition by Cust_Id order by Recharge_Dt rows between unbounded preceding and unbounded following)   as last_days
                         FROM CASE1 t) t1

                  )t2

) ORDER BY Cust_Id;
