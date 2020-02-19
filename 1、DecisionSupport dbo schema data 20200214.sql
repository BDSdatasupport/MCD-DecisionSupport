USE [MCDDecisionSupport]
GO

-----获取每张dbo表最大日期


/***** 订单数据 ：用于计算分时间段营业额 *******************/

-----每天获取前一天的 internal 订单数据
insert into [MCDDecisionSupport].dbo.[Order](平台,订单编号,接单时长,店铺名称,商户编号,城市,支付方式,订单状态,订单配送状态,配送方式,订单取消原因,是否预定单,下单时间,接单时间,订单完成时间,配送时间,预定送达时间,订单总金额,实付金额,平台活动补贴,商家活动补贴,商户配送补贴,配送费,是否活动订单,优惠活动,菜品信息,餐盒费总金额,餐盒总数量,订单评分,订单评价,是否催单,回复状态,商家回复内容,商家优惠券补贴金额,商品原价)

select 平台,订单编号,接单时长,店铺名称,商户编号,城市,支付方式,订单状态,订单配送状态,配送方式,订单取消原因,是否预定单,下单时间,接单时间,订单完成时间,配送时间,预定送达时间,订单总金额,实付金额,平台活动补贴,商家活动补贴,商户配送补贴,配送费,是否活动订单,优惠活动,菜品信息,餐盒费总金额,餐盒总数量,订单评分,订单评价,是否催单,回复状态,商家回复内容,商家优惠券补贴金额,商品原价
from [MCD].[Internal].[Order]
where convert(varchar(10),下单时间,23) >(select dataperiod from [MCDDecisionSupport].[dbo].[OrdertempMaxdate])
order by 下单时间
go


----remove duplicate data
DELETE FROM a  
FROM
(
SELECT *,row_number() over(partition by [平台],[订单编号] order by insertdate desc)rn
FROM [MCDDecisionSupport].dbo.[Order]
WHERE convert(date,insertdate) > convert(date,getdate()-7)
) a
WHERE a.rn > 1
GO



-----update daypart
update [MCDDecisionSupport].dbo.[Order]
set 时间段 ='早餐' where DATEPART(hh,下单时间) between '6' and '10' and 时间段 is null
update [MCDDecisionSupport].dbo.[Order]
set 时间段 ='午餐' where DATEPART(hh,下单时间) between '11' and '13' and 时间段 is null
update [MCDDecisionSupport].dbo.[Order]
set 时间段 ='下午茶' where DATEPART(hh,下单时间) between '14' and '16' and 时间段 is null
update [MCDDecisionSupport].dbo.[Order]
set 时间段 ='晚餐' where DATEPART(hh,下单时间) between '17' and '19' and 时间段 is null
update [MCDDecisionSupport].dbo.[Order]
set 时间段 ='宵夜' where DATEPART(hh,下单时间) between '20' and '23' and 时间段 is null
update [MCDDecisionSupport].dbo.[Order]
set 时间段 ='通宵' where DATEPART(hh,下单时间) between '0' and '5' and 时间段 is null

go


----店铺名称不为空 商户编号不为空
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.EleMeOriginalShopName and a.商户编号=b.EleMeID
where 店铺名称!='' and 平台='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.MeiTuanOriginalShopName and a.商户编号=b.MeiTuanID
where 店铺名称!='' and 平台='meituan' and a.[BDSStoreName] is null

go

----店铺名称不为空 商户编号为空
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.EleMeOriginalShopName
where 店铺名称!='' and 平台='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.MeiTuanOriginalShopName
where 店铺名称!='' and 平台='meituan' and a.[BDSStoreName] is null

go

----店铺名称为空 商户编号不为空
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.商户编号=b.EleMeID
where 店铺名称='' and 商户编号 is not null and 平台='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.商户编号=b.MeiTuanID
where 店铺名称='' and 商户编号 is not null and 平台='meituan' and a.[BDSStoreName] is null

go


----店铺名称为空  商户编号为空
update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.EleMeOriginalShopName
where 店铺名称='' and 商户编号 is null and 平台='eleme' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[Order] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.MeiTuanOriginalShopName
where 店铺名称='' and 商户编号 is null and 平台='meituan' and a.[BDSStoreName] is null

go

update [MCDDecisionSupport].dbo.[Order]
set [Market]='Others' where [Market] is null and cityname is not null
go




/******** 营业数据 **************/

/*****[MCDDecisionSupport].dbo.[SalesSummary]  不分时间段*******************/
-----营业额

---meituan
insert into [MCDDecisionSupport].dbo.[SalesSummary](平台,日期,店铺名称,店铺编号,营业额,有效订单数,预计收入,菜品收入,餐盒收入,配送收入,商户补贴,平台补贴,客单价,无效订单数)

select 平台,data_date,shop_name,wm_poi_id,turnover,effectiveOrders,orderTurnover,foodPrice,boxPrice,shippingFee,bizSubsidy,mtSubsidy,pricePerOrder,invalidOrders
from(
	select 'MeiTuan' as 平台,data_date,shop_name,wm_poi_id,turnover,effectiveOrders,orderTurnover,foodPrice,boxPrice,shippingFee,bizSubsidy,mtSubsidy,pricePerOrder,invalidOrders
	,ROW_NUMBER() over(partition by data_date,wm_poi_id order by turnover desc,create_time desc) rn
	from [MCD].[Internal].[t_meituan_sales_info_by_shop]
	where data_date>(select dataperiod from [MCDDecisionSupport].[dbo].[SalesSummarytempMaxdate])
)a
where rn=1
go


---EleMe
insert into [MCDDecisionSupport].dbo.[SalesSummary](平台,日期,店铺名称,店铺编号,营业额,有效订单数,菜品收入,餐盒收入,配送收入,无效订单数,在线支付,去补贴客单价,预计订单收入,支出,平台服务费,商家活动补贴,商家优惠券补贴,商家配送补贴,商家其他补贴)

select 平台,data_date,shop_name,shop_id,turnover,validOrder,foodIncome,boxIncome,deliveryIncome,invalidOrder,userPay,avgPrice,income,payout,serviceFeePayout,activityPayout,couponPayout,deliveryPayout,allowancePayout 
from(
	select 'EleMe' as 平台,data_date,shop_name,shop_id,turnover,validOrder,foodIncome,boxIncome,deliveryIncome,invalidOrder,userPay,avgPrice,income,payout,serviceFeePayout,activityPayout,couponPayout,deliveryPayout,allowancePayout
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
on a.店铺编号=b.EleMeID
where 平台='eleme' and a.[BDSStoreName] is null

go


update [MCDDecisionSupport].dbo.[SalesSummary]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	cityname = b.[City],
	[Market] = b.[Market],
	citytier = b.citytier
from [MCDDecisionSupport].dbo.[SalesSummary] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺编号=b.MeiTuanID
where 平台='meituan' and a.[BDSStoreName] is null

go


DELETE FROM a  
FROM
(
	SELECT *,row_number() over(partition by [平台],[BDSStoreName],[日期] order by 营业额 desc)rn
	FROM [MCDDecisionSupport].[dbo].[SalesSummary]
	WHERE convert(date,[日期]) > convert(date,getdate()-7) and [BDSStoreName] is not null
) a
WHERE a.rn > 1
GO


-----update 商户总补贴
update [MCDDecisionSupport].dbo.[SalesSummary]
set 商户总补贴=case when 商家活动补贴 is null then 0 else 商家活动补贴 end
			 +case when 商家优惠券补贴 is null then 0 else 商家优惠券补贴 end
			 +case when 商家配送补贴 is null then 0 else 商家配送补贴 end
			 +case when 商家其他补贴 is null then 0 else 商家其他补贴 end
where 平台='eleme' and 商户总补贴 is null
go

update [MCDDecisionSupport].dbo.[SalesSummary]
set 商户总补贴=商户补贴
where 平台='meituan' and 商户总补贴 is null 
go	


---
update [MCDDecisionSupport].dbo.[SalesSummary]
set Market='Others' where Market is null and cityname is not null
go




/********* 自然流量数据 *************/

---getdata from  MCD [Internal].[TrafficSummary]
INSERT INTO  [dbo].[NaturalTraffic]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopName],OriginalShopID,[自然曝光人数],[自然到店人数],[自然下单人数])

select 'Eleme',2,data_date,shop_name,shop_id,exposureNum,visitorNum,buyerNum
from(
	select data_date,shop_name,shop_id,exposureNum,visitorNum,buyerNum,ROW_NUMBER() over(partition by shop_id,data_date order by exposureNum desc,create_time desc)rn
	from [MCD].[Internal].[t_eleme_flow_info_by_shop]
	where data_date>(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])
)a
where rn=1
order by data_date

GO

INSERT INTO  [dbo].[NaturalTraffic]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopName],城市,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT 'Meituan',3,[日期],[门店],[城市(负责人)],[曝光人数],[访问人数],[下单人数]
FROM  [MCD].[dbo].[TrafficSummaryMeituan]
where [日期] >(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTraffictempMaxdate])

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
ON a.[OriginalShopName] = b.MeituanOriginalShopName and a.城市=b.MCDCity
Where a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null

GO

----20190603 美团城市由城市改为了城市加负责人形式
UPDATE [dbo].[NaturalTraffic]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[cityname] = b.[city],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[NaturalTraffic] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopName] = b.MeituanOriginalShopName and left(a.城市,charindex('（',a.城市)-1)=b.MCDCity
Where a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null
and charindex('（',a.城市)>0

GO

---remove duplicate data
DELETE FROM a  
FROM
(
	SELECT *,row_number() over(partition by [BDSStoreName],[DataPeriod],[ChannelName] order by insertdata desc)rn
	FROM [MCDDecisionSupport].[dbo].[NaturalTraffic]
	WHERE convert(date,insertdata) > convert(date,getdate()-7) and [BDSStoreName] is not null 
	and [ChannelName]='eleme'---meituan的抓取数据还未好
) a
WHERE a.rn > 1
GO

---
update [dbo].[NaturalTraffic]
set Market='Others' where Market is null and cityname is not null
go




/******** 自然流量入口数据 ***********/

---getdata from  MCD [Internal].[TrafficSummary]
--source_channel  1搜索 2品类入口 3导购模块 4 推荐商家列表 5其他

INSERT INTO  [dbo].[NaturalTrafficImport]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[列表名],[自然曝光人数])

SELECT 'Eleme',2,data_date,[shop_id],[shop_name],[source_channel],[exposure_cnt]
FROM
(
	SELECT *
	,row_number()over(partition by shop_name,source_channel,data_date order by create_time desc) rn
	FROM  [MCD].[Internal].[t_eleme_visitor_source] 
	where [shop_name] not like '%咖啡%'
) a
WHERE a.rn = 1
and data_date >(select dataperiod from [MCDDecisionSupport].[dbo].[NaturalTrafficImporttempMaxdate])
GO


INSERT INTO  [dbo].[NaturalTrafficImport]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[列表名],[自然曝光人数])

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
SELECT *,row_number() over(partition by [OriginalShopName],[DataPeriod],[ChannelName],列表名 order by insertdata desc)rn
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
	[BDSStoreName] = '深圳麦当劳兴融二路店',
	[cityname] = '深圳',
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



/******** 推广数据 ************/
---20200214 新增了datatag列，区分饿了么cpc数据来源，0表示优先级更高，1表示低优先级(饿了么优先使用[PromotionResult]表的数据，但是[PromotionResult]和[t_uv_seven_days_summary_trend_by_shop]的匹配条件不同)
---20200214 eleme除[PromotionResult]数据，其余改用name+ID 匹配bdsstorename

--Meituan
--CPC
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],城市,[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)

SELECT 'Meituan',3,[日期],[门店ID],[门店名称],城市,'CPC',[推广消费],[订单交易额],[曝光提升数],[访问提升数],[订单提升数],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
AND 日期  >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
AND [推广产品]='点金推广' and 平台='meituan'
ORDER BY [门店名称],[日期]
GO

--CPM
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],城市,[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)

SELECT 'Meituan',3,[日期],[门店ID],[门店名称],城市,'CPM',[推广消费],[订单交易额],[曝光提升数],[访问提升数],[订单提升数],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
and 日期 >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
AND [推广产品]='铂金竞价购买' and  平台='Meituan'
ORDER BY [门店名称],[日期]
GO

UPDATE [dbo].[CPCCPMSummary]
SET [BDSStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[CityName] = b.[City],
	[CityTier] = b.[CityTier],
	[Market] = b.[Market]
FROM [dbo].[CPCCPMSummary] a 
JOIN [MCDDecisionSupport].[dbo].[MCDStoreList] b
ON a.[OriginalShopID] = b.MeiTuanID and a.OriginalShopName=b.MeiTuanOriginalShopName and a.城市=b.MCDCity
WHERE a.[ChannelName] = 'Meituan' and a.[BDSStoreName] is null

GO

-- Eleme

---CPC
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)
SELECT  'Eleme',2,time_sign,shop_id,shop_name,'CPC',total_cost,NULL,exposure_amount,total_count,NULL, 1
FROM
(
	SELECT *,row_number() over (partition by  shop_id ,time_sign order by total_cost desc) rn
	--,row_number() over (partition by  shop_id,shop_name ,time_sign order by total_cost desc) rn
	FROM [MCD].[Internal].[t_uv_seven_days_summary_trend_by_shop]
	WHERE 1 = 1
	AND [type]= '全部'
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

INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],城市,[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)

SELECT 'Eleme',2,[日期],[门店ID],[门店名称],城市,'CPC',[推广消费],[订单交易额],[曝光提升数],[访问提升数],[订单提升数],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
AND 日期  >(select dataperiod from [MCDDecisionSupport].[dbo].[CPCCPMSummarytempMaxdate])
AND [推广产品]='点金推广' and 平台='Eleme'
ORDER BY [门店名称],[日期]
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
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)
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

------调整eleme cpc/cpm 推广下单次数 和 推广带来的营业额

update [CPCCPMSummary]
set 推广下单次数 =Original推广下单次数
   ,推广带来的营业额 =Original推广带来的营业额
where [ChannelName] = 'Meituan' and 推广下单次数 is null

go


-- Eleme CPC推广下单次数
UPDATE [CPCCPMSummary]
SET 推广下单次数 = a.推广点击次数 * b.[自然下单转化率] / 2.5
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName,case sum(自然到店人数) when 0 then null else sum(自然下单人数)/sum(自然到店人数) end as [自然下单转化率]
	FROM dbo.[NaturalTraffic]
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPC'
and a.DataPeriod<'2019-06-01'  ----190909 新增
and 推广下单次数 is null

GO
-----190909 平台上饿了么的系数从6月1号的数据开始更新为1.2
UPDATE [CPCCPMSummary]
SET 推广下单次数 = a.推广点击次数 * b.[自然下单转化率] / 1.2
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName,case sum(自然到店人数) when 0 then null else sum(自然下单人数)/sum(自然到店人数) end as [自然下单转化率]
	FROM dbo.[NaturalTraffic] 
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPC'
and a.DataPeriod>='2019-06-01'  ----190909 新增
and 推广下单次数 is null

GO



UPDATE [CPCCPMSummary]
SET 推广带来的营业额 = a.推广下单次数 * b.[客单价]
FROM [CPCCPMSummary] a
JOIN 
(
  SELECT 平台,日期,BDSStoreName,cityname,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end as [客单价]
  FROM [MCDDecisionSupport].dbo.[SalesSummary]
  group by 平台,日期,BDSStoreName,cityname
) b
ON a.[ChannelName] = b.平台
AND a.[cityname] = b.cityname
AND a.DataPeriod = b.日期
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPC'
and 推广带来的营业额 is null

GO



--Eleme CPM推广下单次数
UPDATE [CPCCPMSummary]
SET 推广下单次数 = a.推广点击次数 * b.[自然下单转化率] / 2.5
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName
	,case sum(自然到店人数) when 0 then null else sum(自然下单人数)/sum(自然到店人数) end as [自然下单转化率]
	FROM dbo.[NaturalTraffic]
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPM'
and a.DataPeriod<'2019-06-01'  ----190909 新增
and 推广下单次数 is null

GO
-----190909 平台上饿了么的系数从6月1号的数据开始更新为1.2
UPDATE [CPCCPMSummary]
SET 推广下单次数 = a.推广点击次数 * b.[自然下单转化率] / 1.2
FROM [CPCCPMSummary] a
JOIN (
	SELECT cityname,DataPeriod,Channelname,BDSStoreName
	,case sum(自然到店人数) when 0 then null else sum(自然下单人数)/sum(自然到店人数) end as [自然下单转化率]
	FROM dbo.[NaturalTraffic]
	group by Channelname,DataPeriod,BDSStoreName,cityname
) b
ON a.Channelname = b.Channelname
AND a.cityname = b.cityname
AND a.DataPeriod = b.DataPeriod
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPM'
and a.DataPeriod>='2019-06-01'  ----190909 新增
and 推广下单次数 is null

GO


UPDATE [CPCCPMSummary]
SET 推广带来的营业额 = a.推广下单次数 * b.[客单价]
FROM [CPCCPMSummary] a
JOIN 
(
  SELECT 平台,日期,BDSStoreName,cityname,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end as [客单价]
  FROM [MCDDecisionSupport].dbo.[SalesSummary]
  group by 平台,日期,BDSStoreName,cityname
) b
ON a.[ChannelName] = b.平台
AND a.[cityname] = b.cityname
AND a.DataPeriod = b.日期
AND A.BDSStoreName=B.BDSStoreName
WHERE a.ChannelName = 'eleme' 
and PromotionType='CPM'
and 推广带来的营业额 is null

GO

-----
update [CPCCPMSummary]
set Market='Others' where Market is null and CityName is not null
go




/******* 促销活动订单占比 ************/

insert into [dbo].[OrderPromotion]([ChannelName],订单编号,店铺名称,商户编号,BDSStoreName,MCDStoreID,cityname,[Market],citytier,订单状态,下单时间,是否活动订单,商品原价,OriginalPromotioninfo)

select distinct a.平台,订单编号,店铺名称,商户编号,BDSStoreName,MCDStoreID,cityname,Market,citytier,订单状态,下单时间,是否活动订单,商品原价,v.value as value2
from(
	select distinct 平台,订单编号,店铺名称,商户编号,BDSStoreName,MCDStoreID,cityname,Market,citytier,订单状态,下单时间,是否活动订单,优惠活动,商品原价,v.value
	from [MCDDecisionSupport].dbo.[Order] p
	CROSS APPLY STRING_SPLIT(p.优惠活动, '/') v
	--where promotion='新用户下单立减16元;满30减7，满50减10，满100减13;单品定价;单品定价;'
)a
CROSS APPLY STRING_SPLIT(a.value, '+') v
where convert(varchar(10),下单时间,23) >(select dataperiod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
go

---
update [MCDDecisionSupport].dbo.[OrderPromotion]
set ordercode= replace(订单编号,char(9),'') 
where convert(varchar(10),下单时间,23) >(select dataperiod from [MCDDecisionSupport].[dbo].[OrderPromotiontempMaxdate])
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

----店铺名称不为空 商户编号不为空
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.EleMeOriginalShopName and a.商户编号=b.EleMeID
where 店铺名称!='' and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.MeiTuanOriginalShopName and a.商户编号=b.MeiTuanID
where 店铺名称!='' and [ChannelName]='meituan' and a.CityName is null

go

----店铺名称不为空 商户编号为空
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.EleMeOriginalShopName
where 店铺名称!='' and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.MeiTuanOriginalShopName
where 店铺名称!='' and [ChannelName]='meituan' and a.CityName is null

go

----店铺名称为空 商户编号不为空
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.商户编号=b.EleMeID
where 店铺名称='' and 商户编号 is not null and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on  a.商户编号=b.MeiTuanID
where 店铺名称='' and 商户编号 is not null and [ChannelName]='meituan' and a.CityName is null

go


----店铺名称为空  商户编号为空
update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.EleMeOriginalShopName
where 店铺名称='' and 商户编号 is null and [ChannelName]='eleme' and a.CityName is null

go

update [MCDDecisionSupport].dbo.[OrderPromotion]
SET [MCDStoreID] = b.[MCDStoreID],
	[BDSStoreName] = b.[BDSStoreName],
	[Cityname] = b.[City],
	[Market] = b.[Market],
	citytier= b.citytier
from [MCDDecisionSupport].dbo.[OrderPromotion] a
join [MCDDecisionSupport].[dbo].[MCDStoreList] b
on a.店铺名称=b.MeiTuanOriginalShopName
where 店铺名称='' and 商户编号 is null and [ChannelName]='meituan' and a.CityName is null

go



/******* 竞品促销 *********/

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





/********* 天气数据 ****************/
IF OBJECT_ID('[MCDDecisionSupport].[dbo].[WeatherMaxDate]') IS NOT NULL
    DROP TABLE [MCDDecisionSupport].[dbo].[WeatherMaxDate]

GO

create table [MCDDecisionSupport].[dbo].[WeatherMaxDate](MaxData date null)
go

insert into [MCDDecisionSupport].[dbo].[WeatherMaxDate]
select dateadd(day,1,max([prediction_date])) from [MCDDecisionSupport].[dbo].[WeatherTemp]
go



----温度
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
set temperature=replace(temperature,'℃','')
where charindex('℃',temperature)>0 and [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go


----风级
insert into [MCDDecisionSupport].dbo.windtemp([city_name],[prediction_date],wind_direction,create_time)

select distinct [city_name],[prediction_date],wind_direction,create_time
from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather] p
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.windtemp
set tag=case when b.tag='无风' then '0' else b.tag end
from [MCDDecisionSupport].dbo.windtemp a
join [MCDDecisionSupport].[dbo].[WeatherWindTag] b
on a.wind_direction=b.Wind_Level
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go


------雨雪等级

insert into [MCDDecisionSupport].dbo.dayweathertemp([city_name],[prediction_date],day_weather)

select distinct [city_name],[prediction_date],day_weather
from [211.152.47.71].[DC_WEATHER].[dbo].[city_weather] 
where (day_weather like'%雨%' or day_weather like'%雪%' or day_weather like'%冰雹%')
and [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.dayweathertemp
set rainid=case when day_weather='特大暴雨' then 1 when day_weather='大暴雨' then 2 when day_weather='暴雨' then 3 when day_weather='大雨' then 4 when day_weather='中雨' then 5 when day_weather='小雨' then 6 when day_weather='雷阵雨' then 7 when day_weather='阵雨' then 8 end
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go

update [MCDDecisionSupport].dbo.dayweathertemp
set snowid=case when day_weather='暴雪' then 1 when day_weather='大雪' then 2 when day_weather='中雪' then 3 when day_weather='小雪' then 4 when day_weather='阵雪' then 5 when day_weather='雨夹雪' then 6 when day_weather='冰雹' then 7 end
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
go


/********** 天气 ****************/

insert into [MCDDecisionSupport].[dbo].[cityweather]([cityname],[predictiondate],[maxtemperature],[mintemperature])

select [city_name],[prediction_date],max(temperature)+'℃',min(temperature)+'℃'
from [MCDDecisionSupport].dbo.WEATHERtemp
where [prediction_date]=(select MaxData from [MCDDecisionSupport].[dbo].[WeatherMaxDate])
group by [prediction_date],[city_name]
go

---风
update [MCDDecisionSupport].[dbo].[cityweather]
set winddirection=b.wind_direction
from [MCDDecisionSupport].[dbo].[cityweather] a
join(
  select * from (
	select city_name,prediction_date,wind_direction,tag,ROW_NUMBER() over (partition by city_name,prediction_date order by tag desc)rn
	from [MCDDecisionSupport].dbo.windtemp
	where tag like'%级%'
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
	where tag is null and wind_direction !='无持续风向'
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
	where tag is null and wind_direction ='无持续风向'
	)a
  where rn=1
)b
on a.cityname=b.city_name and a.predictiondate=b.prediction_date
where winddirection is null
go


----雨
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

----雪
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

----雨雪等级，雪>雨
update [MCDDecisionSupport].[dbo].[CityWeather]
set [RainSnowDirection] = [snowdirection]
go

update [MCDDecisionSupport].[dbo].[CityWeather]
set [RainSnowDirection] = [raindirection]
where [RainSnowDirection] is null
go

---空气质量
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

