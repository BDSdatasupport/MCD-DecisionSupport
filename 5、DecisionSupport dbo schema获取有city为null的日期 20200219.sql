use [MCDDecisionSupport]
go

--------[Order]��citynameΪnull������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[Ordertempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[Ordertempdate]

GO

create table [MCDDecisionSupport].[dbo].[Ordertempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[Ordertempdate]

select distinct convert(varchar(10),�µ�ʱ��,23) dataperiod
from [MCDDecisionSupport].dbo.[Order]
where cityname is null
order by dataperiod
go


--------[SalesSummary]��citynameΪnull������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[SalesSummarytempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[SalesSummarytempdate]

GO

create table [MCDDecisionSupport].[dbo].[SalesSummarytempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[SalesSummarytempdate]

select distinct ����
from [MCDDecisionSupport].dbo.[SalesSummary]
where cityname is null
order by ����
go



--------[NaturalTraffic]��citynameΪnull������
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


--------[NaturalTrafficImport]��citynameΪnull������
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



--------[CPCCPMSummary]��citynameΪnull������
--------�ƹ�eleme�ƹ��µ�������Ӫҵ����Ҫ�õ�[NaturalTraffic][SalesSummary]���ݣ����������ű���cityΪnull������Ҳ��Ҫ
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
select distinct ����
from [MCDDecisionSupport].dbo.[SalesSummary]
where cityname is null
order by DataPeriod
go


--------[OrderPromotion]��OriginalPromotionInfo��Ҫcoding������
--------�����ռ���Ǵ�[Order]�������ݣ�����Ҳ��Ҫ[Order]��cityΪnull������
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[OrderPromotiontempdate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[OrderPromotiontempdate]

GO

create table [MCDDecisionSupport].[dbo].[OrderPromotiontempdate](dataperiod date)
go

insert into [MCDDecisionSupport].[dbo].[OrderPromotiontempdate]

select distinct convert(varchar(10),�µ�ʱ��,23) dataperiod
from [MCDDecisionSupport].dbo.[OrderPromotion]
where (OriginalPromotionInfo is not null and OriginalPromotionInfo!='' and OriginalPromotionInfo!='��')
and type is null
union
select distinct convert(varchar(10),�µ�ʱ��,23) dataperiod
from [MCDDecisionSupport].dbo.[Order]
where cityname is null
order by dataperiod
go

