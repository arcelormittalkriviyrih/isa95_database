--------------------------------------------------------------
-- Процедура v_DiagramConnection_delete
IF OBJECT_ID ('dbo.v_DiagramConnection_delete',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramConnection_delete;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramConnection_delete]
@ID   INT
AS
BEGIN

DELETE FROM [dbo].[WorkflowSpecificationProperty]
WHERE [WorkflowSpecificationConnection]=@ID;

DELETE FROM [dbo].[WorkflowSpecificationConnection]
WHERE [ID]=@ID;

END;
GO
