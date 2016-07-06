--------------------------------------------------------------
-- Процедура dbo.set_StandardMode
IF OBJECT_ID ('dbo.set_StandardMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_StandardMode;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[set_StandardMode]
@EquipmentID    INT
AS
BEGIN

   DECLARE @StandardWorkDefinitionID [NVARCHAR](50),
           @StandardJobOrderID       [NVARCHAR](50);

   SET @StandardWorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'STANDARD_WORK_DEFINITION_ID');
   SET @StandardJobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'STANDARD_JOB_ORDER_ID');

   IF @StandardWorkDefinitionID IS NOT NULL
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N'WORK_DEFINITION_ID',
                                         @EquipmentPropertyValue = @StandardWorkDefinitionID;

   IF @StandardJobOrderID IS NOT NULL
      BEGIN
         EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                            @EquipmentClassPropertyValue = N'JOB_ORDER_ID',
                                            @EquipmentPropertyValue = @StandardJobOrderID;

         DECLARE @JobOrderID      INT,
                 @WorkRequestID   INT,
                 @MAX_WEIGHT      [NVARCHAR](50),
                 @MIN_WEIGHT      [NVARCHAR](50),
                 @SANDWICH_MODE   [NVARCHAR](50),
                 @AUTO_MANU_VALUE [NVARCHAR](50);


         SET @JobOrderID=CAST(@StandardJobOrderID AS INT);
         SET @WorkRequestID=dbo.get_WorkRequestByJobOrder(@JobOrderID);

         SET @MAX_WEIGHT=dbo.get_JobOrderPropertyValue(@JobOrderID,N'MAX_WEIGHT');
         SET @MIN_WEIGHT=dbo.get_JobOrderPropertyValue(@JobOrderID,N'MIN_WEIGHT');
         SET @SANDWICH_MODE=dbo.get_JobOrderPropertyValue(@JobOrderID,N'SANDWICH_MODE');
         SET @AUTO_MANU_VALUE=dbo.get_JobOrderPropertyValue(@JobOrderID,N'AUTO_MANU_VALUE');

         -- Отправляем команды на котроллер
         EXEC [dbo].[ins_JobOrderOPCCommandMaxWeight] @WorkRequestID = @WorkRequestID,
                                                      @EquipmentID   = @EquipmentID,
                                                      @TagValue      = @MAX_WEIGHT;
         
         EXEC [dbo].[ins_JobOrderOPCCommandMinWeight] @WorkRequestID = @WorkRequestID,
                                                      @EquipmentID   = @EquipmentID,
                                                      @TagValue      = @MIN_WEIGHT;
         
         EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                                     @EquipmentID   = @EquipmentID,
                                                     @TagValue      = @SANDWICH_MODE;
         
         EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                                     @EquipmentID   = @EquipmentID,
                                                     @TagValue      = @AUTO_MANU_VALUE;
      END;

/*
   IF @JobOrderID IS NULL
      BEGIN
         SET @err_message = N'Property JOB_ORDER_ID is not set for EquipmentID=[' + CAST(@EquipmentID AS NVARCHAR) + N']';
         THROW 60010, @err_message, 1;
      END;
*/
END;
GO
