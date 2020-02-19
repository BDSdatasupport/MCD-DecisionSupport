USE [MCDDecisionSupport]
GO

delete from [Order] where convert(varchar(10),下单时间,23) between '' and ''
delete from [SalesSummary] where 日期 between '' and ''
delete from [NaturalTraffic] where [DataPeriod] between '' and ''
delete from [NaturalTrafficImport] where [DataPeriod] between '' and ''
delete from [CPCCPMSummary] where [DataPeriod] between '' and '' --跟[NaturalTraffic]、[SalesSummary]也有关，即这两张表任意一张有某天改动，cpccpm也要重新计算
delete from [OrderPromotion] where convert(varchar(10),下单时间,23) between '' and '' --跟[Order]有关


delete from [report].[ResultTimeDivisionSales] where [Date] between '' and '' --跟[Order]有关
delete from [report].[ResultTimeDivisionSalesProportion] where [Date] between '' and ''   --跟[ResultTimeDivisionSales]有关
delete from [report].ResultDailySales where [Date] between '' and '' --跟[SalesSummary]有关
delete from [report].[ResultNaturalTraffic] where DataPeriod between '' and '' --跟[NaturalTraffic]有关
delete from [report].[ResultNaturalTrafficImport] where DataPeriod between '' and '' --跟[NaturalTrafficImport]有关
delete from [report].[ResultCPCCPMSummary] where DataPeriod between '' and '' --跟[CPCCPMSummary]有关
delete from [report].[ResultDeliveryOrderPromotion] where [Date] between '' and ''--跟[OrderPromotion]有关
go



---------------- dbo ----------------
USE [MCDDecisionSupport]
GO

-----获取每张dbo表最大日期


/***** 订单数据 ：用于计算分时间段营业额 *******************/

-----每天获取前一天的 internal 订单数据
insert into [MCDDecisionSupport].dbo.[Order](平台,订单编号,接单时长,店铺名称,商户编号,城市,支付方式,订单状态,订单配送状态,配送方式,订单取消原因,是否预定单,下单时间,接单时间,订单完成时间,配送时间,预定送达时间,订单总金额,实付金额,平台活动补贴,商家活动补贴,商户配送补贴,配送费,是否活动订单,优惠活动,菜品信息,餐盒费总金额,餐盒总数量,订单评分,订单评价,是否催单,回复状态,商家回复内容,商家优惠券补贴金额,商品原价)

select 平台,订单编号,接单时长,店铺名称,商户编号,城市,支付方式,订单状态,订单配送状态,配送方式,订单取消原因,是否预定单,下单时间,接单时间,订单完成时间,配送时间,预定送达时间,订单总金额,实付金额,平台活动补贴,商家活动补贴,商户配送补贴,配送费,是否活动订单,优惠活动,菜品信息,餐盒费总金额,餐盒总数量,订单评分,订单评价,是否催单,回复状态,商家回复内容,商家优惠券补贴金额,商品原价
from [MCD].[Internal].[Order]
where convert(varchar(10),下单时间,23) between '' and ''
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
	where data_date between '' and ''
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
	where data_date between '' and ''
)a
where rn=1
order by data_date

GO

INSERT INTO  [dbo].[NaturalTraffic]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopName],城市,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT 'Meituan',3,[日期],[门店],[城市(负责人)],[曝光人数],[访问人数],[下单人数]
FROM  [MCD].[dbo].[TrafficSummaryMeituan]
where [日期]  between '' and ''

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
and data_date  between '' and ''
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
and convert(date,create_time-1)  between '' and ''
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
AND 日期   between '' and ''
AND [推广产品]='点金推广' and 平台='meituan'
ORDER BY [门店名称],[日期]
GO

--CPM
INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],城市,[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)

SELECT 'Meituan',3,[日期],[门店ID],[门店名称],城市,'CPM',[推广消费],[订单交易额],[曝光提升数],[访问提升数],[订单提升数],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
and 日期  between '' and ''
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

INSERT INTO  [dbo].[CPCCPMSummary]( [ChannelName],[ChannelID],[DataPeriod],[OriginalShopID],[OriginalShopName],城市,[PromotionType],[推广费用],[Original推广带来的营业额],[推广曝光次数],[推广点击次数],[Original推广下单次数],datatag)

SELECT 'Eleme',2,[日期],[门店ID],[门店名称],城市,'CPC',[推广消费],[订单交易额],[曝光提升数],[访问提升数],[订单提升数],0
FROM [MCD].[internal].[PromotionResult]
WHERE 1 = 1
AND 日期   between '' and ''
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
where convert(varchar(10),下单时间,23)  between '' and ''
go

---
update [MCDDecisionSupport].dbo.[OrderPromotion]
set ordercode= replace(订单编号,char(9),'') 
where convert(varchar(10),下单时间,23)  between '' and ''
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







---------------- report ----------------

use [MCDDecisionSupport]
go



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
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by 平台,cityname,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='加总'
and a.[Date]  between '' and ''
go


------------------ tye=单店日均 
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,CityName,Market,[Date],营业额)

select '单店日均',平台,cityname,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by 平台,cityname,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 AND A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='单店日均'
and a.date  between '' and ''
go


-------------- 2) market level
------------------ tye=加总 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额)

select CalculateType,ChannelName,-1,Market,Market,[Date],sum(营业额),sum(早餐营业额),sum(午餐营业额),sum(下午茶营业额),sum(晚餐营业额),sum(宵夜营业额),sum(通宵营业额)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='加总' and ChannelName<>'total'
and [Date]  between '' and ''
group by CalculateType,ChannelName,Market,[Date]

go

------------------ tye=单店日均
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均',平台,-1,Market,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by 平台,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 AND A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='单店日均' and cityid='-1'
and a.date  between '' and ''
go
 

-------------- 3) 全国 level
------------------ tye=加总 
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额)

select CalculateType,ChannelName,0,'全国','全国',[Date],sum(营业额),sum(早餐营业额),sum(午餐营业额),sum(下午茶营业额),sum(晚餐营业额),sum(宵夜营业额),sum(通宵营业额)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='加总' and ChannelName<>'total' and cityid is null
and [Date]  between '' and ''
group by CalculateType,ChannelName,[Date]

go

------------------ tye=单店日均
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均',平台,0,'全国','全国',convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by 平台,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.ChannelName=B.平台 and A.Date=B.DATE
WHERE A.CalculateType='单店日均' and cityid='0'
and a.Date  between '' and ''
go
 


------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
				
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,早餐营业额,午餐营业额,下午茶营业额,晚餐营业额,宵夜营业额,通宵营业额)

select CalculateType,'Total',cityid,CityName,Market,[Date],sum(营业额),sum(早餐营业额),sum(午餐营业额),sum(下午茶营业额),sum(晚餐营业额),sum(宵夜营业额),sum(通宵营业额)
from [MCDDecisionSupport].[report].[ResultTimeDivisionSales] 
where CalculateType='加总' and ChannelName<>'Total'
and [Date]  between '' and ''
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
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by cityname,Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON  A.CityName=B.cityname AND A.Date=B.DATE
WHERE A.CalculateType='单店日均' and ChannelName='total'
and a.date  between '' and ''
go

---------market level
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均','Total',-1,Market,Market,convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by Market,convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON  A.CityName=B.Market AND A.Date=B.DATE
WHERE A.CalculateType='单店日均' and ChannelName='total' and cityid='-1'
and a.date  between '' and ''
go

---------全国 level
-----订单总营业额
insert into [MCDDecisionSupport].[report].[ResultTimeDivisionSales](
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额)

select '单店日均','Total',0,'全国','全国',convert(varchar(10),下单时间,23)
,CASE count(distinct BDSStoreName) WHEN 0 THEN NULL ELSE sum(订单总金额)/count(distinct BDSStoreName)END
from [MCDDecisionSupport].dbo.[Order]
where convert(varchar(10),下单时间,23)  between '' and ''
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
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by convert(varchar(10),下单时间,23),时间段
  ) a
  pivot(sum(总金额) for 时间段 in([早餐],[午餐],[下午茶],[晚餐],[宵夜],[通宵]))T
)B
ON A.Date=B.DATE
WHERE A.CalculateType='单店日均' and ChannelName='total' and cityid='0'
and a.date  between '' and ''
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
where Date  between '' and ''
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
where 日期  between '' and ''
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
where 日期  between '' and ''
group by 平台,cityname,Market,日期
go


-------------- 2) market level
------------------ tye=加总
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '加总',平台,-1,Market,Market,日期,sum(营业额),sum(商户总补贴),sum(有效订单数),sum(无效订单数)
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期  between '' and ''
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
where 日期  between '' and ''
group by 平台,Market,日期
go

-------------- 2) 全国 level
------------------ tye=加总
insert into [MCDDecisionSupport].report.ResultDailySales(
CalculateType,ChannelName,cityid,CityName,Market,[Date],营业额,商户补贴,有效订单数,无效订单数,客单价)

select '加总',平台,0,'全国','全国',日期,sum(营业额),sum(商户总补贴),sum(有效订单数),sum(无效订单数)
,case when sum(有效订单数)=0 then null else sum(营业额-商户总补贴)/sum(有效订单数)end
from [MCDDecisionSupport].dbo.[SalesSummary]
where 日期  between '' and ''
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
where 日期  between '' and ''
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
and date  between '' and ''
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
where 日期  between '' and ''
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
where 日期  between '' and ''
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
where 日期  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,-1,Market,Market,sum([自然曝光人数]),sum([自然到店人数]),sum([自然下单人数])
FROM [dbo].[NaturalTraffic]
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

-------------- 3) 全国 level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTraffic] (CalculateType,ChannelName,ChannelID,DataPeriod,cityID,cityname,Market,[自然曝光人数],[自然到店人数],[自然下单人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,0,'全国','全国',sum([自然曝光人数]),sum([自然到店人数]),sum([自然下单人数])
FROM [dbo].[NaturalTraffic]
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[列表名]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[列表名],[自然曝光人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market,[列表名]
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY cityname,DataPeriod,ChannelName,ChannelID,CityTier,Market,[列表名]
ORDER BY cityname,DataPeriod,ChannelName,ChannelID

GO


-------------- 2) market level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[列表名],sum([自然曝光人数])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,-1,Market,Market,[列表名]
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY ChannelName,ChannelID,DataPeriod,Market,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO

-------------- 3) 全国 level
------------------ tye=加总 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '加总',ChannelName,ChannelID,DataPeriod,0,'全国','全国',[列表名],sum([自然曝光人数])
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
GROUP BY ChannelName,ChannelID,DataPeriod,[列表名]
ORDER BY ChannelName,ChannelID,DataPeriod,[列表名]

GO

------------------ tye=单店日均 
INSERT INTO [Report].[ResultNaturalTrafficImport] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market,[列表名],[自然曝光人数])

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,0,'全国','全国',[列表名]
,case count(distinct BDSStoreName) when 0 then null else sum([自然曝光人数])/count(distinct BDSStoreName)end
FROM [dbo].[NaturalTrafficImport]
where DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
GROUP BY DataPeriod,ChannelName,ChannelID,Market
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,-1,Market,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
GROUP BY DataPeriod,ChannelName,ChannelID
ORDER BY DataPeriod,ChannelName,ChannelID

GO

------------------ tye=单店日均
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityid,cityname,Market)

SELECT '单店日均',ChannelName,ChannelID,DataPeriod,0,'全国','全国'
FROM [dbo].[CPCCPMSummary]
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
and DataPeriod  between '' and ''
GROUP BY DataPeriod,cityid,cityname,Market
ORDER BY DataPeriod,cityname

GO

			
------------------2) tye=单店日均 
---------city level
INSERT INTO [Report].[ResultCPCCPMSummary] (CalculateType,ChannelName,ChannelID,DataPeriod,cityname,CityTier,Market)

SELECT '单店日均','Total',1,DataPeriod,cityname,CityTier,Market
FROM [dbo].[CPCCPMSummary]
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
	and DataPeriod  between '' and ''
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
where convert(varchar(10),下单时间,23)  between '' and ''
group by channelname,cityname,market,convert(varchar(10),下单时间,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
    select channelname,cityname,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode)订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by channelname,cityname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='加总' and date  between '' and ''
go

------------------ tye=单店日均 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],market,[Date],[Type],[活动订单数])

select '单店日均',channelname,cityname,market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by channelname,cityname,market,convert(varchar(10),下单时间,23),[Type]
go


update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,cityname,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion] a
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by channelname,cityname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.cityname and a.Date=b.OrderDate
where [CalculateType]='单店日均' and date  between '' and ''
go


-------------- 2) market level
------------------ tye=加总 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '加总',channelname,-1,Market,Market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by channelname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by channelname,Market,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='加总' and cityid='-1' and date  between '' and ''
go


------单店日均
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均',channelname,-1,Market,Market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by channelname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,Market,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by channelname,Market,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.CityName=b.Market and a.Date=b.OrderDate
where [CalculateType]='单店日均' and cityid='-1' and date  between '' and ''
go

-------------- 3) 全国 level
------------------ tye=加总 
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '加总',channelname,0,'全国','全国',convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by channelname,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by channelname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='加总' and cityid='0' and date  between '' and ''
go


------单店日均
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],CityID,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均',channelname,0,'全国','全国',convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by channelname,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select channelname,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by channelname,convert(varchar(10),下单时间,23)
)b
on a.ChannelName=b.ChannelName and a.Date=b.OrderDate
where [CalculateType]='单店日均' and cityid='0' and date  between '' and ''
go

------------2. channel=total(eleme+meituan) 
-----------------不同平台同家店只能算一次，因此计算店均时count(distinct BDSStoreName)需要使用源数据,加总数据不涉及店铺数，因此可直接将结果表中两平台数据相加

------------------1) tye=加总 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[活动订单数])

select '加总','Total',cityname,Market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by cityname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),下单时间,23) OrderDate
	,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by cityname,Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='加总' and [ChannelName]='total' and date  between '' and ''
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '加总','Total',-1,Market,Market,convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='加总' and [ChannelName]='total' and cityid='-1'
and date  between '' and ''
go

---------全国 level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '加总','Total',0,'全国','全国',convert(varchar(10),下单时间,23),[Type],count(distinct OrderCode)
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),下单时间,23) OrderDate,count(distinct OrderCode) 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by convert(varchar(10),下单时间,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='加总' and [ChannelName]='total' and cityid='0'
and date  between '' and ''
go



------------------2) tye=单店日均 
---------city level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均','Total',cityname,Market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by cityname,Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select cityname,Market,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by cityname,Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.cityname and a.Date=b.OrderDate
where [CalculateType]='单店日均' and [ChannelName]='total' and date  between '' and ''
go

---------market level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均','Total',-1,Market,Market,convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by Market,convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select Market,convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by Market,convert(varchar(10),下单时间,23)
)b
on a.cityname=b.Market and a.Date=b.OrderDate
where [CalculateType]='单店日均' and [ChannelName]='total' and cityid='-1'
and date  between '' and ''
go


---------全国 level
insert into [Report].[ResultDeliveryOrderPromotion](
[CalculateType],[ChannelName],cityid,[CityName],Market,[Date],[Type],[活动订单数])

select '单店日均','Total',0,'全国','全国',convert(varchar(10),下单时间,23),[Type]
,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end
from [MCDDecisionSupport].dbo.[OrderPromotion]
where convert(varchar(10),下单时间,23)  between '' and ''
group by convert(varchar(10),下单时间,23),[Type]
go

update [Report].[ResultDeliveryOrderPromotion]
set 订单总数=b.订单总数
from [Report].[ResultDeliveryOrderPromotion] a
join(
	select convert(varchar(10),下单时间,23) OrderDate
	,case count(distinct bdsstorename) when 0 then null else count(distinct OrderCode)/count(distinct bdsstorename) end 订单总数
	from [MCDDecisionSupport].dbo.[OrderPromotion]
	where convert(varchar(10),下单时间,23)  between '' and ''
	group by convert(varchar(10),下单时间,23)
)b
on a.Date=b.OrderDate
where [CalculateType]='单店日均' and [ChannelName]='total' and cityid='0'
and date  between '' and ''
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


