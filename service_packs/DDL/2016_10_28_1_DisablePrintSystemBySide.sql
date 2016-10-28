SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_SideIdByMaterialLotID', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIdByDescription;
GO
/*
   Function: get_SideIdByMaterialLotID

   Функция получения ID стороны стана по MaterialLotID

   Parameters:

      MaterialLotID - MaterialLotID.
      
   Returns:
	  
	  ID стороны стана.

*/
CREATE FUNCTION dbo.get_SideIdByMaterialLotID(@MaterialLotID INT)
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=e.Equipment
FROM EquipmentProperty p,EquipmentClassProperty cp, Equipment e 
where p.ClassPropertyID=cp.ID 
and p.Value=(select SUBSTRING(FactoryNumber,7,2) from MaterialLot where id=@MaterialLotID) 
and cp.Value=N'SCALES_NO'
and p.EquipmentID=e.ID

RETURN @Id;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommand
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommand',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommand;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommand
	Процедура отправки комманд на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		Tag             - Имя комманды,
		TagType         - Тип,
		TagValue        - Значение.

*/

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommand]
@WorkRequestID   INT,
@EquipmentID     INT,
@Tag             NVARCHAR(255),
@TagType         NVARCHAR(50),
@TagValue        NVARCHAR(255)
AS
BEGIN

	IF dbo.get_GlobalOption(N'PRINT_SYSTEM_ENABLED')=N'false'
		NOTHING_TODO:
	ELSE
		BEGIN

		   DECLARE @err_message   NVARCHAR(255);

		   IF @WorkRequestID IS NULL
			THROW 60001, N'WorkRequestID param required', 1;
		   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[WorkRequest] WHERE [ID]=@WorkRequestID)
			  BEGIN
				 SET @err_message = N'WorkRequest [' + CAST(@WorkRequestID AS NVARCHAR) + N'] not exists';
				 THROW 60010, @err_message, 1;
			  END;
		   ELSE IF @EquipmentID IS NULL
			THROW 60001, N'EquipmentID param required', 1;
		   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Equipment] WHERE [ID]=@EquipmentID)
			  BEGIN
				 SET @err_message = N'Equipment [' + CAST(@EquipmentID AS NVARCHAR) + N'] not exists';
				 THROW 60010, @err_message, 1;
			  END;
		   ELSE IF @Tag IS NULL
			THROW 60001, N'Tag param required', 1;
		   ELSE IF @TagType IS NULL
			THROW 60001, N'TagType param required', 1;
		   ELSE IF @TagType NOT IN (N'Boolean',N'Byte',N'Short',N'Word',N'Long',N'Dword',N'Float',N'Double',N'Char',N'String')
			  BEGIN
				 SET @err_message = N'[' + @TagType + N'] is not valid value for TagType param';
				 THROW 60010, @err_message, 1;
			  END;
		   ELSE IF @TagValue IS NULL
			THROW 60001, N'TagValue param required', 1;

		   DECLARE @JobOrderID  INT,
				   @Command     NVARCHAR(50),
				   @SideID		INT,
				   @SideEnabled NVARCHAR(50),
				   @CommandRule NVARCHAR(50);

		   SET @SideID = (select Equipment from Equipment where ID=@EquipmentID);
		   SET @SideEnabled = dbo.get_EquipmentPropertyValue(@SideID,N'SIDE_ENABLED');

		   IF @SideEnabled =N'1' 
		   BEGIN
			   SET @JobOrderID = NEXT VALUE FOR [dbo].[gen_JobOrder];
			   SET @Command = dbo.get_EquipmentPropertyValue(@EquipmentID,N'OPC_DEVICE_NAME')+ N'.' +  @Tag;
			   SET @CommandRule = N'(' + @TagType + N')' + @TagValue;
			   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest], [DispatchStatus], [Command], [CommandRule])
			   VALUES (@JobOrderID,N'KEPCommands',CURRENT_TIMESTAMP,@WorkRequestID,N'ToSend',@Command,@CommandRule);
		   END;

		END;

END;
GO

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

	IF dbo.get_GlobalOption(N'PRINT_SYSTEM_ENABLED')=N'false'
		NOTHING_TODO:
	ELSE
		BEGIN

		   DECLARE @err_message NVARCHAR(255),
				   @SideID		INT,
				   @SideEnabled NVARCHAR(50),
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

		   SET @SideID = dbo.get_SideIdByMaterialLotID(@MaterialLotID);
		   SET @SideEnabled = dbo.get_EquipmentPropertyValue(@SideID,N'SIDE_ENABLED');

		   IF @SideEnabled =N'1' 
			   EXEC [dbo].[ins_JobOrderToPrint] @EquipmentID = @EquipmentID,
												@MaterialLotID = @MaterialLotID,
												@Command = @Command,
												@CommandRule = @CommandRule,
												@WorkRequestID = @WorkRequestID;
		END;
END;
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_JobOrderSAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderSAPExport;
GO
--------------------------------------------------------------

/*
	Procedure: ins_JobOrderSAPExport
	Используется для создания задания на отправку бирки в САП.

	Parameters:

		MaterialLotID  - MaterialLot ID,
		WorkRequestID  - WorkRequest ID

	
*/
CREATE PROCEDURE [dbo].[ins_JobOrderSAPExport]
@MaterialLotID   INT,
@WorkRequestID   INT = NULL
AS
BEGIN

	IF dbo.get_GlobalOption(N'PRINT_SYSTEM_ENABLED')=N'false'
		NOTHING_TODO:
	ELSE
		BEGIN

		   DECLARE @JobOrderID    INT,
				   @err_message   NVARCHAR(255),
				   @SideID		  INT,
				   @SideEnabled	  NVARCHAR(50),
				   @LinkedServer  NVARCHAR(50);

		   SET @SideID = dbo.get_SideIdByMaterialLotID(@MaterialLotID);
		   SET @SideEnabled = dbo.get_EquipmentPropertyValue(@SideID,N'SIDE_ENABLED');

		   IF @SideEnabled =N'1'
		   BEGIN
			   SET @LinkedServer=(SELECT top 1 Parameter from WorkDefinition where WORKType='SAPExport' order by ID desc);

			   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
			   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[WorkRequest],CommandRule)
			   VALUES (@JobOrderID,N'SAPExport',N'TODO',CURRENT_TIMESTAMP,@WorkRequestID,@LinkedServer);
 
			   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
			   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
			   FROM [dbo].[PropertyTypes] pt
			   WHERE pt.[Value]=N'MaterialLotID';
			END;

		END;

END;

GO

