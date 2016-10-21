SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.exec_SAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.exec_SAPExport;
GO
--------------------------------------------------------------
/*
	Procedure: exec_SAPExport
	Используется для выполнения экспорта бирок в САП.
*/

CREATE PROCEDURE [dbo].[exec_SAPExport]
AS
BEGIN

	IF dbo.get_GlobalOption(N'PRINT_SYSTEM_ENABLED')=N'false'
		NOTHING_TODO:
	ELSE
		BEGIN

			DECLARE @MaterialLotID int, @JobOrderID int, @LinkedServer NVARCHAR(50);


			DECLARE selMaterialLots CURSOR
			FOR SELECT p.[Value], o.ID, o.CommandRule
				FROM [dbo].JobOrder AS o, [dbo].[Parameter] AS p, [dbo].[PropertyTypes] AS pt
				WHERE o.ID = p.JobOrder AND 
					  p.PropertyType = pt.ID AND 
					  pt.[Value] = N'MaterialLotID' AND 
					  o.WorkType = N'SAPExport' AND
					  o.DispatchStatus = N'TODO';
			OPEN selMaterialLots;
			FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID, @LinkedServer;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				BEGIN TRY
					EXEC DBO.[ins_ExportMaterialLotToSAP] @MaterialLotID = @MaterialLotID, @LinkedServer = @LinkedServer;
					update [dbo].JobOrder set DispatchStatus=N'Done',EndTime=CURRENT_TIMESTAMP where id=@JobOrderID;
				END TRY
				BEGIN CATCH

					EXEC [dbo].[ins_ErrorLog];
				END CATCH;

				FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID, @LinkedServer;
			END;
			CLOSE selMaterialLots;
			DEALLOCATE selMaterialLots;

	END;
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
				   @CommandRule NVARCHAR(50);

		   SET @JobOrderID = NEXT VALUE FOR [dbo].[gen_JobOrder];
		   SET @Command = dbo.get_EquipmentPropertyValue(@EquipmentID,N'OPC_DEVICE_NAME')+ N'.' +  @Tag;
		   SET @CommandRule = N'(' + @TagType + N')' + @TagValue;
		   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest], [DispatchStatus], [Command], [CommandRule])
		   VALUES (@JobOrderID,N'KEPCommands',CURRENT_TIMESTAMP,@WorkRequestID,N'ToSend',@Command,@CommandRule);

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
END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByScalesNo


IF OBJECT_ID('dbo.ins_JobOrderPrintLabelByScalesNo', N'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo;
    END;
GO

SET QUOTED_IDENTIFIER ON;
GO
/*
	Procedure: ins_JobOrderPrintLabelByScalesNo
	Процедура создания бирки и Job на печать бирки.

	Parameters:

		SCALES_NO  - Идентификатор весов,
		TIMESTAMP  - Дата и время,
        WEIGHT_FIX - Вес,
        AUTO_MANU  - Признак AUTO_MANU,
        IDENT      - Идентификатор взвешивания

	
*/
CREATE PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo @SCALES_NO  NVARCHAR(50),
                                                      @TIMESTAMP  DATETIME,
                                                      @WEIGHT_FIX INT,
                                                      @AUTO_MANU  BIT,
                                                      @IDENT      NVARCHAR(50)
AS
     BEGIN
         BEGIN TRY
             DECLARE @EquipmentID INT, @FactoryNumber NVARCHAR(12), @PrinterID NVARCHAR(50), @JobOrderID INT, @WorkType NVARCHAR(50), @WorkDefinitionID INT, @MaterialLotID INT, @Status NVARCHAR(250), @err_message NVARCHAR(255), @Weight_Rounded INT;
             IF NOT EXISTS
             (
                 SELECT NULL
                 FROM MaterialLotProperty AS mlp,
                      PropertyTypes AS pt
                 WHERE pt.ID = mlp.PropertyType
                       AND pt.[Value] = N'MATERIAL_LOT_IDENT'
                       AND mlp.[Value] = @IDENT
             )
                 BEGIN
                     SET @EquipmentID = dbo.get_EquipmentIDByScalesNo(@SCALES_NO);
                     IF @EquipmentID IS NULL
                         BEGIN
                             SET @err_message = N'By SCALES_NO=['+@SCALES_NO+N'] EquipmentID not found';
                             THROW 60010, @err_message, 1;
                         END;

/*
      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;
*/

                     SET @Weight_Rounded = dbo.get_RoundedWeightByEquipment(@WEIGHT_FIX, @EquipmentID);
                     SET @JobOrderID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'JOB_ORDER_ID');
                     IF @JobOrderID IS NULL
                         BEGIN
                             SET @err_message = N'JobOrder is missing for EquipmentID=['+CAST(@EquipmentID AS NVARCHAR)+N']';
                             THROW 60010, @err_message, 1;
                         END;
                     SELECT @WorkType = wr.WorkType
                     FROM dbo.JobOrder AS jo
                          INNER JOIN dbo.WorkRequest AS wr ON wr.ID = jo.WorkRequest
                     WHERE jo.ID = @JobOrderID;
                     SET @Status = dbo.get_MaterialLotStatusByWorkType(@WorkType);
                     IF @WorkType IN(N'Standard')
                         BEGIN
                             SET @FactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
                             EXEC dbo.ins_MaterialLot
                                  @FactoryNumber = @FactoryNumber,
                                  @Status = @Status,
                                  @Quantity = @Weight_Rounded,
                                  @MaterialLotID = @MaterialLotID OUTPUT;
                         END;
                     ELSE
                         BEGIN
                             IF @WorkType IN(N'Sort', N'Reject')
                                 BEGIN
                                     SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
                                     EXEC dbo.ins_MaterialLotWithLinks
                                          @FactoryNumber = @FactoryNumber,
                                          @Status = @Status,
                                          @Quantity = @Weight_Rounded,
                                          @MaterialLotID = @MaterialLotID OUTPUT;                                     
                                 END;
                             ELSE
                                 BEGIN
                                     IF @WorkType IN(N'Separate')
                                         BEGIN
                                             DECLARE @LinkFactoryNumber NVARCHAR(12);
                                             SET @LinkFactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
                                             SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
                                             EXEC dbo.ins_MaterialLotWithLinks
                                                  @FactoryNumber = @FactoryNumber,
                                                  @Status = @Status,
                                                  @Quantity = @Weight_Rounded,
                                                  @LinkFactoryNumber = @LinkFactoryNumber,
                                                  @MaterialLotID = @MaterialLotID OUTPUT;                                             
                                         END;
                                 END;
                         END;
                     DECLARE @MEASURE_TIME NVARCHAR(50), @MILL_ID NVARCHAR(50), @NEMERA NVARCHAR(50);
                     SET @MEASURE_TIME = FORMAT(CURRENT_TIMESTAMP, 'dd.MM.yyyy HH:mm:ss');
                     SET @MILL_ID = dbo.get_EquipmentPropertyValue(dbo.get_ParentEquipmentIDByClass(@EquipmentID, N'MILL'), N'MILL_ID');
                     SET @WorkDefinitionID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'WORK_DEFINITION_ID');
                     SET @NEMERA = dbo.get_JobOrderPropertyValue(@JobOrderID, N'NEMERA');
                     EXEC dbo.ins_MaterialLotPropertyByWorkDefinition
                          @WorkDefinitionID = @WorkDefinitionID,
                          @MaterialLotID = @MaterialLotID,
                          @MEASURE_TIME = @MEASURE_TIME,
                          @AUTO_MANU_VALUE = @AUTO_MANU,
                          @MILL_ID = @MILL_ID,
                          @NEMERA = @NEMERA,
						  @IDENT = @IDENT,
						  @CREATE_MODE = N'Авто печать';

/*
      EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                     @JobOrderID      = @JobOrderID,
                                                     @MEASURE_TIME    = @MEASURE_TIME,
                                                     @AUTO_MANU_VALUE = @AUTO_MANU;
*/

                     SET @PrinterID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'USED_PRINTER');
                     EXEC dbo.ins_JobOrderPrintLabel
                          @PrinterID = @PrinterID,
                          @MaterialLotID = @MaterialLotID,
                          @Command = N'Print';

					IF @WorkType IN(N'Sort', N'Reject')
						EXEC dbo.set_StandardMode
                                          @EquipmentID = @EquipmentID;

					IF @WorkType IN(N'Separate')
						EXEC dbo.set_DecreasePacksLeft
                                                  @EquipmentID = @EquipmentID;
                 END;
         END TRY
         BEGIN CATCH
             EXEC dbo.ins_ErrorLog;
         END CATCH;
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
				   @LinkedServer  NVARCHAR(50);

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

GO


