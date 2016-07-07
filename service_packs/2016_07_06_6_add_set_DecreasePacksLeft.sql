--------------------------------------------------------------
-- Процедура upd_JobOrderProperty
IF OBJECT_ID ('dbo.upd_JobOrderProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderProperty;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_JobOrderProperty]
@JobOrderID      INT,
@PropertyType    NVARCHAR(50),
@PropertyValue   NVARCHAR(50)
AS
BEGIN
   DECLARE @ID            INT,
           @err_message   NVARCHAR(255);

   IF @JobOrderID IS NULL
      THROW 60001, N'JobOrderID param required', 1;
   ELSE IF @PropertyType IS NULL
      THROW 60001, N'PropertyType param required', 1;
   ELSE IF @PropertyValue IS NULL
      THROW 60001, N'PropertyValue param required', 1;

   SELECT @ID=pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=@PropertyType;

    IF @ID IS NULL
      BEGIN
         SET @err_message = N'PropertyType Value=['+@PropertyType+N'] not found';
         THROW 60010, @err_message, 1;
      END;

   UPDATE [dbo].[Parameter]
   SET [Value]=@PropertyValue
   WHERE [JobOrder]=@JobOrderID
     AND [PropertyType]=@ID;

/*
   MERGE [dbo].[Parameter] p
   USING (SELECT pt.* FROM [dbo].[PropertyTypes] pt) pt
   ON (p.[JobOrder]=@JobOrderID AND p.[PropertyType]=pt.[ID])
   WHEN MATCHED THEN
      UPDATE SET p.[Value]=@PropertyValue
   WHEN NOT MATCHED THEN
      INSERT ([Value],[JobOrder],[PropertyType])
      VALUES (@PropertyValue,@JobOrderID,pt.[ID]);
*/
END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_DecreasePacksLeft
IF OBJECT_ID ('dbo.set_DecreasePacksLeft',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_DecreasePacksLeft;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[set_DecreasePacksLeft]
@EquipmentID    INT
AS
BEGIN

   DECLARE @JobOrder        [NVARCHAR](50),
           @JobOrderID      INT,
           @PACKS_LEFT      [NVARCHAR](50),
           @PropertyValue   [NVARCHAR](50);

   SET @JobOrder=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   IF @JobOrder IS NOT NULL
      BEGIN
         SET @JobOrderID=CAST(@JobOrder AS INT);
         SET @PACKS_LEFT=dbo.get_JobOrderPropertyValue(@JobOrderID,N'PACKS_LEFT');
         IF CAST(IsNull(@PACKS_LEFT,N'0') AS INT)>0
            BEGIN
               SET @PropertyValue=CAST(CAST(@PACKS_LEFT AS INT) - 1 AS NVARCHAR);
               EXEC [dbo].[upd_JobOrderProperty] @JobOrderID    = @JobOrderID,
                                                 @PropertyType  = N'PACKS_LEFT',
                                                 @PropertyValue = @PropertyValue;
            END;
      END;
END;
GO
--------------------------------------------------------------
