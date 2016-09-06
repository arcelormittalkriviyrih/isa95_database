--------------------------------------------------------------
-- Процедура v_Diagram_delete
IF OBJECT_ID ('dbo.v_Diagram_delete',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_Diagram_delete;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_Diagram_delete]
@ID   INT
AS
BEGIN

DELETE FROM [dbo].[WorkflowSpecificationProperty]
WHERE [WorkflowSpecification]=@ID;

DELETE FROM [dbo].[WorkflowSpecification]
WHERE [ID]=@ID;

END;
GO

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
