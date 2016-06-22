--------------------------------------------------------------
-- Процедура ins_ErrorLog
IF OBJECT_ID ('dbo.ins_ErrorLog',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ErrorLog;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_ErrorLog]
AS
BEGIN
   INSERT INTO [dbo].[ErrorLog](error_details,error_message)
   SELECT N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + N', ERROR_SEVERITY: '+ IsNull(CAST(ERROR_SEVERITY() AS NVARCHAR),N'') + N', ERROR_STATE: '+ IsNull(CAST(ERROR_STATE() AS NVARCHAR),N'') + N', ERROR_PROCEDURE: '+ IsNull(ERROR_PROCEDURE(),N'') + N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
          ERROR_MESSAGE();
END;
GO

------------------------------------------------------------------
IF OBJECT_ID ('dbo.InsKeplogger',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKeplogger];
GO

CREATE TRIGGER [dbo].[InsKeplogger] ON [dbo].[KEP_logger]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @WEIGHT__FIX_NUMERICID INT,
           @WEIGHT_OK_VALUE       BIT,
           @AUTO_MANU_VALUE       BIT,
           @WEIGHT__FIX_VALUE     INT,
           @WEIGHT__FIX_TIMESTAMP DATETIME,
           @FactoryNumber   [NVARCHAR](12),
           @PrinterID       [NVARCHAR](50),
           @MEASURE_TIME    [NVARCHAR](50),
           @JobOrderID      INT,
           @MaterialLotID   INT;

   SELECT @WEIGHT__FIX_NUMERICID=[WEIGHT__FIX_NUMERICID],
          @WEIGHT_OK_VALUE=[WEIGHT_OK_VALUE],
          @AUTO_MANU_VALUE=[AUTO_MANU_VALUE],
          @WEIGHT__FIX_VALUE=[WEIGHT__FIX_VALUE],
          @WEIGHT__FIX_TIMESTAMP=[WEIGHT__FIX_TIMESTAMP]
   FROM INSERTED;

   BEGIN TRY
      IF @WEIGHT_OK_VALUE=1
         BEGIN
            SELECT TOP 1 @JobOrderID=jo.[ID]
            FROM [dbo].[JobOrder] jo
                 INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@WEIGHT__FIX_NUMERICID)
            WHERE jo.[WorkType]=N'INIT'
            ORDER BY jo.[StartTime] DESC

            SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@WEIGHT__FIX_NUMERICID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
            EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                                         @Status        = N'0',
                                         @Quantity      = @WEIGHT__FIX_VALUE,
                                         @MaterialLotID = @MaterialLotID OUTPUT;

            SET @MEASURE_TIME=CONVERT(NVARCHAR,@WEIGHT__FIX_TIMESTAMP,121);
            EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                           @JobOrderID      = @JobOrderID,
                                                           @MEASURE_TIME    = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE = @AUTO_MANU_VALUE;

            SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@WEIGHT__FIX_NUMERICID,N'USED_PRINTER');
            EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                                @MaterialLotID = @MaterialLotID,
                                                @Command       = N'Print';
         END;
   END TRY
   BEGIN CATCH
      EXEC [dbo].[ins_ErrorLog];
   END CATCH
END
GO

