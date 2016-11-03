SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


IF OBJECT_ID ('dbo.v_KP4_WorkPerformance',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_WorkPerformance;
GO
 

CREATE VIEW [dbo].[v_KP4_WorkPerformance]
AS
SELECT        
	cast(row_number() OVER(ORDER BY WorkPerformance.ID, WorkResponse.ID) as int) AS ID, 
	WorkPerformance.[WorkState],
	dbo.WorkPerformance.ID AS WorkPerformanceID, 
	dbo.WorkPerformance.[Description],
	dbo.WorkPerformance.StartTime,
	dbo.WorkPerformance.EndTime,
	dbo.WorkResponse.[Description] AS Waybill, 
	dbo.WorkResponse.WorkType, 
	dbo.WorkResponse.StartTime	as WorkResponseStartTime, 
	dbo.WorkResponse.EndTime	as WorkResponseEndTime
FROM dbo.WorkPerformance 
left JOIN dbo.WorkResponse 
ON dbo.WorkPerformance.ID = dbo.WorkResponse.WorkPerfomence
