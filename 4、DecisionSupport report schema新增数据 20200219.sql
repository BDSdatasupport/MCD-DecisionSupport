

use [MCDDecisionSupport]
go


/****** 订单数据结果表 ***********************/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=加总 
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],营业额)

select '加总',平台,cityname,Market,convert(varchar(10),下单时间,23),sum(a.订单总金额)
from [MCDDecisionSupport].dbo.[Order] a
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by 平台,cityname,Market,convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select 平台,cityname,Market,convert(varchar(10),下单时间,23)DATE,时间段,sum(订单总金额) as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by 平台,cityname,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='加总'
and a.[Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go


------------------ tye=单店日均 
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],营业额)

select '单店日均',平台,cityname,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by 平台,cityname,Market,convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select 平台,cityname,Market,convert(varchar(10),下单时间,23)DATE,时间段
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by 平台,cityname,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='单店日均'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go


-------------- 2) market level
------------------ tye=加总 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额)

select CalculateType,ChannelName,-1,Market,Market,[Date],sum(营业额),sum(早餐营业额),sum(午餐营业额),sum(下午茶营业额),sum(晚餐营业额),sum(宵夜营业额),sum(通宵营业额)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='加总' and ChannelName<>'total'
and [Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by CalculateType,ChannelName,Market,[Date]

go

------------------ tye=单店日均
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均',平台,-1,Market,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by 平台,Market,convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select 平台,Market,convert(varchar(10),下单时间,23)DATE,时间段
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by 平台,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 AND A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='单店日均' and cityid='-1'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go
 

-------------- 3) 全国 level
------------------ tye=加总 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额)

select CalculateType,ChannelName,0,'全国','全国',[Date],sum(营业额),sum(早餐营业额),sum(午餐营业额),sum(下午茶营业额),sum(晚餐营业额),sum(宵夜营业额),sum(通宵营业额)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='加总' and ChannelName<>'total' and cityid is null
and [Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by CalculateType,ChannelName,[Date]

go

------------------ tye=单店日均
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均',平台,0,'全国','全国',convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by 平台,convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select 平台,convert(varchar(10),下单时间,23)DATE,时间段
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by 平台,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 and A.Date=B.DATE
WHERE A.CalculateType='单店日均' and cityid='0'
and a.Date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go
 


------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
				
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额)

select CalculateType,'Total',cityid,CityName,Market,[Date],sum(营业额),sum(早餐营业额),sum(午餐营业额),sum(下午茶营业额),sum(晚餐营业额),sum(宵夜营业额),sum(通宵营业额)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='加总' and ChannelName<>'Total'
and [Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by CalculateType,cityid,CityName,Market,[Date]

go

------------------2) tye=单店日均 
---------city level
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],营业额)

select '单店日均','Total',cityname,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by cityname,Market,convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select cityname,Market,convert(varchar(10),下单时间,23)DATE,时间段
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by cityname,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON  A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='单店日均' and ChannelName='total'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go

---------market level
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均','Total',-1,Market,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by Market,convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select Market,convert(varchar(10),下单时间,23)DATE,时间段
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON  A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='单店日均' and ChannelName='total' and cityid='-1'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go

---------全国 level
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均','Total',0,'全国','全国',convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by convert(varchar(10),下单时间,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 早餐营业额=B.[早餐]
   ,午餐营业额=B.[午餐]
   ,下午茶营业额=B.[下午茶]
   ,晚餐营业额=B.[晚餐]
   ,宵夜营业额=B.[宵夜]
   ,通宵营业额=B.[通宵]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select convert(varchar(10),下单时间,23)DATE,时间段
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END as 总金额
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.Date=B.DATE
WHERE A.CalculateType='单店日均' and ChannelName='total' and cityid='0'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go


----update lastday/lastweek data
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 营业额Lastday=b.营业额
,早餐营业额Lastday=b.早餐营业额
,午餐营业额Lastday=b.午餐营业额
,下午茶营业额Lastday=b.下午茶营业额
,晚餐营业额Lastday=b.晚餐营业额
,宵夜营业额Lastday=b.宵夜营业额
,通宵营业额Lastday=b.通宵营业额
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] a
join(
  select CalculateType,ChannelName,CityName,Market,Date,营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额
  from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
)b
on a.CalculateType=b.CalculateType and a.ChannelName=b.ChannelName and a.CityName=b.CityName and a.date=convert(datetime,b.date) + 1


update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set 营业额Lastweek=b.营业额
,早餐营业额Lastweek=b.早餐营业额
,午餐营业额Lastweek=b.午餐营业额
,下午茶营业额Lastweek=b.下午茶营业额
,晚餐营业额Lastweek=b.晚餐营业额
,宵夜营业额Lastweek=b.宵夜营业额
,通宵营业额Lastweek=b.通宵营业额
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] a
join(
  select CalculateType,ChannelName,CityName,Market,Date,营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额
  from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
)b
on a.CalculateType=b.CalculateType and a.ChannelName=b.ChannelName and a.CityName=b.CityName and a.date=convert(datetime,b.date) + 7

go



/**********[Report].[ResultTimeDivisionSalesProportion] 分段营业额占比********************/

insert into [MCDDecisionSupport].[Report].[ResultTimeDivisionSalesProportion](CalculateType,ChannelName,CityID,CityName,Market,Date,早餐营业额占比,午餐营业额占比,下午茶营业额占比,晚餐营业额占比,宵夜营业额占比,通宵营业额占比,早餐营业额占比Lastday,午餐营业额占比Lastday,下午茶营业额占比Lastday,晚餐营业额占比Lastday,宵夜营业额占比Lastday,通宵营业额占比Lastday,早餐营业额占比Lastweek,午餐营业额占比Lastweek,下午茶营业额占比Lastweek,晚餐营业额占比Lastweek,宵夜营业额占比Lastweek,通宵营业额占比Lastweek)

select CalculateType,ChannelName,CityID,CityName,Market,Date
,早餐营业额/营业额,午餐营业额/营业额,下午茶营业额/营业额,晚餐营业额/营业额,宵夜营业额/营业额,通宵营业额/营业额
,早餐营业额Lastday/营业额Lastday,午餐营业额Lastday/营业额Lastday,下午茶营业额Lastday/营业额Lastday,晚餐营业额Lastday/营业额Lastday,宵夜营业额Lastday/营业额Lastday,通宵营业额Lastday/营业额Lastday
,早餐营业额Lastweek/营业额Lastweek,午餐营业额Lastweek/营业额Lastweek,下午茶营业额Lastweek/营业额Lastweek,晚餐营业额Lastweek/营业额Lastweek,宵夜营业额Lastweek/营业额Lastweek,通宵营业额Lastweek/营业额Lastweek
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
where Date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go




/******* 营业数据结果表 ********/
/******* [MCDDecisionSupport].report.ResultDailySales *******/
------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=加总 

insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '加总',平台,cityname,Market,日期,sum(营业额),sum(商户总补贴),sum(有效订单数),sum(无效订单数)
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 平台,cityname,Market,日期
go


------------------ tye=单店日均 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '单店日均',平台,cityname,Market,日期
,case when count(distinct [BDSStoreName])=0 then null else sum(营业额)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(商户总补贴)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(有效订单数)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(无效订单数)/count(distinct [BDSStoreName])end
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 平台,cityname,Market,日期
go


-------------- 2) market level
------------------ tye=加总
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '加总',平台,-1,Market,Market,日期,sum(营业额),sum(商户总补贴),sum(有效订单数),sum(无效订单数)
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 平台,Market,日期
go

------------------ tye=单店日均 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '单店日均',平台,-1,Market,Market,日期
,case when count(distinct [BDSStoreName])=0 then null else sum(营业额)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(商户总补贴)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(有效订单数)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(无效订单数)/count(distinct [BDSStoreName])end
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 平台,Market,日期
go

-------------- 2) 全国 level
------------------ tye=加总
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '加总',平台,0,'全国','全国',日期,sum(营业额),sum(商户总补贴),sum(有效订单数),sum(无效订单数)
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 平台,日期
go

------------------ tye=单店日均 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '单店日均',平台,0,'全国','全国',日期
,case when count(distinct [BDSStoreName])=0 then null else sum(营业额)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(商户总补贴)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(有效订单数)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(无效订单数)/count(distinct [BDSStoreName])end
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 平台,日期
go


------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '加总','Total',cityid,CityName,Market,[Date],sum(营业额),sum(商户补贴),sum(有效订单数),sum(无效订单数)
,case when sum(有效订单数)=0 then null else sum(营业额-商户补贴)/sum(有效订单数)end
from [MCDDecisionSupport].report.ResultDailySales
where CalculateType='加总'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by cityid,CityName,Market,[Date]
go


------------------2) tye=单店日均 
---------city level
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '单店日均','Total',cityname,Market,日期
,case when count(distinct [BDSStoreName])=0 then null else sum(营业额)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(商户总补贴)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(有效订单数)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(无效订单数)/count(distinct [BDSStoreName])end
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by cityname,Market,日期
go

---------market level
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '单店日均','Total',-1,Market,Market,日期
,case when count(distinct [BDSStoreName])=0 then null else sum(营业额)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(商户总补贴)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(有效订单数)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(无效订单数)/count(distinct [BDSStoreName])end
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by Market,日期
go

---------全国 level
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '单店日均','Total',0,'全国','全国',日期
,case when count(distinct [BDSStoreName])=0 then null else sum(营业额)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(商户总补贴)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(有效订单数)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(无效订单数)/count(distinct [BDSStoreName])end
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期 > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by 日期
go


---update lastday/lastweek data
update [MCDDecisionSupport].report.ResultDailySales
set 营业额LastDay=b.营业额
,商户补贴LastDay=b.商户补贴
,有效订单数LastDay=b.有效订单数
,无效订单数LastDay=b.无效订单数
,客单价LastDay=b.客单价
from [MCDDecisionSupport].report.ResultDailySales a
join (
  select CalculateType,channelname,CityName,date,营业额,商户补贴,有效订单数,无效订单数,客单价
  from [MCDDecisionSupport].report.ResultDailySales
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and  a.CityName=b.CityName and  a.date=convert(datetime,b.date) + 1 
go

update [MCDDecisionSupport].report.ResultDailySales
set 营业额LastWeek=b.营业额
,商户补贴LastWeek=b.商户补贴
,有效订单数LastWeek=b.有效订单数
,无效订单数LastWeek=b.无效订单数
,客单价LastWeek=b.客单价
from [MCDDecisionSupport].report.ResultDailySales a
join (
  select CalculateType,channelname,CityName,date,营业额,商户补贴,有效订单数,无效订单数,客单价
  from [MCDDecisionSupport].report.ResultDailySales
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and  a.CityName=b.CityName and  a.date=convert(datetime,b.date) + 7
go




/******** 自然流量结果表 *************/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,sum([自然曝光人数]),sum([自然到店人数]),sum([自然下单人数])
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然到店人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然下单人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,-1,Market,Market,sum([自然曝光人数]),sum([自然到店人数]),sum([自然下单人数])
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,-1,Market,Market
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然到店人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然下单人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

-------------- 3) 全国 level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,0,'全国','全国',sum([自然曝光人数]),sum([自然到店人数]),sum([自然下单人数])
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,0,'全国','全国'
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然到店人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然下单人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO



------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '加总','Total',1,DataPeriod,cityID,cityname,Market,sum([自然曝光人数]),sum([自然到店人数]),sum([自然下单人数])
FROM [Report].[ResultNaturalTraffic] 
where CalculateType='加总'
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,cityID,cityname,Market
ORDER BY DataPeriod,cityID,cityname,Market

GO
				

------------------2) tye=单店日均 
---------city level
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '单店日均','Total',1,DataPeriod,cityname,CityTier,Market
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然到店人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然下单人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY cityname,DataPeriod,CityTier,Market
ORDER BY cityname,DataPeriod

GO

---------market level
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '单店日均','Total',1,DataPeriod,-1,Market,Market
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然到店人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然下单人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,Market
ORDER BY DataPeriod

GO

----全国 level
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '单店日均','Total',1,DataPeriod,0,'全国','全国'
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然到店人数])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([自然下单人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod
ORDER BY DataPeriod

GO


--

UPDATE [Report].[ResultNaturalTraffic]
set [自然到店转化率] = 自然到店人数/自然曝光人数
WHERE 自然曝光人数 <>0 

GO

UPDATE [Report].[ResultNaturalTraffic]
set [自然下单转化率] = 自然下单人数/自然到店人数
WHERE 自然到店人数 <>0

GO



-- LAST DAY 
UPDATE [Report].[ResultNaturalTraffic]
SET [自然曝光人数LastDay] = b.[自然曝光人数],
	[自然到店人数LastDay] = b.[自然到店人数],
	[自然下单人数LastDay] = b.[自然下单人数],
	[自然到店转化率LastDay] = b.[自然到店转化率],
	[自然下单转化率LastDay] = b.[自然下单转化率]
FROM [Report].[ResultNaturalTraffic] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.DataPeriod,A.CalculateType,[自然曝光人数],[自然到店人数],[自然下单人数],[自然到店转化率],[自然下单转化率]
	FROM [Report].[ResultNaturalTraffic] a
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,B.DataPeriod) + 1
AND A.CalculateType= b.CalculateType


-- LAST WEEK 
UPDATE [Report].[ResultNaturalTraffic]
SET [自然曝光人数LastWeek] = b.[自然曝光人数],
	[自然到店人数LastWeek] = b.[自然到店人数],
	[自然下单人数LastWeek] = b.[自然下单人数],
	[自然到店转化率LastWeek] = b.[自然到店转化率],
	[自然下单转化率LastWeek] = b.[自然下单转化率]
FROM [Report].[ResultNaturalTraffic] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.Market,a.DataPeriod,A.CalculateType,[自然曝光人数],[自然到店人数],[自然下单人数],[自然到店转化率],[自然下单转化率]
	FROM [Report].[ResultNaturalTraffic] a

) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,B.DataPeriod) + 7
AND A.CalculateType=B.CalculateType


GO




/********** 自然流量入口结果表 *************/

--city level 
------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[列表名],[自然曝光人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[列表名],sum([自然曝光人数])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[列表名]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[列表名],[自然曝光人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[列表名]
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[列表名]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[列表名],sum([自然曝光人数])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[列表名]
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO

-------------- 3) 全国 level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,0,'全国','全国',[列表名],sum([自然曝光人数])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,0,'全国','全国',[列表名]
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO



--占比
UPDATE [Report].[ResultNaturalTrafficImport]
SET [曝光占比] = a.[自然曝光人数] / b.[自然曝光人数]
FROM [Report].[ResultNaturalTrafficImport] a
JOIN
(
	SELECT CalculateType,ChannelName,ChannelID,DataPeriod,cityname,sum([自然曝光人数]) as [自然曝光人数]
	FROM  [Report].[ResultNaturalTrafficImport]
	GROUP BY CalculateType,ChannelName,ChannelID,DataPeriod,cityname
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
and a.CalculateType=b.CalculateType
WHERE b.[自然曝光人数] <> 0

GO


-- LAST DAY 
UPDATE [Report].[ResultNaturalTrafficImport]
SET [自然曝光人数LastDay] = b.[自然曝光人数],
	[曝光占比LastDay] = b.[曝光占比]
FROM [Report].[ResultNaturalTrafficImport] a
JOIN 
(
	SELECT CalculateType,ChannelID,cityname,DataPeriod,列表名,[自然曝光人数],[曝光占比]
	FROM [Report].[ResultNaturalTrafficImport] 	
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 1 
and a.CalculateType=b.CalculateType
and a.列表名=b.列表名


-- LAST WEEK 
UPDATE [Report].[ResultNaturalTrafficImport]
SET [自然曝光人数LastWeek] = b.[自然曝光人数],
	[曝光占比LastWeek] = b.[曝光占比]
FROM [Report].[ResultNaturalTrafficImport] a
JOIN 
(
	SELECT CalculateType,ChannelID,cityname,DataPeriod,列表名,[自然曝光人数],[曝光占比]
	FROM [Report].[ResultNaturalTrafficImport] 	 
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 7
and a.CalculateType=b.CalculateType
and a.列表名=b.列表名

GO


update [MCDDecisionSupport].[Report].[ResultNaturalTrafficImport]
set [列表名ID] = 
case when [ChannelName] = 'Eleme' and [列表名] = '搜索' then '1'
when [ChannelName] = 'Eleme' and [列表名] = '品类入口' then '2'
when [ChannelName] = 'Eleme' and [列表名] = '导购模块' then '3'
when [ChannelName] = 'Eleme' and [列表名] = '推荐商家列表' then '4'
when [ChannelName] = 'Eleme' and [列表名] = '其他' then '5'
when [ChannelName] = 'Meituan' and [列表名] = '商家列表' then '1'
when [ChannelName] = 'Meituan' and [列表名] = '为你优选' then '2'
when [ChannelName] = 'Meituan' and [列表名] = '搜索' then '3'
when [ChannelName] = 'Meituan' and [列表名] = '顾客订单页' then '4'
when [ChannelName] = 'Meituan' and [列表名] = '其他' then '5'

end

where [列表名ID] is null
go




/*********** 推广数据结果表 ***************/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=加总 

INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '加总',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,sum(推广费用) as CPC推广费用
	,sum(推广带来的营业额) as CPC推广带来的营业额
	,sum(推广曝光次数) as CPC推广曝光次数
	,sum(推广点击次数) as CPC推广点击次数
	,sum(推广下单次数) as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='加总'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,sum(推广费用) as CPM推广费用
	,sum(推广带来的营业额) as CPM推广带来的营业额
	,sum(推广曝光次数) as CPM推广曝光次数
	,sum(推广点击次数) as CPM推广点击次数
	,sum(推广下单次数) as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='加总'

GO


------------------ tye=单店日均 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPC推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPC推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPC推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPC推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPM推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPM推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPM推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPM推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均'

GO

-------------- 2) market level
------------------ tye=加总 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,CPC推广费用,CPC推广带来的营业额,CPC推广曝光次数,CPC推广点击次数,CPC推广下单次数,CPM推广费用,CPM推广带来的营业额,CPM推广曝光次数,CPM推广点击次数,CPM推广下单次数)

SELECT '加总',ChannelName,ChannelID,DataPeriod,-1,Market,Market
,sum(CPC推广费用) as CPC推广费用,sum(CPC推广带来的营业额) as CPC推广带来的营业额,sum(CPC推广曝光次数) as CPC推广曝光次数,sum(CPC推广点击次数) as CPC推广点击次数,sum(CPC推广下单次数) as CPC推广下单次数
,sum(CPM推广费用) as CPM推广费用,sum(CPM推广带来的营业额) as CPM推广带来的营业额,sum(CPM推广曝光次数) as CPM推广曝光次数,sum(CPM推广点击次数) as CPM推广点击次数,sum(CPM推广下单次数) as CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] 
WHERE CalculateType='加总'
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,-1,Market,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,Market
ORDER BY ChannelName,ChannelID,DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPC推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPC推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPC推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPC推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY Market,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' AND cityid='-1'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPM推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPM推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPM推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPM推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY Market,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' AND cityid='-1'

GO

-------------- 3) 全国 level
------------------ tye=加总 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,CPC推广费用,CPC推广带来的营业额,CPC推广曝光次数,CPC推广点击次数,CPC推广下单次数,CPM推广费用,CPM推广带来的营业额,CPM推广曝光次数,CPM推广点击次数,CPM推广下单次数)

SELECT '加总',ChannelName,ChannelID,DataPeriod,0,'全国','全国'
,sum(CPC推广费用) as CPC推广费用,sum(CPC推广带来的营业额) as CPC推广带来的营业额,sum(CPC推广曝光次数) as CPC推广曝光次数,sum(CPC推广点击次数) as CPC推广点击次数,sum(CPC推广下单次数) as CPC推广下单次数
,sum(CPM推广费用) as CPM推广费用,sum(CPM推广带来的营业额) as CPM推广带来的营业额,sum(CPM推广曝光次数) as CPM推广曝光次数,sum(CPM推广点击次数) as CPM推广点击次数,sum(CPM推广下单次数) as CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] 
WHERE CalculateType='加总' and cityid is null
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,0,'全国','全国'
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod
ORDER BY ChannelName,ChannelID,DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPC推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPC推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPC推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPC推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' AND cityid='0'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPM推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPM推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPM推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPM推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' AND cityid='0'

GO




------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,CPC推广费用,CPC推广带来的营业额,CPC推广曝光次数,CPC推广点击次数,CPC推广下单次数,CPM推广费用,CPM推广带来的营业额,CPM推广曝光次数,CPM推广点击次数,CPM推广下单次数)

SELECT '加总','Total',1,DataPeriod,cityid,cityname,Market
,sum(CPC推广费用) as CPC推广费用,sum(CPC推广带来的营业额) as CPC推广带来的营业额,sum(CPC推广曝光次数) as CPC推广曝光次数,sum(CPC推广点击次数) as CPC推广点击次数,sum(CPC推广下单次数) as CPC推广下单次数
,sum(CPM推广费用) as CPM推广费用,sum(CPM推广带来的营业额) as CPM推广带来的营业额,sum(CPM推广曝光次数) as CPM推广曝光次数,sum(CPM推广点击次数) as CPM推广点击次数,sum(CPM推广下单次数) as CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] 
WHERE CalculateType='加总'
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,cityid,cityname,Market
ORDER BY DataPeriod,cityname

GO

			
------------------2) tye=单店日均 
---------city level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '单店日均','Total',1,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY cityname,DataPeriod,CityTier,Market
ORDER BY cityname,DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPC推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPC推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPC推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPC推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod
) b
ON  a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' and ChannelName='Total'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPM推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPM推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPM推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPM推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod
) b
ON a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' and ChannelName='Total'

GO

---------market level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '单店日均','Total',1,DataPeriod,-1,Market,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,Market
ORDER BY DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPC推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPC推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPC推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPC推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,Market
) b
ON a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均'  and ChannelName='Total' and cityid='-1'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPM推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPM推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPM推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPM推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,Market
) b
ON  a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' and ChannelName='Total' and cityid='-1'

GO

---------全国 level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '单店日均','Total',1,DataPeriod,0,'全国','全国'
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod
ORDER BY DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用 = b.CPC推广费用,
CPC推广带来的营业额 = b.CPC推广带来的营业额,
CPC推广曝光次数 = b.CPC推广曝光次数,
CPC推广点击次数 = b.CPC推广点击次数,
CPC推广下单次数 = b.CPC推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPC推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPC推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPC推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPC推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPC推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod
) b
ON  a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均'  and ChannelName='Total' and cityid='0'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM推广费用 = b.CPM推广费用,
CPM推广带来的营业额 = b.CPM推广带来的营业额,
CPM推广曝光次数 = b.CPM推广曝光次数,
CPM推广点击次数 = b.CPM推广点击次数,
CPM推广下单次数 = b.CPM推广下单次数
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(推广费用)/count(distinct BDSStoreName) end as CPM推广费用
	,case count(distinct BDSStoreName) when 0 then null else sum(推广带来的营业额)/count(distinct BDSStoreName) end  as CPM推广带来的营业额
	,case count(distinct BDSStoreName) when 0 then null else sum(推广曝光次数)/count(distinct BDSStoreName) end  as CPM推广曝光次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广点击次数)/count(distinct BDSStoreName) end  as CPM推广点击次数
	,case count(distinct BDSStoreName) when 0 then null else sum(推广下单次数)/count(distinct BDSStoreName) end  as CPM推广下单次数
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod
) b
ON a.DataPeriod = b.DataPeriod
where a.CalculateType='单店日均' and ChannelName='Total' and cityid='0'

GO



--CPCROI
UPDATE [Report].[ResultCPCCPMSummary]
SET CPCROI = CPC推广带来的营业额/CPC推广费用
WHERE CPC推广费用 <>0
GO

--CPMROI
UPDATE [Report].[ResultCPCCPMSummary]
SET CPMROI = CPM推广带来的营业额/CPM推广费用
WHERE CPM推广费用 <>0
GO


-------------------------------------------------------------------------------------------------

-- LAST DAY 
UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用LastDay = b.CPC推广费用,
	CPC推广带来的营业额LastDay = b.CPC推广带来的营业额,
	CPC推广曝光次数LastDay = b.CPC推广曝光次数,
	CPC推广点击次数LastDay = b.CPC推广点击次数,
	CPC推广下单次数LastDay = b.CPC推广下单次数,
	CPCROILastDay = b.CPCROI,
	CPM推广费用LastDay = b.CPM推广费用,
	CPM推广带来的营业额LastDay = b.CPM推广带来的营业额,
	CPM推广曝光次数LastDay = b.CPM推广曝光次数,
	CPM推广点击次数LastDay = b.CPM推广点击次数,
	CPM推广下单次数LastDay = b.CPM推广下单次数,
	CPMROILastDay = b.CPMROI
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.DataPeriod,a.CalculateType,CPC推广费用,CPC推广带来的营业额,CPC推广曝光次数,CPC推广点击次数,CPC推广下单次数,CPCROI,CPM推广费用,CPM推广带来的营业额,CPM推广曝光次数,CPM推广点击次数,CPM推广下单次数,CPMROI
	FROM [Report].[ResultCPCCPMSummary] a
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 1 
and A.CalculateType=B.CalculateType


-- LAST WEEK 
UPDATE [Report].[ResultCPCCPMSummary]
SET CPC推广费用LastWeek = b.CPC推广费用,
	CPC推广带来的营业额LastWeek = b.CPC推广带来的营业额,
	CPC推广曝光次数LastWeek = b.CPC推广曝光次数,
	CPC推广点击次数LastWeek = b.CPC推广点击次数,
	CPC推广下单次数LastWeek = b.CPC推广下单次数,
	CPCROILastWeek = b.CPCROI,
	CPM推广费用LastWeek = b.CPM推广费用,
	CPM推广带来的营业额LastWeek = b.CPM推广带来的营业额,
	CPM推广曝光次数LastWeek = b.CPM推广曝光次数,
	CPM推广点击次数LastWeek = b.CPM推广点击次数,
	CPM推广下单次数LastWeek = b.CPM推广下单次数,
	CPMROILastWeek = b.CPMROI
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.GM,a.Market,a.DataPeriod,a.CalculateType,
	CPC推广费用,CPC推广带来的营业额,CPC推广曝光次数,CPC推广点击次数,CPC推广下单次数,CPCROI,CPM推广费用,CPM推广带来的营业额,CPM推广曝光次数,CPM推广点击次数,CPM推广下单次数,CPMROI
	FROM [Report].[ResultCPCCPMSummary] a
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 7 
AND A.CalculateType=B.CalculateType

GO


update [MCDDecisionSupport].[Report].[ResultCPCCPMSummary]
set 
CPC推广到店转化 = case when CPC推广曝光次数 = 0 then null else CPC推广点击次数/CPC推广曝光次数 end,
CPC推广到店转化LastDay = case when CPC推广曝光次数LastDay = 0 then null else CPC推广点击次数LastDay/CPC推广曝光次数LastDay end,
CPC推广到店转化LastWeek = case when CPC推广曝光次数LastWeek = 0 then null else CPC推广点击次数LastWeek/CPC推广曝光次数LastWeek end,

CPC推广下单转化 = case when CPC推广点击次数 = 0 then null else CPC推广下单次数/CPC推广点击次数 end,
CPC推广下单转化LastDay = case when CPC推广点击次数LastDay = 0 then null else CPC推广下单次数LastDay/CPC推广点击次数LastDay end,
CPC推广下单转化LastWeek = case when CPC推广点击次数LastWeek = 0 then null else CPC推广下单次数LastWeek/CPC推广点击次数LastWeek end,

CPM推广到店转化 = case when CPM推广曝光次数 = 0 then null else CPM推广点击次数/CPM推广曝光次数 end,
CPM推广到店转化LastDay = case when CPM推广曝光次数LastDay = 0 then null else CPM推广点击次数LastDay/CPM推广曝光次数LastDay end,
CPM推广到店转化LastWeek = case when CPM推广曝光次数LastWeek = 0 then null else CPM推广点击次数LastWeek/CPM推广曝光次数LastWeek end,

CPM推广下单转化 = case when CPM推广点击次数 = 0 then null else CPM推广下单次数/CPM推广点击次数 end,
CPM推广下单转化LastDay = case when CPM推广点击次数LastDay = 0 then null else CPM推广下单次数LastDay/CPM推广点击次数LastDay end,
CPM推广下单转化LastWeek = case when CPM推广点击次数LastWeek = 0 then null else CPM推广下单次数LastWeek/CPM推广点击次数LastWeek end
go




/********* 促销活动订单占比结果表 ***********/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=加总 
--select * from [Report].[ResultDeliveryOrderPromotion]
use [MCDDecisionSupport]
go

insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],market,[Date],[Type],[活动订单数])

select '加总',channelname,cityname,market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,cityname,market,convert(varchar(10),下单时间,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
    select channelname,cityname,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode)订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,cityname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='加总' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

------------------ tye=单店日均 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],market,[Date],[Type],[活动订单数])

select '单店日均',channelname,cityname,market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,cityname,market,convert(varchar(10),下单时间,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,cityname,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion] a
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,cityname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='单店日均' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


-------------- 2) market level
------------------ tye=加总 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '加总',channelname,-1,Market,Market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,Market,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='加总' and cityid='-1' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


------单店日均
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均',channelname,-1,Market,Market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,Market,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='单店日均' and cityid='-1' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

-------------- 3) 全国 level
------------------ tye=加总 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '加总',channelname,0,'全国','全国',convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='加总' and cityid='0' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


------单店日均
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均',channelname,0,'全国','全国',convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='单店日均' and cityid='0' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[活动订单数])

select '加总','Total',cityname,Market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by cityname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),下单时间,23) OrderDate
	,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by cityname,Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='加总' and [ChannelName]='total' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '加总','Total',-1,Market,Market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='加总' and [ChannelName]='total' and cityid='-1'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---------全国 level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '加总','Total',0,'全国','全国',convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by convert(varchar(10),下单时间,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='加总' and [ChannelName]='total' and cityid='0'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go



------------------2) tye=单店日均 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均','Total',cityname,Market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by cityname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by cityname,Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='单店日均' and [ChannelName]='total' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均','Total',-1,Market,Market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='单店日均' and [ChannelName]='total' and cityid='-1'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


---------全国 level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均','Total',0,'全国','全国',convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by convert(varchar(10),下单时间,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='单店日均' and [ChannelName]='total' and cityid='0'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


----update lastday/lastweek data
update [Report].[ResultDeliveryOrderPromotion]
set 活动订单数Lastday=b.活动订单数
   ,订单总数Lastday=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
   select CalculateType,channelname,cityname,date,type,活动订单数,订单总数
   from [Report].[ResultDeliveryOrderPromotion]
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and a.cityname=b.cityname and a.type=b.type and a.date=convert(datetime,b.date) + 1 

update [Report].[ResultDeliveryOrderPromotion]
set 活动订单数Lastweek=b.活动订单数
   ,订单总数Lastweek=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
   select CalculateType,channelname,cityname,date,type,活动订单数,订单总数
   from [Report].[ResultDeliveryOrderPromotion]
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and a.cityname=b.cityname and a.type=b.type and a.date=convert(datetime,b.date) + 7

go 

update [Report].[ResultDeliveryOrderPromotion]
set 活动订单占比=活动订单数/订单总数
   ,活动订单占比Lastday=活动订单数Lastday/订单总数Lastday
   ,活动订单占比Lastweek=活动订单数Lastweek/订单总数Lastweek
go


update [Report].[ResultDeliveryOrderPromotion]
set typeid='1' where type='满减' and typeid is null
update [Report].[ResultDeliveryOrderPromotion]
set typeid='2' where type='产品促销' and typeid is null
update [Report].[ResultDeliveryOrderPromotion]
set typeid='3' where type='赠品' and typeid is null

go

update [Report].[ResultDeliveryOrderPromotion]
set [ChannelID]=1 where [ChannelName]='total' and [ChannelID] is null
update [Report].[ResultDeliveryOrderPromotion]
set [ChannelID]=2 where [ChannelName]='Eleme' and [ChannelID] is null
update [Report].[ResultDeliveryOrderPromotion]
set [ChannelID]=3 where [ChannelName]='Meituan' and [ChannelID] is null

go


