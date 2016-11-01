USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_KP4_WorkPerformance',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_KP4_WorkPerformance;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec in  ins_KP4_TakeWeight
-- =============================================
CREATE PROCEDURE [dbo].[ins_KP4_WorkPerformance]
   @WorkPerformanceID int OUTPUT,
   @Description    nvarchar(50),
   @WeightBridgeID int
 
AS
BEGIN
 
   if (select count(ID) from [dbo].[WorkPerformance] where [WorkState] = 'Active' and [WorkType] = 'WSH_'+cast(@WeightBridgeID as nvarchar)) > 0
   RAISERROR ('WeightSheet has already been created',16,1);
			   
   SET @WorkPerformanceID=NEXT VALUE FOR [dbo].[gen_WorkPerformance];
   INSERT INTO [dbo].[WorkPerformance]        (ID   ,[Description]  ,[StartTime]    ,[WorkState]    ,WorkType)
   VALUES  (@WorkPerformanceID, 
            @Description, 
			CURRENT_TIMESTAMP, 
			N'Active', 
			'WSH_'+cast(@WeightBridgeID as nvarchar))

   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [DispatchStatus], [Command])
   VALUES   ((NEXT VALUE FOR [dbo].[gen_JobOrder]),  
            N'KP4_WeightSheet', 
			CURRENT_TIMESTAMP,
			N'Active', 
			'insert WorkPerformance ' + cast(@WorkPerformanceID as nvarchar));


END


