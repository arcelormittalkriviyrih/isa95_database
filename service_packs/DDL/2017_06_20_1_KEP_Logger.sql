SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.KEP_logger',N'U') IS NOT NULL
   exec sp_rename 'KEP_logger', 'KEP_logger_table';
GO

IF OBJECT_ID ('dbo.InsKeplogger_archive',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKeplogger_archive];
GO

CREATE TRIGGER [dbo].[InsKeplogger_archive] ON [dbo].[KEP_logger_table]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   INSERT INTO [dbo].[KEP_logger_archive] SELECT * FROM INSERTED;

END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKeplogger_archive]', @order=N'First', @stmttype=N'INSERT'
GO

IF OBJECT_ID ('dbo.InsKeplogger',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKeplogger];
GO

CREATE TRIGGER [dbo].[InsKeplogger] ON [dbo].[KEP_logger_table]
AFTER INSERT
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


IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u2_number_pocket_unqiue' AND object_id = OBJECT_ID('[dbo].[KEP_logger_table]'))
  DROP INDEX [u2_number_pocket_unqiue] ON [dbo].[KEP_logger_table]
GO

truncate table  [dbo].[KEP_logger_table] 
GO

CREATE UNIQUE INDEX [u2_number_pocket_unqiue] ON [dbo].[KEP_logger_table] ([NUMBER_POCKET])
GO


IF OBJECT_ID('dbo.KEP_logger', N'V') IS NOT NULL
    DROP VIEW [dbo].[KEP_logger];
GO

/*
   View: KEP_logger
*/
CREATE VIEW [dbo].[KEP_logger]
AS SELECT [id]
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
      ,[PEREBOR]
  FROM [dbo].[KEP_logger_table];
GO

CREATE TRIGGER [dbo].[InsKeplogger_UPDATE] ON [dbo].[KEP_logger]
INSTEAD OF INSERT
AS
BEGIN

   SET NOCOUNT ON;

   MERGE [dbo].[KEP_logger_table] kp
    USING (SELECT * FROM INSERTED) ins
  ON (ins.[NUMBER_POCKET] =kp.[NUMBER_POCKET])
  WHEN MATCHED THEN
    UPDATE SET kp.[AUTO_MANU] = ins.[AUTO_MANU]
      ,kp.[COUNT_BAR] =            ins.[COUNT_BAR]        
      ,kp.[POCKET_LOC] = 		   ins.[POCKET_LOC]  
      ,kp.[REM_BAR] = 			   ins.[REM_BAR]  
      ,kp.[WEIGHT_CURRENT] = 	   ins.[WEIGHT_CURRENT] 
      ,kp.[TIMESTAMP] = getdate()  
      ,kp.[WEIGHT_SP_MAX] = 	   ins.[WEIGHT_SP_MAX] 
      ,kp.[WEIGHT_SP_MIN] = 	   ins.[WEIGHT_SP_MIN]  
      ,kp.[WEIGHT_STAB] = 		   ins.[WEIGHT_STAB] 
      ,kp.[WEIGHT_ZERO] = 		   ins.[WEIGHT_ZERO]  
      ,kp.[PACK_SANDWICH] = 	   ins.[PACK_SANDWICH] 
      ,kp.[ALARM] = 			   ins.[ALARM]  
      ,kp.[KEY_MANU] = 			   ins.[KEY_MANU] 
      ,kp.[EN_BUTTON_TARA] = 	   ins.[EN_BUTTON_TARA] 
      ,kp.[WEIGHT_OK] = 		   ins.[WEIGHT_OK] 
      ,kp.[CMD_TAKE_WEIGHT] = 	   ins.[CMD_TAKE_WEIGHT] 
      ,kp.[PEREBOR] = 			   ins.[PEREBOR]  
	WHEN NOT MATCHED THEN
	INSERT ([AUTO_MANU]
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
		   VALUES 
		   (ins.[AUTO_MANU]
           ,ins.[COUNT_BAR]
           ,ins.[NUMBER_POCKET]
           ,ins.[POCKET_LOC]
           ,ins.[REM_BAR]
           ,ins.[WEIGHT_CURRENT]
           ,getdate()  
           ,ins.[WEIGHT_SP_MAX]
           ,ins.[WEIGHT_SP_MIN]
           ,ins.[WEIGHT_STAB]
           ,ins.[WEIGHT_ZERO]
           ,ins.[PACK_SANDWICH]
           ,ins.[ALARM]
           ,ins.[KEY_MANU]
           ,ins.[EN_BUTTON_TARA]
           ,ins.[WEIGHT_OK]
           ,ins.[CMD_TAKE_WEIGHT]
           ,ins.[PEREBOR] ) ;

  

END
GO
