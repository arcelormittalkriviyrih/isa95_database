SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelReprint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelReprint;
GO
--------------------------------------------------------------
-- Используется повторной отправки бирок на печать
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelReprint] @MaterialLotIDs NVARCHAR(MAX)
AS
     BEGIN
         EXEC dbo.[upd_JobOrderPrintLabelChangeStatus]
              @MaterialLotIDs = @MaterialLotIDs,
              @Status = N'ToPrint';
     END;

GO


