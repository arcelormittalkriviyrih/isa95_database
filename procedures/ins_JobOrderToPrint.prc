--------------------------------------------------------------
-- Процедура ins_JobOrderToPrint
IF OBJECT_ID ('dbo.ins_JobOrderToPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderToPrint;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderToPrint]
@EquipmentID     INT,
@MaterialLotID   INT,
@Command         NVARCHAR(50),
@CommandRule     NVARCHAR(50) = NULL,
@WorkRequestID   INT = NULL

AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255);

   IF NOT EXISTS (SELECT NULL 
                  FROM [dbo].[Equipment] eq INNER JOIN [dbo].[EquipmentClass] eqc ON (eqc.[ID] = eq.[EquipmentClassID] AND eqc.[Code]=N'PRINTER')
                  WHERE eq.[ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment ID=[' + CAST(@EquipmentID AS NVARCHAR) + N'] is not a PRINTER';
         THROW 60010, @err_message, 1;
      END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[Command],[CommandRule],[WorkRequest])
   VALUES (@JobOrderID,N'Print',N'ToPrint',CURRENT_TIMESTAMP,@Command,@CommandRule,@WorkRequestID);

	 INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq
   WHERE [ID]=@EquipmentID;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;
GO

