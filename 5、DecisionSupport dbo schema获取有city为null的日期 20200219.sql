use [MCDDecisionSupport]
go

--------[Order]有cityname为null的日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[Ordertempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[Ordertempdate]

GO

create table [MCDDecisionSupport].[dbo].[Ordertempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[Ordertempdate]

select distinct convert(varchar(10),下单时间,23) dataperiod
from [MCDDecisionSupport].dbo.[Order]
where cityname is null
order by dataperiod
go


--------[SalesSummary]有cityname为null的日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[SalesSummarytempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[SalesSummarytempdate]

GO

create table [MCDDecisionSupport].[dbo].[SalesSummarytempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[SalesSummarytempdate]

select distinct 日期
from [MCDDecisionSupport].dbo.[SalesSummary]
where cityname is null
order by 日期
go



--------[NaturalTraffic]有cityname为null的日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[NaturalTraffictempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[NaturalTraffictempdate]

GO

create table [MCDDecisionSupport].[dbo].[NaturalTraffictempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[NaturalTraffictempdate]

select distinct DataPeriod
from [MCDDecisionSupport].dbo.[NaturalTraffic]
where cityname is null
order by DataPeriod
go


--------[NaturalTrafficImport]有cityname为null的日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[NaturalTrafficImporttempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempdate]

GO

create table [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempdate]

select distinct DataPeriod
from [MCDDecisionSupport].dbo.[NaturalTrafficImport]
where cityname is null
order by DataPeriod
go



--------[CPCCPMSummary]有cityname为null的日期
--------推广eleme推广下单次数及营业额需要用到[NaturalTraffic][SalesSummary]数据，所以这两张表中city为null的日期也需要
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[CPCCPMSummarytempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[CPCCPMSummarytempdate]

GO

create table [MCDDecisionSupport].[dbo].[CPCCPMSummarytempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[CPCCPMSummarytempdate]

select distinct DataPeriod
from [MCDDecisionSupport].dbo.[CPCCPMSummary]
where cityname is null
union 
select distinct DataPeriod
from [MCDDecisionSupport].dbo.[NaturalTraffic]
where cityname is null
union
select distinct 日期
from [MCDDecisionSupport].dbo.[SalesSummary]
where cityname is null
order by DataPeriod
go


--------[OrderPromotion]有OriginalPromotionInfo需要coding的日期
--------活动订单占比是从[Order]表拿数据，所以也需要[Order]表city为null的日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[OrderPromotiontempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[OrderPromotiontempdate]

GO

create table [MCDDecisionSupport].[dbo].[OrderPromotiontempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[OrderPromotiontempdate]

select distinct convert(varchar(10),下单时间,23) dataperiod
from [MCDDecisionSupport].dbo.[OrderPromotion]
where (OriginalPromotionInfo is not null and OriginalPromotionInfo!='' and OriginalPromotionInfo!='无')
and type is null
union
select distinct convert(varchar(10),下单时间,23) dataperiod
from [MCDDecisionSupport].dbo.[Order]
where cityname is null
order by dataperiod
go

