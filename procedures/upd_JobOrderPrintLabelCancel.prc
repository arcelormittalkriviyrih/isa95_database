SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelCancel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelCancel;
GO
--------------------------------------------------------------
-- Используется для отмены задания на печать
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelCancel] @MaterialLotIDs NVARCHAR(MAX)
AS
     BEGIN
         EXEC dbo.[upd_JobOrderPrintLabelChangeStatus]
              @MaterialLotIDs = @MaterialLotIDs,
              @Status = N'Done';
     END;
GO