SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
--------------------------------------------------------------
-- Процедура вычитки поля ID из таблицы Equipment по EquipmentClassProperty N'SCALES_NO'
IF OBJECT_ID ('dbo.get_EquipmentIDByControllerNo', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIDByControllerNo;
GO

IF OBJECT_ID ('dbo.get_EquipmentIDByScalesNo', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIDByScalesNo;
GO

CREATE FUNCTION dbo.get_EquipmentIDByScalesNo(@Value [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @EquipmentID INT;

SELECT @EquipmentID=eqp.EquipmentID
FROM dbo.EquipmentProperty eqp
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'SCALES_NO')
WHERE eqp.value=@Value;

RETURN @EquipmentID;

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByControllerNo
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabelByControllerNo',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabelByControllerNo;
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
              @err_message      NVARCHAR(255);

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
                                         @Quantity      = @WEIGHT_FIX,
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
                                                  @Quantity            = @WEIGHT_FIX,
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

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_ScalesShortInfo', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_ScalesShortInfo];
GO

CREATE VIEW [dbo].[v_ScalesShortInfo]
AS
SELECT ww.EquipmentID as ID,
       ww.WEIGHT_CURRENT,
       ww.COUNT_BAR RodsQuanity
FROM (SELECT eq.ID EquipmentID,
             ROW_NUMBER() OVER (PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
             kl.[WEIGHT_CURRENT],
             kl.[COUNT_BAR]
      FROM dbo.Equipment eq
           INNER JOIN dbo.EquipmentProperty eqp ON (eqp.EquipmentID=eq.ID)
           INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'SCALES_NO')
           INNER JOIN dbo.KEP_logger kl ON (ISNUMERIC(eqp.value)=1 AND kl.[NUMBER_POCKET]=CAST(eqp.value AS INT) AND kl.[TIMESTAMP]>=DATEADD(hour,-1,GETDATE()))
     ) ww
WHERE ww.RowNumber=1;
GO

SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO

CREATE VIEW [dbo].[v_ScalesDetailInfo]
AS
     WITH BarWeight
          AS (SELECT par.[Value],
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
                 ww.WEIGHT_CURRENT,
                 ww.WEIGHT_STAB,
                 ww.WEIGHT_ZERO,
                 ww.AUTO_MANU,
                 ww.POCKET_LOC,
                 ww.PACK_SANDWICH,
                 CAST(0 AS BIT) AS ALARM,
                 cast(FLOOR(ww.WEIGHT_CURRENT / bw.[Value]) as int) RodsQuantity,
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

IF OBJECT_ID ('dbo.InsKepWeigthFix',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKepWeigthFix];
GO

CREATE TRIGGER [dbo].[InsKepWeigthFix] ON [dbo].[KEP_weigth_fix]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @AUTO_MANU       BIT, --AUTO_MANU_VALUE,
           @NUMBER_POCKET   INT, --WEIGHT__FIX_NUMERICID
           @TIMESTAMP       DATETIME, --WEIGHT__FIX_TIMESTAMP
           @WEIGHT_FIX      INT, --WEIGHT__FIX_VALUE
           @WEIGHT_OK       BIT; --WEIGHT_OK_VALUE

   SELECT @AUTO_MANU=[AUTO_MANU],
          @NUMBER_POCKET=[NUMBER_POCKET],
          @TIMESTAMP=[TIMESTAMP],
          @WEIGHT_FIX=[WEIGHT_FIX],
          @WEIGHT_OK=[WEIGHT_OK]
   FROM INSERTED;

   IF @WEIGHT_OK=1
      EXEC [KRR-SQL-PACLX02-PALBP].[KRR-PA-ISA95_PRODUCTION].[dbo].[ins_JobOrderPrintLabelByScalesNo] @SCALES_NO = @NUMBER_POCKET,
                                                                                                          @TIMESTAMP     = @TIMESTAMP,
                                                                                                          @WEIGHT_FIX    = @WEIGHT_FIX,
                                                                                                          @AUTO_MANU     = @AUTO_MANU;
END
GO

--EXEC sp_settriggerorder @triggername=N'[dbo].[InsKepWeigthFix]', @order=N'Last', @stmttype=N'INSERT'


delete from EquipmentProperty where ClassPropertyID = (
select id from EquipmentClassProperty where [Value]='CONTROLLER_NO');

delete from EquipmentClassProperty where [Value]='CONTROLLER_NO';

update KEP_weigth_fix set NUMBER_POCKET=17 where NUMBER_POCKET=11;
update KEP_weigth_fix set NUMBER_POCKET=18 where NUMBER_POCKET=12;
update KEP_weigth_fix set NUMBER_POCKET=19 where NUMBER_POCKET=13;
update KEP_weigth_fix set NUMBER_POCKET=20 where NUMBER_POCKET=14;
update KEP_weigth_fix_archive set NUMBER_POCKET=17 where NUMBER_POCKET=11;
update KEP_weigth_fix_archive set NUMBER_POCKET=18 where NUMBER_POCKET=12;
update KEP_weigth_fix_archive set NUMBER_POCKET=19 where NUMBER_POCKET=13;
update KEP_weigth_fix_archive set NUMBER_POCKET=20 where NUMBER_POCKET=14;



update KEP_logger set NUMBER_POCKET=17 where NUMBER_POCKET=11;
update KEP_logger set NUMBER_POCKET=18 where NUMBER_POCKET=12;
update KEP_logger set NUMBER_POCKET=19 where NUMBER_POCKET=13;
update KEP_logger set NUMBER_POCKET=20 where NUMBER_POCKET=14;
update KEP_logger_archive set NUMBER_POCKET=17 where NUMBER_POCKET=11;
update KEP_logger_archive set NUMBER_POCKET=18 where NUMBER_POCKET=12;
update KEP_logger_archive set NUMBER_POCKET=19 where NUMBER_POCKET=13;
update KEP_logger_archive set NUMBER_POCKET=20 where NUMBER_POCKET=14;