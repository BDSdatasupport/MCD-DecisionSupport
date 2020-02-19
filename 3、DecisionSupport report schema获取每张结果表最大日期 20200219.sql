use [MCDDecisionSupport]
go


-------��ȡ������������

--------��ȡ����������������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[OrdertempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[OrdertempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[OrdertempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[OrdertempMaxdate]

select max([Date]) dataperiod
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales]
go


--------��ȡӪҵ�������������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate]

select max([date])
from [MCDDecisionSupport].report.ResultDailySales
go



--------��ȡ��Ȼ����������������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate]

select max(DataPeriod)
from [MCDDecisionSupport].[Report].[ResultNaturalTraffic]
go


--------��ȡ��Ȼ������ڽ�����������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate]

select max( DataPeriod)
from [MCDDecisionSupport].[Report].[ResultNaturalTrafficImport]
go



--------��ȡ�ƹ����ݽ�����������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate]

select max( dataperiod)
from [MCDDecisionSupport].[Report].[ResultCPCCPMSummary] 
go


--------��ȡ���������������������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate]

GO

create table [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate]

select max(date)
from [MCDDecisionSupport].[Report].[ResultDeliveryOrderPromotion]
go
