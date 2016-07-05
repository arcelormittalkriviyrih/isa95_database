--------------------------------------------------------------
-- Процедура upd_EquipmentProperty
IF OBJECT_ID ('dbo.upd_EquipmentProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentProperty;
GO

SET QUOTED_IDENTIFIER ON
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
   ELSE IF @EquipmentPropertyValue IS NULL
      THROW 60001, N'EquipmentPropertyValue param required', 1;

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

