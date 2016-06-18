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
           @JobOrderID      INT,
           @MaterialLotID   INT;

   SELECT @WEIGHT__FIX_NUMERICID=[WEIGHT__FIX_NUMERICID],
          @WEIGHT_OK_VALUE=[WEIGHT_OK_VALUE],
          @AUTO_MANU_VALUE=[AUTO_MANU_VALUE],
          @WEIGHT__FIX_VALUE=[WEIGHT__FIX_VALUE],
          @WEIGHT__FIX_TIMESTAMP=[WEIGHT__FIX_TIMESTAMP]
   FROM INSERTED;

   IF @WEIGHT_OK_VALUE=0
      RETURN;

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

   EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                  @JobOrderID      = @JobOrderID,
                                                  @MEASURE_TIME    = @WEIGHT__FIX_TIMESTAMP,
                                                  @AUTO_MANU_VALUE = @AUTO_MANU_VALUE;

   SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@WEIGHT__FIX_NUMERICID,N'USED_PRINTER');
   EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                       @MaterialLotID = @MaterialLotID,
                                       @Command       = N'Print';

END
GO

