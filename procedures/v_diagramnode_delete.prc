--------------------------------------------------------------
-- Процедура v_DiagramNode_delete
IF OBJECT_ID ('dbo.v_DiagramNode_delete',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramNode_delete;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramNode_delete]
@ID   INT
AS
BEGIN

DELETE FROM [dbo].[WorkflowSpecificationProperty]
WHERE [WorkflowSpecificationNode]=@ID;

DELETE FROM [dbo].[WorkflowSpecificationNode]
WHERE [ID]=@ID;

END;
GO
