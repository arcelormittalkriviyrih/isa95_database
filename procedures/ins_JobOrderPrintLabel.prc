--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabel
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabel;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderPrintLabel
	Процедура создания Job на печать или отправку бирки.

	Parameters:

		PrinterID     - Printer ID,
		MaterialLotID - MaterialLot ID,
		Command       - Email или Print,
		CommandRule   - Список адресов,
		WorkRequestID - WorkRequestID

	See Also:

		<ins_JobOrderToPrint>
*/
CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabel]
@PrinterID      NVARCHAR(255) = NULL,
@MaterialLotID  INT,
@Command        NVARCHAR(50),
@CommandRule    NVARCHAR(50) = NULL,
@WorkRequestID  INT = NULL

AS
BEGIN

   DECLARE @err_message NVARCHAR(255),
           @EquipmentID INT;

   IF @Command IS NULL
      THROW 60001, N'Command param required', 1;
   ELSE IF @PrinterID IS NULL AND @Command=N'Print' 
      THROW 60001, N'PrinterID param required for Print Command', 1;
   ELSE IF @MaterialLotID IS NULL
      THROW 60001, N'MaterialLotID param required', 1;
   ELSE IF @CommandRule IS NULL AND @Command=N'Email' 
      THROW 60001, N'CommandRule param required for Email Command', 1;
   ELSE IF @PrinterID IS NOT NULL 
      SET @EquipmentID = [dbo].[get_EquipmentIdByPropertyValue](@PrinterID,N'PRINTER_NO');
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLot] WHERE [ID]=@MaterialLotID)
      BEGIN
         SET @err_message = N'MaterialLot ID [' + CAST(@MaterialLotID AS NVARCHAR) + N'] does not exists';
         THROW 60010, @err_message, 1;
      END;

   IF @EquipmentID IS NULL
      BEGIN
         SET @err_message = N'Принтер с идентификатором "' + @PrinterID + N'" не существует';
          THROW 60010, @err_message, 1;
      END;

   EXEC [dbo].[ins_JobOrderToPrint] @EquipmentID = @EquipmentID,
                                    @MaterialLotID = @MaterialLotID,
                                    @Command = @Command,
                                    @CommandRule = @CommandRule,
                                    @WorkRequestID = @WorkRequestID;

END;
GO

