SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE @maxId int;
SELECT @maxId = max(id)+1 from KEP_logger_archive;
declare @s nvarchar(4000);

IF OBJECT_ID('dbo.gen_KepLoggerArchive', N'SO') IS NULL 
BEGIN
set @s = N'
CREATE SEQUENCE dbo.gen_KepLoggerArchive  AS INT  
START WITH ' + cast(@maxId as nvarchar) + '
INCREMENT BY 1  
NO CACHE;'

EXEC (@s);

ALTER TABLE dbo.KEP_logger_archive
ADD DEFAULT(NEXT VALUE FOR dbo.gen_KepLoggerArchive) FOR ID;


END;
GO


ALTER TRIGGER [dbo].[InsKeplogger_archive] ON [dbo].[KEP_logger_table]
AFTER INSERT, UPDATE
AS
BEGIN

   SET NOCOUNT ON;

   INSERT INTO [dbo].[KEP_logger_archive]  (
           [AUTO_MANU]
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
		   SELECT 
           [AUTO_MANU]
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