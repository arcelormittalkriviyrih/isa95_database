SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
--------------------------------------------------------------
-- Функция округляет вес
IF OBJECT_ID('dbo.get_RoundedWeight', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeight;
GO

CREATE FUNCTION dbo.get_RoundedWeight
(@WeightValue INT,
 @RoundRule   NVARCHAR(50),
 @RoundPrecision  INT
)
RETURNS INT
AS
     BEGIN
         IF @RoundRule IS NULL
             RETURN @WeightValue;
         IF @RoundPrecision IS NULL
             RETURN @WeightValue;
         IF @RoundRule = 'UP'
             RETURN @WeightValue + @RoundPrecision - @WeightValue % @RoundPrecision;
         IF @RoundRule = 'DOWN'
             RETURN @WeightValue - @WeightValue % @RoundPrecision;
         RETURN @WeightValue;
     END;
GO

--------------------------------------------------------------
-- Функция округляет вес для конкретных весов
IF OBJECT_ID('dbo.get_RoundedWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeightByEquipment;
GO

CREATE FUNCTION dbo.get_RoundedWeightByEquipment
(@WeightValue INT,
 @EquipmentID INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @RoundPrecision INT, @RoundRule [NVARCHAR](50);
         SET @RoundRule = dbo.get_EquipmentPropertyValue(@EquipmentID, N'ROUND_RULE');
         SET @RoundPrecision = dbo.get_EquipmentPropertyValue(@EquipmentID, N'ROUND_PRECISION');
         RETURN dbo.[get_RoundedWeight](@WeightValue, @RoundRule, @RoundPrecision);
     END;
GO


IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO

CREATE VIEW [dbo].[v_ScalesDetailInfo]
AS
     WITH BarWeight
          AS (SELECT cast(par.[Value] as float) Bar_Weight,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value] = N'BAR_WEIGHT'
                    AND pr.ID = par.PropertyType
                    AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
              AND ep.[Value] = par.JobOrder)
          SELECT ww.EquipmentID AS ID,
                 ww.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(ww.WEIGHT_CURRENT, ww.EquipmentID) WEIGHT_CURRENT,
                 ww.WEIGHT_STAB,
                 ww.WEIGHT_ZERO,
                 ww.AUTO_MANU,
                 ww.POCKET_LOC,
                 ww.PACK_SANDWICH,
                 CAST(0 AS BIT) AS ALARM,
                 cast(FLOOR(dbo.get_RoundedWeightByEquipment(ww.WEIGHT_CURRENT, ww.EquipmentID) / bw.[Bar_Weight]) as int) RodsQuantity,
                 ww.REM_BAR RodsLeft
          FROM
          (
              SELECT eq.ID EquipmentID,
                     eq.[Description],
                     ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                     kl.[WEIGHT_CURRENT],
                     kl.[WEIGHT_STAB],
                     kl.[WEIGHT_ZERO],
                     kl.[COUNT_BAR],
                     kl.[REM_BAR],
                     kl.[AUTO_MANU],
                     kl.[POCKET_LOC],
                     kl.[PACK_SANDWICH]
              FROM dbo.Equipment eq
                   INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
                   INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                                AND ecp.value = N'SCALES_NO')
                   INNER JOIN dbo.KEP_logger kl ON(ISNUMERIC(eqp.value) = 1
                                                   AND kl.[NUMBER_POCKET] = CAST(eqp.value AS INT)
                                                   AND kl.[TIMESTAMP] >= DATEADD(hour, -1, GETDATE()))
          ) ww
          LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = ww.EquipmentID
          WHERE ww.RowNumber = 1;

GO

IF OBJECT_ID ('dbo.v_ScalesShortInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesShortInfo];
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByScalesNo
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabelByScalesNo',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabelByScalesNo]
@SCALES_NO   NVARCHAR(50),
@TIMESTAMP       DATETIME,
@WEIGHT_FIX      INT,
@AUTO_MANU       BIT
AS
BEGIN
   BEGIN TRY

      DECLARE @EquipmentID      INT,
              @FactoryNumber    [NVARCHAR](12),
              @PrinterID        [NVARCHAR](50),
              @JobOrderID       INT,
              @WorkType         [NVARCHAR](50),
              @WorkDefinitionID INT,
              @MaterialLotID    INT,
              @Status           NVARCHAR(250),
              @err_message      NVARCHAR(255),
		      @Weight_Rounded	  INT;

      SET @EquipmentID=dbo.get_EquipmentIDByScalesNo(@SCALES_NO);
      IF @EquipmentID IS NULL
         BEGIN
            SET @err_message = N'By SCALES_NO=[' + @SCALES_NO + N'] EquipmentID not found';
            THROW 60010, @err_message, 1;
         END;
/*
      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;
*/

	  SET @Weight_Rounded=dbo.get_RoundedWeightByEquipment(@EquipmentID,@WEIGHT_FIX);

      SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
      IF @JobOrderID IS NULL
         BEGIN
            SET @err_message = N'JobOrder is missing for EquipmentID=[' + CAST(@EquipmentID AS NVARCHAR) + N']';
            THROW 60010, @err_message, 1;
         END;

      SELECT @WorkType=wr.[WorkType]
      FROM [dbo].[JobOrder] jo INNER JOIN [dbo].[WorkRequest] wr ON (wr.[ID]=jo.[WorkRequest])
      WHERE jo.[ID]=@JobOrderID;

      SET @Status=[dbo].[get_MaterialLotStatusByWorkType](@WorkType);
      IF @WorkType IN (N'Standard')
         BEGIN
            SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
            EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                                         @Status        = @Status,
                                         @Quantity      = @Weight_Rounded,
                                         @MaterialLotID = @MaterialLotID OUTPUT;
         END;
      ELSE IF @WorkType IN (N'Sort',N'Reject')
         BEGIN
            SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');
            EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber       = @FactoryNumber,
                                                  @Status              = @Status,
                                                  @LinkedMaterialLotID = @MaterialLotID OUTPUT;
         END;
      ELSE IF @WorkType IN (N'Separate')
         BEGIN
            DECLARE @LinkFactoryNumber   [NVARCHAR](12);
            SET @LinkFactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
            SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');
            EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber       = @FactoryNumber,
                                                  @Status              = @Status,
                                                  @Quantity            = @Weight_Rounded,
                                                  @LinkFactoryNumber   = @LinkFactoryNumber,
                                                  @LinkedMaterialLotID = @MaterialLotID OUTPUT;
         END;

      DECLARE @MEASURE_TIME [NVARCHAR](50),
              @MILL_ID      NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,@TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');
      SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU,
                                                           @MILL_ID          = @MILL_ID;
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
	  SET @Quantity=dbo.get_RoundedWeightByEquipment(@EquipmentID,@Quantity);
   END;

SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = @Status,
                             @Quantity      = @Quantity,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');
IF @WorkDefinitionID IS NOT NULL
   BEGIN
      DECLARE @MEASURE_TIME NVARCHAR(50),
              @MILL_ID      NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');
      EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE,
                                                           @MILL_ID          = @MILL_ID;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;
END;
GO

