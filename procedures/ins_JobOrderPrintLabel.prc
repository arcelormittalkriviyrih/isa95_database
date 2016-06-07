--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabel
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabel;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabel]
@PrinterID			INT,
@MaterialLotID	INT
AS
BEGIN

   DECLARE @JobOrderID INT;

   IF @PrinterID IS NULL
	  RAISERROR ('PrinterID param required',16,1);
   ELSE IF @MaterialLotID IS NULL
	  RAISERROR ('MaterialLotID param required',16,1);
	 ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Equipment] WHERE [ID]=@PrinterID)
	  RAISERROR (N'Принтер с кодом [%s] не существует',16,1,@PrinterID);
	 ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLot] WHERE [ID]=@MaterialLotID)
	  RAISERROR (N'MaterialLot ID=[%s] does not exists',16,1,@MaterialLotID);

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [DispatchStatus])
   VALUES (@JobOrderID,N'Print',N'ToPrint');

   INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID], [EquipmentID], [JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq
   WHERE [ID]=@PrinterID;

   INSERT INTO [dbo].[Parameter] ([Value], [JobOrder], [PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;
GO

