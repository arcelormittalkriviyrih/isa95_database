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
