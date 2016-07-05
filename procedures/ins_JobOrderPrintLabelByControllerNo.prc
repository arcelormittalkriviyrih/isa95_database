--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByControllerNo
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabelByControllerNo',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabelByControllerNo;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabelByControllerNo]
@CONTROLLER_NO   NVARCHAR(50),
@TIMESTAMP       DATETIME,
@WEIGHT_FIX      INT,
@AUTO_MANU       BIT
AS
BEGIN
   BEGIN TRY

      DECLARE @EquipmentID     INT,
              @FactoryNumber   [NVARCHAR](12),
              @PrinterID       [NVARCHAR](50),
              @MEASURE_TIME    [NVARCHAR](50),
              @JobOrderID      INT,
              @MaterialLotID   INT,
              @err_message     NVARCHAR(255);

      SET @EquipmentID=dbo.get_EquipmentIDByControllerNo(@CONTROLLER_NO);
      IF @EquipmentID IS NULL
         BEGIN
            SET @err_message = N'By CONTROLLER_NO=[' + @CONTROLLER_NO + N'] EquipmentID not found';
            THROW 60010, @err_message, 1;
         END;

      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;

      IF @JobOrderID IS NULL
         BEGIN
            SET @err_message = N'JobOrder is missing for EquipmentID=[' + CAST(@EquipmentID AS NVARCHAR) + N']';
            THROW 60010, @err_message, 1;
         END;

      SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
      EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                                   @Status        = N'0',
                                   @Quantity      = @WEIGHT_FIX,
                                   @MaterialLotID = @MaterialLotID OUTPUT;
      
      SET @MEASURE_TIME=CONVERT(NVARCHAR,@TIMESTAMP,121);
      EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                     @JobOrderID      = @JobOrderID,
                                                     @MEASURE_TIME    = @MEASURE_TIME,
                                                     @AUTO_MANU_VALUE = @AUTO_MANU;
      
      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END TRY
   BEGIN CATCH
     EXEC [dbo].[ins_ErrorLog];
   END CATCH
END
GO