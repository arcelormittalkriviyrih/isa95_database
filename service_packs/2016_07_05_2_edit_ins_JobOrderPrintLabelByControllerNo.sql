--------------------------------------------------------------
-- Процедура ins_MaterialLotByCommOrder
IF OBJECT_ID ('dbo.ins_MaterialLotByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByCommOrder;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByCommOrder
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByCommOrder;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByJobOrder
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByJobOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByJobOrder;
GO


--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByControllerNo
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabelByControllerNo',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabelByControllerNo;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------
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
              @WorkDefinitionID INT,
              @MaterialLotID   INT,
              @err_message     NVARCHAR(255);

      SET @EquipmentID=dbo.get_EquipmentIDByControllerNo(@CONTROLLER_NO);
      IF @EquipmentID IS NULL
         BEGIN
            SET @err_message = N'By CONTROLLER_NO=[' + @CONTROLLER_NO + N'] EquipmentID not found';
            THROW 60010, @err_message, 1;
         END;
/*
      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;
*/
      SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
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
      SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU;
/*
      EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                     @JobOrderID      = @JobOrderID,
                                                     @MEASURE_TIME    = @MEASURE_TIME,
                                                     @AUTO_MANU_VALUE = @AUTO_MANU;
*/
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

--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByWorkDefinition
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByWorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByWorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotPropertyByWorkDefinition]
@WorkDefinitionID INT,
@MaterialLotID    INT,
@MEASURE_TIME     NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50)
AS
BEGIN

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   INSERT @tblParams
   SELECT pt.[Value],sp.[Value]
   FROM [dbo].[ParameterSpecification] sp
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=sp.[PropertyType])
   WHERE (sp.WorkDefinitionID=@WorkDefinitionID)
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotByEquipment
IF OBJECT_ID ('dbo.ins_MaterialLotByEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotByEquipment]
@EquipmentID     INT
AS
BEGIN

DECLARE @MaterialLotID   INT,
        @WorkDefinitionID      INT,
        @MEASURE_TIME    [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50);

SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = N'0',
                             @Quantity      = NULL,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
IF @WorkDefinitionID IS NOT NULL
   BEGIN
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = N'0';

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;
END;
GO
