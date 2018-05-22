SET QUOTED_IDENTIFIER ON
GO
/*
IF OBJECT_ID ('dbo.v_AvailableWeighbridgesInfo',N'V') IS NOT NULL
  DROP VIEW dbo.v_AvailableWeighbridgesInfo;*/
GO


/*
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
      ,[L_bias_weight]
      ,[H_bias_weight]
      ,[Weight_OK]
      ,[Tara_OK]
      ,cast([stabilizing_weight] as int) as [stabilizing_weight]
FROM [AMKR_WEIGHING].[KEP_Analytics_Weight]
)

SELECT top 100
	   KEP.[ID]
      ,[ID_Scales]
	  ,AW.ID									as [EquipmentID]
      ,[DT]
      ,[Lafet]
      ,[Wagon]
      ,cast(0.001*[Weight] as real)				as [Weight]			
      ,cast(0.001*[Weight_platform_1] as real)	as [Weight_platform_1]
      ,cast(0.001*[Weight_platform_2] as real)	as [Weight_platform_2]
      ,cast(0.001*[L_bias_weight] as real)		as [L_bias_weight]
      ,cast(0.001*[H_bias_weight] as real)		as [H_bias_weight]
      ,[Weight_OK]
      ,[Tara_OK]
      ,[stabilizing_weight]
FROM KEP
inner join [dbo].[v_AvailableWeighbridges] AW on KEP.ID_Scales = AW.ScaleID
where	N = 1
	and	DT > getdate()-1.0/24
order by dt desc
*/


GO