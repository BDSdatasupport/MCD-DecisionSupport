use [MCDDecisionSupport]
go


-------获取结果表最大日期

--------获取订单结果表最大日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[OrdertempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[OrdertempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[OrdertempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[OrdertempMaxdate]

select max([Date]) dataperiod
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
go


--------获取营业额结果表最大日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate]

select max([date])
from [MCDDecisionSupport].report.ResultDailySales
go



--------获取自然流量结果表最大日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate]

select max(DataPeriod)
from [MCDDecisionSupport].[Report].[ResultNaturalTraffic]
go


--------获取自然流量入口结果表最大日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate]

select max( DataPeriod)
from [MCDDecisionSupport].[Report].[ResultNaturalTrafficImport]
go



--------获取推广数据结果表最大日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate]

select max( dataperiod)
from [MCDDecisionSupport].[Report].[ResultCPCCPMSummary] 
go


--------获取订单促销活动结果表最大日期
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate]

select max(date)
from [MCDDecisionSupport].[Report].[ResultDeliveryOrderPromotion]
go
