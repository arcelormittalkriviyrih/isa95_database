--------------------------------------------------------------
-- Функция возвращает текущий режим по весам
IF OBJECT_ID ('dbo.get_CurrentWorkType', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_CurrentWorkType;
GO

CREATE FUNCTION dbo.get_CurrentWorkType(@EquipmentID INT)
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @JobOrderID INT,
        @WorkType   [NVARCHAR](50);

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
SELECT @WorkType=wr.[WorkType]
FROM [dbo].[JobOrder] jo INNER JOIN [dbo].[WorkRequest] wr ON (wr.[ID]=jo.[WorkRequest])
WHERE jo.[ID]=@JobOrderID;

RETURN @WorkType;

END;
GO

--------------------------------------------------------------
-- Процедура возвращает MaterialLot.Status по режиму работы
IF OBJECT_ID ('dbo.get_MaterialLotStatusByWorkType', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_MaterialLotStatusByWorkType];
GO

CREATE FUNCTION [dbo].[get_MaterialLotStatusByWorkType](@WorkType NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
   IF @WorkType = N'Sort'
      RETURN N'2';
   ELSE IF @WorkType = N'Reject'
      RETURN N'3';
   ELSE IF @WorkType = N'Separate'
      RETURN N'4';

   RETURN N'0';
END;
GO

--------------------------------------------------------------
-- Процедура ins_MaterialLotByEquipment
IF OBJECT_ID ('dbo.ins_MaterialLotByEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------
-- Используется для тестовой печати и для ручной печати с вводом кол-ва
CREATE PROCEDURE [dbo].[ins_MaterialLotByEquipment]
@EquipmentID   INT,
@Quantity      INT = NULL
AS
BEGIN

DECLARE @MaterialLotID    INT,
        @WorkDefinitionID INT,
        @MEASURE_TIME    [NVARCHAR](50),
        @AUTO_MANU_VALUE [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50),
        @Status          [NVARCHAR](250);

SET @Status=N'0';
SET @AUTO_MANU_VALUE=N'0';

IF @Quantity IS NOT NULL
   BEGIN
      SET @Status=[dbo].[get_MaterialLotStatusByWorkType]([dbo].[get_CurrentWorkType](@EquipmentID));
      SET @AUTO_MANU_VALUE=N'1';
   END;

SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = @Status,
                             @Quantity      = @Quantity,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
IF @WorkDefinitionID IS NOT NULL
   BEGIN
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;
END;
GO