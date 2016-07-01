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
