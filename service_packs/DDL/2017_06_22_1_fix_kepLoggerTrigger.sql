SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[InsKeplogger] ON [dbo].[KEP_logger_table]
AFTER INSERT, UPDATE
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT OFF;

SAVE TRANSACTION updProperty;

BEGIN TRY

   DECLARE @NUMBER_POCKET    INT,
           @WEIGHT_ZERO      BIT,
           @EquipmentID      INT,
           @TakeWeightLocked [NVARCHAR](50),
           @err_message      [NVARCHAR](255);

   SELECT @NUMBER_POCKET=[NUMBER_POCKET],
          @WEIGHT_ZERO=[WEIGHT_ZERO]
   FROM INSERTED;

   IF @WEIGHT_ZERO=1
      BEGIN
         SET @EquipmentID=dbo.get_EquipmentIDByScalesNo(@NUMBER_POCKET);
         IF @EquipmentID IS NULL
            BEGIN
               SET @err_message = N'By SCALES_NO=[' + @NUMBER_POCKET + N'] EquipmentID not found';
               THROW 60010, @err_message, 1;
            END;

         SET @TakeWeightLocked=dbo.get_EquipmentPropertyValue(@EquipmentID,N'TAKE_WEIGHT_LOCKED');
         IF @TakeWeightLocked NOT IN (N'0')
            EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                               @EquipmentClassPropertyValue = N'TAKE_WEIGHT_LOCKED',
                                               @EquipmentPropertyValue = N'0';
      END;

END TRY

BEGIN CATCH
   ROLLBACK TRANSACTION updProperty;
   BEGIN TRY
      SAVE TRANSACTION InsErr;
      EXEC [dbo].[ins_ErrorLog];
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION InsErr;
   END CATCH
END CATCH

END


GO
EXEC sp_settriggerorder @triggername=N'[dbo].[InsKeplogger]', @order=N'Last', @stmttype=N'INSERT'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[InsKeplogger_archive] ON [dbo].[KEP_logger_table]
AFTER INSERT, UPDATE
AS
BEGIN

   SET NOCOUNT ON;

   INSERT INTO [dbo].[KEP_logger_archive]  ([id]
           ,[AUTO_MANU]
           ,[COUNT_BAR]
           ,[NUMBER_POCKET]
           ,[POCKET_LOC]
           ,[REM_BAR]
           ,[WEIGHT_CURRENT]
           ,[TIMESTAMP]
           ,[WEIGHT_SP_MAX]
           ,[WEIGHT_SP_MIN]
           ,[WEIGHT_STAB]
           ,[WEIGHT_ZERO]
           ,[PACK_SANDWICH]
           ,[ALARM]
           ,[KEY_MANU]
           ,[EN_BUTTON_TARA]
           ,[WEIGHT_OK]
           ,[CMD_TAKE_WEIGHT]
           ,[PEREBOR]) 
		   SELECT [id]
           ,[AUTO_MANU]
           ,[COUNT_BAR]
           ,[NUMBER_POCKET]
           ,[POCKET_LOC]
           ,[REM_BAR]
           ,[WEIGHT_CURRENT]
           ,[TIMESTAMP]
           ,[WEIGHT_SP_MAX]
           ,[WEIGHT_SP_MIN]
           ,[WEIGHT_STAB]
           ,[WEIGHT_ZERO]
           ,[PACK_SANDWICH]
           ,[ALARM]
           ,[KEY_MANU]
           ,[EN_BUTTON_TARA]
           ,[WEIGHT_OK]
           ,[CMD_TAKE_WEIGHT]
           ,[PEREBOR] FROM INSERTED;

END


GO
EXEC sp_settriggerorder @triggername=N'[dbo].[InsKeplogger_archive]', @order=N'First', @stmttype=N'INSERT'
GO
