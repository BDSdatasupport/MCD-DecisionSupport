USE [MCDDecisionSupport]
GO

-----��ȡÿ��dbo���������


/***** �������� �����ڼ����ʱ���Ӫҵ�� *******************/

-----ÿ���ȡǰһ��� internal ��������
insert into [MCDDecisionSupport].dbo.[Order](ƽ̨,�������,�ӵ�ʱ��,��������,�̻����,����,֧����ʽ,����״̬,��������״̬,���ͷ�ʽ,����ȡ��ԭ��,�Ƿ�Ԥ����,�µ�ʱ��,�ӵ�ʱ��,�������ʱ��,����ʱ��,Ԥ���ʹ�ʱ��,�����ܽ��,ʵ�����,ƽ̨�����,�̼һ����,�̻����Ͳ���,���ͷ�,�Ƿ�����,�Żݻ,��Ʒ��Ϣ,�ͺз��ܽ��,�ͺ�������,��������,��������,�Ƿ�ߵ�,�ظ�״̬,�̼һظ�����,�̼��Ż�ȯ�������,��Ʒԭ��)

select ƽ̨,�������,�ӵ�ʱ��,��������,�̻����,����,֧����ʽ,����״̬,��������״̬,���ͷ�ʽ,����ȡ��ԭ��,�Ƿ�Ԥ����,�µ�ʱ��,�ӵ�ʱ��,�������ʱ��,����ʱ��,Ԥ���ʹ�ʱ��,�����ܽ��,ʵ�����,ƽ̨�����,�̼һ����,�̻����Ͳ���,���ͷ�,�Ƿ�����,�Żݻ,��Ʒ��Ϣ,�ͺз��ܽ��,�ͺ�������,��������,��������,�Ƿ�ߵ�,�ظ�״̬,�̼һظ�����,�̼��Ż�ȯ�������,��Ʒԭ��
from [MCD].[Internal].[Order]
where convert(varchar(10),�µ�ʱ��,23) >(select dataperiod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
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
	where data_date>(select dataperiod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
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
	where data_date>(select dataperiod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
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
	where data_date>(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
)a
where rn=1
order by data_date

GO

INSERT INTO  [dbo].[NaturalTraffic]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopName],����,[��Ȼ�ع�����],[��Ȼ��������],[��Ȼ�µ�����])

SELECT 'Meituan',3,[����],[�ŵ�],[����(������)],[�ع�����],[��������],[�µ�����]
FROM  [MCD].[dbo].[TrafficSummaryMeituan]
where [����] >(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])

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
and data_date >(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
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
and convert(date,create_time-1) >(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
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
AND ����  >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
AND [�ƹ��Ʒ]='����ƹ�' and ƽ̨='meituan'
ORDER BY [�ŵ�����],[����]
GO

--CPM
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],����,[PromotionType],[�ƹ����],[Original�ƹ������Ӫҵ��],[�ƹ��ع����],[�ƹ�������],[Original�ƹ��µ�����],datatag)

SELECT 'Meituan',3,[����],[�ŵ�ID],[�ŵ�����],����,'CPM',[�ƹ�����],[�������׶�],[�ع�������],[����������],[����������],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
and ���� >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
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
WHERE a.rn =1 and time_sign >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
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
AND ����  >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
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
WHERE a.rn =1 and data_date >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
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
where convert(varchar(10),�µ�ʱ��,23) >(select dataperiod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---
update [MCDDecisionSupport].dbo.[OrderPromotion]
set ordercode= replace(�������,char(9),'') 
where convert(varchar(10),�µ�ʱ��,23) >(select dataperiod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
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



/******* ��Ʒ���� *********/

IF OBJECT_ID('[MCDDecisionSupport].[dbo].[PromotionMaxDate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[PromotionMaxDate]

GO

create table [MCDDecisionSupport].[dbo].[PromotionMaxDate](MaxData date null)
go

insert into [MCDDecisionSupport].[dbo].[PromotionMaxDate]
select dateadd(day,1,max([date])) from [MCDDecisionSupport].[dbo].[ResultMCDDailyPromotion]
go


insert into [MCDDecisionSupport].[dbo].[ResultMCDDailyPromotion](
[PromotionType],[BrandName],[OriginalPromotionInfo],[CodingPromotionInfo],[OriginalDishPrice],[PromotionDishPrice],[Date],[CityName],[ChannelName],[StoreID],[Threshold],[DiscountValue],[DiscountRate],[Type],[Gift],[PromotionStoreNo],[TotStoreNo],[PromotionStorePer],[CityTier],[week],[DateFilter],[TypeID],[channelname2])

select [PromotionType],[BrandName],[OriginalPromotionInfo],[CodingPromotionInfo],[OriginalDishPrice],[PromotionDishPrice],[Date],[CityName],[ChannelName],[StoreID],[Threshold],[DiscountValue],[DiscountRate],[Type],[Gift],[PromotionStoreNo],[TotStoreNo],[PromotionStorePer],[CityTier],[week],[DateFilter],[TypeID],[channelname2]
from [YUMDailyProcess].[dbo].[ResultMCDDailyPromotion]
where [Date]=(select MaxData from [MCDDecisionSupport].[dbo].[PromotionMaxDate])
go





/********* �������� ****************/
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[WeatherMaxDate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[WeatherMaxDate]

GO

create table [MCDDecisionSupport].[dbo].[WeatherMaxDate](MaxData date null)
go

insert into [MCDDecisionSupport].[dbo].[WeatherMaxDate]
select dateadd(day,1,max([prediction_date])) from [MCDDecisionSupport].[dbo].[WeatherTemp]
go



----�¶�
insert into [MCDDecisionSupport].dbo.[WeatherTemp]([city_name],[prediction_date],temperature)

select distinct [city_name],[prediction_date],v.value
from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather] p
CROSS APPLY STRING_SPLIT(p.temperature, '/')v
where prediction_date=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])

union all

select distinct [city_name],[prediction_date],temperature
from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather] p
where CHARINDEX('/',temperature)=0
and prediction_date=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.[WeatherTemp]
set temperature=replace(temperature,'��','')
where charindex('��',temperature)>0 and [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go


----�缶
insert into [MCDDecisionSupport].dbo.windtemp([city_name],[prediction_date],wind_direction,create_time)

select distinct [city_name],[prediction_date],wind_direction,create_time
from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather] p
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.windtemp
set tag=case when b.tag='�޷�' then '0' else b.tag end
from [MCDDecisionSupport].dbo.windtemp a
join [MCDDecisionSupport].[dbo].[WeatherWindTag] b
on a.wind_direction=b.Wind_Level
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go


------��ѩ�ȼ�

insert into [MCDDecisionSupport].dbo.dayweathertemp([city_name],[prediction_date],day_weather)

select distinct [city_name],[prediction_date],day_weather
from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather] 
where (day_weather like'%��%' or day_weather like'%ѩ%' or day_weather like'%����%')
and [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.dayweathertemp
set rainid=case when day_weather='�ش���' then 1 when day_weather='����' then 2 when day_weather='����' then 3 when day_weather='����' then 4 when day_weather='����' then 5 when day_weather='С��' then 6 when day_weather='������' then 7 when day_weather='����' then 8 end
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.dayweathertemp
set snowid=case when day_weather='��ѩ' then 1 when day_weather='��ѩ' then 2 when day_weather='��ѩ' then 3 when day_weather='Сѩ' then 4 when day_weather='��ѩ' then 5 when day_weather='���ѩ' then 6 when day_weather='����' then 7 end
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go


/********** ���� ****************/

insert into [MCDDecisionSupport].[dbo].[cityweather]([cityname],[predictiondate],[maxtemperature],[mintemperature])

select [city_name],[prediction_date],max(temperature)+'��',min(temperature)+'��'
from [MCDDecisionSupport].dbo.WEATHERtemp
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
group by [prediction_date],[city_name]
go

---��
update [MCDDecisionSupport].[dbo].[cityweather]
set winddirection=b.wind_direction
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from (
	select city_name,prediction_date,wind_direction,tag,ROW_NUMBER() over (partition by city_name,prediction_date order by tag desc)rn
	from [MCDDecisionSupport].dbo.windtemp
	where tag like'%��%'
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where a.[predictiondate]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].[dbo].[cityweather]
set winddirection=b.wind_direction
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from (
	select city_name,wind_direction,prediction_date,tag,ROW_NUMBER() over (partition by city_name,prediction_date order by create_time desc)rn
	from [MCDDecisionSupport].dbo.windtemp
	where tag is null and wind_direction !='�޳�������'
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where winddirection is null
go

update [MCDDecisionSupport].[dbo].[cityweather]
set winddirection=b.wind_direction
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from (
	select city_name,wind_direction,prediction_date,tag,ROW_NUMBER() over (partition by city_name,prediction_date order by create_time desc)rn
	from [MCDDecisionSupport].dbo.windtemp
	where tag is null and wind_direction ='�޳�������'
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where winddirection is null
go


----��
update [MCDDecisionSupport].[dbo].[cityweather]
set raindirection=b.day_weather
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from(
	select city_name,prediction_date,day_weather,rainid,ROW_NUMBER() over (partition by city_name,prediction_date order by rainid desc)rn
	from [MCDDecisionSupport].dbo.dayweathertemp
	where rainid is not null
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where raindirection is null
go

----ѩ
update [MCDDecisionSupport].[dbo].[cityweather]
set snowdirection=b.day_weather
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from(
	select city_name,prediction_date,day_weather,snowid,ROW_NUMBER() over (partition by city_name,prediction_date order by snowid desc)rn
	from [MCDDecisionSupport].dbo.dayweathertemp
	where snowid is not null
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where snowdirection is null
go

----��ѩ�ȼ���ѩ>��
update [MCDDecisionSupport].[dbo].[CityWeather]
set [RainSnowDirection] = [snowdirection]
go

update [MCDDecisionSupport].[dbo].[CityWeather]
set [RainSnowDirection] = [raindirection]
where [RainSnowDirection] is null
go

---��������
update [MCDDecisionSupport].[dbo].[cityweather]
set airquality=b.air_quality
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from(
	select city_name,convert(varchar(10),create_time,23) as prediction_date,air_quality,ROW_NUMBER()over(partition by city_name,convert(varchar(10),create_time,23) order by create_time desc)rn
	from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather_current]
	where air_quality!=''
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where airquality is null
go


delete from [MCDDecisionSupport].[dbo].[CityWeather]
where cityname not in (select distinct City
from MCDDecisionSupport.dbo.MCDStoreList)
go

update [MCDDecisionSupport].[dbo].[CityWeather]
set Market=b.Market
from [MCDDecisionSupport].[dbo].[CityWeather] a
join MCDDecisionSupport.dbo.MCDStoreList b
on a.cityname=b.MCDCity
go


update [MCDDecisionSupport].[dbo].[CityWeather]
set Market='Others'
where cityname is not null and Market is null
go


----market
insert into [MCDDecisionSupport].[dbo].[CityWeather](market,cityname,[predictiondate])

SELECT  distinct market,market,[predictiondate]
FROM [MCDDecisionSupport].[dbo].[CityWeather]
order by [predictiondate] desc
go

