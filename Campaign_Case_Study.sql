select * from [dbo].[Campaign_Starting_Data];
alter table [dbo].[Campaign_Starting_Data] drop column F8;

select * into c_start from [dbo].[Campaign_Starting_Data];

select * from c_start;

update c_start set Campaigns='campaign 1',Duration='12/02/14-23/03/14',product='CZV01-CZS09' where [S No] = 2;
update c_start set Campaigns='campaign 1',Duration='12/02/14-23/03/14',product='CZV01-CZS09' where [S No] = 3;
update c_start set Campaigns='campaign 1',Duration='12/02/14-23/03/14',product='CZV01-CZS09' where [S No] = 4;

update c_start set Campaigns='campaign 2',Duration='12/04/14-30/5/14',product='CZV04-CZS08-CZX05' where [S No] = 6;
update c_start set Campaigns='campaign 2',Duration='12/04/14-30/5/14',product='CZV04-CZS08-CZX05' where [S No] = 7;
update c_start set Campaigns='campaign 2',Duration='12/04/14-30/5/14',product='CZV04-CZS08-CZX05' where [S No] = 8;

update c_start set Campaigns='campaign 3',Duration='15/04/14-30/6/14',product='CZV01-CZS05' where [S No] = 10;
update c_start set Campaigns='campaign 3',Duration='15/04/14-30/6/14',product='CZV01-CZS05' where [S No] = 11;
update c_start set Campaigns='campaign 3',Duration='15/04/14-30/6/14',product='CZV01-CZS05' where [S No] = 12;

select * into c_start2 from c_start;

select * from c_start2;

select *, left(duration, CHARINDEX('-',Duration) - 1) as start_date,
		 right(duration, len(duration) - charindex('-',duration)) as end_date
	into c_start3
from c_start2;

select * from c_start3;

select *,convert(datetime,start_date,3) as dt_start_date,convert(datetime,end_date,3) as dt_end_date 
into c_start4 
from c_start3;

select * from c_start4;

select *,DATENAME(weekday,dt_start_date) as SD_WD ,datename(weekday,dt_end_date) as ED_WD
into c_start5
from c_start4;

select * from c_start5;

select *,case 
when DATENAME(weekday,dt_start_date)='Monday' then dateadd(day,4,dt_start_date)
when DATENAME(weekday,dt_start_date)='Tuesday' then dateadd(day,3,dt_start_date)
when DATENAME(weekday,dt_start_date)='Wednesday' then dateadd(day,2,dt_start_date)
when DATENAME(weekday,dt_start_date)='Thursday' then dateadd(day,1,dt_start_date)
when DATENAME(weekday,dt_start_date)='Friday' then dateadd(day,0,dt_start_date)
when DATENAME(weekday,dt_start_date)='Saturday' then dateadd(day,6,dt_start_date)
when DATENAME(weekday,dt_start_date)='Sunday' then dateadd(day,5,dt_start_date)
end as dt_friday_start_date,
case
when DATENAME(weekday,dt_end_date)='Monday' then dateadd(day,4,dt_end_date)
when DATENAME(weekday,dt_end_date)='Tuesday' then dateadd(day,3,dt_end_date)
when DATENAME(weekday,dt_end_date)='Wednesday' then dateadd(day,2,dt_end_date)
when DATENAME(weekday,dt_end_date)='Thursday' then dateadd(day,1,dt_end_date)
when DATENAME(weekday,dt_end_date)='Friday' then dateadd(day,0,dt_end_date)
when DATENAME(weekday,dt_end_date)='Saturday' then dateadd(day,6,dt_end_date)
when DATENAME(weekday,dt_end_date)='Sunday' then dateadd(day,5,dt_end_date)
end as dt_friday_end_date
into c_start6
from c_start5;

select * from c_start6;

select *,DATENAME(weekday,dt_friday_start_date) as FSD_WD ,datename(weekday,dt_friday_end_date) as FED_WD
from c_start6;

select *, dt_end_date-dt_start_date+1 as c_duration
into c_start7
from c_start6;

select * from c_start7;

select *, cast(convert(datetime,c_duration) as int) as c_duration_n 
into c_start8
from c_start7;

select * from c_start8;

select *,Trim('$' from spend) as t_spend 
into c_start9
from c_start8

select * from c_start10

select *,replace(t_spend,',','') as ts_spend 
into c_start10
from c_start9

select *,cast(convert(varchar,ts_spend) as int) as spend_int 
into c_start11
from c_start10

select * from c_start11

select *,len(product) - len(replace(product,'-','')) + 1 as no_of_products 
into c_start12
from c_start11

select * from c_start12

select *,round(cast(spend_int as float)/(c_duration_n*no_of_products),2) as spend_per_product
into c_start13
from c_start12

select * from c_start13

/*
drop table if exists c_start_20
*/

select [s no],channel,campaigns,duration,category,product,dt_start_date,dt_end_date,dt_friday_start_date,
dt_friday_end_date,c_duration_n,spend_int,no_of_products,spend_per_product into c_start_14 from c_start13;

select * from c_start_14

select min(dt_friday_start_date) as min_FSD from c_start_14
select max(dt_friday_end_date) as max_FED from c_start_14

declare @startdate date = '2014-02-14';
declare @enddate date = '2014-07-04';
/*
with weekdays_table as
(select @startdate as [weekdays]
union all
select dateadd(dd,7,[weekdays])
from weekdays_table
where dateadd(dd,7,[weekdays])<=@enddate)

select [weekdays] from weekdays_table
*/
with CTE_Calender as
(select @startdate as [date]
union all
select dateadd(dd,7,[date])
from CTE_Calender
where dateadd(dd,7,[date])<=@enddate)

select [date] into weekdays_table from CTE_Calender

select * from weekdays_table

select date as weekdays into WDT from weekdays_table

select * from WDT

select c.*,w.weekdays into c_start_15 from c_start_14 c cross join wdt w 

select * from c_start_15

select *, convert(datetime,weekdays,103) as dt_weekdays into c_start_16 from c_start_15

select * from c_start_16

select *,case 
when dt_weekdays>=dt_friday_start_date and dt_weekdays<=dt_friday_end_date then 'keep' else 'remove'
end as flag
into c_start_17
from c_start_16

select * from c_start_17

select * into c_start_18 from c_start_17 where flag='keep'

select * from c_start_18

select *,cast(convert(datetime,dt_weekdays-dt_start_date) as int) as W_S, 
cast(convert(datetime,dt_weekdays-dt_end_date) as int) as W_E 
into c_start_19
from c_start_18

select * from c_start_19

select *,case
when W_S<=6 then W_S+1
when W_E<=6 and W_E>=0 then 7-W_E
else 7
end as no_of_days
into c_start_20
from c_start_19

select * from c_start_20

select *,spend_per_product*no_of_days as weekly_spend into c_start_21 from c_start_20

select * from c_start_21

select [s no],channel,campaigns,duration,category,product,dt_start_date,dt_end_date,dt_friday_start_date,
dt_friday_end_date,c_duration_n,spend_int,no_of_products,spend_per_product,dt_weekdays,flag,W_S,W_E,no_of_days,weekly_spend from c_start_21

select *, substring(product,1,5) as product1, substring(product,7,11) as product2, substring(product,13,17) as product3
into c_start_22
from c_start_21

select * from c_start_22

select *,left(product2,5) as product_2 into c_start_23 from c_start_22

select * from c_start_23

select *,case
when product3='CZX05' then 'CZX05' else null
end as product_3 
into c_start_24
from c_start_23

select * from c_start_24

select [s no],channel,campaigns,duration,category,product,dt_start_date,dt_end_date,dt_friday_start_date,
dt_friday_end_date,c_duration_n,spend_int,no_of_products,spend_per_product,dt_weekdays,flag,W_S,W_E,no_of_days,weekly_spend, product_new, cross_product
into c_25
from 
( select * from c_start_24) as original
unpivot
(cross_product for product_new in ([product1],[product_2])) as unpivot_product

select * from c_25

select [s no],channel,campaigns,duration,category,product,dt_start_date,dt_end_date,dt_friday_start_date,
dt_friday_end_date,c_duration_n,spend_int,no_of_products,spend_per_product,dt_weekdays,flag,W_S,W_E,no_of_days,weekly_spend, cross_product 
into c_27
from c_25

select * into c_26 from c_start_24 where product_3 is not null

select * from c_26

select [s no],channel,campaigns,duration,category,product,dt_start_date,dt_end_date,dt_friday_start_date,
dt_friday_end_date,c_duration_n,spend_int,no_of_products,spend_per_product,dt_weekdays,flag,W_S,W_E,no_of_days,weekly_spend, product_3 as cross_product  
into c_28
from c_26

select * from c_27
select * from c_28

select * into c_29 from
(select * from c_27
union
select * from c_28) as a

select * from c_29

select * from c_29 order by campaigns, category, cross_product

select * from c_end
