﻿--------------------------------------------------------------
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
@AUTO_MANU_VALUE  NVARCHAR(50),
@MILL_ID          NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL,
@IDENT			  NVARCHAR(50) = NULL
AS
BEGIN

   DECLARE @LEAVE_NO NVARCHAR(50);
   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   SET @LEAVE_NO =
	   (
		  SELECT sp.[Value]
		  FROM [dbo].[ParameterSpecification] sp
			  INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = sp.[PropertyType])
		  WHERE(sp.WorkDefinitionID = @WorkDefinitionID)
			  AND pt.[Value] = N'COMM_ORDER'
	   );

   INSERT @tblParams
   SELECT pt.[Value],sp.[Value]
   FROM [dbo].[ParameterSpecification] sp
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=sp.[PropertyType])
   WHERE (sp.WorkDefinitionID=@WorkDefinitionID)
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL
   UNION ALL
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL
   UNION ALL
   SELECT N'NEMERA',@NEMERA WHERE @NEMERA IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(CAST(@LEAVE_NO AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @LEAVE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_LOT_IDENT',@IDENT WHERE @IDENT IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

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

CREATE PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo @SCALES_NO  NVARCHAR(50),
                                                      @TIMESTAMP  DATETIME,
                                                      @WEIGHT_FIX INT,
                                                      @AUTO_MANU  BIT,
                                                      @IDENT      INT
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
                       AND mlp.[Value] = cast(@IDENT as nvarchar)
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
                                     EXEC dbo.set_StandardMode
                                          @EquipmentID = @EquipmentID;
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
                                             EXEC dbo.set_DecreasePacksLeft
                                                  @EquipmentID = @EquipmentID;
                                         END;
                                 END;
                         END;
                     DECLARE @MEASURE_TIME NVARCHAR(50), @MILL_ID NVARCHAR(50), @NEMERA NVARCHAR(50);
                     SET @MEASURE_TIME = CONVERT(NVARCHAR, @TIMESTAMP, 121);
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
					 @IDENT = @IDENT;

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
                 END;
         END TRY
         BEGIN CATCH
             EXEC dbo.ins_ErrorLog;
         END CATCH;
     END;
GO