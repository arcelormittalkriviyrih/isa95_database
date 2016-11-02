USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_KP4_WorkPerformance',N'P') IS NOT NULL
  DROP PROCEDURE dbo.upd_KP4_WorkPerformance;
GO

/****** Object:  StoredProcedure [dbo].[upd_KP4_WorkPerformance]    Script Date: 02.11.2016 14:41:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- вызов в ПО АРМ Весовщика
-- =============================================
CREATE PROCEDURE [dbo].[upd_KP4_WorkPerformance]
   @WorkPerformanceID int

AS
BEGIN

   UPDATE [dbo].[WorkPerformance] 
   SET    [EndTime]=getdate(), [WorkState]='Closed'
   WHERE  ID=@WorkPerformanceID

   UPDATE [dbo].[JobOrder]  
   SET    [DispatchStatus]=N'Closed', [EndTime]=CURRENT_TIMESTAMP
   WHERE  [WorkType]=N'KP4_WeightSheet'  AND [DispatchStatus]='Active' AND [Command] like '% '+cast(@WorkPerformanceID as nvarchar)

          
END

GO


