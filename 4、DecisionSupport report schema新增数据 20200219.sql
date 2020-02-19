

use [MCDDecisionSupport]
go


/****** �������ݽ���� ***********************/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=���� 
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��)

select '����',ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23),sum(a.�����ܽ��)
from [MCDDecisionSupport].dbo.[Order] a
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���,sum(�����ܽ��) as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='����'
and a.[Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go


------------------ tye=�����վ� 
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��)

select '�����վ�',ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go


-------------- 2) market level
------------------ tye=���� 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��)

select CalculateType,ChannelName,-1,Market,Market,[Date],sum(Ӫҵ��),sum(���Ӫҵ��),sum(���Ӫҵ��),sum(�����Ӫҵ��),sum(���Ӫҵ��),sum(��ҹӪҵ��),sum(ͨ��Ӫҵ��)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='����' and ChannelName<>'total'
and [Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by CalculateType,ChannelName,Market,[Date]

go

------------------ tye=�����վ�
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�',ƽ̨,-1,Market,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by ƽ̨,Market,convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select ƽ̨,Market,convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by ƽ̨,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ AND A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and cityid='-1'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go
 

-------------- 3) ȫ�� level
------------------ tye=���� 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��)

select CalculateType,ChannelName,0,'ȫ��','ȫ��',[Date],sum(Ӫҵ��),sum(���Ӫҵ��),sum(���Ӫҵ��),sum(�����Ӫҵ��),sum(���Ӫҵ��),sum(��ҹӪҵ��),sum(ͨ��Ӫҵ��)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='����' and ChannelName<>'total' and cityid is null
and [Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by CalculateType,ChannelName,[Date]

go

------------------ tye=�����վ�
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�',ƽ̨,0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by ƽ̨,convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select ƽ̨,convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by ƽ̨,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ and A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and cityid='0'
and a.Date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go
 


------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
				
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��)

select CalculateType,'Total',cityid,CityName,Market,[Date],sum(Ӫҵ��),sum(���Ӫҵ��),sum(���Ӫҵ��),sum(�����Ӫҵ��),sum(���Ӫҵ��),sum(��ҹӪҵ��),sum(ͨ��Ӫҵ��)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='����' and ChannelName<>'Total'
and [Date] > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by CalculateType,cityid,CityName,Market,[Date]

go

------------------2) tye=�����վ� 
---------city level
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��)

select '�����վ�','Total',cityname,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by cityname,Market,convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select cityname,Market,convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by cityname,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON  A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and ChannelName='total'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go

---------market level
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�','Total',-1,Market,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by Market,convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select Market,convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON  A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and ChannelName='total' and cityid='-1'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go

---------ȫ�� level
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�','Total',0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
group by convert(varchar(10),�µ�ʱ��,23)

go

-----day part sales
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set ���Ӫҵ��=B.[���]
   ,���Ӫҵ��=B.[���]
   ,�����Ӫҵ��=B.[�����]
   ,���Ӫҵ��=B.[���]
   ,��ҹӪҵ��=B.[��ҹ]
   ,ͨ��Ӫҵ��=B.[ͨ��]
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] A
JOIN (
  select *
  from(
	select convert(varchar(10),�µ�ʱ��,23)DATE,ʱ���
	,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END as �ܽ��
	from [MCDDecisionSupport].dbo.[Order] P
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
	group by convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and ChannelName='total' and cityid='0'
and a.date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go


----update lastday/lastweek data
update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set Ӫҵ��Lastday=b.Ӫҵ��
,���Ӫҵ��Lastday=b.���Ӫҵ��
,���Ӫҵ��Lastday=b.���Ӫҵ��
,�����Ӫҵ��Lastday=b.�����Ӫҵ��
,���Ӫҵ��Lastday=b.���Ӫҵ��
,��ҹӪҵ��Lastday=b.��ҹӪҵ��
,ͨ��Ӫҵ��Lastday=b.ͨ��Ӫҵ��
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] a
join(
  select CalculateType,ChannelName,CityName,Market,Date,Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��
  from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
)b
on a.CalculateType=b.CalculateType and a.ChannelName=b.ChannelName and a.CityName=b.CityName and a.date=convert(datetime,b.date) + 1


update [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
set Ӫҵ��Lastweek=b.Ӫҵ��
,���Ӫҵ��Lastweek=b.���Ӫҵ��
,���Ӫҵ��Lastweek=b.���Ӫҵ��
,�����Ӫҵ��Lastweek=b.�����Ӫҵ��
,���Ӫҵ��Lastweek=b.���Ӫҵ��
,��ҹӪҵ��Lastweek=b.��ҹӪҵ��
,ͨ��Ӫҵ��Lastweek=b.ͨ��Ӫҵ��
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] a
join(
  select CalculateType,ChannelName,CityName,Market,Date,Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��
  from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
)b
on a.CalculateType=b.CalculateType and a.ChannelName=b.ChannelName and a.CityName=b.CityName and a.date=convert(datetime,b.date) + 7

go



/**********[Report].[ResultTimeDivisionSalesProportion] �ֶ�Ӫҵ��ռ��********************/

insert into [MCDDecisionSupport].[Report].[ResultTimeDivisionSalesProportion](CalculateType,ChannelName,CityID,CityName,Market,Date,���Ӫҵ��ռ��,���Ӫҵ��ռ��,�����Ӫҵ��ռ��,���Ӫҵ��ռ��,��ҹӪҵ��ռ��,ͨ��Ӫҵ��ռ��,���Ӫҵ��ռ��Lastday,���Ӫҵ��ռ��Lastday,�����Ӫҵ��ռ��Lastday,���Ӫҵ��ռ��Lastday,��ҹӪҵ��ռ��Lastday,ͨ��Ӫҵ��ռ��Lastday,���Ӫҵ��ռ��Lastweek,���Ӫҵ��ռ��Lastweek,�����Ӫҵ��ռ��Lastweek,���Ӫҵ��ռ��Lastweek,��ҹӪҵ��ռ��Lastweek,ͨ��Ӫҵ��ռ��Lastweek)

select CalculateType,ChannelName,CityID,CityName,Market,Date
,���Ӫҵ��/Ӫҵ��,���Ӫҵ��/Ӫҵ��,�����Ӫҵ��/Ӫҵ��,���Ӫҵ��/Ӫҵ��,��ҹӪҵ��/Ӫҵ��,ͨ��Ӫҵ��/Ӫҵ��
,���Ӫҵ��Lastday/Ӫҵ��Lastday,���Ӫҵ��Lastday/Ӫҵ��Lastday,�����Ӫҵ��Lastday/Ӫҵ��Lastday,���Ӫҵ��Lastday/Ӫҵ��Lastday,��ҹӪҵ��Lastday/Ӫҵ��Lastday,ͨ��Ӫҵ��Lastday/Ӫҵ��Lastday
,���Ӫҵ��Lastweek/Ӫҵ��Lastweek,���Ӫҵ��Lastweek/Ӫҵ��Lastweek,�����Ӫҵ��Lastweek/Ӫҵ��Lastweek,���Ӫҵ��Lastweek/Ӫҵ��Lastweek,��ҹӪҵ��Lastweek/Ӫҵ��Lastweek,ͨ��Ӫҵ��Lastweek/Ӫҵ��Lastweek
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
where Date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
go




/******* Ӫҵ���ݽ���� ********/
/******* [MCDDecisionSupport].report.ResultDailySales *******/
------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=���� 

insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '����',ƽ̨,cityname,Market,����,sum(Ӫҵ��),sum(�̻��ܲ���),sum(��Ч������),sum(��Ч������)
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ƽ̨,cityname,Market,����
go


------------------ tye=�����վ� 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '�����վ�',ƽ̨,cityname,Market,����
,case when count(distinct [BDSStoreName])=0 then null else sum(Ӫҵ��)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(�̻��ܲ���)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ƽ̨,cityname,Market,����
go


-------------- 2) market level
------------------ tye=����
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '����',ƽ̨,-1,Market,Market,����,sum(Ӫҵ��),sum(�̻��ܲ���),sum(��Ч������),sum(��Ч������)
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ƽ̨,Market,����
go

------------------ tye=�����վ� 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '�����վ�',ƽ̨,-1,Market,Market,����
,case when count(distinct [BDSStoreName])=0 then null else sum(Ӫҵ��)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(�̻��ܲ���)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ƽ̨,Market,����
go

-------------- 2) ȫ�� level
------------------ tye=����
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '����',ƽ̨,0,'ȫ��','ȫ��',����,sum(Ӫҵ��),sum(�̻��ܲ���),sum(��Ч������),sum(��Ч������)
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ƽ̨,����
go

------------------ tye=�����վ� 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '�����վ�',ƽ̨,0,'ȫ��','ȫ��',����
,case when count(distinct [BDSStoreName])=0 then null else sum(Ӫҵ��)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(�̻��ܲ���)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ƽ̨,����
go


------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '����','Total',cityid,CityName,Market,[Date],sum(Ӫҵ��),sum(�̻�����),sum(��Ч������),sum(��Ч������)
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻�����)/sum(��Ч������)end
from [MCDDecisionSupport].report.ResultDailySales
where CalculateType='����'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by cityid,CityName,Market,[Date]
go


------------------2) tye=�����վ� 
---------city level
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '�����վ�','Total',cityname,Market,����
,case when count(distinct [BDSStoreName])=0 then null else sum(Ӫҵ��)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(�̻��ܲ���)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by cityname,Market,����
go

---------market level
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '�����վ�','Total',-1,Market,Market,����
,case when count(distinct [BDSStoreName])=0 then null else sum(Ӫҵ��)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(�̻��ܲ���)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by Market,����
go

---------ȫ�� level
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '�����վ�','Total',0,'ȫ��','ȫ��',����
,case when count(distinct [BDSStoreName])=0 then null else sum(Ӫҵ��)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(�̻��ܲ���)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when count(distinct [BDSStoreName])=0 then null else sum(��Ч������)/count(distinct [BDSStoreName])end
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ���� > (select DataPeriod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
group by ����
go


---update lastday/lastweek data
update [MCDDecisionSupport].report.ResultDailySales
set Ӫҵ��LastDay=b.Ӫҵ��
,�̻�����LastDay=b.�̻�����
,��Ч������LastDay=b.��Ч������
,��Ч������LastDay=b.��Ч������
,�͵���LastDay=b.�͵���
from [MCDDecisionSupport].report.ResultDailySales a
join (
  select CalculateType,channelname,CityName,date,Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���
  from [MCDDecisionSupport].report.ResultDailySales
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and  a.CityName=b.CityName and  a.date=convert(datetime,b.date) + 1 
go

update [MCDDecisionSupport].report.ResultDailySales
set Ӫҵ��LastWeek=b.Ӫҵ��
,�̻�����LastWeek=b.�̻�����
,��Ч������LastWeek=b.��Ч������
,��Ч������LastWeek=b.��Ч������
,�͵���LastWeek=b.�͵���
from [MCDDecisionSupport].report.ResultDailySales a
join (
  select CalculateType,channelname,CityName,date,Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���
  from [MCDDecisionSupport].report.ResultDailySales
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and  a.CityName=b.CityName and  a.date=convert(datetime,b.date) + 7
go




/******** ��Ȼ��������� *************/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,sum([��Ȼ�ع�����]),sum([��Ȼ��������]),sum([��Ȼ�µ�����])
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ��������])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�µ�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,-1,Market,Market,sum([��Ȼ�ع�����]),sum([��Ȼ��������]),sum([��Ȼ�µ�����])
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,-1,Market,Market
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ��������])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�µ�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

-------------- 3) ȫ�� level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��',sum([��Ȼ�ع�����]),sum([��Ȼ��������]),sum([��Ȼ�µ�����])
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��'
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ��������])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�µ�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO



------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '����','Total',1,DataPeriod,cityID,cityname,Market,sum([��Ȼ�ع�����]),sum([��Ȼ��������]),sum([��Ȼ�µ�����])
FROM [Report].[ResultNaturalTraffic] 
where CalculateType='����'
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,cityID,cityname,Market
ORDER BY DataPeriod,cityID,cityname,Market

GO
				

------------------2) tye=�����վ� 
---------city level
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '�����վ�','Total',1,DataPeriod,cityname,CityTier,Market
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ��������])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�µ�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY cityname,DataPeriod,CityTier,Market
ORDER BY cityname,DataPeriod

GO

---------market level
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '�����վ�','Total',1,DataPeriod,-1,Market,Market
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ��������])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�µ�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod,Market
ORDER BY DataPeriod

GO

----ȫ�� level
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '�����վ�','Total',1,DataPeriod,0,'ȫ��','ȫ��'
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ��������])/count(distinct BDSStoreName)end
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�µ�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTraffic]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
GROUP BY DataPeriod
ORDER BY DataPeriod

GO


--

UPDATE [Report].[ResultNaturalTraffic]
set [��Ȼ����ת����] = ��Ȼ��������/��Ȼ�ع�����
WHERE ��Ȼ�ع����� <>0 

GO

UPDATE [Report].[ResultNaturalTraffic]
set [��Ȼ�µ�ת����] = ��Ȼ�µ�����/��Ȼ��������
WHERE ��Ȼ�������� <>0

GO



-- LAST DAY 
UPDATE [Report].[ResultNaturalTraffic]
SET [��Ȼ�ع�����LastDay] = b.[��Ȼ�ع�����],
	[��Ȼ��������LastDay] = b.[��Ȼ��������],
	[��Ȼ�µ�����LastDay] = b.[��Ȼ�µ�����],
	[��Ȼ����ת����LastDay] = b.[��Ȼ����ת����],
	[��Ȼ�µ�ת����LastDay] = b.[��Ȼ�µ�ת����]
FROM [Report].[ResultNaturalTraffic] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.DataPeriod,A.CalculateType,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����],[��Ȼ����ת����],[��Ȼ�µ�ת����]
	FROM [Report].[ResultNaturalTraffic] a
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,B.DataPeriod) + 1
AND A.CalculateType= b.CalculateType


-- LAST WEEK 
UPDATE [Report].[ResultNaturalTraffic]
SET [��Ȼ�ع�����LastWeek] = b.[��Ȼ�ع�����],
	[��Ȼ��������LastWeek] = b.[��Ȼ��������],
	[��Ȼ�µ�����LastWeek] = b.[��Ȼ�µ�����],
	[��Ȼ����ת����LastWeek] = b.[��Ȼ����ת����],
	[��Ȼ�µ�ת����LastWeek] = b.[��Ȼ�µ�ת����]
FROM [Report].[ResultNaturalTraffic] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.Market,a.DataPeriod,A.CalculateType,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����],[��Ȼ����ת����],[��Ȼ�µ�ת����]
	FROM [Report].[ResultNaturalTraffic] a

) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,B.DataPeriod) + 7
AND A.CalculateType=B.CalculateType


GO




/********** ��Ȼ������ڽ���� *************/

--city level 
------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[�б���],[��Ȼ�ع�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[�б���],sum([��Ȼ�ع�����])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[�б���]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[�б���],[��Ȼ�ع�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[�б���]
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[�б���]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[�б���],sum([��Ȼ�ع�����])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[�б���]
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO

-------------- 3) ȫ�� level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��',[�б���],sum([��Ȼ�ع�����])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��',[�б���]
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO



--ռ��
UPDATE [Report].[ResultNaturalTrafficImport]
SET [�ع�ռ��] = a.[��Ȼ�ع�����] / b.[��Ȼ�ع�����]
FROM [Report].[ResultNaturalTrafficImport] a
JOIN
(
	SELECT CalculateType,ChannelName,ChannelID,DataPeriod,cityname,sum([��Ȼ�ع�����]) as [��Ȼ�ع�����]
	FROM  [Report].[ResultNaturalTrafficImport]
	GROUP BY CalculateType,ChannelName,ChannelID,DataPeriod,cityname
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
and a.CalculateType=b.CalculateType
WHERE b.[��Ȼ�ع�����] <> 0

GO


-- LAST DAY 
UPDATE [Report].[ResultNaturalTrafficImport]
SET [��Ȼ�ع�����LastDay] = b.[��Ȼ�ع�����],
	[�ع�ռ��LastDay] = b.[�ع�ռ��]
FROM [Report].[ResultNaturalTrafficImport] a
JOIN 
(
	SELECT CalculateType,ChannelID,cityname,DataPeriod,�б���,[��Ȼ�ع�����],[�ع�ռ��]
	FROM [Report].[ResultNaturalTrafficImport] 	
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 1 
and a.CalculateType=b.CalculateType
and a.�б���=b.�б���


-- LAST WEEK 
UPDATE [Report].[ResultNaturalTrafficImport]
SET [��Ȼ�ع�����LastWeek] = b.[��Ȼ�ع�����],
	[�ع�ռ��LastWeek] = b.[�ع�ռ��]
FROM [Report].[ResultNaturalTrafficImport] a
JOIN 
(
	SELECT CalculateType,ChannelID,cityname,DataPeriod,�б���,[��Ȼ�ع�����],[�ع�ռ��]
	FROM [Report].[ResultNaturalTrafficImport] 	 
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 7
and a.CalculateType=b.CalculateType
and a.�б���=b.�б���

GO


update [MCDDecisionSupport].[Report].[ResultNaturalTrafficImport]
set [�б���ID] = 
case when [ChannelName] = 'Eleme' and [�б���] = '����' then '1'
when [ChannelName] = 'Eleme' and [�б���] = 'Ʒ�����' then '2'
when [ChannelName] = 'Eleme' and [�б���] = '����ģ��' then '3'
when [ChannelName] = 'Eleme' and [�б���] = '�Ƽ��̼��б�' then '4'
when [ChannelName] = 'Eleme' and [�б���] = '����' then '5'
when [ChannelName] = 'Meituan' and [�б���] = '�̼��б�' then '1'
when [ChannelName] = 'Meituan' and [�б���] = 'Ϊ����ѡ' then '2'
when [ChannelName] = 'Meituan' and [�б���] = '����' then '3'
when [ChannelName] = 'Meituan' and [�б���] = '�˿Ͷ���ҳ' then '4'
when [ChannelName] = 'Meituan' and [�б���] = '����' then '5'

end

where [�б���ID] is null
go




/*********** �ƹ����ݽ���� ***************/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=���� 

INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '����',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,sum(�ƹ����) as CPC�ƹ����
	,sum(�ƹ������Ӫҵ��) as CPC�ƹ������Ӫҵ��
	,sum(�ƹ��ع����) as CPC�ƹ��ع����
	,sum(�ƹ�������) as CPC�ƹ�������
	,sum(�ƹ��µ�����) as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='����'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,sum(�ƹ����) as CPM�ƹ����
	,sum(�ƹ������Ӫҵ��) as CPM�ƹ������Ӫҵ��
	,sum(�ƹ��ع����) as CPM�ƹ��ع����
	,sum(�ƹ�������) as CPM�ƹ�������
	,sum(�ƹ��µ�����) as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='����'

GO


------------------ tye=�����վ� 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPC�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPC�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPC�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPC�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPM�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPM�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPM�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPM�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�'

GO

-------------- 2) market level
------------------ tye=���� 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,CPC�ƹ����,CPC�ƹ������Ӫҵ��,CPC�ƹ��ع����,CPC�ƹ�������,CPC�ƹ��µ�����,CPM�ƹ����,CPM�ƹ������Ӫҵ��,CPM�ƹ��ع����,CPM�ƹ�������,CPM�ƹ��µ�����)

SELECT '����',ChannelName,ChannelID,DataPeriod,-1,Market,Market
,sum(CPC�ƹ����) as CPC�ƹ����,sum(CPC�ƹ������Ӫҵ��) as CPC�ƹ������Ӫҵ��,sum(CPC�ƹ��ع����) as CPC�ƹ��ع����,sum(CPC�ƹ�������) as CPC�ƹ�������,sum(CPC�ƹ��µ�����) as CPC�ƹ��µ�����
,sum(CPM�ƹ����) as CPM�ƹ����,sum(CPM�ƹ������Ӫҵ��) as CPM�ƹ������Ӫҵ��,sum(CPM�ƹ��ع����) as CPM�ƹ��ع����,sum(CPM�ƹ�������) as CPM�ƹ�������,sum(CPM�ƹ��µ�����) as CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] 
WHERE CalculateType='����'
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ�
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,-1,Market,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod,Market
ORDER BY ChannelName,ChannelID,DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPC�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPC�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPC�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPC�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY Market,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' AND cityid='-1'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPM�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPM�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPM�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPM�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY Market,DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' AND cityid='-1'

GO

-------------- 3) ȫ�� level
------------------ tye=���� 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,CPC�ƹ����,CPC�ƹ������Ӫҵ��,CPC�ƹ��ع����,CPC�ƹ�������,CPC�ƹ��µ�����,CPM�ƹ����,CPM�ƹ������Ӫҵ��,CPM�ƹ��ع����,CPM�ƹ�������,CPM�ƹ��µ�����)

SELECT '����',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��'
,sum(CPC�ƹ����) as CPC�ƹ����,sum(CPC�ƹ������Ӫҵ��) as CPC�ƹ������Ӫҵ��,sum(CPC�ƹ��ع����) as CPC�ƹ��ع����,sum(CPC�ƹ�������) as CPC�ƹ�������,sum(CPC�ƹ��µ�����) as CPC�ƹ��µ�����
,sum(CPM�ƹ����) as CPM�ƹ����,sum(CPM�ƹ������Ӫҵ��) as CPM�ƹ������Ӫҵ��,sum(CPM�ƹ��ع����) as CPM�ƹ��ع����,sum(CPM�ƹ�������) as CPM�ƹ�������,sum(CPM�ƹ��µ�����) as CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] 
WHERE CalculateType='����' and cityid is null
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ�
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��'
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY ChannelName,ChannelID,DataPeriod
ORDER BY ChannelName,ChannelID,DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPC�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPC�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPC�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPC�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' AND cityid='0'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT ChannelName,ChannelID,DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPM�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPM�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPM�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPM�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,ChannelName,ChannelID
) b
ON a.ChannelID = b.ChannelID
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' AND cityid='0'

GO




------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,CPC�ƹ����,CPC�ƹ������Ӫҵ��,CPC�ƹ��ع����,CPC�ƹ�������,CPC�ƹ��µ�����,CPM�ƹ����,CPM�ƹ������Ӫҵ��,CPM�ƹ��ع����,CPM�ƹ�������,CPM�ƹ��µ�����)

SELECT '����','Total',1,DataPeriod,cityid,cityname,Market
,sum(CPC�ƹ����) as CPC�ƹ����,sum(CPC�ƹ������Ӫҵ��) as CPC�ƹ������Ӫҵ��,sum(CPC�ƹ��ع����) as CPC�ƹ��ع����,sum(CPC�ƹ�������) as CPC�ƹ�������,sum(CPC�ƹ��µ�����) as CPC�ƹ��µ�����
,sum(CPM�ƹ����) as CPM�ƹ����,sum(CPM�ƹ������Ӫҵ��) as CPM�ƹ������Ӫҵ��,sum(CPM�ƹ��ع����) as CPM�ƹ��ع����,sum(CPM�ƹ�������) as CPM�ƹ�������,sum(CPM�ƹ��µ�����) as CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] 
WHERE CalculateType='����'
and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,cityid,cityname,Market
ORDER BY DataPeriod,cityname

GO

			
------------------2) tye=�����վ� 
---------city level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '�����վ�','Total',1,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY cityname,DataPeriod,CityTier,Market
ORDER BY cityname,DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPC�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPC�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPC�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPC�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod
) b
ON  a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' and ChannelName='Total'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,cityname
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPM�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPM�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPM�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPM�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY cityname,DataPeriod
) b
ON a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' and ChannelName='Total'

GO

---------market level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '�����վ�','Total',1,DataPeriod,-1,Market,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod,Market
ORDER BY DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPC�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPC�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPC�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPC�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,Market
) b
ON a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�'  and ChannelName='Total' and cityid='-1'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod,Market
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPM�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPM�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPM�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPM�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod,Market
) b
ON  a.cityname = b.Market
AND a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' and ChannelName='Total' and cityid='-1'

GO

---------ȫ�� level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '�����վ�','Total',1,DataPeriod,0,'ȫ��','ȫ��'
FROM [dbo].[CPCCPMSummary]
where DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
GROUP BY DataPeriod
ORDER BY DataPeriod
GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ���� = b.CPC�ƹ����,
CPC�ƹ������Ӫҵ�� = b.CPC�ƹ������Ӫҵ��,
CPC�ƹ��ع���� = b.CPC�ƹ��ع����,
CPC�ƹ������� = b.CPC�ƹ�������,
CPC�ƹ��µ����� = b.CPC�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPC�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPC�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPC�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPC�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPC�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPC'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod
) b
ON  a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�'  and ChannelName='Total' and cityid='0'

GO

UPDATE [Report].[ResultCPCCPMSummary]
SET CPM�ƹ���� = b.CPM�ƹ����,
CPM�ƹ������Ӫҵ�� = b.CPM�ƹ������Ӫҵ��,
CPM�ƹ��ع���� = b.CPM�ƹ��ع����,
CPM�ƹ������� = b.CPM�ƹ�������,
CPM�ƹ��µ����� = b.CPM�ƹ��µ�����
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT DataPeriod
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ����)/count(distinct BDSStoreName) end as CPM�ƹ����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ������Ӫҵ��)/count(distinct BDSStoreName) end  as CPM�ƹ������Ӫҵ��
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��ع����)/count(distinct BDSStoreName) end  as CPM�ƹ��ع����
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ�������)/count(distinct BDSStoreName) end  as CPM�ƹ�������
	,case count(distinct BDSStoreName) when 0 then null else sum(�ƹ��µ�����)/count(distinct BDSStoreName) end  as CPM�ƹ��µ�����
	FROM [dbo].[CPCCPMSummary]
	WHERE 1 = 1
	AND PromotionType = 'CPM'
	and DataPeriod > (select DataPeriod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
	GROUP BY DataPeriod
) b
ON a.DataPeriod = b.DataPeriod
where a.CalculateType='�����վ�' and ChannelName='Total' and cityid='0'

GO



--CPCROI
UPDATE [Report].[ResultCPCCPMSummary]
SET CPCROI = CPC�ƹ������Ӫҵ��/CPC�ƹ����
WHERE CPC�ƹ���� <>0
GO

--CPMROI
UPDATE [Report].[ResultCPCCPMSummary]
SET CPMROI = CPM�ƹ������Ӫҵ��/CPM�ƹ����
WHERE CPM�ƹ���� <>0
GO


-------------------------------------------------------------------------------------------------

-- LAST DAY 
UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ����LastDay = b.CPC�ƹ����,
	CPC�ƹ������Ӫҵ��LastDay = b.CPC�ƹ������Ӫҵ��,
	CPC�ƹ��ع����LastDay = b.CPC�ƹ��ع����,
	CPC�ƹ�������LastDay = b.CPC�ƹ�������,
	CPC�ƹ��µ�����LastDay = b.CPC�ƹ��µ�����,
	CPCROILastDay = b.CPCROI,
	CPM�ƹ����LastDay = b.CPM�ƹ����,
	CPM�ƹ������Ӫҵ��LastDay = b.CPM�ƹ������Ӫҵ��,
	CPM�ƹ��ع����LastDay = b.CPM�ƹ��ع����,
	CPM�ƹ�������LastDay = b.CPM�ƹ�������,
	CPM�ƹ��µ�����LastDay = b.CPM�ƹ��µ�����,
	CPMROILastDay = b.CPMROI
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.DataPeriod,a.CalculateType,CPC�ƹ����,CPC�ƹ������Ӫҵ��,CPC�ƹ��ع����,CPC�ƹ�������,CPC�ƹ��µ�����,CPCROI,CPM�ƹ����,CPM�ƹ������Ӫҵ��,CPM�ƹ��ع����,CPM�ƹ�������,CPM�ƹ��µ�����,CPMROI
	FROM [Report].[ResultCPCCPMSummary] a
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 1 
and A.CalculateType=B.CalculateType


-- LAST WEEK 
UPDATE [Report].[ResultCPCCPMSummary]
SET CPC�ƹ����LastWeek = b.CPC�ƹ����,
	CPC�ƹ������Ӫҵ��LastWeek = b.CPC�ƹ������Ӫҵ��,
	CPC�ƹ��ع����LastWeek = b.CPC�ƹ��ع����,
	CPC�ƹ�������LastWeek = b.CPC�ƹ�������,
	CPC�ƹ��µ�����LastWeek = b.CPC�ƹ��µ�����,
	CPCROILastWeek = b.CPCROI,
	CPM�ƹ����LastWeek = b.CPM�ƹ����,
	CPM�ƹ������Ӫҵ��LastWeek = b.CPM�ƹ������Ӫҵ��,
	CPM�ƹ��ع����LastWeek = b.CPM�ƹ��ع����,
	CPM�ƹ�������LastWeek = b.CPM�ƹ�������,
	CPM�ƹ��µ�����LastWeek = b.CPM�ƹ��µ�����,
	CPMROILastWeek = b.CPMROI
FROM [Report].[ResultCPCCPMSummary] a
JOIN 
(
	SELECT a.ChannelID,a.cityname,a.GM,a.Market,a.DataPeriod,a.CalculateType,
	CPC�ƹ����,CPC�ƹ������Ӫҵ��,CPC�ƹ��ع����,CPC�ƹ�������,CPC�ƹ��µ�����,CPCROI,CPM�ƹ����,CPM�ƹ������Ӫҵ��,CPM�ƹ��ع����,CPM�ƹ�������,CPM�ƹ��µ�����,CPMROI
	FROM [Report].[ResultCPCCPMSummary] a
) b
ON a.ChannelID = b.ChannelID
AND a.cityname = b.cityname
AND a.DataPeriod = convert(datetime,b.DataPeriod) + 7 
AND A.CalculateType=B.CalculateType

GO


update [MCDDecisionSupport].[Report].[ResultCPCCPMSummary]
set 
CPC�ƹ㵽��ת�� = case when CPC�ƹ��ع���� = 0 then null else CPC�ƹ�������/CPC�ƹ��ع���� end,
CPC�ƹ㵽��ת��LastDay = case when CPC�ƹ��ع����LastDay = 0 then null else CPC�ƹ�������LastDay/CPC�ƹ��ع����LastDay end,
CPC�ƹ㵽��ת��LastWeek = case when CPC�ƹ��ع����LastWeek = 0 then null else CPC�ƹ�������LastWeek/CPC�ƹ��ع����LastWeek end,

CPC�ƹ��µ�ת�� = case when CPC�ƹ������� = 0 then null else CPC�ƹ��µ�����/CPC�ƹ������� end,
CPC�ƹ��µ�ת��LastDay = case when CPC�ƹ�������LastDay = 0 then null else CPC�ƹ��µ�����LastDay/CPC�ƹ�������LastDay end,
CPC�ƹ��µ�ת��LastWeek = case when CPC�ƹ�������LastWeek = 0 then null else CPC�ƹ��µ�����LastWeek/CPC�ƹ�������LastWeek end,

CPM�ƹ㵽��ת�� = case when CPM�ƹ��ع���� = 0 then null else CPM�ƹ�������/CPM�ƹ��ع���� end,
CPM�ƹ㵽��ת��LastDay = case when CPM�ƹ��ع����LastDay = 0 then null else CPM�ƹ�������LastDay/CPM�ƹ��ع����LastDay end,
CPM�ƹ㵽��ת��LastWeek = case when CPM�ƹ��ع����LastWeek = 0 then null else CPM�ƹ�������LastWeek/CPM�ƹ��ع����LastWeek end,

CPM�ƹ��µ�ת�� = case when CPM�ƹ������� = 0 then null else CPM�ƹ��µ�����/CPM�ƹ������� end,
CPM�ƹ��µ�ת��LastDay = case when CPM�ƹ�������LastDay = 0 then null else CPM�ƹ��µ�����LastDay/CPM�ƹ�������LastDay end,
CPM�ƹ��µ�ת��LastWeek = case when CPM�ƹ�������LastWeek = 0 then null else CPM�ƹ��µ�����LastWeek/CPM�ƹ�������LastWeek end
go




/********* ���������ռ�Ƚ���� ***********/

------------1. channel=eleme/meituan
-------------- 1) CITY LEVEL
------------------ tye=���� 
--select * from [Report].[ResultDeliveryOrderPromotion]
use [MCDDecisionSupport]
go

insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],market,[Date],[Type],[�������])

select '����',channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
    select channelname,cityname,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode)��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,cityname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='����' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

------------------ tye=�����վ� 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],market,[Date],[Type],[�������])

select '�����վ�',channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,cityname,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion] a
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,cityname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


-------------- 2) market level
------------------ tye=���� 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '����',channelname,-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='����' and cityid='-1' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


------�����վ�
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '�����վ�',channelname,-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and cityid='-1' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

-------------- 3) ȫ�� level
------------------ tye=���� 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '����',channelname,0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='����' and cityid='0' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


------�����վ�
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '�����վ�',channelname,0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by channelname,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by channelname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and cityid='0' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[�������])

select '����','Total',cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by cityname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='����' and [ChannelName]='total' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '����','Total',-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='����' and [ChannelName]='total' and cityid='-1'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---------ȫ�� level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '����','Total',0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by convert(varchar(10),�µ�ʱ��,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='����' and [ChannelName]='total' and cityid='0'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go



------------------2) tye=�����վ� 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[�������])

select '�����վ�','Total',cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by cityname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and [ChannelName]='total' and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '�����վ�','Total',-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and [ChannelName]='total' and cityid='-1'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


---------ȫ�� level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '�����վ�','Total',0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
group by convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23) > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
	group by convert(varchar(10),�µ�ʱ��,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='�����վ�' and [ChannelName]='total' and cityid='0'
and date > (select DataPeriod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go


----update lastday/lastweek data
update [Report].[ResultDeliveryOrderPromotion]
set �������Lastday=b.�������
   ,��������Lastday=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
   select CalculateType,channelname,cityname,date,type,�������,��������
   from [Report].[ResultDeliveryOrderPromotion]
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and a.cityname=b.cityname and a.type=b.type and a.date=convert(datetime,b.date) + 1 

update [Report].[ResultDeliveryOrderPromotion]
set �������Lastweek=b.�������
   ,��������Lastweek=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
   select CalculateType,channelname,cityname,date,type,�������,��������
   from [Report].[ResultDeliveryOrderPromotion]
)b
on a.CalculateType=b.CalculateType and a.channelname=b.channelname and a.cityname=b.cityname and a.type=b.type and a.date=convert(datetime,b.date) + 7

go 

update [Report].[ResultDeliveryOrderPromotion]
set �����ռ��=�������/��������
   ,�����ռ��Lastday=�������Lastday/��������Lastday
   ,�����ռ��Lastweek=�������Lastweek/��������Lastweek
go


update [Report].[ResultDeliveryOrderPromotion]
set typeid='1' where type='����' and typeid is null
update [Report].[ResultDeliveryOrderPromotion]
set typeid='2' where type='��Ʒ����' and typeid is null
update [Report].[ResultDeliveryOrderPromotion]
set typeid='3' where type='��Ʒ' and typeid is null

go

update [Report].[ResultDeliveryOrderPromotion]
set [ChannelID]=1 where [ChannelName]='total' and [ChannelID] is null
update [Report].[ResultDeliveryOrderPromotion]
set [ChannelID]=2 where [ChannelName]='Eleme' and [ChannelID] is null
update [Report].[ResultDeliveryOrderPromotion]
set [ChannelID]=3 where [ChannelName]='Meituan' and [ChannelID] is null

go


