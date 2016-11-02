SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


IF OBJECT_ID ('dbo.v_AvailableWeighbridgesInfo',N'V') IS NOT NULL
  DROP VIEW dbo.v_AvailableWeighbridgesInfo;
GO
 




CREATE view [dbo].[v_AvailableWeighbridgesInfo]
as

with KEP as(
SELECT 
	   [ID]
	  ,ROW_NUMBER() over(partition by [ID_Scales] order by [DT] desc) N
      ,[ID_Scales]
      ,[DT]
      ,[Lafet]
      ,[Wagon]
      ,[Weight]
      ,[Weight_platform_1]
      ,[Weight_platform_2]
	 -- ,	cast(1000*2.3*1.2*(sin(1.1+0.5*cos(pi()+0.1*pi()*datepart(ss, getdate())))-0.56)*	
		--case
		--	when datepart(ss, getdate()) between 0 and 20
		--	then 48+5*rand(2000*datepart(mi, getdate())+500*datepart(ss, getdate())/10)
		--	else 50+25*rand(2000*datepart(mi, getdate())+500*datepart(ss, getdate())/10)
		--end as int) [Weight]
	 -- ,cast(1000*2.3*(sin(1.1+0.5*cos(pi()+0.1*pi()*datepart(ss, getdate())))-0.56)*	
		--case
		--	when datepart(ss, getdate()) between 0 and 20
		--	then 48+5*rand(2000*datepart(mi, getdate())+500*datepart(ss, getdate())/10)
		--	else 50+25*rand(2000*datepart(mi, getdate())+500*datepart(ss, getdate())/10)
		--end as int) [Weight_platform_1]
	 -- ,cast(1000*2.3/2*(sin(1.1+0.5*cos(pi()+0.1*pi()*datepart(ss, getdate())))-0.56)*	
		--case
		--	when datepart(ss, getdate()) between 0 and 20
		--	then 48+5*rand(2000*datepart(mi, getdate())+500*datepart(ss, getdate())/10)
		--	else 50+25*rand(2000*datepart(mi, getdate())+500*datepart(ss, getdate())/10)
		--end as int) [Weight_platform_2]
      ,[L_bias_weight]
      ,[H_bias_weight]
      ,[Weight_OK]
      ,[Tara_OK]
      ,cast([stabilizing_weight] as int) as [stabilizing_weight]
	 -- , case
		--	when sin(1.1+0.5*cos(pi()+0.1*pi()*datepart(ss, getdate()))) - sin(1.1+0.5*cos(pi()+0.1*pi()*(datepart(ss, getdate())-1))) between -0.007 and 0.007
		--	then 1
		--	else 0
		--end	[stabilizing_weight]
FROM [dbo].[KEP_Analytics_Weight]
)

SELECT top 10
	  KEP.[ID]
      ,[ID_Scales]
      ,[DT]
      ,[Lafet]
      ,[Wagon]
      ,cast(0.001*[Weight] as real)				as [Weight]			
      ,cast(0.001*[Weight_platform_1] as real)	as [Weight_platform_1]
      ,cast(0.001*[Weight_platform_2] as real)	as [Weight_platform_2]
      ,[L_bias_weight]
      ,[H_bias_weight]
      ,[Weight_OK]
      ,[Tara_OK]
      ,[stabilizing_weight]
FROM KEP
inner join [dbo].[v_AvailableWeighbridges] AW on KEP.ID_Scales = AW.ID
where	N = 1
	and	DT > getdate()-1.0/24
order by dt desc




GO


