--------------------------------------------------------------
-- Процедура ins_ExportJobOrderToSAP
IF OBJECT_ID ('dbo.ins_ExportJobOrderToSAP',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ExportJobOrderToSAP;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_ExportJobOrderToSAP]
@JobOrderID INT
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @MaterialLotID INT;

   SET @MaterialLotID=CAST(dbo.get_JobOrderPropertyValue(@JobOrderID,N'MaterialLotID') AS INT);

   EXEC [dbo].[ins_ExportMaterialLotToSAP] @MaterialLotID=@MaterialLotID;

END;
GO

