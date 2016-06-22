--------------------------------------------------------------
-- Процедура ins_ErrorLog
IF OBJECT_ID ('dbo.ins_ErrorLog',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ErrorLog;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_ErrorLog]
AS
BEGIN
   INSERT INTO [dbo].[ErrorLog](error_details,error_message)
   SELECT N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + N', ERROR_SEVERITY: '+ IsNull(CAST(ERROR_SEVERITY() AS NVARCHAR),N'') + N', ERROR_STATE: '+ IsNull(CAST(ERROR_STATE() AS NVARCHAR),N'') + N', ERROR_PROCEDURE: '+ IsNull(ERROR_PROCEDURE(),N'') + N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
          ERROR_MESSAGE();
END;
GO
