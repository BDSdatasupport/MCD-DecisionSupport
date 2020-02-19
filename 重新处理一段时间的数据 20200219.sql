USE [MCDDecisionSupport]
GO

delete from [Order] where convert(varchar(10),�µ�ʱ��,23) between '' and ''
delete from [SalesSummary] where ���� between '' and ''
delete from [NaturalTraffic] where [DataPeriod] between '' and ''
delete from [NaturalTrafficImport] where [DataPeriod] between '' and ''
delete from [CPCCPMSummary] where [DataPeriod] between '' and '' --��[NaturalTraffic]��[SalesSummary]Ҳ�йأ��������ű�����һ����ĳ��Ķ���cpccpmҲҪ���¼���
delete from [OrderPromotion] where convert(varchar(10),�µ�ʱ��,23) between '' and '' --��[Order]�й�


delete from [report].[ResultTimeDivisionSales] where [Date] between '' and '' --��[Order]�й�
delete from [report].[ResultTimeDivisionSalesProportion] where [Date] between '' and ''   --��[ResultTimeDivisionSales]�й�
delete from [report].ResultDailySales where [Date] between '' and '' --��[SalesSummary]�й�
delete from [report].[ResultNaturalTraffic] where DataPeriod between '' and '' --��[NaturalTraffic]�й�
delete from [report].[ResultNaturalTrafficImport] where DataPeriod between '' and '' --��[NaturalTrafficImport]�й�
delete from [report].[ResultCPCCPMSummary] where DataPeriod between '' and '' --��[CPCCPMSummary]�й�
delete from [report].[ResultDeliveryOrderPromotion] where [Date] between '' and ''--��[OrderPromotion]�й�
go



---------------- dbo ----------------
USE [MCDDecisionSupport]
GO

-----��ȡÿ��dbo���������


/***** �������� �����ڼ����ʱ���Ӫҵ�� *******************/

-----ÿ���ȡǰһ��� internal ��������
insert into [MCDDecisionSupport].dbo.[Order](ƽ̨,�������,�ӵ�ʱ��,��������,�̻����,����,֧����ʽ,����״̬,��������״̬,���ͷ�ʽ,����ȡ��ԭ��,�Ƿ�Ԥ����,�µ�ʱ��,�ӵ�ʱ��,�������ʱ��,����ʱ��,Ԥ���ʹ�ʱ��,�����ܽ��,ʵ�����,ƽ̨�����,�̼һ����,�̻����Ͳ���,���ͷ�,�Ƿ�����,�Żݻ,��Ʒ��Ϣ,�ͺз��ܽ��,�ͺ�������,��������,��������,�Ƿ�ߵ�,�ظ�״̬,�̼һظ�����,�̼��Ż�ȯ�������,��Ʒԭ��)

select ƽ̨,�������,�ӵ�ʱ��,��������,�̻����,����,֧����ʽ,����״̬,��������״̬,���ͷ�ʽ,����ȡ��ԭ��,�Ƿ�Ԥ����,�µ�ʱ��,�ӵ�ʱ��,�������ʱ��,����ʱ��,Ԥ���ʹ�ʱ��,�����ܽ��,ʵ�����,ƽ̨�����,�̼һ����,�̻����Ͳ���,���ͷ�,�Ƿ�����,�Żݻ,��Ʒ��Ϣ,�ͺз��ܽ��,�ͺ�������,��������,��������,�Ƿ�ߵ�,�ظ�״̬,�̼һظ�����,�̼��Ż�ȯ�������,��Ʒԭ��
from [MCD].[Internal].[Order]
where convert(varchar(10),�µ�ʱ��,23) between '' and ''
order by �µ�ʱ��
go


----remove duplicate data
DELETE FROM a  
FROM
(
SELECT *,row_number() over(partition by [ƽ̨],[�������] order by insertdate desc)rn
FROM [MCDDecisionSupport].dbo.[Order]
WHERE convert(date,insertdate) > convert(date,getdate()-7)
) a
WHERE a.rn > 1
GO



-----update daypart
update [MCDDecisionSupport].dbo.[Order]
set ʱ��� ='���' where DATEPART(hh,�µ�ʱ��) between '6' and '10' and ʱ��� is null
update [MCDDecisionSupport].dbo.[Order]
set ʱ��� ='���' where DATEPART(hh,�µ�ʱ��) between '11' and '13' and ʱ��� is null
update [MCDDecisionSupport].dbo.[Order]
set ʱ��� ='�����' where DATEPART(hh,�µ�ʱ��) between '14' and '16' and ʱ��� is null
update [MCDDecisionSupport].dbo.[Order]
set ʱ��� ='���' where DATEPART(hh,�µ�ʱ��) between '17' and '19' and ʱ��� is null
update [MCDDecisionSupport].dbo.[Order]
set ʱ��� ='��ҹ' where DATEPART(hh,�µ�ʱ��) between '20' and '23' and ʱ��� is null
update [MCDDecisionSupport].dbo.[Order]
set ʱ��� ='ͨ��' where DATEPART(hh,�µ�ʱ��) between '0' and '5' and ʱ��� is null

go


----�������Ʋ�Ϊ�� �̻���Ų�Ϊ��
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.EleMeOriginalShopName and a.�̻����=b.EleMeID
where ��������!='' and ƽ̨='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.MeiTuanOriginalShopName and a.�̻����=b.MeiTuanID
where ��������!='' and ƽ̨='meituan' and a.[BDSStoreName] is null

go

----�������Ʋ�Ϊ�� �̻����Ϊ��
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.EleMeOriginalShopName
where ��������!='' and ƽ̨='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.MeiTuanOriginalShopName
where ��������!='' and ƽ̨='meituan' and a.[BDSStoreName] is null

go

----��������Ϊ�� �̻���Ų�Ϊ��
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.�̻����=b.EleMeID
where ��������='' and �̻���� is not null and ƽ̨='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.�̻����=b.MeiTuanID
where ��������='' and �̻���� is not null and ƽ̨='meituan' and a.[BDSStoreName] is null

go


----��������Ϊ��  �̻����Ϊ��
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.EleMeOriginalShopName
where ��������='' and �̻���� is null and ƽ̨='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.MeiTuanOriginalShopName
where ��������='' and �̻���� is null and ƽ̨='meituan' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
set [Market]='Others' where [Market] is null and cityname is not null
go




/******** Ӫҵ���� **************/

/*****[MCDDecisionSupport].dbo.[SalesSummary]  ����ʱ���*******************/
-----Ӫҵ��

---meituan
insert into [MCDDecisionSupport].dbo.[SalesSummary](ƽ̨,����,��������,���̱��,Ӫҵ��,��Ч������,Ԥ������,��Ʒ����,�ͺ�����,��������,�̻�����,ƽ̨����,�͵���,��Ч������)

select ƽ̨,data_date,shop_name,wm_poi_id,turnover,effectiveOrders,orderTurnover,foodPrice,boxPrice,shippingFee,bizSubsidy,mtSubsidy,pricePerOrder,invalidOrders
from(
	select 'MeiTuan' as ƽ̨,data_date,shop_name,wm_poi_id,turnover,effectiveOrders,orderTurnover,foodPrice,boxPrice,shippingFee,bizSubsidy,mtSubsidy,pricePerOrder,invalidOrders
	,ROW_NUMBER() over(partition by data_date,wm_poi_id order by turnover desc,create_time desc) rn
	from [MCD].[Internal].[t_meituan_sales_info_by_shop]
	where data_date between '' and ''
)a
where rn=1
go


---EleMe
insert into [MCDDecisionSupport].dbo.[SalesSummary](ƽ̨,����,��������,���̱��,Ӫҵ��,��Ч������,��Ʒ����,�ͺ�����,��������,��Ч������,����֧��,ȥ�����͵���,Ԥ�ƶ�������,֧��,ƽ̨�����,�̼һ����,�̼��Ż�ȯ����,�̼����Ͳ���,�̼���������)

select ƽ̨,data_date,shop_name,shop_id,turnover,validOrder,foodIncome,boxIncome,deliveryIncome,invalidOrder,userPay,avgPrice,income,payout,serviceFeePayout,activityPayout,couponPayout,deliveryPayout,allowancePayout 
from(
	select 'EleMe' as ƽ̨,data_date,shop_name,shop_id,turnover,validOrder,foodIncome,boxIncome,deliveryIncome,invalidOrder,userPay,avgPrice,income,payout,serviceFeePayout,activityPayout,couponPayout,deliveryPayout,allowancePayout
	,ROW_NUMBER() over(partition by data_date,shop_id order by turnover desc,create_time desc) rn
	from [MCD].[Internal].[t_eleme_sales_info_by_shop]
	where data_date between '' and ''
)a
where rn=1
go


update [MCDDecisionSupport].dbo.[SalesSummary]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	cityname = b.[City],
	[Market] = b.[Market],
	citytier = b.citytier
from [MCDDecisionSupport].dbo.[SalesSummary] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.���̱��=b.EleMeID
where ƽ̨='eleme' and a.[BDSStoreName] is null

go


update [MCDDecisionSupport].dbo.[SalesSummary]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	cityname = b.[City],
	[Market] = b.[Market],
	citytier = b.citytier
from [MCDDecisionSupport].dbo.[SalesSummary] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.���̱��=b.MeiTuanID
where ƽ̨='meituan' and a.[BDSStoreName] is null

go


DELETE FROM a  
FROM
(
	SELECT *,row_number() over(partition by [ƽ̨],[BDSStoreName],[����] order by Ӫҵ�� desc)rn
	FROM [MCDDecisionSupport].[dbo].[SalesSummary]
	WHERE convert(date,[����]) > convert(date,getdate()-7) and [BDSStoreName] is not null
) a
WHERE a.rn > 1
GO


-----update �̻��ܲ���
update [MCDDecisionSupport].dbo.[SalesSummary]
set �̻��ܲ���=case when �̼һ���� is null then 0 else �̼һ���� end
			 +case when �̼��Ż�ȯ���� is null then 0 else �̼��Ż�ȯ���� end
			 +case when �̼����Ͳ��� is null then 0 else �̼����Ͳ��� end
			 +case when �̼��������� is null then 0 else �̼��������� end
where ƽ̨='eleme' and �̻��ܲ��� is null
go

update [MCDDecisionSupport].dbo.[SalesSummary]
set �̻��ܲ���=�̻�����
where ƽ̨='meituan' and �̻��ܲ��� is null 
go	


---
update [MCDDecisionSupport].dbo.[SalesSummary]
set Market='Others' where Market is null and cityname is not null
go




/********* ��Ȼ�������� *************/

---getdata from  MCD [Internal].[TrafficSummary]
INSERT INTO  [dbo].[NaturalTraffic]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopName],OriginalShopID,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

select 'Eleme',2,data_date,shop_name,shop_id,exposureNum,visitorNum,buyerNum
from(
	select data_date,shop_name,shop_id,exposureNum,visitorNum,buyerNum,ROW_NUMBER() over(partition by shop_id,data_date order by exposureNum desc,create_time desc)rn
	from [MCD].[Internal].[t_eleme_flow_info_by_shop]
	where data_date between '' and ''
)a
where rn=1
order by data_date

GO

INSERT INTO  [dbo].[NaturalTraffic]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopName],����,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT 'Meituan',3,[����],[�ŵ�],[����(������)],[�ع�����],[��������],[�µ�����]
FROM  [MCD].[dbo].[TrafficSummaryMeituan]
where [����]  between '' and ''

GO


---remove duplicate data
DELETE FROM a  
FROM
(
SELECT *,row_number() over(partition by [OriginalShopName],[DataPeriod],[ChannelName] order by insertdata desc)rn
FROM [MCDDecisionSupport].[dbo].[NaturalTraffic]
WHERE convert(date,insertdata) > convert(date,getdate()-7)
) a
WHERE a.rn > 1
GO



--UPDATE Store Information 
UPDATE [dbo].[NaturalTraffic]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[cityname] = b.[city],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[NaturalTraffic] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopID] = b.EleMeID 
Where a.[ChannelName] = 'eleme' and a.[BDSStoreName] is null

GO


UPDATE [dbo].[NaturalTraffic]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[cityname] = b.[city],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[NaturalTraffic] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopName] = b.MeituanOriginalShopName and a.����=b.MCDCity
Where a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null

GO

----20190603 ���ų����ɳ��и�Ϊ�˳��мӸ�������ʽ
UPDATE [dbo].[NaturalTraffic]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[cityname] = b.[city],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[NaturalTraffic] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopName] = b.MeituanOriginalShopName and left(a.����,charindex('��',a.����)-1)=b.MCDCity
Where a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null
and charindex('��',a.����)>0

GO

---remove duplicate data
DELETE FROM a  
FROM
(
	SELECT *,row_number() over(partition by [BDSStoreName],[DataPeriod],[ChannelName] order by insertdata desc)rn
	FROM [MCDDecisionSupport].[dbo].[NaturalTraffic]
	WHERE convert(date,insertdata) > convert(date,getdate()-7) and [BDSStoreName] is not null 
	and [ChannelName]='eleme'---meituan��ץȡ���ݻ�δ��
) a
WHERE a.rn > 1
GO

---
update [dbo].[NaturalTraffic]
set Market='Others' where Market is null and cityname is not null
go




/******** ��Ȼ����������� ***********/

---getdata from  MCD [Internal].[TrafficSummary]
--source_channel  1���� 2Ʒ����� 3����ģ�� 4 �Ƽ��̼��б� 5����

INSERT INTO  [dbo].[NaturalTrafficImport]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[�б���],[��Ȼ�ع�����])

SELECT 'Eleme',2,data_date,[shop_id],[shop_name],[source_channel],[exposure_cnt]
FROM
(
	SELECT *
	,row_number()over(partition by shop_name,source_channel,data_date order by create_time desc) rn
	FROM  [MCD].[Internal].[t_eleme_visitor_source] 
	where [shop_name] not like '%����%'
) a
WHERE a.rn = 1
and data_date  between '' and ''
GO


INSERT INTO  [dbo].[NaturalTrafficImport]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[�б���],[��Ȼ�ع�����])

SELECT 'Meituan',3,convert(date,create_time-1),[wm_poi_id],[shop_name],[entry_name],[exposure_num]
FROM 
( 
	SELECT *
	,row_number()over(partition by shop_name,entry_name,convert(date,create_time) order by create_time desc) rn
	FROM [MCD].[Internal].[t_meituan_exposure_info]
	where client='mcd'
) a
WHERE a.rn = 1
and convert(date,create_time-1)  between '' and ''
GO


---remove duplicate data
DELETE FROM a  
FROM
(
SELECT *,row_number() over(partition by [OriginalShopName],[DataPeriod],[ChannelName],�б��� order by insertdata desc)rn
FROM [MCDDecisionSupport].[dbo].[NaturalTrafficImport]
WHERE convert(date,insertdata) > convert(date,getdate()-7)
) a
WHERE a.rn > 1
GO



--UPDATE Store Information 

UPDATE [dbo].[NaturalTrafficImport]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[cityname] = b.[city],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[NaturalTrafficImport] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopID] = convert(nvarchar,b.EleMeID) and a.[OriginalShopName]=b.EleMeOriginalShopName
WHERE a.[ChannelName] = 'eleme' and a.[BDSStoreName] is null

GO


UPDATE [dbo].[NaturalTrafficImport]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[cityname] = b.[city],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[NaturalTrafficImport] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopID] = b.MeituanID and a.[OriginalShopName]=b.MeiTuanOriginalShopName
WHERE a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null

GO

UPDATE [dbo].[NaturalTrafficImport]
SET [BDSStoreID] = 260232 ,
	[BDSStoreName] = '�����������ڶ�·��',
	[cityname] = '����',
	[CityID]= 26,
	[CityTier] = 'Tier 1',
	[Market] = 'SZ',
	[GM]='Terry Zhang'
WHERE OriginalShopID= 492025 and BDSStoreName is null

GO



----
update [dbo].[NaturalTrafficImport]
set Market='Others' where Market is null and CityName is not null
go



/******** �ƹ����� ************/
---20200214 ������datatag�У����ֶ���ôcpc������Դ��0��ʾ���ȼ����ߣ�1��ʾ�����ȼ�(����ô����ʹ��[PromotionResult]������ݣ�����[PromotionResult]��[t_uv_seven_days_summary_trend_by_shop]��ƥ��������ͬ)
---20200214 eleme��[PromotionResult]���ݣ��������name+ID ƥ��bdsstorename

--Meituan
--CPC
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],����,[PromotionType],[�ƹ����],[Original�ƹ������Ӫҵ��],[�ƹ��ع����],[�ƹ�������],[Original�ƹ��µ�����],datatag)

SELECT 'Meituan',3,[����],[�ŵ�ID],[�ŵ�����],����,'CPC',[�ƹ�����],[�������׶�],[�ع�������],[����������],[����������],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
AND ����   between '' and ''
AND [�ƹ��Ʒ]='����ƹ�' and ƽ̨='meituan'
ORDER BY [�ŵ�����],[����]
GO

--CPM
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],����,[PromotionType],[�ƹ����],[Original�ƹ������Ӫҵ��],[�ƹ��ع����],[�ƹ�������],[Original�ƹ��µ�����],datatag)

SELECT 'Meituan',3,[����],[�ŵ�ID],[�ŵ�����],����,'CPM',[�ƹ�����],[�������׶�],[�ع�������],[����������],[����������],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
and ����  between '' and ''
AND [�ƹ��Ʒ]='���𾺼۹���' and  ƽ̨='Meituan'
ORDER BY [�ŵ�����],[����]
GO

UPDATE [dbo].[CPCCPMSummary]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[CityName] = b.[City],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[CPCCPMSummary] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopID] = b.MeiTuanID and a.OriginalShopName=b.MeiTuanOriginalShopName and a.����=b.MCDCity
WHERE a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null

GO

-- Eleme

---CPC
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[PromotionType],[�ƹ����],[Original�ƹ������Ӫҵ��],[�ƹ��ع����],[�ƹ�������],[Original�ƹ��µ�����],datatag)
SELECT  'Eleme',2,time_sign,shop_id,shop_name,'CPC',total_cost,NULL,exposure_amount,total_count,NULL, 1
FROM
(
	SELECT *,row_number() over (partition by  shop_id ,time_sign order by total_cost desc) rn
	--,row_number() over (partition by  shop_id,shop_name ,time_sign order by total_cost desc) rn
	FROM [MCD].[Internal].[t_uv_seven_days_summary_trend_by_shop]
	WHERE 1 = 1
	AND [type]= 'ȫ��'
) a
WHERE a.rn =1 and time_sign  between '' and ''
Order by shop_name,time_sign
GO

UPDATE [dbo].[CPCCPMSummary]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[CityName] = b.[City],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[CPCCPMSummary] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopName] = b.EleMeOriginalShopName and  a.[OriginalShopID] = b.ElemeID
WHERE a.[ChannelName] = 'eleme' and a.[PromotionType]='cpc' and a.datatag=1  and a.[BDSStoreName] is null

GO

INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],����,[PromotionType],[�ƹ����],[Original�ƹ������Ӫҵ��],[�ƹ��ع����],[�ƹ�������],[Original�ƹ��µ�����],datatag)

SELECT 'Eleme',2,[����],[�ŵ�ID],[�ŵ�����],����,'CPC',[�ƹ�����],[�������׶�],[�ع�������],[����������],[����������],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
AND ����   between '' and ''
AND [�ƹ��Ʒ]='����ƹ�' and ƽ̨='Eleme'
ORDER BY [�ŵ�����],[����]
GO

UPDATE [dbo].[CPCCPMSummary]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[CityName] = b.[City],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[CPCCPMSummary] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopName] = b.EleMeOriginalShopName 
WHERE a.[ChannelName] = 'eleme' and a.[PromotionType]='cpc' and a.datatag=0  and a.[BDSStoreName] is null

GO

---CPM
--2019-05-13 cost_num desc 
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[PromotionType],[�ƹ����],[Original�ƹ������Ӫҵ��],[�ƹ��ع����],[�ƹ�������],[Original�ƹ��µ�����],datatag)
SELECT  'Eleme',2,data_date,shop_id,shop_name,'CPM',cost_num,NULL,exposure_num,click_num,NULL, 0
FROM
(
	SELECT *,row_number() over (partition by  shop_id ,data_date order by cost_num desc) rn
	--,row_number() over (partition by  shop_id,shop_name ,data_date order by cost_num desc) rn
	FROM [MCD].[Internal].[t_eleme_cpm_shop_info_7_days]
	WHERE 1 = 1
) a
WHERE a.rn =1 and data_date  between '' and ''
Order by shop_name,data_date
GO

UPDATE [dbo].[CPCCPMSummary]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[CityName] = b.[City],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[CPCCPMSummary] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopName] = b.EleMeOriginalShopName and  a.[OriginalShopID] = b.ElemeID
WHERE a.[ChannelName] = 'eleme' and a.[PromotionType]='cpm'  and a.[BDSStoreName] is null

GO


---remove duplicate data
DELETE FROM a  
FROM
(
	SELECT *,row_number() over(partition by [BDSStoreName],[DataPeriod],[ChannelName],PromotionType order by datatag asc,insertdata desc)rn
	FROM [MCDDecisionSupport].[dbo].[CPCCPMSummary]
	WHERE convert(date,insertdata) > convert(date,getdate()-7) and [BDSStoreName] is not null
) a
WHERE a.rn > 1
GO

------����eleme cpc/cpm �ƹ��µ����� �� �ƹ������Ӫҵ��

update [CPCCPMSummary]
set �ƹ��µ����� =Original�ƹ��µ�����
   ,�ƹ������Ӫҵ�� =Original�ƹ������Ӫҵ��
where [ChannelName] = 'Meituan' and �ƹ��µ����� is null

go


-- Eleme CPC�ƹ��µ�����
UPDATE [CPCCPMSummary]
SET �ƹ��µ����� = a.�ƹ������� * b.[��Ȼ�µ�ת����] / 2.5
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName,case sum(��Ȼ��������) when 0 then null else sum(��Ȼ�µ�����)/sum(��Ȼ��������) end as [��Ȼ�µ�ת����]
	FROM dbo.[NaturalTraffic]
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPC'
and a.DataPeriod<'2019-06-01'  ----190909 ����
and �ƹ��µ����� is null

GO
-----190909 ƽ̨�϶���ô��ϵ����6��1�ŵ����ݿ�ʼ����Ϊ1.2
UPDATE [CPCCPMSummary]
SET �ƹ��µ����� = a.�ƹ������� * b.[��Ȼ�µ�ת����] / 1.2
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName,case sum(��Ȼ��������) when 0 then null else sum(��Ȼ�µ�����)/sum(��Ȼ��������) end as [��Ȼ�µ�ת����]
	FROM dbo.[NaturalTraffic] 
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPC'
and a.DataPeriod>='2019-06-01'  ----190909 ����
and �ƹ��µ����� is null

GO



UPDATE [CPCCPMSummary]
SET �ƹ������Ӫҵ�� = a.�ƹ��µ����� * b.[�͵���]
FROM [CPCCPMSummary] a
JOIN 
(
  SELECT ƽ̨,����,BDSStoreName,cityname,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end as [�͵���]
  FROM [MCDDecisionSupport].dbo.[SalesSummary]
  group by ƽ̨,����,BDSStoreName,cityname
) b
ON a.[ChannelName] = b.ƽ̨
AND a.[cityname] = b.cityname
AND a.DataPeriod = b.����
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPC'
and �ƹ������Ӫҵ�� is null

GO



--Eleme CPM�ƹ��µ�����
UPDATE [CPCCPMSummary]
SET �ƹ��µ����� = a.�ƹ������� * b.[��Ȼ�µ�ת����] / 2.5
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName
	,case sum(��Ȼ��������) when 0 then null else sum(��Ȼ�µ�����)/sum(��Ȼ��������) end as [��Ȼ�µ�ת����]
	FROM dbo.[NaturalTraffic]
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPM'
and a.DataPeriod<'2019-06-01'  ----190909 ����
and �ƹ��µ����� is null

GO
-----190909 ƽ̨�϶���ô��ϵ����6��1�ŵ����ݿ�ʼ����Ϊ1.2
UPDATE [CPCCPMSummary]
SET �ƹ��µ����� = a.�ƹ������� * b.[��Ȼ�µ�ת����] / 1.2
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName
	,case sum(��Ȼ��������) when 0 then null else sum(��Ȼ�µ�����)/sum(��Ȼ��������) end as [��Ȼ�µ�ת����]
	FROM dbo.[NaturalTraffic]
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPM'
and a.DataPeriod>='2019-06-01'  ----190909 ����
and �ƹ��µ����� is null

GO


UPDATE [CPCCPMSummary]
SET �ƹ������Ӫҵ�� = a.�ƹ��µ����� * b.[�͵���]
FROM [CPCCPMSummary] a
JOIN 
(
  SELECT ƽ̨,����,BDSStoreName,cityname,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end as [�͵���]
  FROM [MCDDecisionSupport].dbo.[SalesSummary]
  group by ƽ̨,����,BDSStoreName,cityname
) b
ON a.[ChannelName] = b.ƽ̨
AND a.[cityname] = b.cityname
AND a.DataPeriod = b.����
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPM'
and �ƹ������Ӫҵ�� is null

GO

-----
update [CPCCPMSummary]
set Market='Others' where Market is null and CityName is not null
go




/******* ���������ռ�� ************/

insert into [dbo].[OrderPromotion]([ChannelName],�������,��������,�̻����,BDSStoreName,MCDStoreID,cityname,[Market],citytier,����״̬,�µ�ʱ��,�Ƿ�����,��Ʒԭ��,OriginalPromotioninfo)

select distinct a.ƽ̨,�������,��������,�̻����,BDSStoreName,MCDStoreID,cityname,Market,citytier,����״̬,�µ�ʱ��,�Ƿ�����,��Ʒԭ��,v.value as value2
from(
	select distinct ƽ̨,�������,��������,�̻����,BDSStoreName,MCDStoreID,cityname,Market,citytier,����״̬,�µ�ʱ��,�Ƿ�����,�Żݻ,��Ʒԭ��,v.value
	from [MCDDecisionSupport].dbo.[Order] p
	CROSS APPLY STRING_SPLIT(p.�Żݻ, '/') v
	--where promotion='���û��µ�����16Ԫ;��30��7����50��10����100��13;��Ʒ����;��Ʒ����;'
)a
CROSS APPLY STRING_SPLIT(a.value, '+') v
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
go

---
update [MCDDecisionSupport].dbo.[OrderPromotion]
set ordercode= replace(�������,char(9),'') 
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
go

update [OrderPromotion]
set OriginalPromotionInfo=replace(REPLACE(REPLACE(REPLACE(OriginalPromotionInfo, CHAR(13) + CHAR(10),''), CHAR(13),''), CHAR(10),''),CHAR(9),'')
where type is null
go


---remove duplicate data

DELETE FROM a  
FROM
(
SELECT *,row_number() over(partition by ordercode,originalpromotioninfo,[ChannelName] order by insertdate desc)rn
FROM [MCDDecisionSupport].[dbo].[OrderPromotion]
WHERE convert(date,insertdate) > convert(date,getdate()-7)
) a
WHERE a.rn > 1
GO


----update promotion type
update [OrderPromotion]
set type=b.type
from [OrderPromotion] a
join [DeliveryPromotionCoding] b
on a.OriginalPromotioninfo=b.OriginalPromotioninfo
where a.type is null
go


update [MCDDecisionSupport].dbo.[OrderPromotion]
set market='Others' where market is null and CityName is not null
go

----�������Ʋ�Ϊ�� �̻���Ų�Ϊ��
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.EleMeOriginalShopName and a.�̻����=b.EleMeID
where ��������!='' and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.MeiTuanOriginalShopName and a.�̻����=b.MeiTuanID
where ��������!='' and [ChannelName]='meituan' and a.CityName is null

go

----�������Ʋ�Ϊ�� �̻����Ϊ��
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.EleMeOriginalShopName
where ��������!='' and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.MeiTuanOriginalShopName
where ��������!='' and [ChannelName]='meituan' and a.CityName is null

go

----��������Ϊ�� �̻���Ų�Ϊ��
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.�̻����=b.EleMeID
where ��������='' and �̻���� is not null and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.�̻����=b.MeiTuanID
where ��������='' and �̻���� is not null and [ChannelName]='meituan' and a.CityName is null

go


----��������Ϊ��  �̻����Ϊ��
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.EleMeOriginalShopName
where ��������='' and �̻���� is null and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.��������=b.MeiTuanOriginalShopName
where ��������='' and �̻���� is null and [ChannelName]='meituan' and a.CityName is null

go







---------------- report ----------------

use [MCDDecisionSupport]
go



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
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='����'
and a.[Date]  between '' and ''
go


------------------ tye=�����վ� 
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],Ӫҵ��)

select '�����վ�',ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by ƽ̨,cityname,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�'
and a.date  between '' and ''
go


-------------- 2) market level
------------------ tye=���� 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��)

select CalculateType,ChannelName,-1,Market,Market,[Date],sum(Ӫҵ��),sum(���Ӫҵ��),sum(���Ӫҵ��),sum(�����Ӫҵ��),sum(���Ӫҵ��),sum(��ҹӪҵ��),sum(ͨ��Ӫҵ��)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='����' and ChannelName<>'total'
and [Date]  between '' and ''
group by CalculateType,ChannelName,Market,[Date]

go

------------------ tye=�����վ�
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�',ƽ̨,-1,Market,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by ƽ̨,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ AND A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and cityid='-1'
and a.date  between '' and ''
go
 

-------------- 3) ȫ�� level
------------------ tye=���� 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��)

select CalculateType,ChannelName,0,'ȫ��','ȫ��',[Date],sum(Ӫҵ��),sum(���Ӫҵ��),sum(���Ӫҵ��),sum(�����Ӫҵ��),sum(���Ӫҵ��),sum(��ҹӪҵ��),sum(ͨ��Ӫҵ��)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='����' and ChannelName<>'total' and cityid is null
and [Date]  between '' and ''
group by CalculateType,ChannelName,[Date]

go

------------------ tye=�����վ�
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�',ƽ̨,0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by ƽ̨,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.ChannelName=B.ƽ̨ and A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and cityid='0'
and a.Date  between '' and ''
go
 


------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
				
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,���Ӫҵ��,���Ӫҵ��,�����Ӫҵ��,���Ӫҵ��,��ҹӪҵ��,ͨ��Ӫҵ��)

select CalculateType,'Total',cityid,CityName,Market,[Date],sum(Ӫҵ��),sum(���Ӫҵ��),sum(���Ӫҵ��),sum(�����Ӫҵ��),sum(���Ӫҵ��),sum(��ҹӪҵ��),sum(ͨ��Ӫҵ��)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='����' and ChannelName<>'Total'
and [Date]  between '' and ''
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
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by cityname,Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON  A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and ChannelName='total'
and a.date  between '' and ''
go

---------market level
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�','Total',-1,Market,Market,convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by Market,convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON  A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and ChannelName='total' and cityid='-1'
and a.date  between '' and ''
go

---------ȫ�� level
-----������Ӫҵ��
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��)

select '�����վ�','Total',0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(�����ܽ��)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
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
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by convert(varchar(10),�µ�ʱ��,23),ʱ���
  ) a
  pivot(sum(�ܽ��) for ʱ��� in([���],[���],[�����],[���],[��ҹ],[ͨ��]))T
)B
ON A.Date=B.DATE
WHERE A.CalculateType='�����վ�' and ChannelName='total' and cityid='0'
and a.date  between '' and ''
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
where Date  between '' and ''
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
where ����  between '' and ''
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
where ����  between '' and ''
group by ƽ̨,cityname,Market,����
go


-------------- 2) market level
------------------ tye=����
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '����',ƽ̨,-1,Market,Market,����,sum(Ӫҵ��),sum(�̻��ܲ���),sum(��Ч������),sum(��Ч������)
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ����  between '' and ''
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
where ����  between '' and ''
group by ƽ̨,Market,����
go

-------------- 2) ȫ�� level
------------------ tye=����
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],Ӫҵ��,�̻�����,��Ч������,��Ч������,�͵���)

select '����',ƽ̨,0,'ȫ��','ȫ��',����,sum(Ӫҵ��),sum(�̻��ܲ���),sum(��Ч������),sum(��Ч������)
,case when sum(��Ч������)=0 then null else sum(Ӫҵ��-�̻��ܲ���)/sum(��Ч������)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where ����  between '' and ''
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
where ����  between '' and ''
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
and date  between '' and ''
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
where ����  between '' and ''
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
where ����  between '' and ''
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
where ����  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,-1,Market,Market,sum([��Ȼ�ع�����]),sum([��Ȼ��������]),sum([��Ȼ�µ�����])
FROM [dbo].[NaturalTraffic]
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

-------------- 3) ȫ�� level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��',sum([��Ȼ�ع�����]),sum([��Ȼ��������]),sum([��Ȼ�µ�����])
FROM [dbo].[NaturalTraffic]
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[�б���]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[�б���],[��Ȼ�ع�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[�б���]
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[�б���]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[�б���],sum([��Ȼ�ع�����])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[�б���]
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO

-------------- 3) ȫ�� level
------------------ tye=���� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '����',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��',[�б���],sum([��Ȼ�ع�����])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY ChannelName,ChannelID,DataPeriod,[�б���]
ORDER BY ChannelName,ChannelID,DataPeriod,[�б���]

GO

------------------ tye=�����վ� 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[�б���],[��Ȼ�ع�����])

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��',[�б���]
,case count(distinct BDSStoreName) when 0 then null else sum([��Ȼ�ع�����])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ�
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,-1,Market,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=�����վ�
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '�����վ�',ChannelName,ChannelID,DataPeriod,0,'ȫ��','ȫ��'
FROM [dbo].[CPCCPMSummary]
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
GROUP BY DataPeriod,cityid,cityname,Market
ORDER BY DataPeriod,cityname

GO

			
------------------2) tye=�����վ� 
---------city level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '�����վ�','Total',1,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
    select channelname,cityname,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode)��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by channelname,cityname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='����' and date  between '' and ''
go

------------------ tye=�����վ� 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],market,[Date],[Type],[�������])

select '�����վ�',channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by channelname,cityname,market,convert(varchar(10),�µ�ʱ��,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,cityname,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion] a
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by channelname,cityname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and date  between '' and ''
go


-------------- 2) market level
------------------ tye=���� 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '����',channelname,-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by channelname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by channelname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='����' and cityid='-1' and date  between '' and ''
go


------�����վ�
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '�����վ�',channelname,-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by channelname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by channelname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and cityid='-1' and date  between '' and ''
go

-------------- 3) ȫ�� level
------------------ tye=���� 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '����',channelname,0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by channelname,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by channelname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='����' and cityid='0' and date  between '' and ''
go


------�����վ�
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[�������])

select '�����վ�',channelname,0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by channelname,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by channelname,convert(varchar(10),�µ�ʱ��,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and cityid='0' and date  between '' and ''
go

------------2. channel=total(eleme+meituan) 
-----------------��ͬƽ̨ͬ�ҵ�ֻ����һ�Σ���˼�����ʱcount(distinct BDSStoreName)��Ҫʹ��Դ����,�������ݲ��漰����������˿�ֱ�ӽ����������ƽ̨�������

------------------1) tye=���� 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[�������])

select '����','Total',cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by cityname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='����' and [ChannelName]='total' and date  between '' and ''
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '����','Total',-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='����' and [ChannelName]='total' and cityid='-1'
and date  between '' and ''
go

---------ȫ�� level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '����','Total',0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),�µ�ʱ��,23) OrderDate,count(distinct OrderCode) ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by convert(varchar(10),�µ�ʱ��,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='����' and [ChannelName]='total' and cityid='0'
and date  between '' and ''
go



------------------2) tye=�����վ� 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[�������])

select '�����վ�','Total',cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by cityname,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by cityname,Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and [ChannelName]='total' and date  between '' and ''
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '�����վ�','Total',-1,Market,Market,convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by Market,convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by Market,convert(varchar(10),�µ�ʱ��,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='�����վ�' and [ChannelName]='total' and cityid='-1'
and date  between '' and ''
go


---------ȫ�� level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[�������])

select '�����վ�','Total',0,'ȫ��','ȫ��',convert(varchar(10),�µ�ʱ��,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
group by convert(varchar(10),�µ�ʱ��,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set ��������=b.��������
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),�µ�ʱ��,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end ��������
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),�µ�ʱ��,23)  between '' and ''
	group by convert(varchar(10),�µ�ʱ��,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='�����վ�' and [ChannelName]='total' and cityid='0'
and date  between '' and ''
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


