
IF OBJECT_ID ('dbo.upd_WeightingOperations',N'P') IS NOT NULL
  DROP PROCEDURE dbo.upd_WeightingOperations;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
create PROCEDURE [dbo].[upd_WeightingOperations]
   @WeightingOperationsID int,
   @Status nvarchar(20)
AS
BEGIN
	IF @WeightingOperationsID IS NULL
    THROW 60001, N'WeightingOperationsID param required', 1;

	update WO
	set WO.[Status] = @Status
	FROM [dbo].[WeightingOperations] WO
	join [dbo].[Documentations] D
	on WO.DocumentationsID = D.ID
	where D.[Status] = N'active' and WO.ID = @WeightingOperationsID
          
END

GO