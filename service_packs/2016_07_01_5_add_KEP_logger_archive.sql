IF OBJECT_ID('[dbo].[KEP_weigth_fix_archive]') IS NOT NULL
   DROP TABLE [dbo].[KEP_weigth_fix_archive]
GO

IF OBJECT_ID('[dbo].[KEP_logger_archive]') IS NOT NULL
   DROP TABLE [dbo].[KEP_logger_archive]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[KEP_logger_archive](
	[id] [int] NOT NULL,
	[AUTO_MANU] [bit] NULL,
	[COUNT_BAR] [int] NULL,
	[NUMBER_POCKET] [int] NULL,
	[POCKET_LOC] [bit] NULL,
	[REM_BAR] [int] NULL,
	[WEIGHT_CURRENT] [real] NULL,
	[TIMESTAMP] [datetime] NULL,
	[WEIGHT_SP_MAX] [real] NULL,
	[WEIGHT_SP_MIN] [real] NULL,
	[WEIGHT_STAB] [bit] NULL,
	[WEIGHT_ZERO] [bit] NULL,
	[PACK_SANDWICH] [bit] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[KEP_weigth_fix_archive](
	[id] [int] NOT NULL,
	[AUTO_MANU] [bit] NOT NULL,
	[NUMBER_POCKET] [int] NOT NULL,
	[TIMESTAMP] [datetime] NOT NULL,
	[WEIGHT_FIX] [int] NOT NULL,
	[WEIGHT_OK] [bit] NOT NULL
) ON [PRIMARY]
GO


IF OBJECT_ID ('dbo.InsKeplogger_archive',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKeplogger_archive];
GO

CREATE TRIGGER [dbo].[InsKeplogger_archive] ON [dbo].[KEP_logger]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   INSERT INTO [dbo].[KEP_logger_archive] SELECT * FROM INSERTED;

END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKeplogger_archive]', @order=N'First', @stmttype=N'INSERT'

IF OBJECT_ID ('dbo.InsKepWeigthFix_archive',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKepWeigthFix_archive];
GO

CREATE TRIGGER [dbo].[InsKepWeigthFix_archive] ON [dbo].[KEP_weigth_fix]
AFTER INSERT
AS
BEGIN

   INSERT INTO [dbo].[KEP_weigth_fix_archive] SELECT * FROM INSERTED;

END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKepWeigthFix]', @order=N'Last', @stmttype=N'INSERT'

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKepWeigthFix_archive]', @order=N'First', @stmttype=N'INSERT'

--------------------------------------------------------------
-- Процедура del_KEPLoggerJob
IF OBJECT_ID ('dbo.del_KEPLoggerJob',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_KEPLoggerJob;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_KEPLoggerJob]
AS
BEGIN

   DELETE FROM [dbo].[KEP_logger]
   WHERE [TIMESTAMP]<=DATEADD(minute,-30,GETDATE());

   DELETE FROM [dbo].[KEP_weigth_fix]
   WHERE [TIMESTAMP]<=DATEADD(minute,-30,GETDATE());

END;
GO
