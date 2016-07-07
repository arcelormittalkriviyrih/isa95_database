SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

--------------------------------------------------------------
-- Процедура upd_EquipmentProperty
IF OBJECT_ID ('dbo.upd_EquipmentProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentProperty;
GO

CREATE PROCEDURE [dbo].[upd_EquipmentProperty]
@EquipmentID                   INT,
@EquipmentClassPropertyValue   NVARCHAR(50),
@EquipmentPropertyValue        NVARCHAR(50)
AS
BEGIN
   DECLARE @err_message          NVARCHAR(255);

   IF @EquipmentID IS NULL
      THROW 60001, N'EquipmentID param required', 1;
   ELSE IF @EquipmentClassPropertyValue IS NULL
      THROW 60001, N'EquipmentClassPropertyValue param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL 
                       FROM [dbo].[EquipmentClassProperty] ecp
                       WHERE ecp.[Value]=@EquipmentClassPropertyValue)
      BEGIN
         SET @err_message = N'EquipmentClassProperty Value=['+@EquipmentClassPropertyValue+N'] not found';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF NOT EXISTS (SELECT NULL 
                       FROM [dbo].[EquipmentClassProperty] ecp
                            INNER JOIN [dbo].[Equipment] eq ON (eq.[ID]=@EquipmentID AND eq.[EquipmentClassID]=ecp.[EquipmentClassID])
                       WHERE ecp.[Value]=@EquipmentClassPropertyValue)
      BEGIN
         SELECT @err_message = N'Wrong EquipmentClassProperty Value=['+@EquipmentClassPropertyValue+ N'] for Equipment ID=['+CAST(@EquipmentID AS NVARCHAR)+']';
         THROW 60010, @err_message, 1;
      END;
   -- allow NULL to be able to clear values
   --ELSE IF @EquipmentPropertyValue IS NULL
   --   THROW 60001, N'EquipmentPropertyValue param required', 1;

   MERGE [dbo].[EquipmentProperty] ep
   USING (SELECT dbo.get_EquipmentClassPropertyByValue(@EquipmentClassPropertyValue) EquipmentClassPropertyID) ecp
   ON (ep.[EquipmentID]=@EquipmentID AND ep.[ClassPropertyID]=ecp.EquipmentClassPropertyID)
   WHEN MATCHED THEN
      UPDATE SET ep.[Value]=@EquipmentPropertyValue
   WHEN NOT MATCHED THEN
      INSERT ([Value],[EquipmentID],[ClassPropertyID])
      VALUES (@EquipmentPropertyValue,@EquipmentID,ecp.EquipmentClassPropertyID);

END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_StandardMode
IF OBJECT_ID ('dbo.set_StandardMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_StandardMode;
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

	IF @StandardJobOrderID IS NULL
	   BEGIN
		  EXEC [dbo].[upd_EquipmentProperty]
			  @EquipmentID = @EquipmentID,
			  @EquipmentClassPropertyValue = N'JOB_ORDER_ID',
			  @EquipmentPropertyValue = NULL;
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



