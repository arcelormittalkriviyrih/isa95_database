SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_KP4_LastWorkPerformance',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_LastWorkPerformance;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[v_KP4_LastWorkPerformance]
AS
select top 1 
	 WP.[ID]
	,WP.[Description] as [WeightSheetNumber]
	,WP.[WorkType]
	,WP.[StartTime]
	,WP.[EndTime]
	,WP.[WorkState]
	,SUBSTRING(WP.[WorkType], CHARINDEX('_', WP.[WorkType])+1, LEN(WP.[WorkType])) as [WeightBridgeID]
	,(select top 1 [WorkType] from [dbo].[WorkResponse] where WorkPerfomence = WP.ID) as [WeightingMode]
from [dbo].[WorkPerformance] as WP
where 
		WP.[WorkState] = 'Active' 
	and WP.[WorkType] like 'WSH_%'
order by WP.[ID] desc



GO